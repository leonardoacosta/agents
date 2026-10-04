# Orca integration

Inspected 2026-10-04 on Orca `1.4.176` (`orca-ide`). Shared-skill links already present in host Claude, Codex, and Pi homes; added links to Orca's managed Codex runtime home (`~/.config/orca/codex-runtime-home/home`):

- `~/.claude/skills/worktree-standard` → `~/.agents/skills/worktree-standard`
- `~/.codex/skills/worktree-standard` → `~/.agents/skills/worktree-standard`
- `~/.pi/agent/skills/worktree-standard` → `~/.agents/skills/worktree-standard`
- `~/.config/orca/codex-runtime-home/home/skills/worktree-standard` → `~/.agents/skills/worktree-standard`
- `~/.config/orca/codex-runtime-home/home/.agents/skills/worktree-standard` → `~/.agents/skills/worktree-standard`

Use this skill's `scripts/worktree.py` helper with `--client orca` for Orca-created worktrees. No host runtime links/configs were changed.

## Native root

Orca exposes a supported **per-repo** `worktree-base-path` on `orca project setup-create` / `setup-update`. In installed source, `shared/worktree-ownership.js` reads it to build known workspace layouts for discovery. `orca worktree create` accepts a repo selector and worktree name, but the CLI request has no base-path argument. The package contains no verified creation-path use of this setting or documented append/template behavior. Therefore, despite authorization for additive roots, no existing repo setup was updated: effect on future native creation could not be verified, and changing discovery metadata alone would not satisfy the requested root guarantee. The 10 current git repo records remain unchanged.

The CLI/catalog exposes no Orca-native pre-tool policy hook or global worktree mutation guard. Do not infer that nested Codex config is an Orca-wide guard. Orca runtime `~/.config/orca/codex-runtime-home/home/hooks.json` has two existing `PreToolUse` entries; this integration left that chain unchanged. The host Codex hook chain may have changed independently during this task, so it is not described here.

## Enforcement boundary

The shared hook accepts `--client orca` and rejects matching raw Git worktree mutation commands when invoked with JSON stdin. Orca exposes no verified hook-registration route, so no nested Codex hook was added and this is not an Orca-wide native gate. The skill/helper is the documented route; instructions and the helper do not prevent bypass through Orca's native UI or another direct Git invocation.

No Orca app source, existing Orca runtime config, or worktree path was modified. The native UI bypass remains untested and unblocked. Native worktree-root behavior remains unverified.
