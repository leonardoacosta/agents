# az devops manual index

Captured 2026-09-08 from Azure CLI 2.90.0 / azure-devops 1.0.8.
Each entry was verified with native `-h`. Re-read live leaf help before use.
Flags below exclude global flags. Availability does not authorize execution.

## Contents

- `az devops`
- `az devops admin`
- `az devops extension`
- `az devops migrations`
- `az devops project`
- `az devops security`
- `az devops service-endpoint`
- `az devops team`
- `az devops user`
- `az devops wiki`
- `az devops configure`
- `az devops invoke`
- `az devops login`
- `az devops logout`
- `az devops admin banner`
- `az devops extension disable`
- `az devops extension enable`
- `az devops extension install`
- `az devops extension list`
- `az devops extension search`
- `az devops extension show`
- `az devops extension uninstall`
- `az devops migrations cutover`
- `az devops migrations pipelines`
- `az devops migrations abandon`
- `az devops migrations create`
- `az devops migrations list`
- `az devops migrations pause`
- `az devops migrations resume`
- `az devops migrations status`
- `az devops project create`
- `az devops project delete`
- `az devops project list`
- `az devops project show`
- `az devops security group`
- `az devops security permission`
- `az devops service-endpoint azurerm`
- `az devops service-endpoint github`
- `az devops service-endpoint create`
- `az devops service-endpoint delete`
- `az devops service-endpoint list`
- `az devops service-endpoint show`
- `az devops service-endpoint update`
- `az devops team create`
- `az devops team delete`
- `az devops team list`
- `az devops team list-member`
- `az devops team show`
- `az devops team update`
- `az devops user add`
- `az devops user list`
- `az devops user remove`
- `az devops user show`
- `az devops user update`
- `az devops wiki page`
- `az devops wiki create`
- `az devops wiki delete`
- `az devops wiki list`
- `az devops wiki show`
- `az devops admin banner add`
- `az devops admin banner list`
- `az devops admin banner remove`
- `az devops admin banner show`
- `az devops admin banner update`
- `az devops migrations cutover approve`
- `az devops migrations cutover cancel`
- `az devops migrations cutover review`
- `az devops migrations cutover set`
- `az devops migrations pipelines delete`
- `az devops migrations pipelines list`
- `az devops migrations pipelines retry`
- `az devops migrations pipelines submit`
- `az devops migrations pipelines update`
- `az devops security group membership`
- `az devops security group create`
- `az devops security group delete`
- `az devops security group list`
- `az devops security group show`
- `az devops security group update`
- `az devops security permission namespace`
- `az devops security permission list`
- `az devops security permission reset`
- `az devops security permission reset-all`
- `az devops security permission show`
- `az devops security permission update`
- `az devops service-endpoint azurerm create`
- `az devops service-endpoint github create`
- `az devops wiki page create`
- `az devops wiki page delete`
- `az devops wiki page show`
- `az devops wiki page update`
- `az devops security group membership add`
- `az devops security group membership list`
- `az devops security group membership remove`
- `az devops security permission namespace list`
- `az devops security permission namespace show`

## az devops

az devops : Manage Azure DevOps organization level operations.
Related Groups
az pipelines: Manage Azure Pipelines
az boards: Manage Azure Boards
az repos: Manage Azure Repos
az artifacts: Manage Azure Artifacts.

Children: `admin` (group), `extension` (group), `migrations` (group), `project` (group), `security` (group), `service-endpoint` (group), `team` (group), `user` (group), `wiki` (group), `configure` (command), `invoke` (command), `login` (command), `logout` (command)

## az devops admin

az devops admin : Manage administration operations.

Children: `banner` (group)

## az devops extension

az devops extension : Manage extensions.

Children: `disable` (command), `enable` (command), `install` (command), `list` (command), `search` (command), `show` (command), `uninstall` (command)

## az devops migrations

az devops migrations : Manage enterprise live migrations.
The ELM migration command group is part of the azure-devops extension. Please refer to
https://aka.ms/adoELM for more information.
WARNING: This command group is in preview and under development. Reference and support
levels: https://aka.ms/CLI_refstatus

Children: `cutover` (group), `pipelines` (group), `abandon` (command), `create` (command), `list` (command), `pause` (command), `resume` (command), `status` (command)

## az devops project

az devops project : Manage team projects.

Children: `create` (command), `delete` (command), `list` (command), `show` (command)

## az devops security

az devops security : Manage security related operations.

Children: `group` (group), `permission` (group)

## az devops service-endpoint

az devops service-endpoint : Manage service endpoints/connections.

Children: `azurerm` (group), `github` (group), `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az devops team

az devops team : Manage teams.

Children: `create` (command), `delete` (command), `list` (command), `list-member` (command), `show` (command), `update` (command)

## az devops user

az devops user : Manage users.

Children: `add` (command), `list` (command), `remove` (command), `show` (command), `update` (command)

## az devops wiki

az devops wiki : Manage wikis.

Children: `page` (group), `create` (command), `delete` (command), `list` (command), `show` (command)

## az devops configure

az devops configure : Configure the Azure DevOps CLI or view your configuration.

```text
Arguments
    --defaults -d          : Space separated 'name=value' pairs for common arguments defaults, e.g.
                             '--defaults project=my-project-name organization=my-org-url arg=value'.
                             Use '' to clear the defaults, e.g. --defaults project=''.
    --list -l              : Lists the contents of the config file.
    --use-git-aliases      : Set to 'true' to configure Git aliases global git config file (to
                             enable commands like "git pr list"). Set to 'false' to remove any
                             aliases set by the tool.  Allowed values: false, true.
