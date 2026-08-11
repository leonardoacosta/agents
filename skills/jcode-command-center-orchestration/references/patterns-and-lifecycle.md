# Patterns and lifecycle

## Selection matrix

| User intent | Pattern | Generic skill |
|---|---|---|
| Transfer full ownership and return when complete | Full handoff | `orca-cli` |
| Supervise dependencies, gates, retries, or DAG completion | Run/Task/Dispatch | `orchestration` |
| Perform one narrow operator-driven action | Direct terminal | `orca-cli` |
| Inspect runtime state without changing it | Observation only | `orca-cli` or `orchestration` read surface |
| Pause for an authorized human decision | Decision gate | `orchestration` |

A phrase such as “hand this off” defaults to full handoff only when the user does not also ask
to supervise, monitor, wait on dependencies, coordinate a DAG, or control intermediate gates.

## Lifecycle

1. Resolve canonical executable identity.
2. Select one ownership pattern.
3. Record Jcode intent, authorization, correlation, and idempotency.
4. Load the version-matched generic Orca guide.
5. Launch or observe through verified mechanics.
6. Normalize ordered evidence.
7. Reconcile gaps before settlement.
8. Settle durable state from verified receipts.
9. Retain or release runtime resources intentionally.

## Replay and recovery

Replay scope is `(principal, initiative, Orca run, stream)`. Reject stale cursors after an
authorization change or retention expiry and return a fresh authorized snapshot. Unknown events
remain evidence-only.

After a crash, reconcile an existing idempotency envelope with Orca before retrying. Partial
launch or cleanup becomes recovery-required. Never claim cleanup for resources without a
verified release result.

## Scheduled work

A trigger makes durable intent eligible. It does not bypass policy. Run the same lifecycle as an
interactive command. Each retry gets a new Dispatch ID and attempt number while preserving the
schedule, Jcode run, correlation chain, and causal predecessor.
