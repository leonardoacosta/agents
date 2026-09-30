# Providers, routing, and agent transports

## Providers and accounts

Connect accounts through the dashboard or the installed provider CLI. Authentication can be OAuth, API key, or provider-specific web credentials. Verify current provider instructions before assuming an account is free, supported, or no-auth. Ask before interactive OAuth or credential import. Keep upstream account secrets separate from OmniRoute-issued client keys.

A provider can have multiple accounts. Quota, cooldown, and authentication failures can be account/model-specific. Inspect health and quota metadata before changing routing. Repeated manual retries can worsen throttling.

## Named combos and auto routing

A combo is a named routing configuration, not a provider model. Use its configured name as the request's `model`; obtain names from the runtime catalog or authenticated management API. `GET /api/combos` returns `{combos,total}` and supports `offset`/`limit`. Creation and edits require management auth.

`auto/*` entries are virtual combos synthesized by the model catalog. They can disappear when auto routing is disabled or `hideAutoCombos` is set. They resolve to a concrete provider, model, account, and credentials. Do not assume `auto/default` exists just because it appears in a README.

Upstream names strategies including priority, weighted and round-robin distribution, least-used, random, quota-aware, fill-first, cheapest, latency/cost aware, advanced, context-aware, and semantic routing. This list is orientation, not an allowed-values schema. Before writing a combo, read its installed schema or the pinned `omni-combos-routing` skill. Strategy names, supported fields, and defaults change between versions.

Keep these separate:

- Model selection: which provider/model can satisfy the task.
- Account selection: which connected credential and quota pool to use.
- Fallback: what happens after a classified failure.
- Session affinity: whether later turns remain on an account.
- Budgets/cache/compression: separate policies that can change costs or outputs.

Use the narrowest routing change that fixes the observed issue. Preserve context limits, tools/vision requirements, spend caps, and approved providers. Do not “fix” throttling by removing budget protections or adding paid fallback without approval.

## Resilience

Upstream exposes circuit-breaker, rate-limit, queue, fallback, and observability controls. Read-only status comes before resets. Resetting a circuit breaker or cooldown changes live traffic and may repeat failing requests. Validate the actual error class and affected account/model first.

Compression features such as RTK and Caveman can change prompt content and output style. Do not enable them silently for code, strict JSON, tool payloads, or workflows that require exact content. Marketing savings are not measured results for the user's workload.

## MCP

Supported transports are stdio, SSE, and streamable HTTP:

- Stdio runs as a client-owned subprocess, documented at `open-sse/mcp-server/server.ts`.
- HTTP transports run in-process with the dashboard server at `/api/mcp/sse` and `/api/mcp/stream`. The latter implements POST/GET/DELETE session lifecycle using `mcp-session-id`. The actual port follows the application deployment. A documentation example mentions `20130`, but it is not a universal dedicated MCP port. Do not assume a WebSocket MCP transport or port `20131`.

HTTP transports are off by default. Inspect effective `mcpEnabled` and `mcpTransport` settings, or `omniroute mcp status`. Enabling them changes access and requires approval. Transport restart resets active sessions, so it is not a read-only diagnostic.

Default access is local-only. Current management policy permits the narrow `mcp:connect` scope for the `/api/mcp/` transport carve-out, or broader `manage`/`admin` scopes. Older MCP docs describe only `manage`; do not grant broad management access if the installed version supports the narrower scope. This exception does not make every management endpoint remotely accessible.

Transport access is not blanket permission to run mutating tools. Inspect each tool's schema and permissions. Read-only inventory and health differ from provider creation, key management, routing edits, or state resets. Do not widen global agent grants to make a tool call work.

## A2A

OmniRoute also implements agent-to-agent task discovery/execution. Read `docs/frameworks/A2A-SERVER.md` and upstream `omni-agents-a2a` or `cli-a2a` before wiring a client. JSON-RPC and REST task routes can have different authentication checks. Do not infer all A2A auth from one prose paragraph or protocol endpoint.

Verify the advertised agent card, actual transport URL, skill input schema, and task lifecycle on the installed version. Task invocation can cause inference, tool execution, or spend. Listing a skill is not approval to invoke it.
