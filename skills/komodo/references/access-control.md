# Komodo access control

Komodo separates user authentication from authorization to individual resources. A user may be able to sign in yet have no visibility or permission to operate on a particular server, deployment, stack, or other resource. Provider credentials for Git, registries, or cloud integrations are a separate boundary. See [configuration and providers](configuration-and-providers.md) for those credentials.

## Prefer groups and least privilege

The permissioning docs recommend assigning resource permissions to **User Groups**, then placing users in the groups they need. A user can belong to multiple groups and inherits their permissions. Review any group configured for **Everyone** carefully: all users implicitly receive the group's grants. For larger installations, groups can also be declared through Resource Sync, whose proposed changes require review before apply.

Resource-level permission has four levels:

- **None:** no resource visibility or API access.
- **Read:** view the resource and its configuration, but do not change configuration or trigger actions.
- **Execute:** run permitted actions, such as builds or redeploys, without editing configuration.
- **Write:** edit configuration, execute actions, and delete the resource.

Start with Read. Grant Execute only when someone must run operations, and Write only when they must own configuration or deletion. Check whether a feature also has its own permission gate. The inspected docs identify specific grants including Logs and terminal-related access; do not infer that resource Read or Execute automatically includes every such capability.

## Transparent mode is a broad policy change

`KOMODO_TRANSPARENT_MODE=true` changes the baseline: the documentation says it grants Read as the base level across resources for all users, and changes the ordinary non-admin default from None. This is not a harmless visibility toggle. Inspect its impact on every resource and user before enabling it, and grant higher permissions explicitly as needed.

## Audit effective access

For a requested access change, identify the person or group, exact resource, action needed, and separate feature permission required. Check inherited grants, overlapping groups, Everyone, and transparent mode before changing anything. Verify both that intended access works and that unrelated resources remain unavailable. Logs, inspection output, and terminal sessions can contain secrets; never copy secret-bearing output into a ticket or chat.

Canonical references:

- [Permissioning](https://komo.do/docs/configuration/permissioning)
- [Advanced setup](https://komo.do/docs/setup/advanced)
- [Resource Sync and user groups](https://komo.do/docs/automate/sync-resources#user-group)

These are descriptive notes based on official documentation captured 2026-09-28, not a review of a live Komodo policy. Permission names and special gates can change. Fetch the current permissioning page and inspect the target instance's effective configuration before advising a change. Do not reset passwords.