```

## az devops invoke

az devops invoke : This command will invoke request for any DevOps area and resource. Please use
only json output as the response of this command is not fixed. Helpful docs -
https://docs.microsoft.com/en-us/rest/api/azure/devops/.

```text
Arguments
    --accept-media-type    : Specifies the content type of the response.  Default: application/json.
    --api-version          : The version of the API to target.  Default: 5.0.
    --area                 : The area to find the resource.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --encoding             : Encoding of the input file. Used in conjunction with --in-file.
                             Allowed values: ascii, utf-16be, utf-16le, utf-8.  Default: utf-8.
    --http-method          : Specifies the method used for the request.  Allowed values: DELETE,
                             GET, HEAD, OPTIONS, PATCH, POST, PUT.  Default: GET.
    --in-file              : Path and file name to the file that contains the contents of the
                             request.
    --media-type           : Specifies the content type of the request.  Default: application/json.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --out-file             : Path and file name to the file  for which this function saves the
                             response body.
    --query-parameters     : Specifies the list of query parameters.
    --resource             : The name of the resource to operate on.
    --route-parameters     : Specifies the list of route parameters.
```

## az devops login

az devops login : Set the credential (PAT) to use for a particular organization.
Refer https://aka.ms/azure-devops-cli-auth for more information on providing PAT as input.

```text
Arguments
    --org --organization   : Azure DevOps organization URL. Example:
                             `https://dev.azure.com/MyOrganizationName`.
```

## az devops logout

az devops logout : Clear the credential for all or a particular organization.

```text
Arguments
    --org --organization   : Azure DevOps organization URL. Example:
                             `https://dev.azure.com/MyOrganizationName/`. If no organization is
                             specified, all organizations will be logged out.
```

## az devops admin banner

az devops admin banner : Manage organization banner.

Children: `add` (command), `list` (command), `remove` (command), `show` (command), `update` (command)

## az devops extension disable

az devops extension disable : Disable an extension.

```text
Arguments
    --extension-id [Required] : Extension Id. This will map to extension-name
                                in the az devops extension search output.
    --publisher-id [Required] : Publisher Id. This will map to publisher-name
                                in the az devops extension search output.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops extension enable

az devops extension enable : Enable an extension.

```text
Arguments
    --extension-id [Required] : Extension Id. This will map to extension-name
                                in the az devops extension search output.
    --publisher-id [Required] : Publisher Id. This will map to publisher-name
                                in the az devops extension search output.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops extension install

az devops extension install : Install an extension.

```text
Arguments
    --extension-id [Required] : Extension Id. This will map to extension-name
                                in the az devops extension search output.
    --publisher-id [Required] : Publisher Id. This will map to publisher-name
                                in the az devops extension search output.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops extension list

az devops extension list : List extensions installed in an organization.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --include-built-in   : Include built in extensions.  Allowed values: false, true.
    --include-disabled   : Include disabled extensions.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az devops extension search

az devops extension search : Search extensions from marketplace.

```text
Arguments
    --search-query -q [Required] : Search term.
```

## az devops extension show

az devops extension show : Get detail of single extension.

```text
Arguments
    --extension-id [Required] : Extension Id. This will map to extension-name
                                in the az devops extension search output.
    --publisher-id [Required] : Publisher Id. This will map to publisher-name
                                in the az devops extension search output.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops extension uninstall

az devops extension uninstall : Uninstall an extension.

```text
Arguments
    --extension-id [Required] : Extension Id. This will map to extension-name
                                in the az devops extension search output.
    --publisher-id [Required] : Publisher Id. This will map to publisher-name
                                in the az devops extension search output.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y                  : Do not prompt for confirmation.
```

## az devops migrations cutover

az devops migrations cutover : Manage migration cutover.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus
Commands:
approve : Approve cutover by accepting unprocessed items and/or verifying rewired pipelines.
cancel  : Cancel a scheduled cutover.
review  : Review unprocessed migration items before cutover.
set     : Schedule cutover for a migration.

Children: `approve` (command), `cancel` (command), `review` (command), `set` (command)

## az devops migrations pipelines

az devops migrations pipelines : Manage pipeline rewiring for migrations. (Preview).
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus
Commands:
delete : Delete pipeline rewiring data for a migration. (Preview).
list   : List pipeline rewiring configuration and per-pipeline status.
retry  : Retry failed pipeline rewiring entries. (Preview).
submit : Submit pipelines for rewiring. (Preview).
update : Bulk update pipeline rewiring configuration. (Preview).

Children: `delete` (command), `list` (command), `retry` (command), `submit` (command), `update` (command)

## az devops migrations abandon

az devops migrations abandon : Abandon a migration.
Moves the migration to an abandoned/failed state; the migration record is not purged.
Pipeline rewiring data is left intact so a subsequent migration can reuse it.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --remove-read-only     : Also set the Azure Repos repository back to read-write state by sending
                             removeReadOnly=true.
    --repository-id        : ID of the Azure Repos repository (GUID).
    --yes -y               : Do not prompt for confirmation.
```

## az devops migrations create

