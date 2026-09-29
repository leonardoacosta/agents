# Image Builds

A Komodo **Build** defines how to obtain a Dockerfile and build context, where to build, how to tag the image, and which registry destinations receive it. A **Builder** selects the machine or provider-backed capacity used for the build. A Build resource is separate from deploying the resulting image; connect it to a [Deployment](containers.md) or otherwise reference its published image.

## Choose the source and builder

Dockerfile/context sources include a definition entered in Komodo, files already present on the builder, or a Git repository. Git is the documented default source mode in the captured reference. For a Git source, identify the repository, branch or pinned commit, build context path and Dockerfile path. For host files, paths are interpreted on the builder, not on the deployment server. UI-defined Dockerfiles and build settings may interpolate variables or secrets; review access and visibility before storing sensitive values.

A Builder can use a connected Server or temporary AWS EC2 capacity. The build documentation discourages building on production servers. An ephemeral cloud builder introduces separate provider permissions, network reachability, image-registry access, cleanup and cost considerations. Validate these prerequisites before selecting it; this reference does not imply that any cloud account or builder is configured.

## Tags and image destinations

Komodo's documented versioning model uses `major.minor.patch`; by default the patch can increment on builds. Tag options can produce version tags, a moving `latest` tag, and a commit-derived tag. Review which tags are published and what consumers expect. A moving tag is useful for digest-based updates, while a pinned version or digest gives more repeatable deployment inputs.

A Build may publish to one or multiple Docker-compatible registries. Provider accounts supply registry authentication; avoid placing credentials in repository content. When a Deployment is connected to a Build, the Build's registry credentials may be inherited by default. Confirm that the target server can pull from that registry and that the selected account has the needed access.

## Build inputs and secrets

Ordinary build arguments can be exposed in image history. Do not pass secrets through regular build arguments. Use the BuildKit secret mechanism supported by the current Komodo and Docker build path, and ensure the Dockerfile consumes secrets through a secret mount rather than copying them into layers. Treat build output, logs, cache and published artifacts as potential disclosure paths too.

Buildx and multi-platform output require compatible builder-side Docker/buildx setup and explicit target-platform configuration. Do not assume an installed builder supports a platform merely because the registry accepts the image.

## Common pitfalls

- Confusing where an image is built with where a Deployment runs.
- Using builder-local paths as if they were paths on the target server.
- Assuming generated tags are immutable, or that publishing a moving tag causes deployments to update automatically.
- Passing secrets as ordinary build arguments.
- Assuming a private registry account available to the builder is also usable by the deployment target.
- Using temporary cloud capacity without checking permissions, networking, cleanup and cost.

## Canonical sources

- [Komodo Build](https://komo.do/docs/build)
- [Komodo Providers](https://komo.do/docs/configuration/providers)
- [Komodo Variables](https://komo.do/docs/configuration/variables)
- [Docker build secrets](https://docs.docker.com/build/building/secrets/)
- [Docker Buildx](https://docs.docker.com/build/buildx/)

## Refresh rules

Before writing a Build resource or build command, check the current Build and Providers pages for schema, source modes, tag defaults, registry credential behavior, builder types and cloud-provider requirements. Check Docker's current build documentation for secret handling and Buildx semantics. Do not invent flags, provider settings or executable examples from this summary.