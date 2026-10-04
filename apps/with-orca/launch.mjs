/* eslint-disable no-await-in-loop, sort-keys */
/* oxlint-disable promise/avoid-new */
import { execFileSync, spawn } from "node:child_process";
import {
  existsSync,
  readFileSync,
  realpathSync,
  statSync,
  writeFileSync,
} from "node:fs";
import path from "node:path";
import { createInterface } from "node:readline";
import { setTimeout as delay } from "node:timers/promises";

const systemPrompt =
  "You are the isolated Orca launch smoke role. Reply to every user message with exactly ORCA_HERDR_JCODE_SMOKE_OK. Never call tools, edit files, process issues, send messages, or perform external actions.";

const privateDirectory = (directoryPath) => {
  const directory = realpathSync(directoryPath);
  const info = statSync(directory);
  if (
    !info.isDirectory() ||
    info.uid !== process.getuid() ||
    info.mode % 0o100 !== 0
  ) {
    throw new Error(
      "Request directory must be owned by this user and private (0700)"
    );
  }
  return directory;
};

export const trigger = (directoryPath) => {
  const directory = privateDirectory(directoryPath);
  try {
    writeFileSync(
      path.join(directory, "request.json"),
      JSON.stringify({ role: "smoke" }),
      { flag: "wx", mode: 0o600 }
    );
    return { queued: true };
  } catch (error) {
    if (error.code !== "EEXIST") {
      throw error;
    }
    return { duplicate: true };
  }
};

const herdr = (...args) => {
  const output = execFileSync(process.env.HERDR_BIN_PATH || "herdr", args, {
    encoding: "utf-8",
  });
  return output.trim() ? JSON.parse(output).result : undefined;
};
const common = (cwd) =>
  realpathSync(
    execFileSync(
      "git",
      ["-C", cwd, "rev-parse", "--path-format=absolute", "--git-common-dir"],
      { encoding: "utf-8" }
    ).trim()
  );
const quote = (value) => `'${value.replaceAll("'", "'\\''")}'`;

const bridgeClient = (directory) => {
  const socket = path.join(directory, "daemon.sock");
  const child = spawn(
    "jcode",
    ["--socket", socket, "api-bridge", "--stdio", "--no-update"],
    {
      env: { ...process.env, JCODE_RUNTIME_DIR: directory },
      stdio: ["pipe", "pipe", "pipe"],
    }
  );
  const pending = new Map();
  let id = 0;
  let errorOutput = "";
  child.stderr.on("data", (data) => {
    errorOutput = (errorOutput + data).slice(-2000);
  });
  const lines = createInterface({ input: child.stdout });
  const rejectAll = (error) => {
    for (const entry of pending.values()) {
      clearTimeout(entry.timer);
      entry.reject(error);
    }
    pending.clear();
  };
  child.on("error", rejectAll);
  child.on("exit", (code) =>
    rejectAll(new Error(`Jcode bridge exited ${code}: ${errorOutput}`))
  );
  lines.on("line", (line) => {
    try {
      const frame = JSON.parse(line);
      const entry = pending.get(frame.reply_to);
      if (entry) {
        pending.delete(frame.reply_to);
        clearTimeout(entry.timer);
        if (frame.ev === "error") {
          entry.reject(new Error(JSON.stringify(frame)));
        } else {
          entry.resolve(frame);
        }
      }
    } catch (error) {
      rejectAll(error);
    }
  });
  return {
    close: () => {
      lines.close();
      child.stdin.end();
      child.kill();
    },
    notify: (request) => {
      id += 1;
      child.stdin.write(`${JSON.stringify({ v: 1, id, ...request })}\n`);
    },
    request: (request) =>
      new Promise((resolve, reject) => {
        id += 1;
        const requestId = id;
        const timer = setTimeout(() => {
          pending.delete(requestId);
          reject(new Error(`Jcode API timeout: ${request.req}`));
        }, 30_000);
        pending.set(requestId, { resolve, reject, timer });
        child.stdin.write(
          `${JSON.stringify({ v: 1, id: requestId, ...request })}\n`
        );
      }),
    socket,
  };
};