az devops migrations create : Create a migration for a repository.
GitHub authentication uses device flow: the CLI prints a URL and a one-time code to complete
sign-in interactively. No GitHub token or service connection is required.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus

```text
Arguments
    --agent-pool                                         : Agent pool name to use for migration
                                                           work.
    --auto-discover --enable-auto-discover-pipelines     : Opt in to automatic pipeline discovery at
                                                           cutover. Off by default. When enabled,
                                                           the ELM sync job walks the source
                                                           repository and creates clone definitions
                                                           for every pipeline that references it.
                                                           Requires --pipeline-service-connection-
                                                           id; without it discovery runs as a no-op
                                                           and enrolls 0 pipelines. Pipeline
                                                           rewiring itself is always available via
                                                           az devops migrations pipelines submit /
                                                           update.
    --cutover-date                                       : Scheduled cutover date/time (ISO 8601).
    --detect                                             : Automatically detect organization.
                                                           Allowed values: false, true.
    --enable-boards-gh --enable-boards-github-connection : Opt in to provisioning the Azure Boards
                                                           GitHub connection at cutover. Off by
                                                           default. Requires the Azure Boards GitHub
                                                           App to be installed on the target GitHub
                                                           Enterprise organization before the
                                                           migration runs.
    --org --organization                                 : Azure DevOps organization URL. You can
                                                           configure the default organization using
                                                           az devops configure -d
                                                           organization=ORG_URL. Required if not
                                                           configured as default or picked up via
                                                           git config. Example: `https://dev.azure.c
                                                           om/MyOrganizationName/`.
    --pipeline-sc-id --pipeline-service-connection-id    : Project-scoped GitHub service connection
                                                           ID (GUID) attached at create time for
                                                           pipeline rewiring. Required for full
                                                           auto-discovery when combined with
                                                           --enable-auto-discover-pipelines;
                                                           optional in manual mode (pre-attaches the
                                                           connection so subsequent pipelines submit
                                                           calls only need --pipeline-ids).
    --repository-id                                      : ID of the Azure Repos repository (GUID).
    --skip-validation                                    : Validation policies to skip. Accepts
                                                           either a comma-separated list of policy
                                                           names (for example,
                                                           AgentPoolExists,MaxFileSize) or a non-
                                                           negative integer bitmask. Supported
                                                           policy names (case-insensitive): None,
                                                           ActivePullRequestCount,
                                                           PullRequestDeltaSize, AgentPoolExists,
                                                           MaxFileSize, MaxPullRequestSize,
                                                           MaxPushPackSize, MaxReferenceNameLength,
                                                           TargetRepositoryDoesNotExist,
                                                           SourceRepositoryContainsLfsObjects,
                                                           SourceRepositoryNotReadOnly,
                                                           BoardsGitHubConnectionProvisioning, All.
    --target-owner-user-id                               : Target repository owner user ID.
                                                           Deprecated and ignored when server-side
                                                           token-based owner resolution is enabled.
    --target-repository                                  : Target repository URL (must start with
                                                           `http://` or `https://`).
    --validate-only                                      : Create in validate-only mode (pre-
                                                           migration checks only).
```

## az devops migrations list

az devops migrations list : List migrations in an organization.
By default the latest migration per repository is returned, regardless of state. Use
--include-all to return the full migration history.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus

```text
Arguments
    --detect                        : Automatically detect organization.  Allowed values: false,
                                      true.
    --include-all                   : Return the full migration history (all records per
                                      repository). By default only the latest migration per
                                      repository is returned, regardless of its state.
    --include-inactive [Deprecated] : Deprecated. Use --include-all instead.
        WARNING: Option '--include-inactive' has been deprecated and will be removed in a future
        release. Use '--include-all' instead.
    --org --organization            : Azure DevOps organization URL. You can configure the default
                                      organization using az devops configure -d
                                      organization=ORG_URL. Required if not configured as default or
                                      picked up via git config. Example:
                                      `https://dev.azure.com/MyOrganizationName/`.
    --project                       : Optional project name or ID to filter migrations.
```

## az devops migrations pause

az devops migrations pause : Pause an active migration.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect               : Automatically detect organization.  Allowed values: false, true.
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--repository-id        : ID of the Azure Repos repository (GUID).

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops migrations resume

az devops migrations resume : Resume a stopped (paused, failed) migration.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect               : Automatically detect organization.  Allowed values: false, true.
--migration            : Promote a succeeded validate-only migration to a full migration (sets
validateOnly=false and statusRequested=active).
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--repository-id        : ID of the Azure Repos repository (GUID).
--validate-only        : Resume in validate-only mode.

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --migration            : Promote a succeeded validate-only migration to a full migration (sets
                             validateOnly=false and statusRequested=active).
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
    --validate-only        : Resume in validate-only mode.
```

## az devops migrations status

az devops migrations status : Get migration status for a repository.
WARNING: Command group 'devops migrations' is in preview and under development. Reference
and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect               : Automatically detect organization.  Allowed values: false, true.
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--repository-id        : ID of the Azure Repos repository (GUID).

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops project create

az devops project create : Create a team project.

```text
Arguments
    --name      [Required] : Name of the new project.
    --description -d       : Description for the new project.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --open                 : Open the team project in the default web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --process -p           : Process to use. Default if not specified.
    --source-control -s    : Source control type of the initial code repository created.  Allowed
                             values: git, tfvc.  Default: git.
    --visibility           : Project visibility.  Allowed values: private, public.  Default:
                             private.
```

