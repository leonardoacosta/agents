# az boards manual index

Captured 2026-09-08 from Azure CLI 2.90.0 / azure-devops 1.0.8.
Each entry was verified with native `-h`. Re-read live leaf help before use.
Flags below exclude global flags. Availability does not authorize execution.

## Contents

- `az boards`
- `az boards area`
- `az boards iteration`
- `az boards work-item`
- `az boards query`
- `az boards area project`
- `az boards area team`
- `az boards iteration project`
- `az boards iteration team`
- `az boards work-item relation`
- `az boards work-item create`
- `az boards work-item delete`
- `az boards work-item show`
- `az boards work-item update`
- `az boards area project create`
- `az boards area project delete`
- `az boards area project list`
- `az boards area project show`
- `az boards area project update`
- `az boards area team add`
- `az boards area team list`
- `az boards area team remove`
- `az boards area team update`
- `az boards iteration project create`
- `az boards iteration project delete`
- `az boards iteration project list`
- `az boards iteration project show`
- `az boards iteration project update`
- `az boards iteration team add`
- `az boards iteration team list`
- `az boards iteration team list-work-items`
- `az boards iteration team remove`
- `az boards iteration team set-backlog-iteration`
- `az boards iteration team set-default-iteration`
- `az boards iteration team show-backlog-iteration`
- `az boards iteration team show-default-iteration`
- `az boards work-item relation add`
- `az boards work-item relation list-type`
- `az boards work-item relation remove`
- `az boards work-item relation show`

## az boards

az boards : Manage Azure Boards.
This command group is a part of the azure-devops extension.

Children: `area` (group), `iteration` (group), `work-item` (group), `query` (command)

## az boards area

az boards area : Manage area paths.

Children: `project` (group), `team` (group)

## az boards iteration

az boards iteration : Manage iterations.

Children: `project` (group), `team` (group)

## az boards work-item

az boards work-item : Manage work items.

Children: `relation` (group), `create` (command), `delete` (command), `show` (command), `update` (command)

## az boards query

az boards query : Query for a list of work items.
Only supports flat queries.

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --id                   : The ID of an existing query.  Required unless --path or --wiql are
                             specified.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --path                 : The path of an existing query.  Ignored if --id is specified.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --wiql                 : The query in Work Item Query Language format.  Ignored if --id or
                             --path is specified.
```

## az boards area project

az boards area project : Manage areas for a project.

Children: `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az boards area team

az boards area team : Manage areas for a team.

Children: `add` (command), `list` (command), `remove` (command), `update` (command)

## az boards iteration project

az boards iteration project : Manage iterations for a project.

Children: `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az boards iteration team

az boards iteration team : Manage iterations for a team.

Children: `add` (command), `list` (command), `list-work-items` (command), `remove` (command), `set-backlog-iteration` (command), `set-default-iteration` (command), `show-backlog-iteration` (command), `show-default-iteration` (command)

## az boards work-item relation

az boards work-item relation : Manage work item relations.

Children: `add` (command), `list-type` (command), `remove` (command), `show` (command)

## az boards work-item create

az boards work-item create : Create a work item.

```text
Arguments
    --title     [Required] : Title of the work item.
    --type      [Required] : Name of the work item type (e.g. Bug).
    --area                 : Area the work item is assigned to (e.g. Demos).
    --assigned-to          : Name of the person the work item is assigned-to (e.g. fabrikam).
    --description -d       : Description of the work item.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --discussion           : Comment to add to a discussion in a work item.
    --fields -f            : Space separated "field=value" pairs for custom fields you would like to
                             set. In case of multiple fields : "field1=value1" "field2=value2".
                             Refer https://aka.ms/azure-devops-cli-field-api for more details on
                             fields.
    --iteration            : Iteration path of the work item (e.g. Demos\Iteration 1).
    --open                 : Open the work item in the default web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --reason               : Reason for the state of the work item.
```

## az boards work-item delete

az boards work-item delete : Delete a work item.

```text
Arguments
    --id        [Required] : Unique id of the work item.
    --destroy              : Permanently delete this work item.
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

## az boards work-item show

az boards work-item show : Show details for a work item.

