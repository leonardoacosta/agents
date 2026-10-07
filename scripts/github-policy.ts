import { spawnSync } from "node:child_process";
import { readFileSync } from "node:fs";
import { pathToFileURL } from "node:url";

const SETTINGS = [
  "allow_auto_merge",
  "delete_branch_on_merge",
  "allow_merge_commit",
  "allow_squash_merge",
  "allow_rebase_merge",
] as const;
type Setting = (typeof SETTINGS)[number];
type Policy = Partial<Record<Setting | "actions_readonly", boolean>>;
// Raw GitHub payloads stay untrusted until field guards validate each consumed value.
// eslint-disable-next-line anti-slop/no-unsafe-dictionary-type
type JsonObject = Record<string, unknown>;
interface WorkflowPermissions {
  can_approve_pull_request_reviews?: boolean;
  default_workflow_permissions?: string;
  unavailable?: string;
}
interface Audit {
  repository: JsonObject;
  rulesets: JsonObject[];
  rulesetsIncomplete: boolean;
  workflowPermissions: WorkflowPermissions;
  actionsPermissions: JsonObject;
}
interface Plan {
  before: Partial<Record<Setting, boolean>>;
  after: Partial<Record<Setting, boolean>>;
  workflowPermissions?: {
    before: WorkflowPermissions;
    after: WorkflowPermissions;
  };
}

// External JSON is untrusted: these predicates establish the contract at the I/O boundary.
// eslint-disable-next-line anti-slop/no-unknown-parameters
const isObject = (value: unknown): value is JsonObject =>
  // eslint-disable-next-line anti-slop/no-runtime-typeof
  typeof value === "object" && value !== null && !Array.isArray(value);
// eslint-disable-next-line anti-slop/no-unknown-parameters
const isBoolean = (value: unknown): value is boolean =>
  // eslint-disable-next-line anti-slop/no-runtime-typeof
  typeof value === "boolean";
// eslint-disable-next-line anti-slop/no-unknown-parameters
const isString = (value: unknown): value is string =>
  // eslint-disable-next-line anti-slop/no-runtime-typeof
  typeof value === "string";
const object = (text: string): JsonObject => {
  const value: unknown = JSON.parse(text);
  if (!isObject(value)) {
    throw new Error("Expected JSON object");
  }
  return value;
};
const settingKey = (key: string): key is Setting =>
  SETTINGS.some((item) => item === key);

