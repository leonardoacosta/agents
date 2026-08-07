---
name: scheduled-jobs
description: >
  Conventions for authoring, installing, and instrumenting scheduled work on managed hosts.
  Use when adding a new cron job, recurring task, systemd timer, launchd agent, scheduled script,
  nightly job, timer unit, OnCalendar schedule, or when touching any existing scheduled job.
  Triggers: new cron job, recurring task, systemd timer, launchd agent, scheduled script,
  nightly job, "run this every", timer unit, OnCalendar, schedule a job.
allowed-tools: Read, Glob, Grep, Bash
---

# Scheduled Jobs

> **North star.** One place answers "who owns this unit", "did it run", and "is it installed
> safely". The homelab inventory lives at `docs/reference/systemd-user-timer-provenance.md`
> (cc repo); this skill carries the conventions that inventory enforces.

## Directory-and-manifest model (`packages/cron`)

Each repo that owns schedules keeps them in one directory with a manifest listing every job.
A node project can adopt this literally as a workspace package; a system-hosted job adopts the
same shape as unit files plus a manifest.

```
packages/cron/          # or scripts/install/<job>-timer/ for cc-style units
  manifest.json         # job name, schedule, command, timeout, owner
  <job>.timer           # systemd unit (Linux)
  <job>.service         # paired service unit
```

The manifest is the human-readable index; the unit files are what systemd loads. Both stay in
the owning repo and deploy as **regular files** — never symlinks into a live git checkout.

## Naming: `<owner>-<job>`

| Good | Bad | Why |
| --- | --- | --- |
| `mesh-heartbeat` | `heartbeat` | Owner prefix makes namespace ownership recoverable |
| `recon-sweep` | `sweep` | Matches `mesh`, `recon`, `nova`, `nexus` prefix convention |
| `claude-ratchet` | `ratchet` | cc-owned jobs need the `claude-` or repo-short prefix |

When modifying any existing job whose name lacks a prefix, rename it as part of that change —
do not defer to a separate cleanup wave.

## Install kind: regular files only

**Never** install a timer as `ln -sf ~/dev/<repo>/... ~/.config/systemd/user/<unit>.timer`.

A symlinked unit points into a live git checkout. Any checkout, rebase, or branch switch can
momentarily unlink the target; systemd logs `Unit to trigger vanished`, fails the timer, and
**does not recover** on `daemon-reload` or reboot. On 2026-07-31 six cc-owned timers died in
the same second and stayed dead five days.

Correct pattern: copy or `install -m 644` the unit into `~/.config/systemd/user/`, then
`systemctl --user daemon-reload && systemctl --user enable --now <unit>.timer`.

See `docs/reference/systemd-user-timer-provenance.md` § Group A for the seven symlinked cc
units that form the standing remediation backlog.

## Run record (guideline, not a gate)

Every run — scheduled or manual — appends one structured record. Minimum fields:

| Field | Meaning |
| --- | --- |
| `ts_start` | ISO-8601 start timestamp |
| `ts_end` | ISO-8601 end timestamp |
| `job` | Job name (`<owner>-<job>`) |
| `trigger` | `cron`, `manual`, or `systemd` |
| `host` | Hostname |
| `exit` | Exit code |
| `duration_s` | Wall seconds |
| `timed_out` | Boolean |

Reach for a structured-logging library that produces pino-shaped output where one exists for
the job's language. Where no library fits, emit the fields by any means (JSONL append, shell
heredoc) — the shape matters, not the library.

Reference implementation: `~/dev/personal/shepherd-plugins/bin/jobs-run.sh` (also carries
optional `cost_usd` and `result` for agent jobs).

Manual runs MUST use the same entry point as scheduled runs. A job that bypasses the recorder
is invisible to every downstream health check — the failure class behind the 2026-07-17..21
docs-hygiene incident (89 sessions, zero assistant turns, exit 0 every time).

## Mechanism stance

| Mechanism | Status |
| --- | --- |
| systemd user timers | **Standard** on Linux hosts |
| launchd | Documented macOS twin |
| cron / anacron / at | Non-standard; unavailable on the homelab (no cron daemon) |
| GitHub Actions / Vercel crons | Document separately; out of scope for unit-file conventions |

## On-contact remediation

When you touch **any** existing scheduled job for any reason, bring that job to convention in
the same change:

1. Rename to `<owner>-<job>` if unprefixed
2. Convert symlink installs to regular-file copies
3. Wire run-record emission if missing

Do not open a separate cleanup wave. The standing backlog is the seven cc-owned symlinked units
in `docs/reference/systemd-user-timer-provenance.md` § Group A (`ratchet`, `wt-reap`,
`wisp-purge`, `metrics-drain`, `intel-brief`, `eval-kpi`, `recon-sweep`).

## Verify

```bash
# install kind for a unit
f=~/.config/systemd/user/<owner>-<job>.timer
[ -L "$f" ] && echo "FAIL: symlink" || echo "OK: regular file"

# last run record (shepherd jobs-run shape)
tail -1 ~/.local/state/shepherd/jobs/runs.jsonl | jq .
```
