# Dependency and concurrency safety

## Explicit dependency evidence

Create a directional edge only from durable evidence: a proposal's parser-visible dependency, an
issue relationship, a task dependency, or a recorded precondition whose satisfaction requires
another outcome. Execute the prerequisite first and do not start its dependent until the required
successful state exists.

Do not invent a dependency merely to serialize work. Uncertainty calls for investigation; mutable
overlap creates a concurrency conflict, not semantic order.

## Mutable-resource conflicts

Treat simultaneous access as conflicting when work can observe or change the same:

- repository path, generated output, branch, or index;
- database schema, migration sequence, or shared fixture;
- deployment target, environment, service, or account;
- credential, lock, cache, registry, release pin, or version surface;
- external system record or other irreversible effect.

Resolve a concurrency conflict by serializing the work or proving isolation through separate
worktrees, databases, environments, credentials, locks, or equivalent boundaries. The proof must
cover indirect outputs and final integration, not only the files each task initially names.

When multiple sessions or harnesses can reach the resources, resolve their canonical keys through
one coordination namespace and atomic lease authority. Declare and acquire the full mutable set
before mutation; a harness-private lock cannot prove exclusion from other participants. Follow
[workflow-lease.md](workflow-lease.md) for owner attribution, expiry, fencing, and finalization.

## Safe parallelism

Parallel work is eligible only when dependencies are satisfied, ownership is disjoint, mutable
resources are isolated, and each unit has independent validation. The coordinator retains the
right to serialize work as new evidence appears and owns integration of all results.
