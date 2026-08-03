# Runners

Map every job's effective `runs-on`, including matrices, expressions, reusable workflow calls, and repository or organization variables. Verify the Depot App installation covers the repository, the runner group permits it, and the proposed label appears in current Depot documentation. Do not infer a runner label from architecture or an existing GitHub-hosted label.

Preserve matrix dimensions, dependencies, services, containers, timeouts, concurrency, environments, permissions, and caller inputs. A reusable workflow owns its runner choice unless a documented input deliberately delegates it.

Runner-only work requires App installation, repository scope, runner group, documented label, and action-pin policy. Project or OIDC identity is applicable only when another affected step needs it. Record irrelevant fields as `N/A`. Evaluate fork and Dependabot paths separately. Missing or contradictory evidence blocks the exact affected job.
