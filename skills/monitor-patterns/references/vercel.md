# Vercel Live Monitor (snapshot + stream)

LIVE present-tense visibility into a Vercel project's deploy pipeline and runtime log stream.
For RETROSPECTIVE log queries (time-window aggregation, historical errors), use your log
provider's historical-query surface instead — a live monitor and a retrospective query tool are
different jobs and shouldn't be conflated into one command.

## Modes

| Mode | Description | Default |
|------|-------------|---------|
| `--prod` | Target production branch | off |
| `--dev` | Target dev branch | on |
| `--deploys` | Snapshot deploy state and exit | off |
| `--logs` | Skip snapshot, tail logs only | off |
| `--json` | Structural JSON output for the snapshot | off |

Default behaviour (no `--deploys` / `--logs`): two-phase — snapshot first, then
stream logs until the Monitor lifetime ends.

## Project Registry

Resolve the Vercel project slug for the target project from wherever your project registry
lives (a config file, an env var, or a lookup table keyed by project code). Skip Vercel
monitoring entirely for projects that don't have Vercel deploys configured — print an
instructive error and exit rather than polling a nonexistent project.

## Prerequisites

Requires a `VERCEL_TOKEN` environment variable and the `vercel` CLI authenticated.

## Phase 1: Live Deploy Snapshot

```bash
source /path/to/monitor-helpers.sh
PROJECT="my-vercel-project"
BRANCH=$([ "$TARGET" = "prod" ] && echo "main" || echo "dev")
monitor_vercel_deploy "$PROJECT" "$BRANCH" 15
```

Emits `<state>\t<deploy_id>\t<url>` once on terminal state. Exits when the
deploy reaches READY / ERROR / CANCELED. Skipped if `--logs` is passed.

## Phase 2: Live Log Tail

```bash
monitor_vercel_logs "$PROJECT" "$BRANCH" 15
```

Emits `<level>\t<route>\t<msg>` per error/warning event. Stream-only — no
terminal state; the Monitor invocation bounds runtime.

## Cross-References

- `references/azure.md` — peer (Azure pipeline snapshot + App Insights tail)
- `references/better-stack.md` — peer (uptime + Logtail stream)
