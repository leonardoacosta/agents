# az repos manual index

Captured 2026-09-08 from Azure CLI 2.90.0 / azure-devops 1.0.8.
Each entry was verified with native `-h`. Re-read live leaf help before use.
Flags below exclude global flags. Availability does not authorize execution.

## Contents

- `az repos`
- `az repos import`
- `az repos policy`
- `az repos pr`
- `az repos ref`
- `az repos create`
- `az repos delete`
- `az repos list`
- `az repos show`
- `az repos update`
- `az repos import create`
- `az repos policy approver-count`
- `az repos policy build`
- `az repos policy case-enforcement`
- `az repos policy comment-required`
- `az repos policy file-size`
- `az repos policy merge-strategy`
- `az repos policy required-reviewer`
- `az repos policy work-item-linking`
- `az repos policy create`
- `az repos policy delete`
- `az repos policy list`
- `az repos policy show`
- `az repos policy update`
- `az repos pr policy`
- `az repos pr reviewer`
- `az repos pr work-item`
- `az repos pr checkout`
- `az repos pr create`
- `az repos pr list`
- `az repos pr set-vote`
- `az repos pr show`
- `az repos pr update`
- `az repos ref create`
- `az repos ref delete`
- `az repos ref list`
- `az repos ref lock`
- `az repos ref unlock`
- `az repos policy approver-count create`
- `az repos policy approver-count update`
- `az repos policy build create`
- `az repos policy build update`
- `az repos policy case-enforcement create`
- `az repos policy case-enforcement update`
- `az repos policy comment-required create`
- `az repos policy comment-required update`
- `az repos policy file-size create`
- `az repos policy file-size update`
- `az repos policy merge-strategy create`
- `az repos policy merge-strategy update`
- `az repos policy required-reviewer create`
- `az repos policy required-reviewer update`
- `az repos policy work-item-linking create`
- `az repos policy work-item-linking update`
- `az repos pr policy list`
- `az repos pr policy queue`
- `az repos pr reviewer add`
- `az repos pr reviewer list`
- `az repos pr reviewer remove`
- `az repos pr work-item add`
- `az repos pr work-item list`
- `az repos pr work-item remove`

## az repos

az repos : Manage Azure Repos.
This command group is a part of the azure-devops extension.

Children: `import` (group), `policy` (group), `pr` (group), `ref` (group), `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az repos import

az repos import : Manage Git repositories import.
This command imports the public repo fabrikam-open-source to the empty Git repo fabrikam-
open-source for the default configuration.

Children: `create` (command)

## az repos policy

az repos policy : Manage branch policy.

Children: `approver-count` (group), `build` (group), `case-enforcement` (group), `comment-required` (group), `file-size` (group), `merge-strategy` (group), `required-reviewer` (group), `work-item-linking` (group), `create` (command), `delete` (command), `list` (command), `show` (command), `update` (command)

## az repos pr

az repos pr : Manage pull requests.

Children: `policy` (group), `reviewer` (group), `work-item` (group), `checkout` (command), `create` (command), `list` (command), `set-vote` (command), `show` (command), `update` (command)

## az repos ref

az repos ref : Manage Git references.

Children: `create` (command), `delete` (command), `list` (command), `lock` (command), `unlock` (command)

## az repos create

az repos create : Create a Git repository in a team project.

```text
Arguments
    --name      [Required] : Name for the new repository.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --open                 : Open the repository page in your web browser.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
```

## az repos delete

az repos delete : Delete a Git repository in a team project.

```text
Arguments
    --id        [Required] : ID of the repository.
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

## az repos list

az repos list : List Git repositories of a team project.

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

## az repos show

az repos show : Get the details of a Git repository.

```text
Arguments
    --repository -r [Required] : Name or ID of the repository.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --open                     : Open the repository page in your web browser.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az repos update

az repos update : Update the Git repository.

```text
Arguments
    --repository -r [Required] : Name or ID of the repository.
    --default-branch           : Default branch to be set for the repository. Example:
                                 'refs/heads/live' or 'live'.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --name                     : New name for the repository.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az repos import create

az repos import create : Create a git import request.

