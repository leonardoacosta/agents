---
name: mcp-builder
description: >-
  Build, configure, and register MCP servers for Claude Code. Covers transport
  selection (stdio / Docker / mcp-remote), `mcp.json` config patterns, tool
  registration with `@modelcontextprotocol/sdk`, reliability anti-patterns, and
  when NOT to build MCP (use Bash or WebFetch instead). Use when: wiring up an
  authenticated external API called >5× per session, adding a new service to
  `claude mcp list`, implementing OAuth-gated tools, deciding between MCP vs
  Bash vs WebFetch, configuring `mcp.json`, or building a TypeScript MCP server.
license: Complete terms in LICENSE.txt
---

# MCP Builder — Claude Code Edition

## Decision Tree: MCP vs Alternatives

Before building an MCP server, pick the right tool:

```
Does the task require calling an external API?
├── No → Use Bash (local filesystem, CLI tools, one-off scripts)
└── Yes
    ├── Single call, public endpoint, no auth?
    │   └── Use WebFetch — no server needed
    ├── Multi-step operation with branching logic?
    │   └── Use Agent tool — spawn a sub-agent with Bash/WebFetch
    └── Auth required AND called >5× per session?
        └── Build MCP ✓
```

**MCP is warranted when:**
- External service needs persistent auth (OAuth token, API key injected per call)
- Same service called repeatedly across a session (e.g., GitHub, Sentry, Slack)
- The service has a large surface area worth exposing as named tools

**MCP is NOT warranted when:**
- One-off command (`gh issue list` via Bash beats a GitHub MCP for single queries)
- Local filesystem ops (Bash + Read/Write/Glob tools are faster)
- Public read-only APIs (WebFetch is zero overhead)
- Latency-sensitive operations (MCP round-trip adds ~50–200ms per call)

---

## Transport Types and Reliability Profiles

| Transport | Example | Reliability | Use When |
|-----------|---------|-------------|----------|
| **stdio** | Local process | Fast, no isolation | Dev tooling, read-only local services |
| **Docker + stdio** | `github` MCP | Best isolation, restart-safe | Any server with write access to external systems |
| **HTTP/SSE via mcp-remote** | `vercel`, `figma`, `posthog` | Good for OAuth flows | Services using browser-based OAuth |

**Rule of thumb:** If the MCP server can mutate external state (create issues, send messages, deploy), run it in Docker.

---

## Claude Code Config (`~/.claude/mcp.json`)

**MANDATORY**: Read [`references/config-patterns.md`](references/config-patterns.md) for the config pattern matching your transport (Docker, mcp-remote, or local process).

Quick summary of available patterns:
- **Docker** — write-access servers; provides isolation and restart safety
- **mcp-remote** — OAuth browser-auth services (Vercel, Figma, Slack)
- **Local process** — read-only dev tools you build yourself

Auth tokens always come from env vars via `${VAR}` syntax — never hardcode in `mcp.json`.

---

## Reliability Anti-Patterns

- **NEVER** expose latency-sensitive ops via MCP — use Bash instead. File reads, local git ops, and subprocess calls belong in Bash, not MCP.
- **NEVER** use always-on WebSocket connections — event-driven / request-response only.
- **NEVER** hardcode auth tokens in `mcp.json` — use env var injection.
- **NEVER** run a write-access MCP as a local process — use Docker for isolation and restart safety.
- **NEVER** create a new MCP server for a service that already has a well-maintained public one (GitHub, Sentry, Slack all have official servers).
- **AVOID** port conflicts with local process servers — always bind to an unused port or use stdio transport.

---

## Tool Surface Design

Before registering tools, ask:

- **Granularity**: One coarse tool (params as filters) or many fine tools? Fine tools improve routing accuracy. Rule: match granularity to how a human describes the operation in one sentence.
- **Description quality**: Claude uses tool descriptions — not names — for selection. Each description must answer: what state does this change? what does it return? when should I NOT use it?
- **Error surface**: Always include raw API status code and body in errors — MCP errors are opaque by default.

---

## Building a New TypeScript MCP Server

**MANDATORY**: Read [`references/ts-template.md`](references/ts-template.md) for the TypeScript template and package setup.

**Do NOT load** `references/ts-template.md` if you are only configuring an existing server.

After building, add the server to `~/.claude/mcp.json` using the appropriate pattern from
[`references/config-patterns.md`](references/config-patterns.md), then verify with `claude mcp list`.

---

## Build Checklist

- [ ] Auth via env var, never hardcoded
- [ ] Every tool has a clear, one-sentence description (Claude uses this for tool selection)
- [ ] Errors throw with actionable messages (include status code + response body)
- [ ] Docker wrapping if server has write access to external systems
- [ ] Added to `~/.claude/mcp.json` and verified with `claude mcp list`
- [ ] Test: invoke one tool from a Claude Code session to confirm end-to-end
