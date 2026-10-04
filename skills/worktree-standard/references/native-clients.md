# Native client hooks

Install these as additional hooks; merge into existing event arrays. Do not replace existing hooks or unrelated settings. These are local user-level registrations. The shared gate is best-effort shell-pattern detection, not a sandbox.

## Shared gate

```text
~/.agents/skills/worktree-standard/scripts/hook.py --client <client>
```

Reads JSON on stdin and recursively checks string fields named `command`, `cmd`, and `script`. Claude Code and Codex: exit 0 allows; exit 2 with the diagnostic on stderr denies. Cursor: `beforeShellExecution` receives JSON and supports stdout response `{"permission":"deny","user_message":"…","agent_message":"…"}`; exit 2 also blocks. Gate currently emits that Cursor response for both allow and deny.

## Claude Code

Add one `PreToolUse` matcher `Bash` entry:

The special `WorktreeCreate` hook uses `scripts/claude-create.py`, which maps `cwd`, `session_id`, and a lowercase kebab-case `name` (fallback `worktree`) to the shared helper (`--type task`). Its stdout is only the absolute path. The existing user-level `WorktreeCreate` shell wrapper was updated to call this adapter and retains telemetry forwarding. The settings hook wrapper remains in place.

```json
{"matcher":"Bash","hooks":[{"type":"command","command":"python3 ~/.agents/skills/worktree-standard/scripts/hook.py --client claude","timeout":5}]}
```

## Codex

Add one `PreToolUse` matcher `Bash` entry in `~/.codex/hooks.json`:

```json
{"matcher":"Bash","hooks":[{"type":"command","command":"python3 ~/.agents/skills/worktree-standard/scripts/hook.py --client codex","timeout":5}]}
```

Codex applies matchers to canonical `tool_name`; its documented Bash input uses `tool_input.command`. It supports denying with exit 2 and a reason on stderr. Concurrent matching hooks cannot prevent other hooks from starting, so this gate denies the tool call, not arbitrary side effects from other hooks.

## Cursor

Append to `beforeShellExecution` in `~/.cursor/hooks.json`:

```json
{"command":"python3 ~/.agents/skills/worktree-standard/scripts/hook.py --client cursor","timeout":5}
```

Cursor command hooks receive JSON on stdin. Exit 2 blocks; supported JSON permission output includes `permission`, with optional user/agent messages. Other exit codes fail open by default.

## Claude Code WorktreeCreate

Claude's special `WorktreeCreate` contract differs from a normal PreToolUse hook: stdin includes `session_id`, `cwd`, and `name`; stdout must contain only the absolute worktree path. The installed creator now delegates to `scripts/claude-create.py`, which maps the name to a task slug and converts helper JSON to path-only stdout. The existing hook wrapper and telemetry forwarding are preserved. Adapter tests create a real temporary Git worktree; an end-to-end Claude session creation was not exercised.

## Sources

- Claude Code hooks: https://docs.anthropic.com/en/docs/claude-code/hooks
- Codex hooks: https://developers.openai.com/codex/hooks/
- Cursor hooks: https://cursor.com/docs/hooks
