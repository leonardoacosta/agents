# az pipelines manual index

Captured 2026-09-08 from Azure CLI 2.90.0 / azure-devops 1.0.8.
Each entry was verified with native `-h`. Re-read live leaf help before use.
Flags below exclude global flags. Availability does not authorize execution.

## Contents

- `az pipelines`
- `az pipelines agent`
- `az pipelines build`
- `az pipelines folder`
- `az pipelines pool`
- `az pipelines queue`
- `az pipelines release`
- `az pipelines runs`
- `az pipelines variable`
- `az pipelines variable-group`
- `az pipelines create`
- `az pipelines delete`
- `az pipelines list`
- `az pipelines run`
- `az pipelines show`
- `az pipelines update`
- `az pipelines agent list`
- `az pipelines agent show`
- `az pipelines build definition`
- `az pipelines build tag`
- `az pipelines build cancel`
- `az pipelines build list`
- `az pipelines build queue`
- `az pipelines build show`
- `az pipelines folder create`
- `az pipelines folder delete`
- `az pipelines folder list`
- `az pipelines folder update`
- `az pipelines pool list`
- `az pipelines pool show`
- `az pipelines queue list`
- `az pipelines queue show`
- `az pipelines release definition`
- `az pipelines release create`
- `az pipelines release list`
- `az pipelines release show`
- `az pipelines runs artifact`
- `az pipelines runs tag`
- `az pipelines runs list`
- `az pipelines runs show`
- `az pipelines variable create`
- `az pipelines variable delete`
- `az pipelines variable list`
- `az pipelines variable update`
- `az pipelines variable-group variable`
- `az pipelines variable-group create`
- `az pipelines variable-group delete`
- `az pipelines variable-group list`
- `az pipelines variable-group show`
- `az pipelines variable-group update`
- `az pipelines build definition list`
- `az pipelines build definition show`
- `az pipelines build tag add`
- `az pipelines build tag delete`
- `az pipelines build tag list`
- `az pipelines release definition list`
- `az pipelines release definition show`
- `az pipelines runs artifact download`
- `az pipelines runs artifact list`
- `az pipelines runs artifact upload`
- `az pipelines runs tag add`
- `az pipelines runs tag delete`
- `az pipelines runs tag list`
- `az pipelines variable-group variable create`
- `az pipelines variable-group variable delete`
- `az pipelines variable-group variable list`
- `az pipelines variable-group variable update`

## az pipelines

az pipelines : Manage Azure Pipelines.
This command group is a part of the azure-devops extension.

Children: `agent` (group), `build` (group), `folder` (group), `pool` (group), `queue` (group), `release` (group), `runs` (group), `variable` (group), `variable-group` (group), `create` (command), `delete` (command), `list` (command), `run` (command), `show` (command), `update` (command)

## az pipelines agent

az pipelines agent : Manage agents.

Children: `list` (command), `show` (command)

## az pipelines build

az pipelines build : Manage builds.

Children: `definition` (group), `tag` (group), `cancel` (command), `list` (command), `queue` (command), `show` (command)

## az pipelines folder

az pipelines folder : Manage folders for organizing pipelines.

Children: `create` (command), `delete` (command), `list` (command), `update` (command)

## az pipelines pool

az pipelines pool : Manage agent pools.

Children: `list` (command), `show` (command)

## az pipelines queue

az pipelines queue : Manage agent queues.

Children: `list` (command), `show` (command)

## az pipelines release

az pipelines release : Manage releases.

Children: `definition` (group), `create` (command), `list` (command), `show` (command)

## az pipelines runs

az pipelines runs : Manage pipeline runs.

Children: `artifact` (group), `tag` (group), `list` (command), `show` (command)

## az pipelines variable

az pipelines variable : Manage pipeline variables.

Children: `create` (command), `delete` (command), `list` (command), `update` (command)

## az pipelines variable-group

az pipelines variable-group : Manage variable groups.

