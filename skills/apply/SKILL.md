---
name: apply
description: Execute one approved feature or an ordered feature queue through implementation, verification, recovery, and truthful closeout while preserving repository ownership and harness-native execution choices.
---

# Apply

Use after feature authoring has produced an approved, executable change. The change artifacts define the work; `tasks.md` is authoritative task state.

## Stages

1. Load the approved proposal, requirements, design, and tasks at a pinned repository revision.
2. Validate readiness: approval, incomplete tasks, explicit dependencies, touched paths, preconditions, and drift.
3. Build a task graph from declared dependencies and obvious local prerequisites. Do not impose DB/API/UI/E2E phases.
4. Execute bounded tasks with one accountable owner, exact file scope, and a verification recipe. Parallelize only non-conflicting work.
5. Invoke `gates` to select and run checks relevant to changed surfaces and proposal requirements. Record fresh command-level evidence.
6. Invoke `review` independently after the final implementation gates. Review the actual final diff, requirements, edge cases, security, scope, and evidence.
7. Repair every blocking or actionable finding, then rerun affected gates and the independent review against the repaired revision.
8. Mark completed tasks in `tasks.md` only from verified results; record blocked or deferred work explicitly.
9. Commit each bounded implementation unit with scoped staging and a descriptive history entry. Do not leave verified work as an uncommitted working-tree state.
10. Invoke `close` only after all required tasks, fresh gates, independent review, and required commits pass. `close` must confirm final persistence and archive state.

## Mandatory terminal sequence

`apply` cannot report completion or hand control to a completion handler until this sequence has produced durable evidence:

```text
final implementation
  → fresh gates
  → independent review
  → repair and repeat gates/review when needed
  → task and issue state update
  → scoped commits with verified history
  → archive
  → archive/persistence confirmation and log review
  → completed
```

Missing, stale, failed, or unverified evidence leaves the change `in_progress` or `blocked`. A task-local test, worker success message, clean diff, uncommitted worktree, or previous session result is not terminal evidence. The final review must inspect the commit range and confirm implementation, task state, proposal deltas, and archive changes are in scope. Do not add or honor a normal `apply`/`apply:all` option that skips gates, review, archive, or required commits. User-decision gates can park a change, but cannot convert it to `completed`.

## Invariants

- Honor explicit dependencies and isolate mutable-resource conflicts.
- Reconstruct progress from files, git state, task state, and verification evidence, never conversation memory alone.
- Never claim completion from worker output without repository evidence.
- Never mutate unrelated files or silently broaden scope.
- Do not create or require Beads, vendor issue IDs, telemetry, automatic pushes, or universal stack phases.
