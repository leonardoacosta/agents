# Komodo installation

Komodo has two components: **Core** hosts the UI, API, and management state; **Periphery** runs on each managed server and performs Core-requested operations. Current v2 onboarding uses an outbound Periphery connection to Core. Verify the installed version before choosing network rules. Core stores configuration, users, audit logs, and system state in its database. Each managed host needs its own Periphery. These references describe architecture and choices, not an installation runbook. Do not run examples without confirming the target, versions, persistence paths, and operator approval.

## Choose a deployment shape

The official setup uses Docker Compose and offers MongoDB or FerretDB. The upstream Compose examples can deploy Core, Periphery, and a database together. For separately managed hosts, install Periphery on each host and connect it to Core. Choose based on the existing Docker, database, network, and persistence model rather than treating either topology as universally preferable.

- **MongoDB:** Komodo's recommended database in the inspected documentation. It stores all Komodo state. The Core connection is internal to the Compose network in the example. Keep the database data and configuration volumes persistent. The example does not publish Mongo's port by default; do not expose it without a specific need and access controls.
- **FerretDB:** PostgreSQL-backed compatibility path for MongoDB API use. Consider it where MongoDB support is unsuitable, but check the current Komodo/FerretDB version and migration instructions. Existing users of pre-v1.18.0 PostgreSQL or SQLite setup options are identified by current docs as FerretDB v1 users and need the v2 upgrade guide before upgrading.
- **Core and Periphery:** Keep their release tags compatible. A Compose example's `2` tag tracks a major line, not a fully pinned patch release. Pin a tested release where reproducibility or migration compatibility matters.

## Establish persistence and trust

Before installation, identify the database volume, Core configuration, Core/Periphery communication keys, backups mount, and any operator-managed files. A container restart policy is not a backup. Avoid publishing database ports by default. Treat Periphery as privileged host management, especially when it receives the Docker socket or host filesystem mounts.

Core and Periphery may each need custom CA roots to reach private OIDC or Git services. The current advanced setup documents automatic certificate update behavior for v2 images when certificates are mounted under `/usr/local/share/ca-certificates`. Confirm the image version and mount in both relevant components. Do not disable certificate validation to work around trust configuration.

## Fetch version-specific setup before deployment

Upstream Compose files and defaults change. Before giving executable steps, fetch the current official setup and matching database and advanced-configuration pages. Compare the desired config with the running deployment, inspect image tags and volume mappings, and protect existing state. Do not substitute `latest` images or copy secrets into tracked files.

Canonical references:

- [Komodo setup](https://komo.do/docs/setup)
- [MongoDB setup](https://komo.do/docs/setup/mongo)
- [FerretDB setup](https://komo.do/docs/setup/ferretdb)
- [Advanced setup](https://komo.do/docs/setup/advanced)
- [Connect more servers](https://komo.do/docs/setup/connect-servers)

The source material for this reference was captured from official docs on 2026-09-28. It is not a live deployment check; verify all defaults, supported versions, migration paths, and installation commands against the current docs before use.