## az devops project delete

az devops project delete : Delete team project.

```text
Arguments
    --id        [Required] : The id of the project to delete.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y               : Do not prompt for confirmation.
```

## az devops project list

az devops project list : List team projects.

```text
Arguments
    --continuation-token         : Continuation token. This can be retrived from previous run of
                                   this command if more results are present.
    --detect                     : Automatically detect organization.  Allowed values: false, true.
    --get-default-team-image-url : Whether to get default team image url or not.  Allowed values:
                                   false, true.
    --org --organization         : Azure DevOps organization URL. You can configure the default
                                   organization using az devops configure -d organization=ORG_URL.
                                   Required if not configured as default or picked up via git
                                   config. Example: `https://dev.azure.com/MyOrganizationName/`.
    --skip                       : Number of results to skip.
    --state-filter               : State filter.  Allowed values: all, createPending, deleted,
                                   deleting, new, unchanged, wellFormed.  Default: all.
    --top                        : Maximum number of results to list.
```

## az devops project show

az devops project show : Show team project.

```text
Arguments
    --project -p [Required] : Name or ID of the project. You can configure the default project using
                              az devops configure -d project=NAME_OR_ID. Required if not configured
                              as default or picked up via git config.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --open                  : Open the team project in the default web browser.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security group

az devops security group : Manage security groups.

Children: `membership` (group), `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az devops security permission

az devops security permission : Manage security permissions.

Children: `namespace` (group), `list` (command), `reset` (command), `reset-all` (command), `show` (command), `update` (command)

## az devops service-endpoint azurerm

az devops service-endpoint azurerm : Manage Azure RM service endpoints/connections.

Children: `create` (command)

## az devops service-endpoint github

az devops service-endpoint github : Manage GitHub service endpoints/connections.

Children: `create` (command)

## az devops service-endpoint create

az devops service-endpoint create : Create a service endpoint using configuration file.
You can learn more about this at https://aka.ms/azure-devops-service-endpoint-config.

```text
Arguments
    --service-endpoint-configuration [Required] : Configuration file with service endpoint request.
    --detect                                    : Automatically detect organization.  Allowed
                                                  values: false, true.
    --encoding                                  : Encoding of the input file.  Allowed values:
                                                  ascii, utf-16be, utf-16le, utf-8.  Default: utf-8.
    --org --organization                        : Azure DevOps organization URL. You can configure
                                                  the default organization using az devops configure
                                                  -d organization=ORG_URL. Required if not
                                                  configured as default or picked up via git config.
                                                  Example:
                                                  `https://dev.azure.com/MyOrganizationName/`.
    --project -p                                : Name or ID of the project. You can configure the
                                                  default project using az devops configure -d
                                                  project=NAME_OR_ID. Required if not configured as
                                                  default or picked up via git config.
```

## az devops service-endpoint delete

az devops service-endpoint delete : Deletes service endpoint.

```text
Arguments
    --id        [Required] : Id of the service endpoint to delete.
    --deep                 : Specific to AzureRM endpoint created in Automatic flow. When it is
                             specified, this will also delete corresponding AAD application in
                             Azure.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --yes -y               : Do not prompt for confirmation.
```

## az devops service-endpoint list

az devops service-endpoint list : List service endpoints in a project.
:rtype: list of :class:`VssJsonCollectionWrapper
<service_endpoint.v4_1.models.ServiceEndpoint>`.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az devops service-endpoint show

az devops service-endpoint show : Get the details of a service endpoint.

```text
Arguments
    --id      [Required] : ID of the service endpoint.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az devops service-endpoint update

az devops service-endpoint update : Update a service endpoint.

```text
Arguments
    --id        [Required] : ID of the service endpoint.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --enable-for-all       : Allow all pipelines to access this service endpoint.  Allowed values:
                             false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az devops team create

az devops team create : Create a team.

```text
Arguments
    --name      [Required] : Name of the new team.
    --description          : Description of the new team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az devops team delete

az devops team delete : Delete a team.

```text
Arguments
    --id        [Required] : The id of the team to delete.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --yes -y               : Do not prompt for confirmation.
```

## az devops team list

az devops team list : List all teams in a project.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --skip               : Number of teams to skip.
    --top                : Maximum number of teams to return.
```

## az devops team list-member

az devops team list-member : List members of a team.

```text
Arguments
    --team      [Required] : The name or id of the team to show members of.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --skip                 : Number of members to skip.
    --top                  : Maximum number of members to return.
```

## az devops team show

az devops team show : Show team details.

```text
Arguments
    --team    [Required] : The name or id of the team to show.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az devops team update

az devops team update : Update a team's name and/or description.

```text
Arguments
    --team      [Required] : The name or id of the team to be updated.
    --description          : New description of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --name                 : New name of the team.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az devops user add

az devops user add : Add user.

```text
Arguments
    --email-id     [Required] : Email ID of the user.
    --license-type [Required] : License type for the user.  Allowed values: advanced, earlyAdopter,
                                express, professional, stakeholder.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
    --send-email-invite       : Whether to send email invite for new user or not.  Allowed values:
                                false, true.
```

## az devops user list

az devops user list : List users in an organization [except for users which are added via AAD
groups].

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --skip               : Offset: Number of records to skip.
    --top                : Maximum number of users to return. Max value is 10000.  Default: 100.
```

