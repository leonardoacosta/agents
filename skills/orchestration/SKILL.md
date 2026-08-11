---
name: orchestration
description: >-
  Use Orca orchestration for structured multi-agent coordination: threaded
  messages, blocking ask/reply flows, task dispatch, worker_done/escalation
  waits, task DAGs, decision gates, coordinator loops, or decomposing work
  across agents. Use `orca-cli` instead for full ownership handoffs, including
  requests phrased as "hand off", "handoff", "handover", "give this to another
  agent", or "another worktree" when the user did not explicitly ask to
  supervise, monitor, wait for results, or coordinate a DAG. Use `orca-cli` for
  ordinary terminal control, lightweight terminal prompts, shell commands, Orca
  worktree management, reading or waiting on terminals, and automation of the
  browser embedded inside Orca. Use Computer Use for browser windows, webviews,
  Orca app UI, or desktop UI outside Orca's embedded browser.
---

# Orca Orchestration

This file is a discovery stub, not the usage guide. The full, version-matched Orca
orchestration reference is served by the `orca` binary itself — kept out of this file on
purpose so it can never drift from the binary that will actually run your commands.

Engage Orca orchestration whenever you need structured multi-agent coordination: threaded
messages, blocking ask/reply flows, task dispatch, worker_done/escalation waits, task DAGs,
decision gates, coordinator loops, or decomposing work across agents. Use the orca-cli skill
instead for full ownership handoffs ("hand off", "handoff", "handover", "give this to
another agent", "another worktree") when the user did not ask to supervise, monitor, wait
for results, or coordinate a DAG — and for ordinary terminal control, shell commands,
worktree management, and the built-in browser. Coordination requires real Orca runtime
state; never substitute a non-Orca subagent tool.

For Jcode Command Center work involving initiatives, schedules, durable run state,
approvals, retry/cancel policy, or projection of Orca lifecycle evidence, load
`jcode-command-center-orchestration` first. This skill remains generic and supplies
supervised coordination mechanics only.

## Resolve the CLI for this session

Choose the executable once and reuse it for every later command:

- If the `ORCA_CLI_COMMAND` environment variable is set, use its value. Orca exports this
  for managed WSL sessions.
- Otherwise, in a dev checkout whose session exposes `ORCA_DEV_REPO_ROOT`, use `orca-dev`.
- Otherwise, on Linux outside an Orca-managed terminal, use `orca-ide`. Never run bare
  `orca` there — outside Orca's terminals it normally resolves to the
  GNOME Orca screen reader (`/usr/bin/orca`) and starts speech on the user's machine.
- Otherwise, use `orca`.

Below, `ORCA` is a placeholder for the executable you resolved. Substitute it before
running anything; do not create a shell variable or run `ORCA` literally. This works the
same way in POSIX shells, PowerShell, and cmd.exe.

If the selected executable cannot run, report its exact error and stop. Do not fall through
to another executable, which could silently target a different Orca build.

## Model-specific supervised workers

Prefer Orca's native supervised launcher whenever it can express the requested worker:

```text
ORCA orchestration worker-start ... --model <id> --effort <level>
```

Read the version-matched orchestration guide for the complete current call shape. Native
`worker-start` preserves Dispatch provenance, lifecycle ownership, messaging, gates, and
recovery. Do not bypass it merely to select a model or effort level.

Use a direct Jcode or Codex launch only when the current Orca launcher cannot express a
required provider or process argument. In that exceptional path:

1. Create or reuse the Orca worktree first.
2. Record that the worker is outside Orca's supervised-worker lifecycle.
3. Preserve the Task, Dispatch, worktree, terminal, model, and correlation identifiers.
4. Do not imply worker messaging, heartbeats, stop, abandon, retain, release, or recovery are
   available unless separately verified.
5. Reconcile the external result into Orca and Jcode only from explicit evidence.

A direct launch trades lifecycle integration for an otherwise unsupported process shape. It is
not the default optimization path.

## Headless runtime recovery

On Linux without a usable desktop window, use Orca's supported headless server instead of repeatedly retrying `open`:

```text
ORCA serve --no-pairing --project-root <absolute-repository-path> --json
```

Run it in a Herdr-managed pane when Herdr is the available terminal supervisor. The command is foregrounded and must remain alive. Verify readiness from a separate terminal:

```text
ORCA status --json
ORCA orchestration run-list --json
ORCA repo list --json
ORCA worktree current --json
```

A valid recovery requires `runtime.state: ready`, `reachable: true`, `orchestration.contract.v1` in capabilities, the repository registered, and the current worktree resolved. `ORCA orchestration run-current` requires a live Orca terminal sender, so treat `no_active_sender_terminal` as a terminal-binding issue, not a runtime failure. Keep the headless server running until the supervised run is complete; stop it through the owning Herdr pane afterward.


```text
ORCA skills get orchestration
```

That prints the complete, version-matched guide for the exact binary that will handle your
next commands — task creation and dispatch, injected lifecycle preambles, worker_done
authority, decision gates, and coordinator loops. Read it first, then run the specific
command you need.

Don't guess subcommands or flags from memory or from a cached copy of this stub. They
change between Orca releases, and this file deliberately no longer lists them. Confirm the
app is up with `ORCA status --json` (start it with `ORCA open --json` if needed), and
prefer `--json` for agent-driven calls.

## If an older Orca does not recognize `skills get`

Use this fallback only when the selected binary explicitly reports that `skills get` is an
unknown command. Another failure is not proof of an older binary; report it rather than
guessing or changing executables. For a confirmed pre-guide binary, use only this bounded,
read-only bootstrap to orient. Do not dead-end and do not invent commands:

```text
ORCA status --json
ORCA orchestration task-list --json
ORCA terminal list --json
```

Then tell the user that updating Orca restores the full, version-matched guide via
`ORCA skills get orchestration`. Beyond these commands, ask the user rather than guessing a
command surface this older binary may not support.
