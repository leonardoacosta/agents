# Container builds

Route by the workflow's existing shape:

- Ordinary Buildx action workflows may use Depot's documented build-push integration after proving every used input and output.
- Bake workflows remain Bake workflows and use the documented Bake integration.
- Bespoke shell workflows remain shell workflows and use documented Depot setup plus CLI.

Preserve context, Dockerfile, target, arguments, secret and SSH mounts, platforms, tags, labels, annotations, attestations, load/push behavior, metadata, caches, outputs, digests, manifest assembly, publication order, and downstream consumers.

Verify current documentation for builder, project, and authentication inputs. If any semantic lacks a documented mapping, block rather than approximate it. For multi-platform publication, trace per-platform digests through artifacts and manifest creation, then validate final tags, platforms, attestations, and outputs.
