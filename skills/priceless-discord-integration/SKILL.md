---
name: priceless-discord-integration
description: Priceless fleet guidance for designing, integrating, debugging, and operating Discord role and community integrations across multitenant applications. Use whenever a Priceless project needs Discord OAuth, bot installation, guild/server connection, custom-domain callback handling, application approval to role mapping, Discord member onboarding, role reconciliation, guild-specific configuration, Discord webhooks, or Linked Roles. Trigger even when the request only says "add Discord roles", "sync approved users", "connect a server", or "support Discord per tenant". Keep tenant identity, OAuth state, Discord installation ownership, role mapping, durable retries, and auditability explicit.
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash, WebFetch, WebSearch
---

# Priceless Discord integration

Use this skill to design and operate Discord integrations without coupling Discord identity to application routing. The core contract is:

`application tenant -> internal user -> linked Discord user -> tenant-owned guild installation -> managed role assignment`

The application tenant may be selected by a custom domain, event slug, workspace, or organization. Discord must never be the authority that selects the tenant.

## First principles

1. **Resolve tenant identity at the application boundary.** Resolve the incoming host or workspace through the application's trusted tenant resolver. Carry the resulting tenant ID explicitly through OAuth state, application records, approval events, queue payloads, and audit logs.
2. **Use stable identifiers.** Store the internal user ID and Discord user ID. Treat Discord usernames, display names, and discriminators as presentation data only.
3. **Separate installation from account linking.** An administrator connects a guild/server and installs the bot. An applicant links their Discord account. These are different workflows with different authorization and ownership checks.
4. **Make role sync reconciliation.** Approval is one desired-state transition. Also reconcile on revocation, unlink, mapping changes, reconnects, and periodic repair.
5. **Only remove roles owned by the integration.** Track installation, mapping, assignment provenance, and mapping version. Never remove an arbitrary role because a stale record says so.
6. **Prefer asynchronous, idempotent work.** Discord calls are external side effects. Use a durable queue, deduplication key, bounded retries, rate-limit handling, and a sync log or outbox.
7. **Protect credentials and authorization state.** Do not log bot tokens, OAuth codes, refresh tokens, signed URLs, or full environment files.

## Architecture decision

For most Priceless multitenant products, prefer:

- one platform-owned Discord application/bot;
- one explicit Discord installation record per tenant or event series;
- one or more guild IDs associated with that installation only after admin authorization;
- tenant-scoped role mappings stored as data;
- internal-user-to-Discord-account linking through OAuth;
- a canonical application approval event that enqueues role reconciliation.

Do not use the OAuth callback hostname, a Discord guild ID by itself, or a user-provided slug as the tenant identity.

## Admin guild installation

Implement a tenant-admin flow like this:

1. Authorize the request using the application's tenant-scoped admin capability.
2. Create a one-time, short-lived, signed `state` value containing the tenant ID, optional event/series ID, initiating user ID, nonce, and return path. Bind it to the session or server-side record.
3. Send the administrator to Discord OAuth with only the scopes and bot permissions required by the product. Role assignment requires the bot to have `Manage Roles` and a role hierarchy above every managed role.
4. On callback, validate the code, state, nonce, expiry, session, and tenant binding. Do not trust a tenant ID from the browser or callback hostname.
5. Verify the selected guild is one the administrator is allowed to configure. Persist the Discord guild ID, installation metadata, bot permissions, connection status, and the actor who connected it.
6. Discover roles and validate hierarchy before enabling synchronization.
7. Store long-lived OAuth tokens only when a user-scoped Discord API capability actually requires them. A bot-token-only design should not put unnecessary refresh tokens in ordinary tenant rows.

The durable relationship is the installation record, not the temporary admin OAuth grant.

## Applicant Discord linking

The applicant flow should:

1. Start from a tenant-scoped page and create signed state bound to the current tenant and authenticated user.
2. Use Discord OAuth to obtain the immutable Discord user ID.
3. Link that Discord ID to the internal user account with a uniqueness constraint.
4. Preserve the originating tenant for UX only. Revalidate it against the authenticated session and stored state on callback.
5. Trigger reconciliation for all current approved assignments in the relevant tenant scope.
6. Clearly distinguish "Discord linked" from "member of the tenant guild". If users must join automatically, implement and consent to a separate guild-join/invite flow.

On unlink, stop future assignment and enqueue removal only for integration-managed roles. If removal fails, record a repairable state rather than hiding the failure.

## Application approval and role mapping

Define mappings against canonical domain vocabulary, not arbitrary UI strings. A useful logical key is:

```text
(tenant_id, event_or_series_id, application_type, approval_state, role_purpose)
```

Examples:

- volunteer + approved -> `Volunteer`
- vendor + approved -> `Vendor`
- department/programming + active -> `Programming Staff`
- staff role/event-admin + active -> `Event Admin`

Keep these concepts distinct:

- **desired state:** what the application says the user should have;
- **mapping:** which Discord role represents that state;
- **installation:** which guild and bot connection owns the mapping;
- **assignment record:** what the integration actually attempted or changed.

When approval changes, commit the domain transition and an outbox/event record transactionally. A worker should re-read current state immediately before calling Discord and verify:

- tenant and event scope agree across payload, headers, and database;
- application is still approved;
- mapping is enabled and current;
- installation is connected;
- user account is still linked;
- role is managed by this installation;
- the guild/member prerequisites hold.

Use an idempotency key such as:

```text
tenant:event:user:application-type:mapping-version:desired-state
```

