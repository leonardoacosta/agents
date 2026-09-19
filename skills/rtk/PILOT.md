# RTK pilot

## Installation and use

Shared instruction-only skill: `~/.agents/skills/rtk/SKILL.md`.
On this machine `~/.agents/skills` resolves to `/home/nyaptor/dev/agents/skills`; no Empryo or jcode source changes are required. Other harnesses that discover this shared directory can also see the skill.

In either harness, ask: **Load the rtk skill for this session.**

Empryo headless supports `empryo --headless --skill rtk '<task>'`.
Jcode exposes `skill_manage` with `action: load, name: rtk`. If an existing daemon has a stale registry, ask it to `reload_all` before loading.

This is opt-in guidance, not automatic interception. Native structured tools remain preferred. No hooks, PATH overrides, shell startup changes, installs, or telemetry settings were added by this pilot.

## Observed checks

- Installed RTK: 0.44.2.
- Empryo discovered and loaded the new skill through its skill loader.
- Fresh Empryo headless smoke: exit 0; shell tool used; response reported RTK status and selected raw `git status --porcelain=v1` for machine output.
- Fresh jcode smoke: exit 0. Persisted session tool calls confirm `skill_manage` loaded `rtk`, then `bash` executed `rtk git status`. Response selected raw porcelain output.
- Direct Git status comparison in a disposable repo containing 30 untracked text files: raw 642 bytes, RTK 535 bytes, both exit 0. This is 16.7% fewer output bytes in one synthetic example, not a token/cost benchmark.
- Failure outside a Git repo: raw Git and RTK both exited 128. RTK reduced the diagnostic to `Not a git repository`.
- Harness startup added `.gitignore` to the disposable fixture. Agent responses therefore described 31 untracked files, while the earlier direct comparison used 30.
- Empryo emitted a warning from an existing `~/.claude/scripts/hooks/apply-lock-heartbeat.sh` hook. This pilot did not install or repair it.
- Markdown-only skill has no detected project typecheck/lint/test commands. Successful skill loading and live smoke runs are the runtime checks; no comprehensive skill benchmark was performed.

Temporary smoke output: `/tmp/rtk-pilot-qg9uyq0v/`. Treat it as ephemeral; this document retains the bounded results. Existing harness session and RTK usage records were produced by running the tools.

## Rollback

Unload `rtk` from active sessions, then remove only the new `~/.agents/skills/rtk` directory (SKILL.md and this report). Reload the jcode skill registry or start a fresh session. Do not remove the shared skills directory or the pre-existing RTK binary.