Children: `variable` (group), `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az pipelines create

az pipelines create : Create a new Azure Pipeline (YAML based).

```text
Arguments
    --name           [Required] : Name of the new pipeline.
    --branch                    : Branch name for which the pipeline will be configured. If omitted,
                                  it will be auto-detected from local repository.
    --description               : Description for the new pipeline.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --folder-path               : Path of the folder where the pipeline needs to be created. Default
                                  is root folder. e.g. "user1/test_pipelines".
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --queue-id                  : Id of the queue in the available agent pools. Will be auto
                                  detected if not specified.
    --repository                : Repository for which the pipeline needs to be configured. Can be
                                  clone url of the git repository or name of the repository for a
                                  Azure Repos or Owner/RepoName in case of GitHub repository. If
                                  omitted it will be auto-detected from the remote url of local git
                                  repository. If name is mentioned instead of url, --repository-type
                                  argument is also required.
    --repository-type           : Type of repository. If omitted, it will be auto-detected from
                                  remote url of local repository. 'tfsgit' for Azure Repos, 'github'
                                  for GitHub repository.  Allowed values: github, tfsgit.
    --service-connection        : Id of the Service connection created for the repository for GitHub
                                  repository. Use command az devops service-endpoint -h for
                                  creating/listing service_connections. Not required for Azure
                                  Repos.
    --skip-first-run --skip-run : Specify this flag to prevent the first run being triggered by the
                                  command. Command will return a pipeline if run is skipped else it
                                  will output a pipeline run.  Allowed values: false, true.
    --yaml-path --yml-path      : Path of the pipelines yaml file in the repo (if yaml is already
                                  present in the repo).
```

## az pipelines delete

az pipelines delete : Delete a pipeline.

```text
Arguments
    --id        [Required] : ID of the pipeline.
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

## az pipelines list

az pipelines list : List pipelines.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --folder-path        : If specified, filters to definitions under this folder.
    --name               : Limit results to pipelines with this name or starting with this name.
                           Examples: "FabCI" or "Fab*".
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --query-order        : Order of the results.  Allowed values: ModifiedAsc, ModifiedDesc,
                           NameAsc, NameDesc, None.
    --repository         : Limit results to pipelines associated with this repository.
    --repository-type    : Limit results to pipelines associated with this repository type. It is
                           mandatory to pass 'repository' argument along with this argument.
                           Allowed values: bitbucket, git, github, githubenterprise, svn, tfsgit,
                           tfsversioncontrol.
    --top                : Maximum number of pipelines to list.
```

## az pipelines run

az pipelines run : Queue (run) a pipeline.

```text
Arguments
    --branch               : Name of the branch on which the pipeline run is to be queued. Example:
                             refs/heads/master or master or refs/pull/1/merge or refs/tags/tag.
    --commit-id            : Commit-id on which the pipeline run is to be queued.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --folder-path          : Folder path of pipeline. Default is root level folder.
    --id                   : ID of the pipeline to queue. Required if --name is not supplied.
    --name                 : Name of the pipeline to queue. Ignored if --id is supplied.
    --open                 : Open the pipeline results page in your web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --parameters           : Space separated "name=value" pairs for the parameters you would like to
                             set.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --variables            : Space separated "name=value" pairs for the variables you would like to
                             set.
```

## az pipelines show

az pipelines show : Get the details of a pipeline.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --folder-path        : Folder path of pipeline. Default is root level folder.
    --id                 : ID of the pipeline.
    --name               : Name of the pipeline. Ignored if --id is supplied.
    --open               : Open the pipeline summary page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines update

az pipelines update : Update a pipeline.

```text
Arguments
    --id        [Required] : Id of the pipeline to update.
    --branch               : Branch name for which the pipeline will be configured.
    --description          : New description for the pipeline.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --new-folder-path      : New full path of the folder to move the pipeline to. e.g.
                             "user1/production_pipelines".
    --new-name             : New updated name of the pipeline.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --queue-id             : Queue id of the agent pool where the pipeline needs to run.
    --yaml-path --yml-path : Path of the pipelines yaml file in the repo.
