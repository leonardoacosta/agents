# Work decomposition and accountability

## Classify by capability

Map bounded work to the capability it requires rather than to a harness-specific role name:

- Foundation: data models, schemas, migrations, and core services.
- Interface: APIs, protocols, contracts, and integration boundaries.
- Consumer: user-facing or downstream use of an interface.
- Verification: tests, security checks, builds, and release evidence.
- Documentation: specifications, runbooks, migration notes, and handoffs.
- Infrastructure: deployment definitions, environments, and platform configuration.
- Operations: rollout, monitoring, incident response, and external-system coordination.

## Choose an executor

Prefer a matching specialist when the harness provides one and the work is sufficiently bounded.
Otherwise use a qualified generalist or execute directly. Lack of delegation support never lowers
the safety, verification, or completion bar.

Give every executor explicit scope, owned paths or responsibilities, dependencies, prohibited
effects, expected evidence, and the reminder that other work may coexist. One owner is accountable
for each task even when several people or processes contribute.

## Choose a topology

Per-task assignment, serial direct execution, and consolidated domain batching are all conformant.
Consolidated domain batching must preserve each feature's dependency edges, ownership, failure
attribution, validation evidence, and terminal outcome. Parallel execution additionally requires
the dependency and mutable-resource safety checks.

## Retain coordination accountability

The coordinator verifies returned work, integrates across boundaries, resolves conflicts, runs
final validation, updates durable workflow state, archives, and completes required persistence.
Delegation transfers bounded implementation responsibility; it does not transfer final completion
accountability.