## az devops user remove

az devops user remove : Remove user from an organization.

```text
Arguments
    --user      [Required] : Email ID or ID of the user.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y               : Do not prompt for confirmation.
```

## az devops user show

az devops user show : Show user details.

```text
Arguments
    --user    [Required] : Email ID or ID of the user.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az devops user update

az devops user update : Update license type for a user.

```text
Arguments
    --license-type [Required] : License type for the user.  Allowed values: advanced, earlyAdopter,
                                express, professional, stakeholder.
    --user         [Required] : Email ID or ID of the user.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops wiki page

az devops wiki page : Manage wiki pages.

Children: `create` (command), `delete` (command), `show` (command), `update` (command)

## az devops wiki create

az devops wiki create : Create a wiki.

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --mapped-path          : [Required for codewiki type] Mapped path of the new wiki e.g. '/' to
                             publish from root of repository.
    --name                 : Name of the new wiki.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --repository -r        : [Required for codewiki type] Name or ID of the repository to publish
                             the wiki from.
    --type --wiki-type     : Type of wiki to create.  Allowed values: codewiki, projectwiki.
                             Default: projectwiki.
    --version -v           : [Required for codewiki type] Repository branch name to publish the code
                             wiki from.
```

## az devops wiki delete

az devops wiki delete : Delete a wiki.

```text
Arguments
    --wiki      [Required] : Name or Id of the wiki to delete.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --yes -y               : Do not prompt for confirmation.
```

## az devops wiki list

az devops wiki list : List all the wikis in a project or organization.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --scope              : List the wikis at project or organization level.  Allowed values:
                           organization, project.  Default: project.
```

## az devops wiki show

az devops wiki show : Show details of a wiki.

```text
Arguments
    --wiki    [Required] : Name or Id of the wiki.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --open               : Open the wiki in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az devops admin banner add

az devops admin banner add : Add a new banner and immediately show it.

```text
Arguments
    --message -m [Required] : Message (string) to show in the banner.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --expiration            : Date/time when the banner should no longer be presented to users. If
                              not set, the banner does not automatically expire and must be removed
                              with the remove command. Example : "2019-06-10 17:21:00 UTC",
                              "2019-06-10".
    --id                    : Identifier for the new banner. This identifier is needed to change or
                              remove the message later. A unique identifier is automatically created
                              if one is not specified.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --type -t               : Type of banner to present. Defaults is "info".  Allowed values: error,
                              info, warning.
```

## az devops admin banner list

az devops admin banner list : List banners.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az devops admin banner remove

az devops admin banner remove : Remove a banner.

```text
Arguments
    --id        [Required] : ID of the banner to remove.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops admin banner show

az devops admin banner show : Show details for a banner.

```text
Arguments
    --id      [Required] : Identifier for the banner.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az devops admin banner update

az devops admin banner update : Update the message, level, or expiration date for a banner.

```text
Arguments
    --id        [Required] : ID of the banner to update.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --expiration           : Date/time when the banner should no longer be presented to users. To
                             unset the expiration for the banner, supply an empty value to this
                             argument. Example : "2019-06-10 17:21:00 UTC", "2019-06-10".
    --message -m           : Message (string) to show in the banner.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --type -t              : Type of banner to present. Defaults is "info".  Allowed values: error,
                             info, warning.
```

## az devops migrations cutover approve

az devops migrations cutover approve : Approve cutover by accepting unprocessed items and/or
verifying rewired pipelines.
Provide --accept-failures when cutover review surfaces unprocessed items, and/or
--pipelines-verified when cutover review reports requiresPipelineVerificationAcknowledgment:
true. At least one of the two must be supplied; both may be sent together in a single call.
WARNING: Command group 'devops migrations cutover' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus

```text
Arguments
    --accept-failures      : Number of unprocessed migration resources to accept before proceeding
                             with cutover.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --pipelines-verified   : Acknowledge that all rewired pipelines have been verified. Required
                             when "cutover review" returns
                             requiresPipelineVerificationAcknowledgment: true. Can be combined with
                             --accept-failures in a single approve call.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops migrations cutover cancel

az devops migrations cutover cancel : Cancel a scheduled cutover.
WARNING: Command group 'devops migrations cutover' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect               : Automatically detect organization.  Allowed values: false, true.
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--repository-id        : ID of the Azure Repos repository (GUID).

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops migrations cutover review

az devops migrations cutover review : Review unprocessed migration items before cutover.
The response includes requiresPipelineVerificationAcknowledgment. When true, cutover approve
must be re-run with --pipelines-verified before the migration can proceed.
WARNING: Command group 'devops migrations cutover' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops migrations cutover set

az devops migrations cutover set : Schedule cutover for a migration.
WARNING: Command group 'devops migrations cutover' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--date                 : The date and time for cutover (ISO 8601).
--detect               : Automatically detect organization.  Allowed values: false, true.
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--repository-id        : ID of the Azure Repos repository (GUID).

```text
Arguments
    --date                 : The date and time for cutover (ISO 8601).
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops migrations pipelines delete

az devops migrations pipelines delete : Delete pipeline rewiring data for a migration.
(Preview).
WARNING: Command group 'devops migrations pipelines' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect               : Automatically detect organization.  Allowed values: false, true.
--migration-id         : Migration ID used for pipeline rewiring cleanup.
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--repository-id        : ID of the Azure Repos repository (GUID).
--yes -y               : Do not prompt for confirmation.

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --migration-id         : Migration ID used for pipeline rewiring cleanup.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --repository-id        : ID of the Azure Repos repository (GUID).
    --yes -y               : Do not prompt for confirmation.
```

