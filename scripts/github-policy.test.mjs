import assert from "node:assert/strict";
import test from "node:test";

import {
  buildSettingsPlan,
  isProposalOnlyChanges,
  validateOwnerRepo,
  validatePolicy,
} from "./github-policy.ts";

await test("accepts exactly one OWNER/REPO positional target", () => {
  assert.equal(
    validateOwnerRepo("Priceless-Development/tribal-cities"),
    "Priceless-Development/tribal-cities"
  );
  for (const target of [
    "../evil/repo",
    "owner/../repo",
    "owner/name/repo",
    "owner/",
    "-owner/repo",
    "owner-/repo",
  ]) {
    assert.throws(() => validateOwnerRepo(target));
  }
});

await test("policy accepts only known boolean keys and cannot weaken readonly", () => {
  assert.deepEqual(
    validatePolicy({ actions_readonly: true, delete_branch_on_merge: true }),
    { actions_readonly: true, delete_branch_on_merge: true }
  );
  assert.throws(
    () => validatePolicy({ protections: false }),
    /Unknown policy key/u
  );
  assert.throws(
    () => validatePolicy({ allow_auto_merge: "yes" }),
    /must be boolean/u
  );
  assert.throws(
    () => validatePolicy({ actions_readonly: false }),
    /only be true/u
  );
  assert.throws(() => validatePolicy([]), /JSON object/u);
});

await test("plan includes only requested keys and preserves unrelated baseline", () => {
  const baseline = {
    allow_auto_merge: false,
    allow_squash_merge: true,
    delete_branch_on_merge: true,
  };
  const plan = buildSettingsPlan(
    {
      ...baseline,
      workflowPermissions: { can_approve_pull_request_reviews: true },
    },
    { allow_auto_merge: true }
  );
  assert.deepEqual(plan, {
    after: { allow_auto_merge: true },
    before: { allow_auto_merge: false },
  });
  assert.deepEqual(baseline, {
    allow_auto_merge: false,
    allow_squash_merge: true,
    delete_branch_on_merge: true,
  });
});

await test("workflow permission plan preserves existing approval setting", () => {
  const plan = buildSettingsPlan(
    { workflowPermissions: { can_approve_pull_request_reviews: true } },
    { actions_readonly: true }
  );
  assert.equal(
    plan.workflowPermissions?.after.default_workflow_permissions,
    "read"
  );
  assert.equal(
    plan.workflowPermissions?.after.can_approve_pull_request_reviews,
    true
  );
});

await test("proposal-only classifier rejects unsafe paths and file modes", () => {
  assert.equal(
    isProposalOnlyChanges("M", [
      "openspec/changes/add-thing/proposal.md",
      "openspec/changes/add-thing/.openspec.yaml",
    ]),
    true
  );
  for (const path of [
    "README.md",
    "openspec/changes/add-thing/code.ts",
    "openspec/changes/../secret.md",
    "/openspec/changes/add-thing/proposal.md",
    "openspec/changes/add-thing/notes.yaml",
    "openspec/changes/add-thing/.git/config",
  ]) {
    assert.equal(isProposalOnlyChanges("M", [path]), false, path);
  }
  assert.equal(isProposalOnlyChanges("M", []), false);
  assert.equal(
    isProposalOnlyChanges("R", ["openspec/changes/new/proposal.md"]),
    false
  );
  assert.equal(
    isProposalOnlyChanges("M", [
      { path: "openspec/changes/new/proposal.md", status: "M", symlink: true },
    ]),
    false
  );
  assert.equal(
    isProposalOnlyChanges("M", [
      {
        path: "openspec/changes/new/proposal.md",
        status: "M",
        submodule: true,
      },
    ]),
    false
  );
});
