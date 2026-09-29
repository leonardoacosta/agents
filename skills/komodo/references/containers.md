# Container Deployments

A Komodo **Deployment** manages one Docker container on a Server through that server's Periphery agent. Komodo turns its configuration into a `docker run` invocation. Use a Deployment when the workload is one container; use a [Stack](compose.md) for a Compose application or [Swarm](docker-swarm.md) for cluster scheduling.

## Choose the image source

- **Build resource:** attach a Komodo Build to connect build/version flow. Registry credentials can be inherited from the Build.
- **Image reference:** specify an image directly. For a private image, select the matching registry account through Komodo's provider configuration.

Prefer an explicit immutable version when repeatability matters. A moving tag such as `latest` is convenient for update polling, but the tag alone does not identify fixed image contents.

## Runtime configuration decisions

Set the target Server and review networking, published ports, persistent mounts, environment, restart policy and command overrides as one runtime contract. The documentation capture describes host networking as the default. Host mode uses the host network namespace, so do not assume port mappings isolate or publish the container as they do with a bridge network. With another network, define required port mappings explicitly.

Bind mounts refer to paths on the target host. Confirm the host paths, ownership, and persistence expectations before deployment. Treat environment and interpolated values as potentially sensitive; use Komodo variables/secrets and provider guidance rather than embedding credentials in tracked configuration.

`extra_args` are passed to Docker directly. They can change runtime behavior outside the typed fields, so review them against the exact current Komodo and Docker documentation before using them. Avoid copying undocumented flags from examples.

## Lifecycle and configuration changes

- **Deploy/Redeploy** replaces the existing container with one created from current configuration. Existing container-local state can be lost unless the workload persists it in mounted storage or an external service.
- **Stop/Start** controls the current container but does not apply edited configuration.
- **Remove** destroys the container; it is not a data backup or a substitute for an application recovery plan.

Separate container lifecycle from application-data lifecycle. Back up volumes and external databases according to the application, not merely the Komodo resource state.

## Common pitfalls

- Choosing a Deployment for multiple cooperating services that need Compose-level configuration.
- Assuming Stop/Start applies edited settings; redeployment is required.
- Using host networking while expecting bridge-network port isolation.
- Assuming a writable container layer survives replacement.
- Enabling image auto-update without choosing an intentional moving-tag and rollout policy. See [updates and triggers](updates-and-triggers.md).

## Canonical sources

- [Komodo Containers](https://komo.do/docs/deploy/containers)
- [Komodo Resources](https://komo.do/docs/resources)
- [Komodo Variables](https://komo.do/docs/configuration/variables)

## Refresh rules

Before emitting executable configuration, check the current Containers page for field names, defaults, supported image-source shape, lifecycle semantics and update behavior. Check Docker's current reference for any Docker-specific networking or runtime detail. This reference is descriptive, not a validated command recipe; documentation examples are not proof for a particular Komodo release or server.