## az devops migrations pipelines list

az devops migrations pipelines list : List pipeline rewiring configuration and per-pipeline
status.
WARNING: Command group 'devops migrations pipelines' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect             : Automatically detect organization.  Allowed values: false, true.
--org --organization : Azure DevOps organization URL. You can configure the default organization
using az devops configure -d organization=ORG_URL. Required if not
configured as default or picked up via git config. Example:
`https://dev.azure.com/MyOrganizationName/`.
--repository-id      : ID of the Azure Repos repository (GUID).

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --repository-id      : ID of the Azure Repos repository (GUID).
```

## az devops migrations pipelines retry

az devops migrations pipelines retry : Retry failed pipeline rewiring entries. (Preview).
WARNING: Command group 'devops migrations pipelines' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect               : Automatically detect organization.  Allowed values: false, true.
--org --organization   : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--pipeline-ids         : Pipeline definition IDs to retry. Accepts space-separated or comma-
separated values.
--repository-id        : ID of the Azure Repos repository (GUID).

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-ids         : Pipeline definition IDs to retry. Accepts space-separated or comma-
                             separated values.
    --repository-id        : ID of the Azure Repos repository (GUID).
```

## az devops migrations pipelines submit

az devops migrations pipelines submit : Submit pipelines for rewiring. (Preview).
WARNING: Command group 'devops migrations pipelines' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--detect                : Automatically detect organization.  Allowed values: false, true.
--org --organization    : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--pipeline-ids          : Pipeline definition IDs. Accepts space-separated values (for example,
42 43 44) or comma-separated values (for example, 42,43,44).
--repository-id         : ID of the Azure Repos repository (GUID).
--repository-mapping    : Repository mapping in the format
`<sourceRepoId>=<targetOwner>/<targetRepo>`. Can be provided multiple
times.
--service-connection-id : Project-scoped GitHub service connection ID (GUID). Optional if a
connection was already attached via migrations create --pipeline-
service-connection-id or pipelines update --service-connection-id.

```text
Arguments
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-ids          : Pipeline definition IDs. Accepts space-separated values (for example,
                              42 43 44) or comma-separated values (for example, 42,43,44).
    --repository-id         : ID of the Azure Repos repository (GUID).
    --repository-mapping    : Repository mapping in the format
                              `<sourceRepoId>=<targetOwner>/<targetRepo>`. Can be provided multiple
                              times.
    --service-connection-id : Project-scoped GitHub service connection ID (GUID). Optional if a
                              connection was already attached via migrations create --pipeline-
                              service-connection-id or pipelines update --service-connection-id.
```

## az devops migrations pipelines update

az devops migrations pipelines update : Bulk update pipeline rewiring configuration. (Preview).
WARNING: Command group 'devops migrations pipelines' is in preview and under development.
Reference and support levels: https://aka.ms/CLI_refstatus
Arguments
--add-ids               : Pipeline IDs to add. Accepts space-separated or comma-separated
values.
--detect                : Automatically detect organization.  Allowed values: false, true.
--org --organization    : Azure DevOps organization URL. You can configure the default
organization using az devops configure -d organization=ORG_URL.
Required if not configured as default or picked up via git config.
Example: `https://dev.azure.com/MyOrganizationName/`.
--remove-ids            : Pipeline IDs to remove. Accepts space-separated or comma-separated
values.
--repository-id         : ID of the Azure Repos repository (GUID).
--repository-mapping    : Repository mapping in the format
`<sourceRepoId>=<targetOwner>/<targetRepo>`. Can be provided multiple
times.
--retry-ids             : Failed pipeline IDs to retry. Accepts space-separated or comma-
separated values.
--service-connection-id : Project-scoped GitHub service connection ID (GUID).

```text
Arguments
    --add-ids               : Pipeline IDs to add. Accepts space-separated or comma-separated
                              values.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --remove-ids            : Pipeline IDs to remove. Accepts space-separated or comma-separated
                              values.
    --repository-id         : ID of the Azure Repos repository (GUID).
    --repository-mapping    : Repository mapping in the format
                              `<sourceRepoId>=<targetOwner>/<targetRepo>`. Can be provided multiple
                              times.
    --retry-ids             : Failed pipeline IDs to retry. Accepts space-separated or comma-
                              separated values.
    --service-connection-id : Project-scoped GitHub service connection ID (GUID).
```

## az devops security group membership

az devops security group membership : Manage memberships for security groups.

Children: `add` (command), `list` (command), `remove` (command)

## az devops security group create

az devops security group create : Create a new Azure DevOps group.

```text
Arguments
    --description          : Description of Azure DevOps group.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --email-id             : Create new group using the mail address as a reference to an existing
                             group from an external AD or AAD backed provider. Required if name or
                             origin-id is missing.
    --groups               : A comma separated list of descriptors referencing groups you want the
                             newly created group to join.
    --name                 : Name of Azure DevOps group.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --origin-id            : Create new group using the OriginID as a reference to an existing group
                             from an external AD or AAD backed provider. Required if name or email-
                             id is missing.
    --project -p           : Name or ID of the project in which Azure DevOps group should be
                             created.
    --scope                : Create group at project or organization level.  Allowed values:
                             organization, project.  Default: project.
```