// One-shot orchestration keeps validation, launch, and failure cleanup together.
// eslint-disable-next-line complexity
export const relay = async (directoryPath, checkoutPath, repoPath) => {
  if (process.env.HERDR_ENV !== "1" || !process.env.HERDR_PANE_ID) {
    throw new Error(
      "Run inside Herdr. Do not spoof HERDR_ENV for unattended Orca runs."
    );
  }
  const directory = privateDirectory(directoryPath);
  const checkout = realpathSync(checkoutPath);
  if (common(checkout) !== common(realpathSync(repoPath))) {
    throw new Error("Checkout does not belong to configured repository");
  }
  const claim = path.join(directory, "claimed");
  try {
    writeFileSync(claim, "one-shot\n", { flag: "wx", mode: 0o600 });
  } catch (error) {
    if (error.code !== "EEXIST") {
      throw error;
    }
    return { duplicate: true };
  }
  const deadline = Date.now() + 90_000;
  const requestPath = path.join(directory, "request.json");
  while (!existsSync(requestPath)) {
    if (Date.now() >= deadline) {
      throw new Error(
        "Orca trigger timeout; use a new private directory to retry"
      );
    }
    await delay(100);
  }
  if (
    JSON.stringify(JSON.parse(readFileSync(requestPath, "utf-8"))) !==
    JSON.stringify({ role: "smoke" })
  ) {
    throw new Error("Only the fixed smoke role is supported");
  }
  const api = bridgeClient(directory);
  try {
    const hello = await api.request({
      client: "orca-herdr-poc",
      max_version: 1,
      min_version: 1,
      req: "hello",
    });
    if (hello.ev !== "hello_ok") {
      throw new Error("Unexpected Jcode handshake");
    }
    const attached = await api.request({
      req: "create_session",
      system_prompt: systemPrompt,
      working_dir: checkout,
    });
    const sessionId = attached.session?.session_id;
    if (attached.ev !== "attached" || !sessionId) {
      throw new Error("Jcode did not create a session");
    }
    const opened = herdr(
      "worktree",
      "open",
      "--cwd",
      repoPath,
      "--path",
      checkout,
      "--label",
      "Tribal Cities · launch POC",
      "--no-focus"
    );
    const workspaceId = opened.workspace?.workspace_id;
    if (!workspaceId) {
      throw new Error(
        `Unexpected Herdr workspace response: ${JSON.stringify(opened)}`
      );
    }
    const tab = herdr(
      "tab",
      "create",
      "--workspace",
      workspaceId,
      "--cwd",
      checkout,
      "--label",
      "Jcode smoke role",
      "--no-focus"
    );
    const paneId = tab.pane?.pane_id ?? tab.root_pane?.pane_id;
    if (!paneId) {
      throw new Error(`Unexpected Herdr tab response: ${JSON.stringify(tab)}`);
    }
    const result = {
      checkout,
      paneId,
      sessionId,
      socket: api.socket,
      state: "attached",
      systemPrompt,
      workspaceId,
    };
    const save = () =>
      writeFileSync(
        path.join(directory, "result.json"),
        JSON.stringify(result, null, 2),
        { mode: 0o600 }
      );
    save();
    herdr(
      "pane",
      "send-text",
      paneId,
      `exec env JCODE_RUNTIME_DIR=${quote(directory)} jcode --socket ${quote(api.socket)} --resume ${quote(sessionId)} --no-update`
    );
    herdr("pane", "send-keys", paneId, "Enter");
    api.notify({
      content: "Confirm your smoke role.",
      req: "send_message",
      session_id: sessionId,
    });
    while (Date.now() < deadline) {
      const history = await api.request({
        req: "get_history",
        session_id: sessionId,
      });
      const assistant = history.messages?.filter(
        (message) => message.role === "assistant"
      );
      if (assistant?.length) {
        if (assistant.at(-1).content.trim() !== "ORCA_HERDR_JCODE_SMOKE_OK") {
          throw new Error(
            "Smoke role response did not match its system prompt"
          );
        }
        result.history = history.messages;
        result.state = "responded";
        save();
        return result;
      }
      await delay(1000);
    }
    throw new Error(
      "Smoke response timeout; inspect result.json and the headed pane"
    );
  } finally {
    api.close();
  }
};