```text
Arguments
    --git-source-url --git-url [Required] : Url of the source git repository.
    --detect                              : Automatically detect organization.  Allowed values:
                                            false, true.
    --git-service-endpoint-id             : Service Endpoint for connection to external endpoint.
    --org --organization                  : Azure DevOps organization URL. You can configure the
                                            default organization using az devops configure -d
                                            organization=ORG_URL. Required if not configured as
                                            default or picked up via git config. Example:
                                            `https://dev.azure.com/MyOrganizationName/`.
    --project -p                          : Name or ID of the project. You can configure the default
                                            project using az devops configure -d project=NAME_OR_ID.
                                            Required if not configured as default or picked up via
                                            git config.
    --repository -r                       : Name or ID of the repository to create the import
                                            request in.
    --requires-authorization              : Flag to tell if source git repository is private.
    --user-name                           : User name in case source git repository is private.
```

## az repos policy approver-count

az repos policy approver-count : Manage approver count policy.

Children: `create` (command), `update` (command)

## az repos policy build

az repos policy build : Manage build policy.

Children: `create` (command), `update` (command)

## az repos policy case-enforcement

az repos policy case-enforcement : Manage case enforcement policy.

Children: `create` (command), `update` (command)

## az repos policy comment-required

az repos policy comment-required : Manage comment required policy.

Children: `create` (command), `update` (command)

## az repos policy file-size

az repos policy file-size : Manage file size policy.

Children: `create` (command), `update` (command)

## az repos policy merge-strategy

az repos policy merge-strategy : Manage merge strategy policy.

Children: `create` (command), `update` (command)

## az repos policy required-reviewer

az repos policy required-reviewer : Manage required reviewer policy.

Children: `create` (command), `update` (command)

## az repos policy work-item-linking

az repos policy work-item-linking : Manage work item linking policy.

Children: `create` (command), `update` (command)

## az repos policy create

az repos policy create : Create a policy using a configuration file.
Recommended when creating policies using multiple scopes for a policy. See
https://aka.ms/azure-devops-cli-docs-policy-file for more information.

```text
Arguments
    --config --policy-configuration [Required] : Local file path for configuration file. Please use
                                                 \backslash when typing in directory path.
    --detect                                   : Automatically detect organization.  Allowed values:
                                                 false, true.
    --org --organization                       : Azure DevOps organization URL. You can configure
                                                 the default organization using az devops configure
                                                 -d organization=ORG_URL. Required if not configured
                                                 as default or picked up via git config. Example:
                                                 `https://dev.azure.com/MyOrganizationName/`.
    --project -p                               : Name or ID of the project. You can configure the
                                                 default project using az devops configure -d
                                                 project=NAME_OR_ID. Required if not configured as
                                                 default or picked up via git config.
```

## az repos policy delete

az repos policy delete : Delete a policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --yes -y                    : Do not prompt for confirmation.
```

## az repos policy list

az repos policy list : List all policies in a project.

```text
Arguments
    --branch             : Branch name to filter results by exact match of branch name. The
                           --repository-id parameter is required to use the branch filter. For
                           example: --branch master.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --repository-id      : ID of the repository to filter results by exact match of the repository
                           ID. For example --repository-ID e556f204-53c9-4153-9cd9-ef41a11e3345.
```

## az repos policy show

az repos policy show : Show policy details.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
```

## az repos policy update

az repos policy update : Update a policy using a configuration file.
Recommended when creating policies using multiple scopes for a policy. See
https://aka.ms/azure-devops-cli-docs-policy-file for more information.

```text
Arguments
    --config --policy-configuration [Required] : Local file path for configuration file. Please use
                                                 \backslash when typing in directory path.
    --id --policy-id                [Required] : ID of the policy.
    --detect                                   : Automatically detect organization.  Allowed values:
                                                 false, true.
    --org --organization                       : Azure DevOps organization URL. You can configure
                                                 the default organization using az devops configure
                                                 -d organization=ORG_URL. Required if not configured
                                                 as default or picked up via git config. Example:
                                                 `https://dev.azure.com/MyOrganizationName/`.
    --project -p                               : Name or ID of the project. You can configure the
                                                 default project using az devops configure -d
                                                 project=NAME_OR_ID. Required if not configured as
                                                 default or picked up via git config.
```

## az repos pr policy

az repos pr policy : Manage pull request policy.

Children: `list` (command), `queue` (command)

## az repos pr reviewer

az repos pr reviewer : Manage pull request reviewers.

Children: `add` (command), `list` (command), `remove` (command)

## az repos pr work-item

az repos pr work-item : Manage work items associated with pull requests.

Children: `add` (command), `list` (command), `remove` (command)

## az repos pr checkout

az repos pr checkout : Checkout the PR source branch locally, if no local changes are present.

```text
Arguments
    --id        [Required] : ID of the pull request.
    --remote-name          : Name of git remote against which PR is raised.  Default: origin.
