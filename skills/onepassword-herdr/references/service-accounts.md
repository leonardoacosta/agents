# Service-account scope and replacement

Use this reference only when creating, replacing, or rotating an `op` service account.

## Verified CLI behavior

The installed CLI documents vault access on creation:

```bash
op service-account create <name> \
  --vault '<vault>:read_items,write_items'
```

Available service-account vault permissions are `read_items`, `write_items`, and `share_items`. `write_items` requires `read_items`. If a vault is omitted from the scope, the service account does not receive that vault. Service accounts cannot access built-in Personal or Private vaults. The create command returns the token only once; save it securely at creation time.

This differs from human vault grants, which use `op vault user grant` and permissions such as `allow_viewing` and `allow_editing`. A user grant does not change a service account's immutable scope.

## Replacing an account

When less account sprawl is preferred and the existing account needs a new vault scope:

1. Identify the existing service account and its consumers from configuration and runtime references without displaying token values.
2. Confirm the replacement scope includes every still-required vault and only the needed permissions.
3. Create the replacement service account and immediately store its one-time token in the intended human-operable vault.
4. Update each identified consumer using its supported secret-injection mechanism.
5. Verify each consumer and verify the replacement account can access the intended vault.
6. Revoke or retire the old account only after consumer verification and an explicit authorized rotation plan.

If consumer ownership or secret propagation is unclear, do not revoke the old account or claim replacement is complete. Ask for the missing authority or inventory.

## Metadata checks

```bash
op vault get '<vault>' --format json
op vault user list '<vault>' --format json
op item list --vault '<vault>' --format json
```

These commands expose metadata. Avoid `--reveal` and do not print secret-bearing fields. Redact item identifiers from broad logs when they are not needed for the task.
