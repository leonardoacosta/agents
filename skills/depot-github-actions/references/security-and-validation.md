# Security and validation

Preserve action-pin policy and least-privilege permissions. Prefer documented OIDC where supported, but never invent trust configuration or credentials. Analyze push, pull request, fork, Dependabot, scheduled, manual, and reusable-call paths independently.

Treat `pull_request_target` as privileged. If it executes pull-request-controlled content, block adding Depot, registry, signing, or publication authority. Secrets belong in documented secret or SSH mounts, never cache keys, normal arguments, command lines, logs, artifacts, or image layers.

## Transactional editing

Hash every target after audit and compare immediately before editing. Concurrent drift blocks the patch. Change only approved fields, inspect the diff, and leave targets byte-identical on every blocked path.

## Truthful validation

Use repository-native YAML and policy checks, then validate applicable runner labels, pins, events, permissions, cold/warm caches, platforms, tags, manifests, attestations, digests, outputs, and consumers. Claim a hosted run only when its URL and result were observed; report failed or unavailable checks explicitly.
