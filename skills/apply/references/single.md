# Single-feature lifecycle

## Resolve and claim

Resolve one feature from the repository's authoritative proposal and issue state. Confirm that it
is approved, strict-valid, dependency-ready, and not already complete or terminally dispositioned.
Claim or lock the feature through the repository-supported mechanism before substantial edits. An
active conflicting claim blocks execution.

## Preflight

Read repository guidance, the proposal, design, delta specifications, tasks, current main specs,
and relevant implementation. Recheck:

- exact dependencies and preconditions;
- touched paths and current dirty baselines;
- required tools, integrations, credentials, and environments;
- ownership boundaries and any separately authorized external repository;
- executable validation recipes and legal human gates.

Classify drift as unchanged, safely reconcilable, conflicting, or scope-expanding. Reconcile safe
drift, stop on conflict, and obtain authority before expanding scope.

## Execute

Work tasks in their declared dependency order. Give each task explicit path or responsibility
ownership and preserve test-first, migration, security, review, and operational requirements.
Record task completion only after its named evidence passes. On failure, collect the relevant
logs, identify a likely cause, and remediate within the approved scope.

## Verify and close

Run targeted checks plus every required regression, build, security, and operational gate. Require
fresh verification for the exact final bytes. Synchronize delta specifications and archive only
after implementation and validation succeed. Update issue state, preserve truthful external
repository outcomes, and complete required commit, push, or other persistence steps.

Report `completed` only when the repository's full completion contract is satisfied. Otherwise use
the precise non-completed outcome and retain enough durable evidence for recovery.