```text
Arguments
    --id      [Required] : The ID of the work item.
    --as-of              : Work item details as of a particular date and time. Provide a date or
                           date time string. Assumes local time zone. Example: '2019-01-20',
                           '2019-01-20 00:20:00'. For UTC, append 'UTC' to the date time string,
                           '2019-01-20 00:20:00 UTC'.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --expand             : The expand parameters for work item attributes.  Allowed values: all,
                           fields, links, none, relations.  Default: all.
    --fields -f          : Comma-separated list of requested fields.
                           Example:System.Id,System.AreaPath. Refer https://aka.ms/azure-devops-cli-
                           field-api for more details on fields.
    --open               : Open the work item in the default web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az boards work-item update

az boards work-item update : Update work items.

```text
Arguments
    --id        [Required] : The id of the work item to update.
    --area                 : Area the work item is assigned to (e.g. Demos).
    --assigned-to          : Name of the person the work item is assigned-to (e.g. fabrikam).
    --description -d       : Description of the work item.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --discussion           : Comment to add to a discussion in a work item.
    --fields -f            : Space separated "field=value" pairs for custom fields you would like to
                             set. Refer https://aka.ms/azure-devops-cli-field-api for more details
                             on fields.
    --iteration            : Iteration path of the work item (e.g. Demos\Iteration 1).
    --open                 : Open the work item in the default web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --reason               : Reason for the state of the work item.
    --state                : State of the work item (e.g. active).
    --title                : Title of the work item.
```

## az boards area project create

az boards area project create : Create area.

```text
Arguments
    --name      [Required] : Name of the area.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --path                 : Absolute path of an area. Creates an area at root level if --path is
                             not specified. Example:\ProjectName\Area\AreaName.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards area project delete

az boards area project delete : Delete area.

```text
Arguments
    --path      [Required] : Absolute path of an area. Example:\ProjectName\Area\AreaName.
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

## az boards area project list

az boards area project list : List areas for a project.

```text
Arguments
    --depth              : Depth of child nodes to be fetched. Example: --depth 3.  Default: 1.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --path               : Absolute path of an area. Example:\ProjectName\Area\AreaName.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az boards area project show

az boards area project show : Show area details for a project.

```text
Arguments
    --id      [Required] : Area ID.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az boards area project update

az boards area project update : Update area.
Move area or update area name.

```text
Arguments
    --path      [Required] : Absolute path of an area. Example:\ProjectName\Area\AreaName.
    --child-id             : Move an existing area and add as child node for this area.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --name                 : New name of the area.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards area team add

az boards area team add : Add area to a team.
Every team needs to have a default area configured which can't be empty. Hence, you need to
pass --set-as-default while adding first area to your team. You can later configure any
other area which already added to team as default by using `az boards area team update -h`
command.

```text
Arguments
    --path      [Required] : Area path. Example:\ProjectName\AreaName.
    --team      [Required] : The name or id of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --include-sub-areas    : Include child nodes of this area.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --set-as-default       : Set this area path as default area for this team. Default: False.
```

## az boards area team list

az boards area team list : List areas for a team.

```text
Arguments
    --team    [Required] : The name or id of the team.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az boards area team remove

az boards area team remove : Remove area from a team.

```text
Arguments
    --path      [Required] : Area path. Example:\ProjectName\AreaName.
    --team      [Required] : The name or id of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards area team update

az boards area team update : Update team area.
Update any area to include/exclude sub areas OR Set already added area as default.

```text
Arguments
    --path      [Required] : Area path. Example:\ProjectName\AreaName.
    --team      [Required] : The name or id of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --include-sub-areas    : Include child nodes of this area.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --set-as-default       : Set as default team area path. Default: False.
```

## az boards iteration project create

az boards iteration project create : Create iteration.

```text
Arguments
    --name      [Required] : Name of the iteration.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --finish-date          : Finish date of the iteration. Example : "2019-06-21".
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --path                 : Absolute path of an iteration. Creates an iteration at root level if
                             --path is not specified. Example:\ProjectName\Iteration\IterationName.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --start-date           : Start date of the iteration. Example : "2019-06-03".
```

## az boards iteration project delete

az boards iteration project delete : Delete iteration.

