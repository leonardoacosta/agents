# Authority and identifiers

## Authority matrix

| Concern | Authority |
|---|---|
| Initiative, milestone, blocker, checkpoint | Jcode |
| Schedule intent and retry policy | Jcode |
| Permission, approval, idempotency, rollback intent | Jcode |
| Canonical Orca Project, Repository, environment, and host/setup identity | Orca |
| Worktree, Run, Task, Dispatch, worker, terminal, gate | Orca |
| Durable outcome settlement | Jcode, after verified Orca receipt |
| Browser selection, expansion, resize state | Browser only |

## Identifier rules

Preserve every identifier in its own typed field. Never derive one domain from another.

- Resolve Orca Project ID, Repository ID, environment ID, and ProjectHostSetup ID separately
  through the version-matched `project list`, `repo list`, and project-setup surfaces.
- A repository path is host-specific lookup evidence, not a globally canonical identifier. Scope
  it to the selected environment and host/setup before matching.
- Runtime ID identifies the running Orca service instance. It is not a Project or Repository ID.
- A Run is a coordinator namespace and inbox. It does not schedule or place workers.
- A Task describes the work contract. A Dispatch identifies one concrete attempt and owns that
  attempt's active lifecycle.
- Worktree and terminal handles describe placement and routing, not lifecycle or outcome authority.
- Correlation joins evidence. Idempotency prevents duplicated effects. They are not
  interchangeable.

If canonical lookup is unavailable, ambiguous, or schema-incompatible, leave the association
unresolved and stop the mutation. Observation may continue as explicitly unassociated evidence.
