# az artifacts manual index

Captured 2026-09-08 from Azure CLI 2.90.0 / azure-devops 1.0.8.
Each entry was verified with native `-h`. Re-read live leaf help before use.
Flags below exclude global flags. Availability does not authorize execution.

## Contents

- `az artifacts`
- `az artifacts universal`
- `az artifacts universal download`
- `az artifacts universal publish`

## az artifacts

az artifacts : Manage Azure Artifacts.
This command group is a part of the azure-devops extension.

Children: `universal` (group)

## az artifacts universal

az artifacts universal : Manage Universal Packages.

Children: `download` (command), `publish` (command)

## az artifacts universal download

az artifacts universal download : Download a package.

```text
Arguments
    --feed       [Required] : Name or ID of the feed.
    --name -n    [Required] : Name of the package, e.g. 'foo-package'.
    --path       [Required] : Directory to place the package contents.
    --version -v [Required] : Version of the package, e.g. 1.0.0.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --file-filter           : Wildcard filter for file download.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p            : Name or ID of the project. You can configure the default project using
                              az devops configure -d project=NAME_OR_ID. Required if not configured
                              as default or picked up via git config.
    --scope                 : Scope of the feed: 'project' if the feed was created in a project, and
                              'organization' otherwise.  Allowed values: organization, project.
                              Default: organization.
```

## az artifacts universal publish

az artifacts universal publish : Publish a package to a feed.

```text
Arguments
    --feed       [Required] : Name or ID of the feed.
    --name -n    [Required] : Name of the package, e.g. 'foo-package'.
    --path       [Required] : Directory containing the package contents.
    --version -v [Required] : Version of the package, e.g. '1.0.0'.
    --description -d        : Description of the package.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p            : Name or ID of the project. You can configure the default project using
                              az devops configure -d project=NAME_OR_ID. Required if not configured
                              as default or picked up via git config.
    --scope                 : Scope of the feed: 'project' if the feed was created in a project, and
                              'organization' otherwise.  Allowed values: organization, project.
                              Default: organization.
```
