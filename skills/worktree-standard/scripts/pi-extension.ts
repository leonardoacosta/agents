import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { spawnSync } from "node:child_process";
import { homedir } from "node:os";
import { join } from "node:path";

const guard = join(homedir(), ".agents", "skills", "worktree-standard", "scripts", "hook.py");

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", (event) => {
    if (event.toolName !== "bash" && event.toolName !== "bg_start") return;
    const client = event.toolName === "bg_start" ? "pi-durable" : "pi";
    const result = spawnSync("python3", [guard, "--client", client], {
      input: JSON.stringify({ tool_name: event.toolName, tool_input: event.input }),
      encoding: "utf8",
      timeout: 5000,
    });
    if (result.error || result.status === null) {
      return { block: true, reason: `Worktree guard unavailable: ${result.error?.message ?? "no exit status"}` };
    }
    if (result.status !== 0) {
      return { block: true, reason: result.stdout || result.stderr || "Worktree guard blocked command; use worktree.py helper." };
    }
    return undefined;
  });
}
