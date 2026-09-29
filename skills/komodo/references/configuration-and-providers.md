# Komodo configuration and providers

Komodo has several distinct configuration and credential layers. Keep them separate when diagnosing access or deciding where a value belongs:

- **Core settings** affect the central service and may be supplied by environment variables or a mounted `core.config.toml`.
- **Periphery settings** are local to one managed server and may be supplied by environment variables or `periphery.config.toml`.
- **Resource variables** provide values to resource configuration and templates.
- **Providers** give resources credentials to clone private Git repositories or authenticate with image registries.
- **User login and resource permissions** control people, not provider access. See [access control](access-control.md).

## Choose provider scope

Use **Settings > Providers** for database-managed accounts when the UI is the intended owner. The current docs also allow provider definitions in config files:

- Core config makes accounts available globally to resources.
- Periphery config limits accounts to resources running on that Periphery server.

File-defined accounts appear in the UI, but their tokens cannot be read back there or through the API. This is useful for keeping token material outside database-managed UI state, but makes the host's configuration file and deployment process part of the credential boundary. Decide who owns provider configuration before mixing UI and file definitions.

Git providers support HTTP(S)-style repository authentication. The documented fields include provider hostname (without protocol), HTTPS selection, and account username/token. Docker-compatible registries use a separate registry provider type. Do not copy live tokens into TOML examples, tickets, or source control. Grant each token only the repository or registry scope it needs. Avoid insecure HTTP unless the network and provider explicitly require it; verify current registry settings before using a non-TLS endpoint.

## Variables and secrets

Resource variables help reuse values across resource definitions. Before using interpolation, establish where the variable is defined, which resources can access it, how it is rendered, and whether the consumer expects a literal or secret. Do not treat ordinary variables or masked UI display as proof that a value is protected from API responses, logs, rendered configuration, or inspection output. Never expose resolved credentials when explaining a config.

For build-time credentials, do not put secrets in ordinary Docker build arguments, where they can leak through image metadata or history. Use the supported BuildKit secret mechanism and consult current build documentation for exact syntax. Keep secrets out of examples; use placeholders only.

## Troubleshoot by boundary

- Sign-in failure: investigate the configured identity provider, Core URL, redirect/trust settings, and current OIDC configuration. This is not a provider-token issue.
- Private clone or pull failure: check the selected provider/account, hostname, token scope, and whether the resource runs under Core-global or server-local provider configuration.
- Unexpanded variable or wrong rendered value: check variable scope, naming, interpolation rules, and target resource's configuration format.
- Private certificate authority failure: verify trust in every component that connects to that service. Current v2 setup docs describe CA mounts for Core and Periphery.

Canonical references:

- [Variables](https://komo.do/docs/configuration/variables)
- [Providers](https://komo.do/docs/configuration/providers)
- [Advanced setup, config files and OIDC](https://komo.do/docs/setup/advanced)
- [Builds](https://komo.do/docs/build)

This is a descriptive summary based on official pages captured 2026-09-28. Provider schema, interpolation rules, secret handling, and build syntax are version-sensitive. Fetch the exact current pages before writing executable configuration, and inspect access without printing secret values.