```

## az pipelines agent list

az pipelines agent list : Get a list of agents in a pool.

```text
Arguments
    --pool-id             [Required] : The agent pool containing the agents.
    --agent-name                     : Filter on agent name.
    --demands                        : Filter by demands the agents can satisfy. Comma separated
                                       list.
    --detect                         : Automatically detect organization.  Allowed values: false,
                                       true.
    --include-assigned-request       : Whether to include details about the agents' current work.
                                       Allowed values: false, true.
    --include-capabilities           : Whether to include the agents' capabilities in the response.
                                       Allowed values: false, true.
    --include-last-completed-request : Whether to include details about the agents' most recent
                                       completed work.  Allowed values: false, true.
    --org --organization             : Azure DevOps organization URL. You can configure the default
                                       organization using az devops configure -d
                                       organization=ORG_URL. Required if not configured as default
                                       or picked up via git config. Example:
                                       `https://dev.azure.com/MyOrganizationName/`.
```

## az pipelines agent show

az pipelines agent show : Show agent details.

```text
Arguments
    --agent-id --id       [Required] : The agent ID to get information about.
    --pool-id             [Required] : The agent pool containing the agent.
    --detect                         : Automatically detect organization.  Allowed values: false,
                                       true.
    --include-assigned-request       : Whether to include details about the agents' current work.
                                       Allowed values: false, true.
    --include-capabilities           : Whether to include the agents' capabilities in the response.
                                       Allowed values: false, true.
    --include-last-completed-request : Whether to include details about the agents' most recent
                                       completed work.  Allowed values: false, true.
    --org --organization             : Azure DevOps organization URL. You can configure the default
                                       organization using az devops configure -d
                                       organization=ORG_URL. Required if not configured as default
                                       or picked up via git config. Example:
                                       `https://dev.azure.com/MyOrganizationName/`.
```

## az pipelines build definition

az pipelines build definition : Manage build definitions.

Children: `list` (command), `show` (command)

## az pipelines build tag

az pipelines build tag : Manage build tags.

Children: `add` (command), `delete` (command), `list` (command)

## az pipelines build cancel

az pipelines build cancel : Cancels if build is running.

```text
Arguments
    --build-id  [Required] : ID of the build.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --open                 : Open the build results page in your web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines build list

az pipelines build list : List build results.

```text
Arguments
    --branch             : Filter by builds for this branch.
    --definition-ids     : IDs (space separated) of definitions to list builds for.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --reason             : Limit to builds with this reason.  Allowed values: all, batchedCI,
                           buildCompletion, checkInShelveset, individualCI, manual, pullRequest,
                           schedule, triggered, userCreated, validateShelveset.
    --requested-for      : Limit to builds requested for this user or group.
    --result             : Limit to builds with this result.  Allowed values: canceled, failed,
                           none, partiallySucceeded, succeeded.
    --status             : Limit to builds with this status.  Allowed values: all, cancelling,
                           completed, inProgress, none, notStarted, postponed.
    --tags               : Limit to builds with each of the specified tags. Space separated.
    --top                : Maximum number of builds to list.
```

## az pipelines build queue

az pipelines build queue : Request (queue) a build.

```text
Arguments
    --branch               : Branch to build. Required if there is not a default branch set up on
                             the definition. Example: refs/heads/master or master or
                             refs/pull/1/merge or refs/tags/tag.
    --commit-id            : Commit ID of the branch to build.
    --definition-id        : ID of the definition to queue. Required if --name is not supplied.
    --definition-name      : Name of the definition to queue. Ignored if --id is supplied.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --open                 : Open the build results page in your web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --queue-id             : Queue Id of the pool that will be used to queue the build.
    --variables            : Space separated "name=value" pairs for the variables you would like to
                             set.
```

## az pipelines build show

az pipelines build show : Get the details of a build.

```text
Arguments
    --id      [Required] : ID of the build.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --open               : Open the build results page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines folder create

az pipelines folder create : Create a folder.

```text
Arguments
    --path      [Required] : Full path of the folder.
    --description          : Description of the folder.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines folder delete

