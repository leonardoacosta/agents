# Azure Pipeline Live Monitor (snapshot + stream)

LIVE present-tense visibility into an Azure DevOps project's pipeline state and App Insights
error stream. For RETROSPECTIVE log queries (last-24h aggregations, top exceptions), use your
log provider's historical-query surface instead.

## Modes

| Mode | Description | Default |
|------|-------------|---------|
| `--prod` | Target production pipeline | off |
| `--dev` | Target dev pipeline | on |
| `--deploys` | Snapshot pipeline state and exit | off |
| `--logs` | Skip snapshot, tail App Insights only | off |

Default behaviour: two-phase — snapshot pipeline first, then tail App Insights
until the Monitor lifetime ends.

## Project Registry

Resolve the Azure DevOps org and project for the target project from wherever your project
registry lives (a config file, an env var, or a lookup table keyed by project code). Skip Azure
monitoring entirely for projects that don't have an Azure DevOps pipeline configured — print an
instructive error and exit rather than polling a nonexistent pipeline.

## Prerequisites

Requires the `az` CLI authenticated (`az login`) with the `azure-devops` extension and
App Insights read permission.

## Phase 1: Live Pipeline Snapshot

```bash
source /path/to/monitor-helpers.sh
ORG="my-ado-org"
AZP="my-ado-project"
monitor_azure_pipeline "$ORG" "$AZP" "" 20
```

Emits `<state>\t<run_id>\t<url>` once on terminal state. Exits when the run
reaches succeeded / failed / canceled.

## Phase 2: Live App Insights Tail

```bash
APP_INSIGHTS_ID="${APP_INSIGHTS_ID:?APP_INSIGHTS_ID env var required}"
monitor_azure_logs "$APP_INSIGHTS_ID" 15
```

Emits `<severity>\t<operation>\t<msg>` per error event. Stream-only.

## Cross-References

- `references/vercel.md` — peer (Vercel deploy + log stream)
- `references/better-stack.md` — peer (uptime + Logtail stream)
