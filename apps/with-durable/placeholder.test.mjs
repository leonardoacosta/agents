import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import test from "node:test";

test("placeholder refuses deployment rather than claiming success", () => {
  const result = spawnSync(process.execPath, ["placeholder.mjs", "--deploy"], {
    cwd: import.meta.dirname,
    encoding: "utf-8",
  });
  assert.equal(result.status, 1);
  assert.match(result.stderr, /not implemented/u);
});
