# Compose Stacks

A Komodo **Stack** manages a Docker Compose application. It is distinct from a single-container [Deployment](containers.md) and from a Docker [Swarm](docker-swarm.md). A Stack can target a standalone Server or, where configured, a Swarm for `docker stack deploy`; confirm the target type before reusing configuration.

## Decide who owns the Compose files

Choose one source of truth before adopting or changing a running application:

- **Defined in Komodo:** Komodo writes the configured files to the target host at deploy time. Review the saved definitions and any secret interpolation.
- **Files already on the host:** Komodo operates on the selected server-side paths. The host repository or operator remains responsible for their content and updates.
- **Git repository:** Komodo clones the repository to the host. Git owns the Compose definitions; webhook-based redeploy can be considered separately.

These source modes are not interchangeable. Avoid maintaining an independent copy in Komodo and Git, or editing host files that Komodo later overwrites. Identify the authoritative files and branch before enabling an automated writer.

## Configuration model

A Stack identifies its deployment target, working directory, one or more Compose file paths, and optionally a project name. Multiple file paths are combined in order using Docker Compose's `-f` inputs, so order can affect overrides. Environment values can be supplied for interpolation. Private repositories require the appropriate Git provider/account configuration.

An existing project may be adopted by creating a Stack with access to the same Compose files and target Server. Compose project identity matters: if the existing project's name differs from the Stack's default name, set the documented project-name override to match. A mismatch can make Komodo treat it as a different project rather than manage the one already running.

Review environment interpolation, mounted data, bind paths, networks and the effective Compose project before deploying. A Stack redeploy can replace services; it does not back up volumes or external databases. Preserve the existing data and establish an application-level recovery plan before changing a production project.

## Update choices

- **Poll for updates** checks whether an image using the same tag has a newer digest and reports it. It does not itself redeploy.
- **Auto update** performs the same check and redeploys when an image update is found.
- **Git push webhook** can cause a repository-sourced Stack to redeploy after a qualifying source change. It is a different trigger from registry image-digest checking.

Do not enable multiple independent update paths without deciding their ownership and timing. Moving tags are needed for digest-based updates to discover new contents under the same tag. For immutable/pinned references, use a deliberate source-change process instead of assuming polling will move the pinned image.

## Common pitfalls

- Choosing Stack while expecting Komodo to manage just one container, or confusing a Stack's Swarm target with ordinary Compose-on-Server operation.
- Adopting a running project with the wrong project name.
- Assuming environment configuration is equivalent to safe secret storage. Keep credentials out of committed Compose files and logs.
- Treating host files, Komodo-defined files and Git files as simultaneous sources of truth.
- Assuming `poll_for_updates` redeploys, or assuming Git push and image polling are the same event.

## Canonical sources

- [Komodo Docker Compose](https://komo.do/docs/deploy/compose)
- [Komodo Automatic Updates](https://komo.do/docs/deploy/auto-update)
- [Komodo Variables](https://komo.do/docs/configuration/variables)
- [Komodo Webhooks](https://komo.do/docs/automate/webhooks)
- [Docker Compose documentation](https://docs.docker.com/compose/)

## Refresh rules

Before generating executable Stack configuration, recheck the current Compose page for source modes, field names/defaults, project identity, server/Swarm targeting and Compose file behavior. Verify current webhook event and branch semantics from the Webhooks page, and digest-update behavior from Automatic Updates. Do not infer provider signature/authentication details from a generic webhook model.