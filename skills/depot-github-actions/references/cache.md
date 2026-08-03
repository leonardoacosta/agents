# Cache

Separate repository file caches from container-layer caches.

Compatible actions using the standard GitHub cache API can be accelerated automatically on verified Depot-managed runners. Preserve their action pins, paths, keys, restore prefixes, lookup/fail behavior, and outputs unless a separate requirement demands a change. Do not substitute an invented provider-specific cache action.

BuildKit cache configuration belongs to the container-build seam. Remove an explicit exporter only after current documentation and cold/warm checks prove equivalence.

Analyze key provenance across branches, forks, event types, and restore prefixes. Never place secrets in keys or cached paths. Low-trust jobs must not gain a write path capable of poisoning content later restored by privileged jobs.
