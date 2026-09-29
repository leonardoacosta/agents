# Resource Sync: declarative resource management

Use this reference when the user wants Komodo to reconcile resource declarations stored in TOML files with resources in Core. Resource Sync is a declarative configuration workflow, not a general-purpose file copier: Core detects differences and presents the computed create, update, delete, or deploy actions.

## How synchronization is organized

A Resource Sync can read declarations configured in the UI, from a local file, or from files in a remote Git repository. Declarations may be distributed across multiple files and nested folders under the configured root. Multiple Resource Syncs can manage separate projects; match tags can filter the resources handled by each sync, and each sync is processed independently.

Core polls the configured files and reports pending changes when it detects diffs. The UI displays the computed actions. By default, a person confirms the proposed sync execution. A Git webhook can instead be configured to execute a sync after pushes to the configured branch, which changes the workflow from review-before-apply to automatic execution.

For a single-file sync, Managed Mode allows UI changes to be written back to the declaration file. For repository-backed files, the documented behavior creates a Git commit. Confirm that this write-back behavior and repository target are intended before enabling or using Managed Mode. Exact supported declaration schemas for each resource type are not reproduced here; check the current Resource Sync and resource-specific documentation before authoring TOML.

## Safe review model

Before applying a sync, inspect the diff as a change plan, especially deletions, updates to shared resources, and any deployment actions. Confirm the sync root, repository/branch, and tag filter identify only the intended ownership boundary. Prefer manual review until the desired automation policy is explicit. Webhook-triggered syncs can apply changes without the usual UI confirmation step.

Resource declarations represent configuration. Do not place credentials or secret values in plaintext TOML or include full secret-bearing diffs in chat or logs. Use Komodo's supported secret/variable mechanisms and verify current documentation for the resource-specific schema before authoring declarations.

## Sources

- [Resource Sync](https://komo.do/docs/automate/sync-resources)
- [Webhooks](https://komo.do/docs/automate/webhooks)