az pipelines folder delete : Delete a folder.
This will delete all pipelines in the folder.

```text
Arguments
    --path      [Required] : Full path of the folder.
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

## az pipelines folder list

az pipelines folder list : List all folders.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --path               : Full path of the folder.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --query-order        : Order in which folders are returned.  Allowed values: Asc, Desc, None.
```

## az pipelines folder update

az pipelines folder update : Update a folder name or description.

```text
Arguments
    --path      [Required] : Full path of the folder.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --new-description      : New description of the folder.
    --new-path             : New full path of the folder.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines pool list

az pipelines pool list : List agent pools.

```text
Arguments
    --action             : Filter the list with user action permitted.  Allowed values: manage,
                           none, use.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --pool-name          : Filter the list with matching pool name.
    --pool-type          : Filter the list with type of pool.  Allowed values: automation,
                           deployment.
```

## az pipelines pool show

az pipelines pool show : Show agent pool details.

```text
Arguments
    --id --pool-id [Required] : Id of the pool to list the details.
    --action                  : Filter the list with user action permitted.  Allowed values: manage,
                                none, use.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az pipelines queue list

az pipelines queue list : List agent queues.

```text
Arguments
    --action             : Filter by whether the calling user has use or manage permissions.
                           Allowed values: manage, none, use.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --queue-name         : Filter the list with matching queue name regex. e.g. *ubuntu* for queue
                           with name 'Hosted Ubuntu 1604'.
```

## az pipelines queue show

az pipelines queue show : Show details of agent queue.

```text
Arguments
    --id --queue-id [Required] : Id of the agent queue to get information about.
    --action                   : Filter by whether the calling user has use or manage permissions.
                                 Allowed values: manage, none, use.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az pipelines release definition

az pipelines release definition : Manage release definitions.

Children: `list` (command), `show` (command)

## az pipelines release create

az pipelines release create : Request (create) a release.

```text
Arguments
    --artifact-metadata-list : Space separated "alias=version_id" pairs.
    --definition-id          : ID of the definition to create. Required if --definition-name is not
                               supplied.
    --definition-name        : Name of the definition to create. Ignored if --definition-id is
                               supplied.
    --description            : Description of the release.
    --detect                 : Automatically detect organization.  Allowed values: false, true.
    --open                   : Open the release results page in your web browser.
    --org --organization     : Azure DevOps organization URL. You can configure the default
                               organization using az devops configure -d organization=ORG_URL.
                               Required if not configured as default or picked up via git config.
                               Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p             : Name or ID of the project. You can configure the default project
                               using az devops configure -d project=NAME_OR_ID. Required if not
                               configured as default or picked up via git config.
```

## az pipelines release list

az pipelines release list : List release results.

```text
Arguments
    --definition-id      : ID of definition to list releases for.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --max-created-time   : Releases that were created before this time.
    --min-created-time   : Releases that were created after this time.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --source-branch      : Filter releases for this branch.
    --status             : Limit to releases with this status.
    --top                : Maximum number of releases to list. Default is 50.
```

## az pipelines release show

az pipelines release show : Get the details of a release.

```text
Arguments
    --id      [Required] : ID of the release.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --open               : Open the release results page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines runs artifact

az pipelines runs artifact : Manage pipeline run artifacts.

Children: `download` (command), `list` (command), `upload` (command)

## az pipelines runs tag

az pipelines runs tag : Manage pipeline run tags.

Children: `add` (command), `delete` (command), `list` (command)

## az pipelines runs list

az pipelines runs list : List the pipeline runs in a project.

