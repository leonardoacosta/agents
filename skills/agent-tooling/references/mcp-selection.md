# MCP Server Selection

## Selection Criteria

Add a new MCP server ONLY if ALL criteria are met:

| Criterion          | Requirement                               |
| ------------------ | ----------------------------------------- |
| **Repeated need**  | Used in >3 sessions                       |
| **Stability**      | Maintained, active updates                |
| **No duplication** | Doesn't overlap CLI tools                 |
| **Security**       | Env vars for auth, Docker if write access |
| **Performance**    | <2s startup impact                        |

### Anti-Patterns

| Anti-Pattern                             | Use Instead               |
| ---------------------------------------- | ------------------------- |
| Duplicate CLI tools (`git`, `gh`, `npm`) | Direct CLI via Bash       |
| No authentication (public APIs)          | WebFetch or direct HTTP   |
| Always-on connections (WebSocket)        | Event-driven architecture |
| Unstable/abandoned (>6mo stale)          | Wait for stability        |
| Single-use case                          | Direct API call           |

The five anti-patterns above are the concrete failure modes behind the criteria table, not
abstract advice — each one has cost a real debugging or maintenance loop somewhere:

- **Never add an MCP server that duplicates a CLI tool already in reach.** If `git`, `gh`, or
  `npm` already does the job, calling it via `Bash` is cheaper to reason about and doesn't add a
  persistent process to keep alive.
- **Never add a server for an API with no auth.** An unauthenticated public API doesn't need a
  standing connection — `WebFetch` or a direct HTTP call is strictly simpler.
- **Never keep an always-on connection (e.g. WebSocket) alive for event-driven work.** Prefer an
  architecture that connects on demand.
- **Never rely on an unmaintained server.** >6 months without an update is a signal to wait, not
  to adopt — a stale server becomes a maintenance liability the moment its upstream API shifts.

### Adding a New Server

1. **Evaluate** against the criteria above.
2. **Test** in an isolated environment before wiring it into a shared config.
3. **Secure** with env vars for auth, Docker if the server has write access.
4. **Document** it — server purpose, auth mechanism, and status — wherever your project tracks
   its tooling inventory.
5. **Monitor** session startup time and stability after adoption; a server that regresses on
   either criterion after the fact should be reconsidered, not grandfathered in.

## Verify It Fired, Not Just That It's Configured

An MCP server listed as "connected" in your tooling inventory describes configured intent, not
confirmed execution. Before trusting a mechanism in a workflow, verify it actually fired — a log
line, a matcher test, or a liveness check — rather than assuming "connected" means "used
correctly on the last run."

## Choosing Between Two Tools for the Same Job (benchmark methodology)

When two tools can do the same job (e.g. a structural/interactive snapshot mode vs a full DOM
snapshot mode of a browser-automation tool), a benchmark comparing them is a claim about that
specific pairing, not a universal ranking — if either tool changes or one becomes unavailable,
the number needs re-measuring, not re-quoting. A reusable rubric for running that comparison:

| Metric | What It Measures |
| ------ | ----------------- |
| Output chars | Raw response size from each mode |
| Est. tokens | chars / 4 (rough token-per-character ratio) |
| Ratio | larger-mode chars / smaller-mode chars (how many x larger) |
| Savings % | (1 - smaller/larger) * 100 |
| Cost/call | Estimated API cost at the model's per-token rate |

Interpreting the ratio: >5x means the smaller mode is significantly more efficient for that use
case; 2-5x is a moderate improvement; <2x is minimal difference (the content is likely already
simple). Prefer the leaner mode as the default; drop to the fuller mode only when the task needs
detail the leaner mode omits (e.g. full visual layout inspection vs an interactive/structural
summary).

## Security Standards

- Store tokens in an env file excluded from version control, never hardcoded in the server config.
- Use Docker containers to isolate write-access servers.
- Prefer read-only access and the minimum scopes the task needs.
