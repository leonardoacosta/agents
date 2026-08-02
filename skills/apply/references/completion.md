# Terminal outcomes and completion

## Outcome vocabulary

- `completed`: requested scope is implemented; fresh verification passes; required issue state,
  specification synchronization, archive, external outcomes, and persistence are complete.
- `blocked`: a prerequisite, authority, conflict, or external condition prevents safe progress and
  the repository's threshold for declaring a block is satisfied.
- `failed`: execution reached a terminal unsuccessful result that requires a new attempt or repair.
- `skipped`: work was intentionally not executed for a recorded, policy-valid reason, often because
  a prerequisite failed or the work was already satisfied.
- `deferred`: repository workflow explicitly parks the work for a later condition or time; it is not
  a euphemism for unfinished execution.

Use the repository's own more specific definitions when they impose a stricter threshold. Never
mark work completed merely because code exists, a subset of tests passes, or a budget is ending.

## Completion evidence

Before reporting `completed`, prove all applicable rows against the final state:

1. Every task and acceptance scenario is implemented.
2. Targeted tests, regression suites, builds, security checks, and operational gates provide fresh
   verification for the final bytes and environment.
3. Valid human post-gates and external repository outcomes are resolved.
4. Main specifications reflect the accepted behavior and the proposal is archived correctly.
5. Feature and task issues have current terminal state.
6. Required commits, pushes, releases, deployments, or other persistence have succeeded.
7. Unrelated dirty work remains preserved.

If any applicable row is incomplete, continue safely or report the exact non-completed outcome with
the causal evidence and the next recoverable action.
