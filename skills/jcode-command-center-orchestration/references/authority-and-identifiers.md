# Authority and identifiers

## Authority matrix

| Concern | Authority |
|---|---|
| Initiative, milestone, blocker, checkpoint | Jcode |
| Schedule intent and retry policy | Jcode |
| Permission, approval, idempotency, rollback intent | Jcode |
| Canonical executable repository/project | Orca |
| Worktree, Run, Task, Dispatch, worker, terminal, gate | Orca |
| Durable outcome settlement | Jcode, after verified Orca receipt |
| Browser selection, expansion, resize state | Browser only |

## Identifier rules

Preserve every identifier in its own typed field. Never derive one domain from another.

- Resolve project identity from Orca repository/project data matched to the canonical absolute
  repository path.
- Runtime ID identifies the running Orca service instance. It is not a project ID.
- A Task describes a durable Orca work contract. A Dispatch identifies one concrete attempt.
- Worktree and terminal handles describe placement and routing, not outcome authority.
- Correlation joins evidence. Idempotency prevents duplicated effects. They are not
  interchangeable.

If canonical lookup is unavailable, ambiguous, or schema-incompatible, leave the association
unresolved and stop the mutation. Observation may continue as explicitly unassociated evidence.
