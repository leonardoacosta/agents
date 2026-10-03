# Agents

Source-controlled agent and automation adapters. Bootstrapped with:

```sh
npx create-turbo@latest agents -e with-shell-commands --package-manager pnpm --skip-install --no-git
```

## Apps

- `apps/with-orca`: install/update three disabled Tribal Cities role automations through Orca CLI; open existing Orca-owned checkouts in Herdr. No Python.
- `apps/with-durable`: Pi Durable deployment placeholder. Deployment deliberately exits nonzero until implemented. No remote deployment or credentials configured.

## Install and verify

Use Node >=24.15.0 and pnpm 10.32.0.

```sh
pnpm install --frozen-lockfile
pnpm check
pnpm build
pnpm test
```

Ultracite supplies Oxlint and Oxfmt presets. No ESLint or `@acme/eslint-config`. The official shell example did not contain that package; its fake lint/type-check scripts and demo library packages were removed.

## Orca

```sh
pnpm orca:validate
pnpm orca:install
# Inside a real Herdr session:
pnpm orca:open /absolute/orca/worktree/path "Tribal Cities · issue"
```

Installation is an uncached, explicit operation. It loads the installed Orca guide, updates by unique name without duplicating existing definitions, always disables schedules, and installs `exit 1` prechecks. It never starts agent runs. Reinstalling intentionally disables any matching enabled automation.

Config: `apps/with-orca/config/tribal-cities.json`. Workflow: `apps/with-orca/WORKFLOW.md`. Repo/workspace paths and IDs are host-specific; provision the controller through Orca and update config on another host. Prompt file paths must also point to that host's checkout. Config has no secrets.

Orca owns Git worktree lifecycle. Herdr opens existing checkouts, not duplicate worktrees. Automatic projection from unattended Orca terminals into Herdr is not implemented. Never spoof `HERDR_ENV`.

Priceless Linear team/project/state IDs remain unresolved because Orca reports no connected teams/projects. Provider availability and exclusive claims must also be verified before replacing prechecks and enabling any schedule.

## Changelog and versions

The official example is named `with-changesets`, not `with-changelog`. This repo uses its Changesets approach with restricted access and private-package versioning. There is no automatic publication script.

```sh
pnpm changeset          # author a release note
pnpm version-packages  # consume release notes into versions + CHANGELOG.md
```

`with-orca` and `with-durable` remain private. Versioning does not deploy agents; `pnpm orca:install` performs local registration. `pnpm durable:deploy` fails closed until the adapter exists.

## References

- https://turborepo.dev/docs/getting-started/examples
- https://github.com/vercel/turborepo/tree/main/examples/with-shell-commands
- https://github.com/vercel/turborepo/tree/main/examples/with-changesets
- https://www.onorca.dev/docs/cli/automations