```

## az repos pr create

az repos pr create : Create a pull request.

```text
Arguments
    --auto-complete                  : Set the pull request to complete automatically when all
                                       policies have passed and the source branch can be merged into
                                       the target branch.  Allowed values: false, true.
    --bypass-policy                  : Bypass required policies (if any) and completes the pull
                                       request once it can be merged.  Allowed values: false, true.
    --bypass-policy-reason           : Reason for bypassing the required policies.
    --delete-source-branch           : Delete the source branch after the pull request has been
                                       completed and merged into the target branch.  Allowed values:
                                       false, true.
    --description -d                 : Description for the new pull request. Can include markdown.
                                       Each value sent to this arg will be a new line. For example:
                                       --description "First Line" "Second Line".
    --detect                         : Automatically detect organization.  Allowed values: false,
                                       true.
    --draft                          : Use this flag to create the pull request in draft/work in
                                       progress mode.  Allowed values: false, true.
    --labels                         : The labels associated with the pull request. Space separated.
    --merge-commit-message           : Message displayed when commits are merged.
    --open                           : Open the pull request in your web browser.
    --optional-reviewers --reviewers : Additional users or groups to include as optional reviewers
                                       on the new pull request. Space separated.
    --org --organization             : Azure DevOps organization URL. You can configure the default
                                       organization using az devops configure -d
                                       organization=ORG_URL. Required if not configured as default
                                       or picked up via git config. Example:
                                       `https://dev.azure.com/MyOrganizationName/`.
    --project -p                     : Name or ID of the project. You can configure the default
                                       project using az devops configure -d project=NAME_OR_ID.
                                       Required if not configured as default or picked up via git
                                       config.
    --repository -r                  : Name or ID of the repository to create the pull request in.
    --required-reviewers             : Additional users or groups to include as required reviewers
                                       on the new pull request. Space separated.
    --source-branch -s               : Name of the source branch. Example: "dev".
    --squash                         : Squash the commits in the source branch when merging into the
                                       target branch.  Allowed values: false, true.
    --target-branch -t               : Name of the target branch. If not specified, defaults to the
                                       default branch of the target repository.
    --title                          : Title for the new pull request.
    --transition-work-items          : Transition any work items linked to the pull request into the
                                       next logical state. (e.g. Active -> Resolved).  Allowed
                                       values: false, true.
    --work-items                     : IDs of the work items to link to the new pull request. Space
                                       separated.
```

## az repos pr list

az repos pr list : List pull requests.

```text
Arguments
    --creator            : Limit results to pull requests created by this user.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --include-links      : Include _links for each pull request.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --repository -r      : Name or ID of the repository.
    --reviewer           : Limit results to pull requests where this user is a reviewer.
    --skip               : Number of pull requests to skip.
    --source-branch -s   : Limit results to pull requests that originate from this source branch.
    --status             : Limit results to pull requests with this status.  Allowed values:
                           abandoned, active, all, completed.
    --target-branch -t   : Limit results to pull requests that target this branch.
    --top                : Maximum number of pull requests to list.
```

## az repos pr set-vote

az repos pr set-vote : Vote on a pull request.

```text
Arguments
    --id        [Required] : ID of the pull request.
    --vote      [Required] : New vote value for the pull request.  Allowed values: approve, approve-
                             with-suggestions, reject, reset, wait-for-author.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr show

az repos pr show : Get the details of a pull request.

```text
Arguments
    --id      [Required] : ID of the pull request.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --open               : Open the pull request in your web browser.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr update

az repos pr update : Update a pull request.

```text
Arguments
    --id         [Required] : ID of the pull request.
    --auto-complete         : Set the pull request to complete automatically when all policies have
                              passed and the source branch can be merged into the target branch.
                              Allowed values: false, true.
    --bypass-policy         : Bypass required policies (if any) and completes the pull request once
                              it can be merged.  Allowed values: false, true.
    --bypass-policy-reason  : Reason for bypassing the required policies.
    --delete-source-branch  : Delete the source branch after the pull request has been completed and
                              merged into the target branch.  Allowed values: false, true.
    --description -d        : New description for the pull request.  Can include markdown.  Each
                              value sent to this arg will be a new line. For example: --description
                              "First Line" "Second Line".
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --draft                 : Publish the PR or convert to draft mode.  Allowed values: false, true.
    --merge-commit-message  : Message displayed when commits are merged.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
    --squash                : Squash the commits in the source branch when merging into the target
                              branch.  Allowed values: false, true.
    --status                : Set the new state of pull request.  Allowed values: abandoned, active,
                              completed.
    --title                 : New title for the pull request.
    --transition-work-items : Transition any work items linked to the pull request into the next
                              logical state. (e.g. Active -> Resolved).  Allowed values: false,
                              true.
