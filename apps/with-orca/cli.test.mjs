import assert from "node:assert/strict";
import { spawnSync } from "node:child_process";
import {
  chmodSync,
  existsSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from "node:fs";
import { tmpdir } from "node:os";
import path from "node:path";
import test from "node:test";

import { validate } from "./cli.mjs";
import { relay, trigger } from "./launch.mjs";

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

test("POC trigger queues once without Herdr access", () => {
  const directory = mkdtempSync(path.join(tmpdir(), "agents-launch-"));
  try {
    const env = { ...process.env };
    delete env.HERDR_ENV;
    const run = () =>
      spawnSync(process.execPath, ["cli.mjs", "trigger", directory], {
        cwd: import.meta.dirname,
        encoding: "utf-8",
        env,
      });
    assert.equal(run().status, 0);
    assert.deepEqual(
      JSON.parse(readFileSync(path.join(directory, "request.json"))),
      { role: "smoke" }
    );
    const duplicate = run();
    assert.equal(duplicate.status, 0);
    assert.match(duplicate.stdout, /duplicate/u);
  } finally {
    rmSync(directory, { force: true, recursive: true });
  }
});

test("POC relay refuses outside-session access before side effects", () => {
  const env = { ...process.env };
  delete env.HERDR_ENV;
  const result = spawnSync(
    process.execPath,
    ["cli.mjs", "relay", "/missing", "/missing"],
    {
      cwd: import.meta.dirname,
      encoding: "utf-8",
      env,
    }
  );
  assert.notEqual(result.status, 0);
  assert.match(result.stderr, /Run inside Herdr/u);
});

test("POC rejects shared request directories", () => {
  const directory = mkdtempSync(path.join(tmpdir(), "agents-launch-"));
  try {
    chmodSync(directory, 0o755);
    assert.throws(() => trigger(directory), /private \(0700\)/u);
    assert.equal(existsSync(path.join(directory, "request.json")), false);
  } finally {
    rmSync(directory, { force: true, recursive: true });
  }
});

test(
  "POC relay rejects wrong checkout before claiming",
  { skip: process.env.HERDR_ENV !== "1" || !process.env.HERDR_PANE_ID },
  async () => {
    const directory = mkdtempSync(path.join(tmpdir(), "agents-launch-"));
    try {
      await assert.rejects(relay(directory, import.meta.dirname, "/missing"));
      assert.equal(existsSync(path.join(directory, "claimed")), false);
    } finally {
      rmSync(directory, { force: true, recursive: true });
    }
  }
);

test(
  "POC relay suppresses duplicates and rejects injected role commands",
  { skip: process.env.HERDR_ENV !== "1" || !process.env.HERDR_PANE_ID },
  async () => {
    const directory = mkdtempSync(path.join(tmpdir(), "agents-launch-"));
    try {
      writeFileSync(
        path.join(directory, "request.json"),
        JSON.stringify({ command: "exit 0", role: "shell" })
      );
      await assert.rejects(
        relay(directory, import.meta.dirname, import.meta.dirname),
        /fixed smoke role/u
      );
      assert.deepEqual(
        await relay(directory, import.meta.dirname, import.meta.dirname),
        { duplicate: true }
      );
      assert.equal(existsSync(path.join(directory, "result.json")), false);
    } finally {
      rmSync(directory, { force: true, recursive: true });
    }
  }
);