```text
Arguments
    --branch             : Filter by builds for this branch.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-ids       : IDs (space separated) of definitions to list builds for. For multiple
                           pipeline ids:  --pipeline-ids 1 2.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --query-order        : Order of pipeline runs.  Allowed values: FinishTimeAsc, FinishTimeDesc,
                           QueueTimeAsc, QueueTimeDesc, StartTimeAsc, StartTimeDesc.
    --reason             : Limit to builds with this reason.  Allowed values: all, batchedCI,
                           buildCompletion, checkInShelveset, individualCI, manual, pullRequest,
                           schedule, triggered, userCreated, validateShelveset.
    --requested-for      : Limit to builds requested for this user or group.
    --result             : Limit to builds with this result.  Allowed values: canceled, failed,
                           none, partiallySucceeded, succeeded.
    --status             : Limit to builds with this status.  Allowed values: all, cancelling,
                           completed, inProgress, none, notStarted, postponed.
    --tags               : Limit to builds with each of the specified tags. Space separated.
    --top                : Maximum number of builds to list.
```

## az pipelines runs show

az pipelines runs show : Show details of a pipeline run.

```text
Arguments
    --id      [Required] : ID of the pipeline run.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --open               : Open the build results page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines variable create

az pipelines variable create : Add a variable to a pipeline.

```text
Arguments
    --name      [Required] : Name of the variable.
    --allow-override       : Indicates whether the value can be set at queue time.  Allowed values:
                             false, true.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-id          : Id of the pipeline.
    --pipeline-name        : Name of the pipeline. Ignored if --pipeline-id parameter is supplied.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --secret               : Indicates whether the variable's value is a secret.  Allowed values:
                             false, true.
    --value                : Value of the variable. For secret variables, if --value parameter is
                             not given, it will be picked from environment variable prefixed with
                             AZURE_DEVOPS_EXT_PIPELINE_VAR_ or user will be prompted to enter it via
                             standard input. e.g. A variable named `MySecret` can be input using
                             environment variable AZURE_DEVOPS_EXT_PIPELINE_VAR_MySecret.
```

## az pipelines variable delete

az pipelines variable delete : Delete a variable from pipeline.

```text
Arguments
    --name      [Required] : Name of the variable to delete.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-id          : Id of the pipeline.
    --pipeline-name        : Name of the pipeline.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --yes -y               : Do not prompt for confirmation.
```

## az pipelines variable list

az pipelines variable list : List the variables in a pipeline.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-id        : Id of the pipeline.
    --pipeline-name      : Name of the pipeline. Ignored if --pipeline-id parameter is supplied.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines variable update

az pipelines variable update : Update a variable in a pipeline.

```text
Arguments
    --name      [Required] : Name of the variable.
    --allow-override       : Indicates whether the value can be set at queue time.  Allowed values:
                             false, true.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --new-name             : New name of the variable.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --pipeline-id          : Id of the pipeline.
    --pipeline-name        : Name of the pipeline. Ignored if --pipeline-id parameter is supplied.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --prompt-value         : Set it to True to update the value of a secret variable using
                             environment variable or prompt via standard input.  Allowed values:
                             false, true.
    --secret               : If the value of the variable is a secret.  Allowed values: false, true.
    --value                : New value of the variable. For secret variables, use --prompt-value
                             parameter, to be prompted to enter it via standard input. For non-
                             interactive consoles it can be picked from environment variable
                             prefixed with AZURE_DEVOPS_EXT_PIPELINE_VAR_ e.g. A variable nameed
                             `MySecret` can be input using environment variable
                             AZURE_DEVOPS_EXT_PIPELINE_VAR_MySecret.
```

## az pipelines variable-group variable

az pipelines variable-group variable : Manage variables in a variable group.

Children: `create` (command), `delete` (command), `list` (command), `update` (command)

## az pipelines variable-group create

az pipelines variable-group create : Create a variable group.

```text
Arguments
    --name      [Required] : Name of the variable group.
    --variables [Required] : Variables in format key=value space separated pairs. Secret variables
                             should be managed using `az pipelines variable-group variable`
                             commands.
    --authorize            : Whether the variable group should be accessible by all pipelines.
                             Allowed values: false, true.
    --description          : Description of the variable group.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines variable-group delete

az pipelines variable-group delete : Delete a variable group.

