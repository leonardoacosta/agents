import { execFileSync } from "node:child_process";
import { readFileSync, realpathSync } from "node:fs";

const config = JSON.parse(
  readFileSync(new URL("config/tribal-cities.json", import.meta.url), "utf-8")
);

const orca = (...args) => {
  let command = process.platform === "linux" ? "orca-ide" : "orca";
  if (process.env.ORCA_DEV_REPO_ROOT) {
    command = "orca-dev";
  }
  if (process.env.ORCA_CLI_COMMAND) {
    command = process.env.ORCA_CLI_COMMAND;
  }
  const data = JSON.parse(
    execFileSync(command, [...args, "--json"], { encoding: "utf-8" })
  );
  if (args[0] === "skills" && typeof data.markdown === "string") {
    return data;
  }
  if (!data.ok) {
    throw new Error(JSON.stringify(data.error ?? data));
  }
  return data.result;
};

export const validate = () => {
  const names = config.automations.map((item) => item.name);
  if (new Set(names).size !== names.length) {
    throw new Error("Duplicate automation names in config");
  }
  for (const item of config.automations) {
    if (!item.prompt.trim() || !["claude", "codex"].includes(item.provider)) {
      throw new Error("Invalid prompt/provider");
    }
  }
  return {
    disabled: true,
    names,
    precheck: "exit 1",
    workspace: config.workspace,
  };
};

const install = () => {
  validate();
  orca("skills", "get", "orca-cli");
  const existing = orca("automations", "list").automations;
  for (const item of config.automations) {
    const matches = existing.filter(
      (automation) => automation.name === item.name
    );
    if (matches.length > 1) {
      throw new Error(`Duplicate existing automation: ${item.name}`);
    }
    const command = matches.length ? ["edit", matches[0].id] : ["create"];
    const result = orca(
      "automations",
      ...command,
      "--name",
      item.name,
      "--trigger",
      "hourly",
      "--provider",
      item.provider,
      "--prompt",
      item.prompt,
      "--workspace",
      config.workspace,
      "--workspace-mode",
      "existing",
      "--fresh-session",
      "--precheck",
      "exit 1",
      "--disabled"
    );
    console.log(
      JSON.stringify({
        disabled: !result.automation.enabled,
        id: result.automation.id,
        name: item.name,
      })
    );
  }
};

const common = (cwd) =>
  realpathSync(
    execFileSync(
      "git",
      ["-C", cwd, "rev-parse", "--path-format=absolute", "--git-common-dir"],
      { encoding: "utf-8" }
    ).trim()
  );

const open = (path, label = "Tribal Cities · Orca") => {
  if (process.env.HERDR_ENV !== "1") {
    throw new Error(
      "Run inside Herdr. Do not spoof HERDR_ENV for unattended Orca runs."
    );
  }
  if (!path) {
    throw new Error("Provide an existing Orca-owned checkout path");
  }
  const checkout = realpathSync(path);
  const repo = realpathSync(config.repo);
  if (common(checkout) !== common(repo)) {
    throw new Error("Checkout does not belong to Tribal Cities");
  }
  execFileSync(
    "herdr",
    [
      "worktree",
      "open",
      "--cwd",
      repo,
      "--path",
      checkout,
      "--label",
      label,
      "--no-focus",
    ],
    { stdio: "inherit" }
  );
};

if (process.argv[1] && realpathSync(process.argv[1]) === import.meta.filename) {
  switch (process.argv[2]) {
    case "validate": {
      console.log(JSON.stringify(validate(), null, 2));
      break;
    }
    case "install": {
      install();
      break;
    }
    case "open": {
      open(process.argv[3], process.argv[4]);
      break;
    }
    default: {
      throw new Error(
        "Usage: node cli.mjs validate|install|open [path] [label]"
      );
    }
  }
}
