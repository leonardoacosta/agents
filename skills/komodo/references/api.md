# Komodo API: read, configure, and execute

Use this reference when integrating an application or script with Komodo Core through its HTTP API or a typed client. Core exposes an RPC-like HTTP API for reading data, writing configuration, and executing actions. Rust and TypeScript clients are documented. This is a descriptive reference, not a locally verified integration guide; consult current API documentation and generated client types for exact method names, parameters, authentication, and response schemas.

## Select an interaction class

- Use **read** operations to inspect state and identify target resources before proposing changes.
- Use **write** operations to change resource configuration. Review the target and intended diff before submitting.
- Use **execute** operations to cause work such as deployments. These may affect live services, so obtain explicit authorization before calling them.

The API documentation illustrates a Rust client initialized with a Core URL and API key/secret, followed by a `read(ListStacks)` call and an `execute(DeployStack)` call. Its TypeScript example constructs `KomodoClient` with API-key authentication, calls `read("ListStacks", {})`, and calls `execute("DeployStack", ...)`. These are orientation examples only; do not treat their placeholder credentials, first-result selection, or deployment operation as safe defaults.

## Integration boundaries

Keep API credentials in a secret manager or another approved secret store. Do not hard-code keys or secrets, print them, or expose them in client errors, traces, configuration dumps, or committed fixtures. Use least-privilege credentials where supported and scope the Core endpoint explicitly. Verify transport security and the target environment before connecting.

Prefer read-before-write workflows. Identify the intended resource by a stable, unambiguous identifier rather than taking the first item returned. Validate arguments using the installed client/API schema. Treat writes and executions as separate actions, and do not automatically execute a deployment merely because a read or diff succeeded.

## Sources

- [Komodo API documentation](https://komo.do/docs/ecosystem/api)
- [Full Rust API reference](https://docs.rs/komodo_client/latest/komodo_client/api/index.html)
- [Rust client crate](https://crates.io/crates/komodo_client)
- [TypeScript client package](https://www.npmjs.com/package/komodo_client)
