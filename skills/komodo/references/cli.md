# Komodo CLI (`km`): help-first operating boundary

Use this reference when the user asks for Komodo CLI guidance. This repository has not verified `km` against a local Komodo installation. Never infer installed syntax from documentation examples or another agent's skill. Do not run live operations as part of authoring or validation.

## Establish syntax before proposing a command

1. Start with `km --help` on the relevant installed version.
2. Use the displayed command tree to select a subcommand, then inspect that exact subcommand's help before relying on arguments, flags, aliases, or confirmation behavior.
3. If help does not establish the needed syntax or effects, stop and consult current [Komodo CLI documentation](https://komo.do/docs/ecosystem/cli). Label unverified details and do not invent flags or issue a state-changing command.
4. Establish the selected Core/profile and target resource before proposing an operation. Do not assume command context from the working directory or a prior session.

## Configuration privacy

CLI configuration and its effective output may contain API credentials, database credentials, or other secrets. Never print, paste, log, or commit secret-bearing configuration output. Inspect only the minimum needed and redact values before sharing. Keep credentials out of command arguments, shell history, process listings, and examples where possible. Do not use a command that dumps full effective configuration into a transcript.

For v2.3.3, the CLI config documents `KOMODO_CLI_HOST` (or `KOMODO_HOST`), `KOMODO_CLI_KEY`, and `KOMODO_CLI_SECRET` as profile overrides. Supply credentials through a protected process environment or stdin-based secret injection, not command-line arguments, shell literals, or checked-in config. Avoid printing the environment or running `km config` with secrets present. Verify names and behavior against the installed version; see the [tagged config](https://github.com/moghtech/komodo/blob/v2.3.3/config/komodo.cli.toml).

## Consent boundaries

Help text and documentation describe capability, not authorization. Ask for explicit user consent before proposing or performing an operation that:

- Resets a user's password or grants/revokes Super Admin privileges.
- Restores or copies a database, or otherwise changes/removes stored state.
- Deploys, refreshes, syncs, or runs an execution that can change a service or resource.
- Opens a server, container, or process terminal, or runs arbitrary commands remotely.
- Changes variables, resource configuration, or other persistent settings.

Never reset a password. Do not treat a broad request for CLI help as consent for any of these actions. For an authorized operation, state the target, expected effect, and potential impact before action, then verify the result through a safe observable check.

## Sources

- [Komodo CLI documentation](https://komo.do/docs/ecosystem/cli)
