# Capability and evidence contract

For each mutation, establish this table before execution:

| Field | Required content |
|---|---|
| Owner | Jcode policy owner and Orca runtime owner |
| Capability | Verified operation exposed by both the selected Orca version and installed Jcode adapter |
| Preconditions | Expected revision, current runtime state, authorization, canonical identity |
| Idempotency | Durable key and duplicate-result behavior |
| Command | Typed Jcode command, not guessed CLI syntax |
| Success evidence | Correlated Orca receipt and expected terminal state |
| Failure behavior | Typed rejection with authoritative state unchanged |
| Unavailable behavior | Unsupported/unavailable, never silent downgrade |
| Cleanup | Resources to retain or release and proof required |

The currently shipped Command Center adapter is status-only and therefore observation-only.
Even when the live Orca CLI supports worker launch, retry, cancellation, or cleanup, Command
Center must advertise those mutations as unavailable until the adapter implements and verifies
them. Runtime capability does not imply adapter capability.

## Fail-closed cases

- Unknown Orca command or schema
- Unresolved or ambiguous project identity
- Missing permission or approval
- Stale revision or runtime precondition
- Replay requested outside authorization scope
- Duplicate request with conflicting payload
- Crash recovery where prior effect cannot yet be reconciled
- Partial cleanup

## Acceptance evidence

A complete change demonstrates:

- correct routing among full handoff, supervised coordination, direct action, observation, and gate
- canonical project identity never sourced from runtime ID
- distinct project/repository/environment/host-setup/run/task/dispatch/worktree/terminal/correlation/idempotency fields
- schedule and interactive parity
- authorization-scoped replay and snapshot fallback
- unsupported mutation and Orca-unavailable degraded states
- crash-safe duplicate prevention
- explicit partial-cleanup recovery
- durable settlement only after verified receipts