Reconcile on approval, rejection, withdrawal, expiration, cancellation, role/department changes, account link/unlink, mapping edits, installation reconnect, and periodic repair.

## Queue and worker contract

A role-sync payload should carry explicit tenant scope, event/series scope, user ID, target kind, target key, desired state, correlation ID, and mapping/install version. The worker should:

- authenticate the queue signature;
- compare tenant scope in the payload, forwarded headers, and loaded records;
- reject missing or contradictory scope;
- treat repeated assignment/removal as success when the desired state is already true;
- classify member-not-found, missing permission, role hierarchy, revoked installation, and rate-limit errors separately;
- retry transient failures with bounded exponential backoff;
- persist an audit record with safe external IDs and no tokens;
- expose pending/assigned/skipped/failed/needs-member/needs-permission states;
- support a tenant-scoped repair or reconciliation command.

For bulk sync, respect Discord rate limits and avoid unbounded fan-out. A per-tenant queue key or deduplication scheme prevents cross-tenant collisions.

## Data model checklist

At minimum, model these separately:

- `discord_installation`: tenant scope, guild ID, connection status, bot/application metadata, actor, timestamps, disconnect state;
- `discord_role_mapping`: installation or tenant scope, canonical source key, Discord role ID/name snapshot, enabled state, mapping version, managed marker;
- `discord_account_link`: internal user ID, Discord user ID, provider metadata, timestamps;
- `discord_role_assignment` or `discord_role_sync_log`: desired state, observed state, action, attempt, error class, correlation ID, installation/mapping version;
- `outbox_event` or equivalent: committed application transition waiting for delivery.

Use uniqueness constraints that handle nullable target keys intentionally. Index every tenant and event scope used by workers. Add audit fields for mapping, installation, and disconnect changes.

## Security and privacy checklist

- Use one-time, short-lived, signed OAuth state and PKCE where supported.
- Enforce tenant-scoped admin authorization before installation or mapping edits.
- Encrypt or avoid refresh/access tokens.
- Never log authorization codes, bot tokens, refresh tokens, or full OAuth URLs.
- Store Discord IDs, not mutable names, as identity keys.
- Verify bot role hierarchy before enabling sync.
- Check guild membership before assigning roles, or provide a separate consented join flow.
- Reject queue payload/header/database tenant mismatches.
- Keep all external Discord IDs tenant-scoped in database queries.
- Make disconnect and role cleanup explicit, auditable, and limited to managed assignments.

## Linked Roles versus bot-managed roles

Discord Linked Roles can be an optional self-service mode when guild administrators want Discord-native verification rules. They require application role-connection metadata and an OAuth flow for role connections.

Use bot-managed roles as the primary mode when the application must guarantee precise approval-driven assignment, revocation, auditability, and tenant isolation. Linked Roles are less direct and introduce policy configuration inside Discord. Do not present them as equivalent enforcement mechanisms without documenting the tradeoff.

## Failure diagnosis

- **Wrong tenant after callback:** inspect state/session binding and host-to-tenant resolution. Never fix by trusting a query parameter.
- **Role assignment returns missing permissions:** verify bot permissions and that the bot's highest role is above the target role.
- **User linked but role not assigned:** distinguish missing guild membership from missing mapping, disabled sync, stale approval, or queue failure.
- **Assignment works for one tenant but affects another:** inspect every query, dedup key, queue header, and cache key for tenant scope.
- **Revocation leaves a role behind:** inspect assignment provenance and whether removal was enqueued after the desired state changed.
- **Duplicate or flapping assignments:** inspect idempotency keys, outbox replay, mapping versions, and concurrent reconciliation.
- **Bulk sync stalls:** inspect Discord rate-limit responses, retry delays, and queue fan-out limits.
- **Disconnect cleanup removes too much:** stop and review managed-role ownership before retrying cleanup.

## Verification plan

Cover these tests before production enablement:

1. Two tenants with the same applicant email cannot cross-assign roles.
2. Changing the custom domain or callback URL cannot change stored tenant scope.
3. Replaying the same approval event creates one effective assignment.
4. Approval followed by immediate rejection converges to no managed role.
5. Linking Discord after approval converges to the approved role.
6. Unlinking Discord removes only integration-managed roles.
7. A non-member receives a repairable needs-member result.
8. A role above the bot produces a clear needs-permission result.
9. Mapping changes reconcile old assignments without touching unmanaged roles.
10. Queue retries and outbox replay do not duplicate or cross tenant work.
11. Disconnecting an installation disables future work and records cleanup outcomes.
12. Logs and error reports contain no credentials or authorization codes.

## Safe implementation sequence

1. Establish tenant-bound OAuth state and explicit installation records.
2. Add canonical mapping vocabulary and managed-role ownership.
3. Emit approval transitions through one transactional outbox path.
4. Implement signed, idempotent, tenant-attributed workers.
5. Add account-link and unlink reconciliation.
6. Add admin role discovery, hierarchy checks, repair UI, and periodic reconciliation.
7. Add cross-tenant integration tests and production evidence dashboards.
8. Consider Linked Roles only as an explicit optional product mode.

## Evidence and currentness

For current Discord API behavior, consult official Discord developer documentation before implementation, especially OAuth2, permissions, guild resources, role management, and Application Role Connection Metadata. Keep provider-specific facts as references and keep application-specific tenant conventions in the product's own architecture records.

When this skill is used for a real implementation, report the tenant model, installation scope, OAuth state strategy, mapping vocabulary, desired-state transitions, queue idempotency, failure classification, and verification evidence. Do not claim production readiness from compilation alone.