```text
Arguments
    --group-id --id [Required] : Id of the variable group.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
    --yes -y                   : Do not prompt for confirmation.
```

## az pipelines variable-group list

az pipelines variable-group list : List variable groups.

```text
Arguments
    --action --action-filter : Action filter for the variable group. It specifies the action which
                               can be performed on the variable groups.  Allowed values: manage,
                               none, use.
    --continuation-token     : Gets the variable groups after the continuation token provided.
    --detect                 : Automatically detect organization.  Allowed values: false, true.
    --group-name             : Name of the variable group. Wildcards are accepted. e.g. var_group*.
    --org --organization     : Azure DevOps organization URL. You can configure the default
                               organization using az devops configure -d organization=ORG_URL.
                               Required if not configured as default or picked up via git config.
                               Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p             : Name or ID of the project. You can configure the default project
                               using az devops configure -d project=NAME_OR_ID. Required if not
                               configured as default or picked up via git config.
    --query-order            : Gets the results in the defined order.  Allowed values: Asc, Desc.
                               Default: Desc.
    --top                    : Number of variable groups to get.
```

## az pipelines variable-group show

az pipelines variable-group show : Show variable group details.

```text
Arguments
    --group-id --id [Required] : ID of the variable group.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az pipelines variable-group update

az pipelines variable-group update : Update a variable group.

```text
Arguments
    --group-id --id [Required] : Id of the variable group.
    --authorize                : Whether the variable group should be accessible by all pipelines.
                                 Allowed values: false, true.
    --description              : New description of the variable group.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --name                     : New name of the variable group.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az pipelines build definition list

az pipelines build definition list : List build definitions.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --name               : Limit results to definitions with this name or starting with this name.
                           Examples: "FabCI" or "Fab*".
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --repository         : Limit results to definitions associated with this repository.
    --repository-type    : Limit results to definitions associated with this repository type. It is
                           mandatory to pass 'repository' argument along with this argument.
                           Allowed values: bitbucket, git, github, githubenterprise, svn, tfsgit,
                           tfsversioncontrol.
    --top                : Maximum number of definitions to list.
```

## az pipelines build definition show

az pipelines build definition show : Get the details of a build definition.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --id                 : ID of the definition.
    --name               : Name of the definition. Ignored if --id is supplied.
    --open               : Open the definition summary page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines build tag add

az pipelines build tag add : Add tag(s) for a build.

```text
Arguments
    --build-id  [Required] : ID of the build.
    --tags      [Required] : Tag(s) to be added to the build. [Comma separated values].
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines build tag delete

az pipelines build tag delete : Delete a build tag.

```text
Arguments
    --build-id  [Required] : ID of the build.
    --tag       [Required] : Tag to be deleted from the build.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines build tag list

az pipelines build tag list : Get tags for a build.

```text
Arguments
    --build-id [Required] : ID of the build.
    --detect              : Automatically detect organization.  Allowed values: false, true.
    --org --organization  : Azure DevOps organization URL. You can configure the default
                            organization using az devops configure -d organization=ORG_URL. Required
                            if not configured as default or picked up via git config. Example:
                            `https://dev.azure.com/MyOrganizationName/`.
    --project -p          : Name or ID of the project. You can configure the default project using
                            az devops configure -d project=NAME_OR_ID. Required if not configured as
                            default or picked up via git config.
