# Better Stack Live Monitor (stream-only)

LIVE present-tense visibility into Better Stack uptime monitor state and a filtered error log
tail. RETROSPECTIVE log queries (last-N-hours aggregations, top-error grouping, time-window
analysis) belong in a separate historical-query tool, not this live stream.

## Modes

| Mode | Description | Default |
|------|-------------|---------|
| `--uptime` | Stream uptime monitor state changes only | off |
| `--logs` | Stream Logtail error events only | off |

Default behaviour (no flag): stream both — uptime + logs interleaved.

## Prerequisites

- `BETTERSTACK_API_TOKEN` env var (Bearer token, monitor read scope)
- `LOGTAIL_SOURCE_TOKEN` env var for `--logs` (per-source token)
- A Better Stack MCP server, if available, as a fallback for richer triage workflows
  (the helpers below use the REST API directly)

## Stream: Live Uptime + Logtail

```bash
source /path/to/monitor-helpers.sh

# Run both helpers in parallel — Monitor invocation captures both stdouts.
if [ "$MODE" != "logs" ]; then
  monitor_bstack_uptime 30 &
fi
if [ "$MODE" != "uptime" ]; then
  monitor_bstack_logtail "$LOGTAIL_SOURCE_TOKEN" 15 &
fi
wait
```

Stream-only — no terminal state. The Monitor invocation bounds runtime.

## Cross-References

- `references/vercel.md` — peer (Vercel deploy + log stream)
- `references/azure.md` — peer (Azure pipeline snapshot + App Insights tail)
