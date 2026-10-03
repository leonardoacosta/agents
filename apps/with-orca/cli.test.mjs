import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import test from "node:test";

import { validate } from "./cli.mjs";

test("definitions remain disabled and fail closed", () => {
  const result = validate();
  assert.equal(result.names.length, 3);
  assert.equal(result.disabled, true);
  assert.equal(result.precheck, "exit 1");
});

test("Herdr bridge refuses outside-session access", () => {
  const env = { ...process.env };
  delete env.HERDR_ENV;
  const result = spawnSync(
    process.execPath,
    ["cli.mjs", "open", "/home/nyaptor"],
    { cwd: import.meta.dirname, encoding: "utf-8", env }
  );
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Run inside Herdr/u);
});

test("unknown commands fail without mutations", () => {
  const result = spawnSync(process.execPath, ["cli.mjs", "unknown"], {
    cwd: import.meta.dirname,
    encoding: "utf-8",
  });
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Usage:/u);
});