```text
Arguments
    --path      [Required] : Absolute path of an iteration.
                             Example:\ProjectName\Iteration\IterationName.
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

## az boards iteration project list

az boards iteration project list : List iterations for a project.

```text
Arguments
    --depth              : Depth of child nodes to be fetched. Example: --depth 3.  Default: 1.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --path               : Absolute path of an iteration.
                           Example:\ProjectName\Iteration\IterationName.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az boards iteration project show

az boards iteration project show : Show iteration details for a project.

```text
Arguments
    --id      [Required] : Iteration ID.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
```

## az boards iteration project update

az boards iteration project update : Update project iteration.
Move iteration or update iteration details like name AND/OR start-date and finish-date.

```text
Arguments
    --path      [Required] : Absolute path of an iteration.
                             Example:\ProjectName\Iteration\IterationName.
    --child-id             : Move an existing iteration and add as child node for this iteration.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --finish-date          : Finish date of the iteration. Example : "2019-06-21".
    --name                 : New name of the iteration.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --start-date           : Start date of the iteration. Example : "2019-06-03".
```

## az boards iteration team add

az boards iteration team add : Add iteration to a team.

```text
Arguments
    --id        [Required] : Identifier of the iteration.
    --team      [Required] : Name or ID of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards iteration team list

az boards iteration team list : List iterations for a team.

```text
Arguments
    --team    [Required] : The name or id of the team.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --timeframe          : A filter for which iterations are returned based on relative time. Only
                           Current is supported currently.
```

## az boards iteration team list-work-items

az boards iteration team list-work-items : List work-items for an iteration.

```text
Arguments
    --id        [Required] : Identifier of the iteration.
    --team      [Required] : Name or ID of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards iteration team remove

az boards iteration team remove : Remove iteration from a team.

```text
Arguments
    --id        [Required] : Identifier of the iteration.
    --team      [Required] : Name or ID of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards iteration team set-backlog-iteration

az boards iteration team set-backlog-iteration : Set backlog iteration for a team.

```text
Arguments
    --id        [Required] : Identifier of the iteration which needs to be set as backlog iteration.
    --team      [Required] : Name or ID of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards iteration team set-default-iteration

az boards iteration team set-default-iteration : Set default iteration for a team.

```text
Arguments
    --team         [Required] : Name or ID of the team.
    --default-iteration-macro : Default iteration macro. Example: @CurrentIteration.
    --detect                  : Automatically detect organization.  Allowed values: false, true.
    --id                      : Identifier of the iteration which needs to be set as default.
    --org --organization      : Azure DevOps organization URL. You can configure the default
                                organization using az devops configure -d organization=ORG_URL.
                                Required if not configured as default or picked up via git config.
                                Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p              : Name or ID of the project. You can configure the default project
                                using az devops configure -d project=NAME_OR_ID. Required if not
                                configured as default or picked up via git config.
```

## az boards iteration team show-backlog-iteration

az boards iteration team show-backlog-iteration : Show backlog iteration for a team.

```text
Arguments
    --team      [Required] : Name or ID of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards iteration team show-default-iteration

az boards iteration team show-default-iteration : Show default iteration for a team.

```text
Arguments
    --team      [Required] : Name or ID of the team.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az boards work-item relation add

az boards work-item relation add : Add relation(s) to work item.

```text
Arguments
    --id            [Required] : The ID of the work item.
    --relation-type [Required] : Relation type to create. Example: parent, child.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --target-id                : ID(s) of work-items to create relation with.
                                 Multiple values can be passed comma separated. Example: 1,2.
    --target-url               : URL(s) of work-items to create relation with.
                                 Multiple values can be passed comma separated.
```

## az boards work-item relation list-type

az boards work-item relation list-type : List work item relations supported in the organization.

```text
Arguments
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az boards work-item relation remove

az boards work-item relation remove : Remove relation(s) from work item.

```text
Arguments
    --id            [Required] : The ID of the work item.
    --relation-type [Required] : Relation type to remove. Example: parent, child.
    --target-id     [Required] : ID(s) of work-items to remove relation from.
                                 Multiple values can be passed comma separated. Example: 1,2.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --yes -y                   : Do not prompt for confirmation.
```

## az boards work-item relation show

az boards work-item relation show : Get work item, fill relations with friendly name.

```text
Arguments
    --id      [Required] : The ID of the work item.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```
