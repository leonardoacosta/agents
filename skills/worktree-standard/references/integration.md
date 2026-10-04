# Client integration coverage

Local inspection, 2026-10-03. Applies to new helper-created worktrees only.

| Client | Policy delivery | Native root / gate coverage |
|---|---|---|
| jcode | Shared `~/.agents/skills/worktree-standard`; available through skill discovery/reload | Installed `~/.jcode/config.toml [hooks].pre_tool` using shared `hook.py --client jcode`; live native rejection and read-only/helper allowance verified |
| pi | Additive `~/.pi/agent/skills/worktree-standard` link | Global `~/.pi/agent/extensions/worktree-standard.ts` gates Bash `tool_call` via shared `hook.py --client pi`; Pi discovers this standard extension path automatically, so no settings edit. Guard must be installed at the shared helper path. |
| codex | Additive `~/.codex/skills/worktree-standard` link | Additive native `PreToolUse` shell hook in `~/.codex/hooks.json`; rejection payload tested, full Codex dispatch verification pending |
| claude | Additive `~/.claude/skills/worktree-standard` link; existing shared instruction fallback | Additive native `PreToolUse` Bash hook in `~/.claude/settings.json`; existing creator delegates to bundled `claude-create.py` with path-only stdout and preserved telemetry; real temporary Git creation test passed; full Claude session dispatch not exercised |
| cursor | Additive `~/.cursor/skills/worktree-standard` and `~/.config/cursor/skills/worktree-standard` links | Additive `beforeShellExecution` hook in `~/.cursor/hooks.json`; allow/deny JSON contract tested; full Cursor dispatch verification pending |
| orca | Explicit shared skill/helper path | Nested Codex runtime config is not proof of Orca-wide hook/root support |
| pi-durable | Explicit shared skill/helper path | `pi-durable` is a Pi extension (`pi.extensions` in its package metadata), not a separate client. The global Pi adapter gates Bash and registered `bg_start` tool calls before execution, labeling `bg_start` as `pi-durable`. Direct background subprocess invocations outside Pi's tool pipeline remain outside coverage. |

Skill links are filesystem-verified, not proof that a running client has reloaded them. New sessions or client-specific skill reloads may be needed. Jcode can use `skill_manage reload_all`.

## Enforcement boundary

The helper is a guarded creation route, not a sandbox. Direct `git worktree add`, built-in UI actions, and clients that ignore instructions can bypass it. Native tool hooks use `scripts/hook.py` where supported. No global Git executable wrapper, filesystem permission restriction, or replacement global Git hooks were installed. Those would risk unrelated workflows.

Jcode's synchronous `pre_tool` gate is installed and live-tested. Shell parsing is not a complete security boundary. Report verified native tool gates per client separately from helper enforcement and advisory policy; never claim universal enforcement.

Native UI worktree settings need per-client documentation and real runtime verification before modification. Do not invent setting names. Use the helper for agent-driven creation now. Preserve all legacy worktrees.

## Client references

Read `native-clients.md` for Claude/Codex/Cursor hook contracts, `pi-integration.md` for Pi/pi-durable tool-event coverage, and `orca-integration.md` for runtime homes and native UI limitations.

## Verification

Run `python3 scripts/worktree.py --help` and `python3 -m unittest discover -s scripts/tests -v` from this skill directory. Tests create real temporary Git repos and check creation/branch protection, provenance, dirty/untracked state, commit preservation, locks, and path escape handling.