```

## az repos ref create

az repos ref create : Create a reference.

```text
Arguments
    --name      [Required] : Name of the reference to create (example: heads/my_branch or
                             tags/my_tag).
    --object-id [Required] : Id of the object to create the reference from.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --repository -r        : Name or ID of the repository.
```

## az repos ref delete

az repos ref delete : Delete a reference.

```text
Arguments
    --name      [Required] : Name of the reference to delete (example: heads/my_branch).
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --object-id            : Id of the reference to delete.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --repository -r        : Name or ID of the repository.
```

## az repos ref list

az repos ref list : List the references.

```text
Arguments
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --filter             : A filter to apply to the refs (starts with). Example: head or heads/ for
                           the branches.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --project -p         : Name or ID of the project. You can configure the default project using az
                           devops configure -d project=NAME_OR_ID. Required if not configured as
                           default or picked up via git config.
    --repository -r      : Name or ID of the repository.
```

## az repos ref lock

az repos ref lock : Lock a reference.

```text
Arguments
    --name      [Required] : Name of the reference to update (example: heads/my_branch).
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --repository -r        : Name or ID of the repository.
```

## az repos ref unlock

az repos ref unlock : Unlock a reference.

```text
Arguments
    --name      [Required] : Name of the reference to update (example: heads/my_branch).
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p           : Name or ID of the project. You can configure the default project using
                             az devops configure -d project=NAME_OR_ID. Required if not configured
                             as default or picked up via git config.
    --repository -r        : Name or ID of the repository.
```

## az repos policy approver-count create

az repos policy approver-count create : Create approver count policy.

```text
Arguments
    --allow-downvotes        [Required] : Whether to allow downvotes or not.  Allowed values: false,
                                          true.
    --blocking               [Required] : Whether the policy should be blocking or not.  Allowed
                                          values: false, true.
    --branch                 [Required] : Branch on which this policy should be applied. For
                                          example: master.
    --creator-vote-counts    [Required] : Whether the creator's vote counts or not.  Allowed values:
                                          false, true.
    --enabled                [Required] : Whether the policy is enabled or not.  Allowed values:
                                          false, true.
    --minimum-approver-count [Required] : Minimum number of approvers required. For example: 2.
    --repository-id          [Required] : Id of the repository on which to apply the policy.
    --reset-on-source-push   [Required] : Whether to reset source on push.  Allowed values: false,
                                          true.
    --branch-match-type                 : Determines how the branch argument is used to apply a
                                          policy. If value is 'exact', the policy will be applied on
                                          a branch which has an exact match on the --branch
                                          argument. If value is 'prefix' the policy is applied
                                          across all branch folders that match the prefix provided
                                          by the --branch argument.  Allowed values: exact, prefix.
                                          Default: exact.
    --detect                            : Automatically detect organization.  Allowed values: false,
                                          true.
    --org --organization                : Azure DevOps organization URL. You can configure the
                                          default organization using az devops configure -d
                                          organization=ORG_URL. Required if not configured as
                                          default or picked up via git config. Example:
                                          `https://dev.azure.com/MyOrganizationName/`.
    --project -p                        : Name or ID of the project. You can configure the default
                                          project using az devops configure -d project=NAME_OR_ID.
                                          Required if not configured as default or picked up via git
                                          config.
```

## az repos policy approver-count update

az repos policy approver-count update : Update approver count policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --allow-downvotes           : Whether to allow downvotes or not.  Allowed values: false, true.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --branch                    : Branch on which this policy should be applied. For example:
                                  master.
    --branch-match-type         : Determines how the branch argument is used to apply a policy. If
                                  value is 'exact', the policy will be applied on a branch which has
                                  an exact match on the --branch argument. If value is 'prefix' the
                                  policy is applied across all branch folders that match the prefix
                                  provided by the --branch argument.  Allowed values: exact, prefix.
    --creator-vote-counts       : Whether the creator's vote counts or not.  Allowed values: false,
                                  true.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --minimum-approver-count    : Minimum number of approvers required. For example: 2.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
    --reset-on-source-push      : Whether to reset source on push.  Allowed values: false, true.
```

## az repos policy build create

az repos policy build create : Create build policy.