```

## az pipelines release definition list

az pipelines release definition list : List release definitions.

```text
Arguments
    --artifact-source-id : Limit results to definitions associated with this artifact_source_id.
                           e.g. For build it would be {projectGuid}:{BuildDefinitionId}, for Jenkins
                           it would be {JenkinsConnectionId}:{JenkinsDefinitionId}, for TfsOnPrem it
                           would be {TfsOnPremConnectionId}:{ProjectName}:{TfsOnPremDefinitionId}.
                           For third-party artifacts e.g. TeamCity, BitBucket you may refer
                           'uniqueSourceIdentifier' inside vss-extension.json at
                           https://github.com/Microsoft/vsts-rm-extensions/blob/master/Extensions.
    --artifact-type      : Release definitions with given artifactType will be returned.  Allowed
                           values: build, externaltfsbuild, git, github, jenkins, tfvc.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --name               : Limit results to definitions with this name or contains this name.
                           Example: "FabCI".
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --top                : Maximum number of definitions to list.
```

## az pipelines release definition show

az pipelines release definition show : Get the details of a release definition.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --id                 : ID of the definition.
    --name               : Name of the definition. Ignored if --id is supplied.
    --open               : Open the definition summary page in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines runs artifact download

az pipelines runs artifact download : Download a pipeline artifact.

```text
Arguments
    --artifact-name [Required] : Name of the artifact to download.
    --path          [Required] : Path to download the artifact into.
    --run-id        [Required] : ID of the run that the artifact is associated to.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az pipelines runs artifact list

az pipelines runs artifact list : List artifacts associated with a run.

```text
Arguments
    --run-id  [Required] : ID of the run that the artifact is associated to.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines runs artifact upload

az pipelines runs artifact upload : Upload a pipeline artifact.

```text
Arguments
    --artifact-name [Required] : Name of the artifact to upload.
    --path          [Required] : Path to upload the artifact from.
    --run-id        [Required] : ID of the run that the artifact is associated to.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az pipelines runs tag add

az pipelines runs tag add : Add tag(s) for a pipeline run.

```text
Arguments
    --run-id    [Required] : ID of the pipeline run.
    --tags      [Required] : Tag(s) to be added to the pipeline run. [Comma separated values].
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines runs tag delete

az pipelines runs tag delete : Delete a pipeline run tag.

```text
Arguments
    --run-id    [Required] : ID of the pipeline run.
    --tag       [Required] : Tag to be deleted from the pipeline run.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az pipelines runs tag list

az pipelines runs tag list : Get tags for a pipeline run.

```text
Arguments
    --run-id  [Required] : ID of the  pipeline run.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az pipelines variable-group variable create

az pipelines variable-group variable create : Add a variable to a variable group.

```text
Arguments
    --group-id --id [Required] : Id of the variable group.
    --name          [Required] : Name of the variable.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
    --secret                   : If the value of the variable is a secret.  Allowed values: false,
                                 true.
    --value                    : Value of the variable. For secret variables, if --value parameter
                                 is not given, it will be picked from environment variable prefixed
                                 with AZURE_DEVOPS_EXT_PIPELINE_VAR_ or user will be prompted to
                                 enter it via standard input. e.g. PersonalAccessToken can be input
                                 using environment variable
                                 AZURE_DEVOPS_EXT_PIPELINE_VAR_PersonalAccessToken.
```

## az pipelines variable-group variable delete

az pipelines variable-group variable delete : Delete a variable from variable group.

```text
Arguments
    --group-id --id [Required] : Id of the variable group.
    --name          [Required] : Name of the variable.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
    --yes -y                   : Do not prompt for confirmation.
```

## az pipelines variable-group variable list

az pipelines variable-group variable list : List the variables in a variable group.

```text
Arguments
    --group-id --id [Required] : Id of the variable group.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az pipelines variable-group variable update

az pipelines variable-group variable update : Update a variable in a variable group.

```text
Arguments
    --group-id --id [Required] : Id of the variable group.
    --name          [Required] : Name of the variable.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --new-name                 : New name of the variable.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
    --prompt-value             : Set it to True to update the value of a secret variable using
                                 environment variable or prompt via standard input.  Allowed values:
                                 false, true.
    --secret                   : If the value of the variable is a secret.  Allowed values: false,
                                 true.
    --value                    : New value of the variable. For secret variables, if --value
                                 parameter is not given, it will be picked from environment variable
                                 prefixed with AZURE_DEVOPS_EXT_PIPELINE_VAR_ or user will be
                                 prompted to enter it via standard input. e.g. PersonalAccessToken
                                 can be input using environment variable
                                 AZURE_DEVOPS_EXT_PIPELINE_VAR_PersonalAccessToken.
```
