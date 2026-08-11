# Patterns and lifecycle

## Selection matrix

| User intent | Ownership pattern | Generic skill |
|---|---|---|
| Transfer full ownership and return when complete | Full handoff | `orca-cli` |
| Supervise dependencies, gates, retries, or DAG completion | Run/Task/Dispatch | `orchestration` |
| Perform one narrow operator-driven action | Direct terminal | `orca-cli` |
| Inspect runtime state without changing it | Observation only | `orca-cli` or `orchestration` read surface |

A decision gate is an orthogonal control, not a fifth ownership pattern. Add it to the selected
ownership pattern when execution must pause for an authorized human decision. A supervised
Run/Task/Dispatch with a gate remains supervised orchestration.

A phrase such as “hand this off” defaults to full handoff only when the user does not also ask
to supervise, monitor, wait on dependencies, coordinate a DAG, or control intermediate gates.

## Lifecycle

1. Resolve environment-scoped Project, Repository, and host/setup identity.
2. Report live Orca runtime capabilities and installed Jcode adapter capabilities.
3. Select one ownership pattern.
4. Record Jcode intent, authorization, correlation, and idempotency.
5. Load the version-matched generic Orca guide.
6. Launch or observe only through capabilities verified on both the runtime and adapter.
7. Normalize ordered evidence.
8. Reconcile gaps before settlement.
9. Settle durable state from verified receipts.
10. Retain or release runtime resources intentionally.

## Replay and recovery

Replay scope is `(principal, initiative, Orca run, stream)`. Reject stale cursors after an
authorization change or retention expiry and return a fresh authorized snapshot. Unknown events
remain evidence-only.

After a crash, reconcile an existing idempotency envelope with Orca before retrying. If a
worker may still be running or termination is uncertain, abandon or fence its Dispatch rather
than claiming it stopped. Retain a worker or terminal only as an intentional live debugging
resource. Release workers, terminals, and worktrees only after settlement and verified release
evidence. Partial launch or cleanup becomes recovery-required, with each remaining resource
listed explicitly.

## Scheduled work

A trigger makes durable intent eligible. It does not bypass policy. Run the same lifecycle as an
interactive command. Each retry gets a new Dispatch ID and attempt number while preserving the
schedule, Jcode run, correlation chain, and causal predecessor.
