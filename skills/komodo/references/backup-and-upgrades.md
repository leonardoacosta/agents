# Komodo backup and upgrades

Komodo's database contains resource configuration, user accounts, audit logs, and system state. A database backup therefore protects management state, not necessarily application data stored in workload volumes, Git repositories, external registries, or other hosts. Define and test separate backups for those systems.

## Backups are not proven until restored

Official docs describe gzip-compressed database backups in timestamped folders, stored on disk or a remote server. They state that the default retention is the most recent 14 backups. New installs from v1.19.0 are documented as creating a daily **Backup Core Database** Procedure; do not assume an older or customized install has it. Confirm the schedule, retention, backup destination, available space, and off-host copy.

Treat a backup as sensitive: it can contain user accounts, resource definitions, tokens, and other configuration. Restrict access, protect remote transport and storage, and avoid sharing snapshots. A successful scheduled task does not prove that files are complete, readable, restorable, or suitable for disaster recovery. Periodically validate a restore into an isolated, non-production environment using version-matched instructions. Never restore over the live database as a test.

## Plan upgrades as state transitions

Before changing Core, Periphery, database, or major release line:

1. Identify the exact current versions and database type, including whether a legacy install uses FerretDB v1.
2. Read the release-specific upgrade and database migration notes. Back up database state and preserve configuration, keys, and mounted files.
3. Confirm compatibility among Core, Periphery, database, and backup format. Use an explicit tested image tag instead of assuming a moving tag is safe.
4. Perform the change only with an approved maintenance and rollback plan. Verify service health, resource inventory, authentication, server connections, and a recoverable backup afterward.

Database migrations can be one-way or require a dedicated conversion step. In particular, docs call out a FerretDB v1-to-v2 upgrade path for legacy setups. Do not infer that changing the Compose database image or connection string migrates data. The exact migration commands, compatibility matrix, and rollback limits are version-specific and must be fetched before action.

## Recovery decision

First determine whether the problem is loss of Core's management database, loss of application data on a managed host, or a failed upgrade. Use the corresponding backup and recovery owner. A Komodo database restore may recover resource definitions without restoring the deployed applications' persistent data. For failed upgrades, preserve the failed state and logs; do not overwrite a database until the target snapshot, target version, and recovery procedure are confirmed.

Canonical references:

- [Backup and restore](https://komo.do/docs/setup/backup)
- [FerretDB setup and migration](https://komo.do/docs/setup/ferretdb)
- [Komodo v2 migration notes](https://komo.do/docs/releases/v2.0.0)
- [Komodo CLI](https://komo.do/docs/ecosystem/cli)

These notes summarize official sources captured 2026-09-28. Backup flags, restore semantics, retention defaults, and migration guidance may change. Fetch current version-specific docs before making a recovery plan; these references are not evidence that any backup exists or has been restored successfully.