## az devops security group delete

az devops security group delete : Delete an Azure DevOps group.

```text
Arguments
    --id        [Required] : Descriptor of the group.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y               : Do not prompt for confirmation.
```

## az devops security group list

az devops security group list : List all the groups in a project or organization.

```text
Arguments
    --continuation-token : If there are more results that can't be returned in a single page, the
                           result set will contain a continuation token for retrieval of the next
                           set of results.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : List groups for a particular project.
    --scope              : List groups at project or organization level.  Allowed values:
                           organization, project.  Default: project.
    --subject-types      : A comma separated list of user subject subtypes to reduce the retrieved
                           results. You can give initial part of descriptor [before the dot] as a
                           filter e.g. vssgp,aadgp.
```

## az devops security group show

az devops security group show : Show group details.

```text
Arguments
    --id      [Required] : Descriptor of the group.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security group update

az devops security group update : Update name AND/OR description for an Azure DevOps group.

```text
Arguments
    --id        [Required] : Descriptor of the group.
    --description          : New description for Azure DevOps group.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --name                 : New name for Azure DevOps group.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security permission namespace

az devops security permission namespace : Manage security namespaces.

Children: `list` (command), `show` (command)

## az devops security permission list

az devops security permission list : List tokens for given user/group and namespace.

```text
Arguments
    --id --namespace-id [Required] : ID of security namespace.
    --subject           [Required] : User Email ID or Group descriptor.
    --detect                       : Automatically detect organization.  Allowed values: false,
                                     true.
    --org --organization           : Azure DevOps organization URL. You can configure the default
                                     organization using az devops configure -d organization=ORG_URL.
                                     Required if not configured as default or picked up via git
                                     config. Example: `https://dev.azure.com/MyOrganizationName/`.
    --recurse                      : If true and this is a hierarchical namespace, return child ACLs
                                     of the specified token.
    --token                        : Security token.
```

## az devops security permission reset

az devops security permission reset : Reset permission for given permission bit(s).

```text
Arguments
    --id --namespace-id [Required] : ID of security namespace.
    --permission-bit    [Required] : Permission bit or addition of permission bits which needs to be
                                     reset                         for given user/group and token.
    --subject           [Required] : User Email ID or Group descriptor.
    --token             [Required] : Security token.
    --detect                       : Automatically detect organization.  Allowed values: false,
                                     true.
    --org --organization           : Azure DevOps organization URL. You can configure the default
                                     organization using az devops configure -d organization=ORG_URL.
                                     Required if not configured as default or picked up via git
                                     config. Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security permission reset-all

az devops security permission reset-all : Clear all permissions of this token for a user/group.

```text
Arguments
    --id --namespace-id [Required] : ID of security namespace.
    --subject           [Required] : User Email ID or Group descriptor.
    --token             [Required] : Security token.
    --detect                       : Automatically detect organization.  Allowed values: false,
                                     true.
    --org --organization           : Azure DevOps organization URL. You can configure the default
                                     organization using az devops configure -d organization=ORG_URL.
                                     Required if not configured as default or picked up via git
                                     config. Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y                       : Do not prompt for confirmation.
```

## az devops security permission show

az devops security permission show : Show permissions for given token, namespace and user/group.

```text
Arguments
    --id --namespace-id [Required] : ID of security namespace.
    --subject           [Required] : User Email ID or Group descriptor.
    --token             [Required] : Security token.
    --detect                       : Automatically detect organization.  Allowed values: false,
                                     true.
    --org --organization           : Azure DevOps organization URL. You can configure the default
                                     organization using az devops configure -d organization=ORG_URL.
                                     Required if not configured as default or picked up via git
                                     config. Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security permission update

az devops security permission update : Assign allow or deny permission to given user/group.
Learn more at https://aka.ms/azure-devops-cli-security-permission.

```text
Arguments
    --id --namespace-id [Required] : ID of security namespace.
    --subject           [Required] : User Email ID or Group descriptor.
    --token             [Required] : Security token.
    --allow-bit                    : Allow bit or addition of bits. Required if --deny-bit is
                                     missing.
    --deny-bit                     : Deny bit or addition of bits. Required if --allow-bit is
                                     missing.
    --detect                       : Automatically detect organization.  Allowed values: false,
                                     true.
    --merge                        : If set, the existing ACE has its allow and deny merged with
                                     the incoming ACE's allow and deny. If unset, the existing ACE
                                     is displaced.  Allowed values: false, true.  Default: True.
    --org --organization           : Azure DevOps organization URL. You can configure the default
                                     organization using az devops configure -d organization=ORG_URL.
                                     Required if not configured as default or picked up via git
                                     config. Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops service-endpoint azurerm create

az devops service-endpoint azurerm create : Create an Azure RM type service endpoint.
For automation, set service principal password/secret in
AZURE_DEVOPS_EXT_AZURE_RM_SERVICE_PRINCIPAL_KEY environment variable. You can learn more
about this at https://aka.ms/azure-devops-cli-azurerm-service-endpoint.