```text
Arguments
    --blocking                    [Required] : Whether the policy should be blocking or not.
                                               Allowed values: false, true.
    --branch                      [Required] : Branch on which this policy should be applied. For
                                               example: master.
    --build-definition-id         [Required] : Build Definition Id.
    --display-name                [Required] : Display name for this build policy to identify the
                                               policy. For example: 'Manual queue policy'.
    --enabled                     [Required] : Whether the policy is enabled or not.  Allowed
                                               values: false, true.
    --manual-queue-only           [Required] : Whether to allow only manual queue of builds.
                                               Allowed values: false, true.
    --queue-on-source-update-only [Required] : Queue Only on source update.  Allowed values: false,
                                               true.
    --repository-id               [Required] : Id of the repository on which to apply the policy.
    --valid-duration              [Required] : Policy validity duration (in minutes).
    --branch-match-type                      : Determines how the branch argument is used to apply a
                                               policy. If value is 'exact', the policy will be
                                               applied on a branch which has an exact match on the
                                               --branch argument. If value is 'prefix' the policy is
                                               applied across all branch folders that match the
                                               prefix provided by the --branch argument.  Allowed
                                               values: exact, prefix.  Default: exact.
    --detect                                 : Automatically detect organization.  Allowed values:
                                               false, true.
    --org --organization                     : Azure DevOps organization URL. You can configure the
                                               default organization using az devops configure -d
                                               organization=ORG_URL. Required if not configured as
                                               default or picked up via git config. Example:
                                               `https://dev.azure.com/MyOrganizationName/`.
    --path-filter                            : Filter path(s) on which the policy is applied.
                                               Supports absolute paths, wildcards and multiple paths
                                               separated by ';'. Example: /WebApp/Models/Data.cs,
                                               /WebApp/* or
                                               *.cs,/WebApp/Models/Data.cs;ClientApp/Models/Data.cs.
    --project -p                             : Name or ID of the project. You can configure the
                                               default project using az devops configure -d
                                               project=NAME_OR_ID. Required if not configured as
                                               default or picked up via git config.
```

## az repos policy build update

az repos policy build update : Update build policy.

```text
Arguments
    --id --policy-id   [Required] : ID of the policy.
    --blocking                    : Whether the policy should be blocking or not.  Allowed values:
                                    false, true.
    --branch                      : Branch on which this policy should be applied. For example:
                                    master.
    --branch-match-type           : Determines how the branch argument is used to apply a policy. If
                                    value is 'exact', the policy will be applied on a branch which
                                    has an exact match on the --branch argument. If value is
                                    'prefix' the policy is applied across all branch folders that
                                    match the prefix provided by the --branch argument.  Allowed
                                    values: exact, prefix.
    --build-definition-id         : Build Definition Id.
    --detect                      : Automatically detect organization.  Allowed values: false, true.
    --display-name                : Display name for this build policy to identify the policy. For
                                    example: 'Manual queue policy'.
    --enabled                     : Whether the policy is enabled or not.  Allowed values: false,
                                    true.
    --manual-queue-only           : Whether to allow only manual queue of builds.  Allowed values:
                                    false, true.
    --org --organization          : Azure DevOps organization URL. You can configure the default
                                    organization using az devops configure -d organization=ORG_URL.
                                    Required if not configured as default or picked up via git
                                    config. Example: `https://dev.azure.com/MyOrganizationName/`.
    --path-filter                 : Filter path(s) on which the policy is applied. Supports absolute
                                    paths, wildcards and multiple paths separated by ';'. Example:
                                    /WebApp/Models/Data.cs, /WebApp/* or
                                    *.cs,/WebApp/Models/Data.cs;ClientApp/Models/Data.cs.
    --project -p                  : Name or ID of the project. You can configure the default project
                                    using az devops configure -d project=NAME_OR_ID. Required if not
                                    configured as default or picked up via git config.
    --queue-on-source-update-only : Queue Only on source update.  Allowed values: false, true.
    --repository-id               : Id of the repository on which to apply the policy.
    --valid-duration              : Policy validity duration (in minutes).
```

## az repos policy case-enforcement create

az repos policy case-enforcement create : Create case enforcement policy.

```text
Arguments
    --blocking      [Required] : Whether the policy should be blocking or not.  Allowed values:
                                 false, true.
    --enabled       [Required] : Whether the policy is enabled or not.  Allowed values: false, true.
    --repository-id [Required] : Id of the repository on which to apply the policy.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az repos policy case-enforcement update

az repos policy case-enforcement update : Update case enforcement policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
```

## az repos policy comment-required create

az repos policy comment-required create : Create comment resolution required policy.

```text
Arguments
    --blocking      [Required] : Whether the policy should be blocking or not.  Allowed values:
                                 false, true.
    --branch        [Required] : Branch on which this policy should be applied. For example: master.
    --enabled       [Required] : Whether the policy is enabled or not.  Allowed values: false, true.
    --repository-id [Required] : Id of the repository on which to apply the policy.
    --branch-match-type        : Determines how the branch argument is used to apply a policy. If
                                 value is 'exact', the policy will be applied on a branch which has
                                 an exact match on the --branch argument. If value is 'prefix' the
                                 policy is applied across all branch folders that match the prefix
                                 provided by the --branch argument.  Allowed values: exact, prefix.
                                 Default: exact.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az repos policy comment-required update

az repos policy comment-required update : Update comment resolution required policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --branch                    : Branch on which this policy should be applied. For example:
                                  master.
    --branch-match-type         : Determines how the branch argument is used to apply a policy. If
                                  value is 'exact', the policy will be applied on a branch which has
                                  an exact match on the --branch argument. If value is 'prefix' the
                                  policy is applied across all branch folders that match the prefix
                                  provided by the --branch argument.  Allowed values: exact, prefix.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
```

## az repos policy file-size create

az repos policy file-size create : Create file size policy.

```text
Arguments
    --blocking              [Required] : Whether the policy should be blocking or not.  Allowed
                                         values: false, true.
    --enabled               [Required] : Whether the policy is enabled or not.  Allowed values:
                                         false, true.
    --maximum-git-blob-size [Required] : Maximum git blob size in bytes. For example, to specify a
                                         10byte limit, --maximum-git-blob-size 10.
    --repository-id         [Required] : Id of the repository on which to apply the policy.
    --use-uncompressed-size [Required] : Whether to use uncompressed size.  Allowed values: false,
                                         true.
    --detect                           : Automatically detect organization.  Allowed values: false,
                                         true.
    --org --organization               : Azure DevOps organization URL. You can configure the
                                         default organization using az devops configure -d
                                         organization=ORG_URL. Required if not configured as default
                                         or picked up via git config. Example:
                                         `https://dev.azure.com/MyOrganizationName/`.
    --project -p                       : Name or ID of the project. You can configure the default
                                         project using az devops configure -d project=NAME_OR_ID.
                                         Required if not configured as default or picked up via git
                                         config.
```

## az repos policy file-size update

az repos policy file-size update : Update file size policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --maximum-git-blob-size     : Maximum git blob size in bytes. For example, to specify a 10byte
                                  limit, --maximum-git-blob-size 10.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
    --use-uncompressed-size     : Whether to use uncompressed size.  Allowed values: false, true.
```

## az repos policy merge-strategy create

az repos policy merge-strategy create : Create merge strategy policy.

```text
Arguments
    --blocking      [Required] : Whether the policy should be blocking or not.  Allowed values:
                                 false, true.
    --branch        [Required] : Branch on which this policy should be applied. For example: master.
    --enabled       [Required] : Whether the policy is enabled or not.  Allowed values: false, true.
    --repository-id [Required] : Id of the repository on which to apply the policy.
    --allow-no-fast-forward    : Basic merge (no fast-forward) - Preserves nonlinear history exactly
                                 as it happened during development.  Allowed values: false, true.
    --allow-rebase             : Rebase and fast-forward - Creates a linear history by replaying the
                                 source branch commits onto the target without a merge commit.
                                 Allowed values: false, true.
    --allow-rebase-merge       : Rebase with merge commit - Creates a semi-linear history by
                                 replaying the source branch commits onto the target and then
                                 creating a merge commit.  Allowed values: false, true.
    --allow-squash             : Squash merge - Creates a linear history by condensing the source
                                 branch commits into a single new commit on the target branch.
                                 Allowed values: false, true.
    --branch-match-type        : Determines how the branch argument is used to apply a policy. If
                                 value is 'exact', the policy will be applied on a branch which has
                                 an exact match on the --branch argument. If value is 'prefix' the
                                 policy is applied across all branch folders that match the prefix
                                 provided by the --branch argument.  Allowed values: exact, prefix.
                                 Default: exact.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az repos policy merge-strategy update

az repos policy merge-strategy update : Update merge strategy policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --allow-no-fast-forward     : Basic merge (no fast-forward) - Preserves nonlinear history
                                  exactly as it happened during development.  Allowed values: false,
                                  true.
    --allow-rebase              : Rebase and fast-forward - Creates a linear history by replaying
                                  the source branch commits onto the target without a merge commit.
                                  Allowed values: false, true.
    --allow-rebase-merge        : Rebase with merge commit - Creates a semi-linear history by
                                  replaying the source branch commits onto the target and then
                                  creating a merge commit.  Allowed values: false, true.
    --allow-squash              : Squash merge - Creates a linear history by condensing the source
                                  branch commits into a single new commit on the target branch.
                                  Allowed values: false, true.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --branch                    : Branch on which this policy should be applied. For example:
                                  master.
    --branch-match-type         : Determines how the branch argument is used to apply a policy. If
                                  value is 'exact', the policy will be applied on a branch which has
                                  an exact match on the --branch argument. If value is 'prefix' the
                                  policy is applied across all branch folders that match the prefix
                                  provided by the --branch argument.  Allowed values: exact, prefix.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
```

## az repos policy required-reviewer create

az repos policy required-reviewer create : Create required reviewer policy.

```text
Arguments
    --blocking              [Required] : Whether the policy should be blocking or not.  Allowed
                                         values: false, true.
    --branch                [Required] : Branch on which this policy should be applied. For example:
                                         master.
    --enabled               [Required] : Whether the policy is enabled or not.  Allowed values:
                                         false, true.
    --message               [Required] : Message.
    --repository-id         [Required] : Id of the repository on which to apply the policy.
    --required-reviewer-ids [Required] : Required reviewers email addresses separated by ';'. For
                                         example: john@contoso.com;alice@contoso.com.
    --branch-match-type                : Determines how the branch argument is used to apply a
                                         policy. If value is 'exact', the policy will be applied on
                                         a branch which has an exact match on the --branch argument.
                                         If value is 'prefix' the policy is applied across all
                                         branch folders that match the prefix provided by the
                                         --branch argument.  Allowed values: exact, prefix.
                                         Default: exact.
    --detect                           : Automatically detect organization.  Allowed values: false,
                                         true.
    --org --organization               : Azure DevOps organization URL. You can configure the
                                         default organization using az devops configure -d
                                         organization=ORG_URL. Required if not configured as default
                                         or picked up via git config. Example:
                                         `https://dev.azure.com/MyOrganizationName/`.
    --path-filter                      : Filter path(s) on which the policy is applied. Supports
                                         absolute paths, wildcards and multiple paths separated by
                                         ';'. Example: /WebApp/Models/Data.cs, /WebApp/* or
                                         *.cs,/WebApp/Models/Data.cs;ClientApp/Models/Data.cs.
    --project -p                       : Name or ID of the project. You can configure the default
                                         project using az devops configure -d project=NAME_OR_ID.
                                         Required if not configured as default or picked up via git
                                         config.
```

## az repos policy required-reviewer update

az repos policy required-reviewer update : Update required reviewer policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --branch                    : Branch on which this policy should be applied. For example:
                                  master.
    --branch-match-type         : Determines how the branch argument is used to apply a policy. If
                                  value is 'exact', the policy will be applied on a branch which has
                                  an exact match on the --branch argument. If value is 'prefix' the
                                  policy is applied across all branch folders that match the prefix
                                  provided by the --branch argument.  Allowed values: exact, prefix.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --message                   : Message.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --path-filter               : Filter path(s) on which the policy is applied. Supports absolute
                                  paths, wildcards and multiple paths separated by ';'. Example:
                                  /WebApp/Models/Data.cs, /WebApp/* or
                                  *.cs,/WebApp/Models/Data.cs;ClientApp/Models/Data.cs.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
    --required-reviewer-ids     : Required reviewers email addresses separated by ';'. For example:
                                  john@contoso.com;alice@contoso.com.
```

## az repos policy work-item-linking create

az repos policy work-item-linking create : Create work item linking policy.

```text
Arguments
    --blocking      [Required] : Whether the policy should be blocking or not.  Allowed values:
                                 false, true.
    --branch        [Required] : Branch on which this policy should be applied. For example: master.
    --enabled       [Required] : Whether the policy is enabled or not.  Allowed values: false, true.
    --repository-id [Required] : Id of the repository on which to apply the policy.
    --branch-match-type        : Determines how the branch argument is used to apply a policy. If
                                 value is 'exact', the policy will be applied on a branch which has
                                 an exact match on the --branch argument. If value is 'prefix' the
                                 policy is applied across all branch folders that match the prefix
                                 provided by the --branch argument.  Allowed values: exact, prefix.
                                 Default: exact.
    --detect                   : Automatically detect organization.  Allowed values: false, true.
    --org --organization       : Azure DevOps organization URL. You can configure the default
                                 organization using az devops configure -d organization=ORG_URL.
                                 Required if not configured as default or picked up via git config.
                                 Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p               : Name or ID of the project. You can configure the default project
                                 using az devops configure -d project=NAME_OR_ID. Required if not
                                 configured as default or picked up via git config.
```

## az repos policy work-item-linking update

az repos policy work-item-linking update : Update work item linking policy.

```text
Arguments
    --id --policy-id [Required] : ID of the policy.
    --blocking                  : Whether the policy should be blocking or not.  Allowed values:
                                  false, true.
    --branch                    : Branch on which this policy should be applied. For example:
                                  master.
    --branch-match-type         : Determines how the branch argument is used to apply a policy. If
                                  value is 'exact', the policy will be applied on a branch which has
                                  an exact match on the --branch argument. If value is 'prefix' the
                                  policy is applied across all branch folders that match the prefix
                                  provided by the --branch argument.  Allowed values: exact, prefix.
    --detect                    : Automatically detect organization.  Allowed values: false, true.
    --enabled                   : Whether the policy is enabled or not.  Allowed values: false,
                                  true.
    --org --organization        : Azure DevOps organization URL. You can configure the default
                                  organization using az devops configure -d organization=ORG_URL.
                                  Required if not configured as default or picked up via git config.
                                  Example: `https://dev.azure.com/MyOrganizationName/`.
    --project -p                : Name or ID of the project. You can configure the default project
                                  using az devops configure -d project=NAME_OR_ID. Required if not
                                  configured as default or picked up via git config.
    --repository-id             : Id of the repository on which to apply the policy.
```

## az repos pr policy list

az repos pr policy list : List policies of a pull request.

```text
Arguments
    --id      [Required] : ID of the pull request.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
    --skip               : Number of policies to skip.
    --top                : Maximum number of policies to list.
```

## az repos pr policy queue

az repos pr policy queue : Queue an evaluation of a policy for a pull request.

```text
Arguments
    --evaluation-id -e [Required] : ID of the policy evaluation to queue.
    --id               [Required] : ID of the pull request.
    --detect                      : Automatically detect organization.  Allowed values: false, true.
    --org --organization          : Azure DevOps organization URL. You can configure the default
                                    organization using az devops configure -d organization=ORG_URL.
                                    Required if not configured as default or picked up via git
                                    config. Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr reviewer add

az repos pr reviewer add : Add one or more reviewers to a pull request.

```text
Arguments
    --id        [Required] : ID of the pull request.
    --reviewers [Required] : Users or groups to include as reviewers on a pull request. Space
                             separated.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
    --required             : Make the reviewers required.  Allowed values: false, true.
```

## az repos pr reviewer list

az repos pr reviewer list : List reviewers of a pull request.

```text
Arguments
    --id      [Required] : ID of the pull request.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr reviewer remove

az repos pr reviewer remove : Remove one or more reviewers from a pull request.

```text
Arguments
    --id        [Required] : ID of the pull request.
    --reviewers [Required] : Users or groups to remove as reviewers on a pull request. Space
                             separated.
    --detect               : Automatically detect organization.  Allowed values: false, true.
    --org --organization   : Azure DevOps organization URL. You can configure the default
                             organization using az devops configure -d organization=ORG_URL.
                             Required if not configured as default or picked up via git config.
                             Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr work-item add

az repos pr work-item add : Link one or more work items to a pull request.

```text
Arguments
    --id         [Required] : ID of the pull request.
    --work-items [Required] : IDs of the work items to link. Space separated.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr work-item list

az repos pr work-item list : List linked work items for a pull request.

```text
Arguments
    --id      [Required] : ID of the pull request.
    --detect             : Automatically detect organization.  Allowed values: false, true.
    --org --organization : Azure DevOps organization URL. You can configure the default organization
                           using az devops configure -d organization=ORG_URL. Required if not
                           configured as default or picked up via git config. Example:
                           `https://dev.azure.com/MyOrganizationName/`.
```

## az repos pr work-item remove

az repos pr work-item remove : Unlink one or more work items from a pull request.

```text
Arguments
    --id         [Required] : ID of the pull request.
    --work-items [Required] : IDs of the work items to unlink. Space separated.
    --detect                : Automatically detect organization.  Allowed values: false, true.
    --org --organization    : Azure DevOps organization URL. You can configure the default
                              organization using az devops configure -d organization=ORG_URL.
                              Required if not configured as default or picked up via git config.
                              Example: `https://dev.azure.com/MyOrganizationName/`.
```
