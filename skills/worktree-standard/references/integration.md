# Client integration coverage

Local inspection, 2026-10-03. Applies to new helper-created worktrees only.

| Client | Policy delivery | Native root / gate coverage |
|---|---|---|
| jcode | Shared `~/.agents/skills/worktree-standard`; available through skill discovery/reload | Bundled docs support `~/.jcode/config.toml [hooks].pre_tool`; no hook installed, existing chains preserved |
| pi | Additive `~/.pi/agent/skills/worktree-standard` link | No native worktree root/gate verified |
| codex | Additive `~/.codex/skills/worktree-standard` link | Local config enables hooks, but specific rejection/root contract not verified |
| claude | Additive `~/.claude/skills/worktree-standard` link; existing shared instruction fallback | No native worktree creation hook installed |
| cursor | Additive `~/.cursor/skills/worktree-standard` and `~/.config/cursor/skills/worktree-standard` links | Discovery from this path and native root/gates unverified; explicit load via shared path is reliable fallback |
| orca | Explicit shared skill/helper path | Nested Codex runtime config is not proof of Orca-wide hook/root support |
| pi-durable | Explicit shared skill/helper path | Local source `~/dev/priceless/pi-durable` is an extension; separate client config surface not established |

Skill links are filesystem-verified, not proof that a running client has reloaded them. New sessions or client-specific skill reloads may be needed. Jcode can use `skill_manage reload_all`.

## Enforcement boundary

The helper is a guarded creation route, not a sandbox. Direct `git worktree add`, built-in UI actions, and clients that ignore instructions can bypass it. No global Git executable wrapper, filesystem permission restriction, or replacement global hooks were installed. Those would risk unrelated workflows.

Jcode docs establish a synchronous `pre_tool` gate, but shell parsing is not a complete security boundary and a client-wide rejection hook needs deliberate composition with existing gates. Until a tested adapter is installed, report coverage as **helper-enforced / agent-policy-advisory**, never universally enforced.

Native UI worktree settings need per-client documentation and real runtime verification before modification. Do not invent setting names. Use the helper for agent-driven creation now. Preserve all legacy worktrees.

## Verification

Run `python3 scripts/worktree.py --help` and `python3 -m unittest discover -s scripts/tests -v` from this skill directory. Tests create real temporary Git repos and check creation/branch protection, provenance, dirty/untracked state, commit preservation, locks, and path escape handling.