export const validateOwnerRepo = (target: string): string => {
  const [owner, repo, extra] = target.split("/");
  if (
    owner === undefined ||
    repo === undefined ||
    extra !== undefined ||
    !/^[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?$/u.test(owner) ||
    !/^[A-Za-z0-9_.-]+$/u.test(repo) ||
    repo === "." ||
    repo === ".."
  ) {
    throw new Error("Target must be OWNER/REPO");
  }
  return target;
};

const gh = (args: string[], input?: string): string => {
  const result = spawnSync("gh", args, {
    encoding: "utf-8",
    input,
    maxBuffer: 16 * 1024 * 1024,
    shell: false,
  });
  if (result.error !== undefined) {
    throw result.error;
  }
  if (result.status !== 0) {
    throw new Error(`gh ${args[0] ?? ""} failed: ${result.stderr.trim()}`);
  }
  return result.stdout;
};
const api = (path: string): JsonObject => object(gh(["api", path]));
const permissions = (target: string): WorkflowPermissions => {
  const value = api(`repos/${target}/actions/permissions/workflow`);
  if (
    !isString(value.default_workflow_permissions) ||
    !isBoolean(value.can_approve_pull_request_reviews)
  ) {
    throw new Error("Invalid workflow permissions response");
  }
  return {
    can_approve_pull_request_reviews: value.can_approve_pull_request_reviews,
    default_workflow_permissions: value.default_workflow_permissions,
  };
};
const rulesets = (target: string): JsonObject[] => {
  const result: JsonObject[] = [];
  for (let page = 1; ; page += 1) {
    const batch: unknown = JSON.parse(
      gh([
        "api",
        `repos/${target}/rulesets?includes_parents=true&per_page=100&page=${page}`,
      ])
    );
    if (!Array.isArray(batch)) {
      throw new TypeError("Invalid ruleset list");
    }
    for (const rule of batch) {
      if (!isObject(rule) || !Number.isSafeInteger(rule.id)) {
        throw new Error("Invalid ruleset entry");
      }
      try {
        const endpoint =
          rule.source_type === "Organization" && isString(rule.source)
            ? `orgs/${rule.source}/rulesets/${String(rule.id)}`
            : `repos/${target}/rulesets/${String(rule.id)}`;
        result.push({ ...rule, details: api(endpoint) });
      } catch (error) {
        result.push({
          ...rule,
          details_unavailable:
            error instanceof Error
              ? error.message
              : "Ruleset detail unavailable",
        });
      }
    }
    if (batch.length < 100) {
      return result;
    }
  }
};
export const auditRepository = (target: string): Audit => {
  validateOwnerRepo(target);
  const repository = api(`repos/${target}`);
  const rules = rulesets(target);
  let workflowPermissions: WorkflowPermissions;
  try {
    workflowPermissions = permissions(target);
  } catch (error) {
    workflowPermissions = {
      unavailable:
        error instanceof Error
          ? error.message
          : "Workflow permissions unavailable",
    };
  }
  let actionsPermissions: JsonObject | { unavailable: string };
  try {
    actionsPermissions = api(`repos/${target}/actions/permissions`);
  } catch (error) {
    actionsPermissions = {
      unavailable:
        error instanceof Error
          ? error.message
          : "Actions permissions unavailable",
    };
  }
  return {
    actionsPermissions,
    repository,
    rulesets: rules,
    rulesetsIncomplete: rules.some(
      (rule) => rule.details_unavailable !== undefined
    ),
    workflowPermissions,
  };
};

// This exported parser is an external configuration boundary, not an internal unknown domain value.
// eslint-disable-next-line anti-slop/no-unknown-parameters
export const validatePolicy = (value: unknown): Policy => {
  if (!isObject(value)) {
    throw new Error("Policy must be a JSON object");
  }
  const policy: Policy = {};
  for (const [key, enabled] of Object.entries(value)) {
    if (!settingKey(key) && key !== "actions_readonly") {
      throw new Error(`Unknown policy key: ${key}`);
    }
    if (!isBoolean(enabled)) {
      throw new Error(`${key} must be boolean`);
    }
    if (key === "actions_readonly" && !enabled) {
      throw new Error("actions_readonly may only be true");
    }
    policy[key] = enabled;
  }
  return policy;
};
export const buildSettingsPlan = (
  current: JsonObject & { workflowPermissions?: WorkflowPermissions },
  policy: Policy
): Plan => {
  const plan: Plan = { after: {}, before: {} };
  for (const [key, enabled] of Object.entries(validatePolicy(policy))) {
    if (key === "actions_readonly") {
      const previous = current.workflowPermissions;
      if (previous === undefined || previous.unavailable !== undefined) {
        throw new Error(
          "Workflow permissions unavailable; cannot safely plan apply"
        );
      }
      plan.workflowPermissions = {
        after: {
          can_approve_pull_request_reviews:
            previous.can_approve_pull_request_reviews,
          default_workflow_permissions: "read",
        },
        before: previous,
      };
    } else if (settingKey(key)) {
      const previous = current[key];
      if (!isBoolean(previous)) {
        throw new Error(`Missing repository setting: ${key}`);
      }
      plan.before[key] = previous;
      plan.after[key] = enabled;
    }
  }
  return plan;
};
export const isProposalOnlyChanges = (
  status: string,
  paths: (string | JsonObject)[]
): boolean =>
  paths.length > 0 &&
  paths.every((entry) => {
    const item = isString(entry) ? { path: entry, status } : entry;
    const state = item.status ?? status;
    const file = item.path;
    return (
      isString(file) &&
      isString(state) &&
      /^[AMD]$/u.test(state) &&
      item.symlink !== true &&
      item.submodule !== true &&
      item.type !== "symlink" &&
      item.type !== "submodule" &&
      !file.startsWith("/") &&
      !file.includes("\\") &&
      !file
        .split("/")
        .some((part) => part === "." || part === ".." || part.length === 0) &&
      /^openspec\/changes\/[A-Za-z0-9._-]+\/(?:.+\.md|\.openspec\.yaml)$/u.test(
        file
      )
    );
  });

const apply = (target: string, policy: Policy, audit: Audit): void => {
  const plan = buildSettingsPlan(
    { ...audit.repository, workflowPermissions: audit.workflowPermissions },
    policy
  );
  console.log(JSON.stringify({ mode: "apply", plan }, null, 2));
  try {
    if (
      Object.entries(plan.after).some(
        ([key, enabled]) => audit.repository[key] !== enabled
      )
    ) {
      gh(
        ["api", `repos/${target}`, "--method", "PATCH", "--input", "-"],
        JSON.stringify(plan.after)
      );
    }
    if (
      plan.workflowPermissions !== undefined &&
      audit.workflowPermissions.default_workflow_permissions !== "read"
    ) {
      gh(
        [
          "api",
          `repos/${target}/actions/permissions/workflow`,
          "--method",
          "PUT",
          "--input",
          "-",
        ],
        JSON.stringify(plan.workflowPermissions.after)
      );
    }
    const result = auditRepository(target);
    for (const [key, enabled] of Object.entries(plan.after)) {
      if (result.repository[key] !== enabled) {
        throw new Error(`Readback mismatch for ${key}`);
      }
    }
    if (
      plan.workflowPermissions !== undefined &&
      (result.workflowPermissions.default_workflow_permissions !== "read" ||
        result.workflowPermissions.can_approve_pull_request_reviews !==
          plan.workflowPermissions.after.can_approve_pull_request_reviews)
    ) {
      throw new Error("Workflow permissions readback mismatch");
    }
    console.log(JSON.stringify({ audit: result, mode: "result" }, null, 2));
  } catch (error) {
    throw new Error(
      `Remote settings may have changed; inspect manually. ${error instanceof Error ? error.message : "Apply failed"}`,
      { cause: error }
    );
  }
};
const main = (args: string[]): void => {
  if (args.length === 1 && (args[0] === "--help" || args[0] === "-h")) {
    console.log(
      "Usage: node scripts/github-policy.ts OWNER/REPO [--apply --policy <JSON|@FILE>]"
    );
    return;
  }
  const [targetArgument] = args;
  if (targetArgument === undefined) {
    throw new Error("Expected OWNER/REPO; use --help");
  }
  const target = validateOwnerRepo(targetArgument);
  let applyFlag = false;
  let policyText: string | undefined;
  for (let i = 1; i < args.length; i += 1) {
    if (args[i] === "--apply") {
      applyFlag = true;
    } else if (args[i] === "--policy") {
      i += 1;
      policyText = args[i];
      if (policyText === undefined) {
        throw new Error("Missing --policy value");
      }
    } else {
      throw new Error(`Unknown argument: ${args[i] ?? ""}`);
    }
  }
  if (applyFlag !== (policyText !== undefined)) {
    throw new Error(
      "--apply requires explicit --policy, and --policy requires --apply"
    );
  }
  const policy =
    policyText === undefined
      ? null
      : validatePolicy(
          JSON.parse(
            policyText.startsWith("@")
              ? readFileSync(policyText.slice(1), "utf-8")
              : policyText
          )
        );
  const audit = auditRepository(target);
  if (applyFlag && policy !== null) {
    apply(target, policy, audit);
  } else {
    console.log(JSON.stringify({ audit, mode: "audit" }, null, 2));
  }
};
const [, entry] = process.argv;
if (entry !== undefined && import.meta.url === pathToFileURL(entry).href) {
  main(process.argv.slice(2));
}