```text
Arguments
    --azure-rm-service-principal-id    [Required] : Service principal id for creating azure rm
                                                    service endpoint.
    --azure-rm-subscription-id         [Required] : Subscription id for azure rm service endpoint.
    --azure-rm-subscription-name       [Required] : Name of azure subscription for azure rm service
                                                    endpoint.
    --azure-rm-tenant-id               [Required] : Tenant id for creating azure rm service
                                                    endpoint.
    --name                             [Required] : Name of service endpoint to create.
    --azure-rm-service-principal-certificate-path : Path to (.pem) which is certificate. Create
                                                    using command "openssl pkcs12 -in file.pfx -out
                                                    file.pem -nodes -password pass:password_here".
                                                    More details : https://aka.ms/azure-devops-cli-
                                                    azurerm-service-endpoint.
    --detect                                      : Automatically detect organization.  Allowed
                                                    values: false, true.
    --org --organization                          : Azure DevOps organization URL. You can configure
                                                    the default organization using az devops
                                                    configure -d organization=ORG_URL. Required if
                                                    not configured as default or picked up via git
                                                    config. Example:
                                                    `https://dev.azure.com/MyOrganizationName/`.
    --project -p                                  : Name or ID of the project. You can configure the
                                                    default project using az devops configure -d
                                                    project=NAME_OR_ID. Required if not configured
                                                    as default or picked up via git config.
```

## az devops service-endpoint github create

az devops service-endpoint github create : Create a GitHub service endpoint.
For automation, set GitHub PAT token in AZURE_DEVOPS_EXT_GITHUB_PAT environment variable.
You can learn more about this at https://aka.ms/azure-devops-cli-service-endpoint.

```text
Arguments
    --github-url [Required] : Url for github for creating service endpoint.
    --name       [Required] : Name of service endpoint to create.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p            : Name or ID of the project. You can configure the default project using
                              az devops configure -d project=NAME_OR_ID. Required if not configured
                              as default or picked up via git config.
```

## az devops wiki page create

az devops wiki page create : Add a new page.

```text
Arguments
    --path      [Required] : Path of the wiki page.
    --wiki      [Required] : Name or Id of the wiki.
    --comment              : Comment in the commit message of file add operation.  Default: Added a
                             new page using Azure DevOps CLI.
    --content              : Content of the wiki page. Ignored if --file-path is specified.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --encoding             : Encoding of the file. Used in conjunction with --file-path parameter.
                             Allowed values: ascii, utf-16be, utf-16le, utf-8.  Default: utf-8.
    --file-path            : Path of the file input if content is specified in the file.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az devops wiki page delete

az devops wiki page delete : Delete a page.

```text
Arguments
    --path      [Required] : Path of the wiki page.
    --wiki      [Required] : Name or Id of the wiki.
    --comment              : Comment in the commit message of delete operation.  Default: Deleted
                             the page using Azure DevOps CLI.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --yes -y               : Do not prompt for confirmation.
```

## az devops wiki page show

az devops wiki page show : Get the content of a page or open a page.

```text
Arguments
    --path    [Required] : Path of the wiki page.
    --wiki    [Required] : Name or Id of the wiki.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --include-content    : Include content of the page.
    --open               : Open the wiki page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --recursion-level    : Include subpages of the page.
    --version -v         : Version (ETag) of the wiki page.
```

## az devops wiki page update

az devops wiki page update : Edit a page.

```text
Arguments
    --path       [Required] : Path of the wiki page.
    --version -v [Required] : Version (ETag) of file to edit.
    --wiki       [Required] : Name or Id of the wiki.
    --comment               : Comment in the commit message of file edit operation.  Default:
                              Updated the page using Azure DevOps CLI.
    --content               : Content of the wiki page. Ignored if --file-path is specified.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --encoding              : Encoding of the file. Used in conjunction with --file-path parameter.
                              Allowed values: ascii, utf-16be, utf-16le, utf-8.  Default: utf-8.
    --file-path             : Path of the file input if content is specified in the file.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p            : Name or ID of the project. You can configure the default project using
                              az devops configure -d project=NAME_OR_ID. Required if not configured
                              as default or picked up via git config.
```

## az devops security group membership add

az devops security group membership add : Add membership.

```text
Arguments
    --group-id  [Required] : Descriptor of the group to which member needs to be added.
    --member-id [Required] : Descriptor of the group or Email Id of the user to be added. User
                             should already be a part of the organization. Use `az devops user add`
                             command to add an user to organization.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security group membership list

az devops security group membership list : List memberships for a group or user.

```text
Arguments
    --id      [Required] : Group descriptor or User Email whose membership details are required.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --relationship       : Get member of/members for this group.  Allowed values: memberof, members.
                           Default: members.
```

## az devops security group membership remove

az devops security group membership remove : Remove membership.

```text
Arguments
    --group-id  [Required] : Descriptor of the group from which member needs to be removed.
    --member-id [Required] : Descriptor of the group or Email Id of the user to be removed.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y               : Do not prompt for confirmation.
```

## az devops security permission namespace list

az devops security permission namespace list : List all available namespaces for an
organization.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --local-only         : If true, retrieve only local security namespaces.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az devops security permission namespace show

az devops security permission namespace show : Show details of permissions available in each
namespace.

```text
Arguments
    --id --namespace-id [Required] : ID of security namespace.
    --detect                       : Automatically detect organization.  Allowed values: false,
                                     true.
    --org --organization           : Azure DevOps organization URL. You can configure the default
                                     organization using az devops configure -d organization=ORG_URL.
                                     Required if not configured as default or picked up via git
                                     config. Example: `https://dev.azure.com/MyOrganizationName/`.
```
