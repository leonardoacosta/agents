# TypeScript MCP Server Template

## Minimal Viable Server (stdio transport)

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

// 1. Create server with name + version (appears in `claude mcp list`)
const server = new McpServer({
  name: "my-service",
  version: "1.0.0",
});

// 2. Register tools — Claude selects tools by description, not name
server.tool(
  "get_item",                                          // tool name (snake_case)
  "Fetch a single item by ID from My Service.",        // description: what it returns + when to use
  { id: z.string().describe("The item ID to fetch") }, // input schema via zod
  async ({ id }) => {
    // 3. Read auth from env — NEVER hardcode
    const apiKey = process.env.MY_SERVICE_API_KEY;
    if (!apiKey) throw new Error("MY_SERVICE_API_KEY env var not set");

    const res = await fetch(`https://api.myservice.com/items/${id}`, {
      headers: { Authorization: `Bearer ${apiKey}` },
    });

    // 4. Include raw status + body in errors — MCP errors are opaque by default
    if (!res.ok) {
      throw new Error(`API error ${res.status}: ${await res.text()}`);
    }

    const data = await res.json();
    // 5. Return content array — always type: "text" for JSON payloads
    return { content: [{ type: "text", text: JSON.stringify(data, null, 2) }] };
  }
);

// 6. Wire transport last — must await server.connect()
const transport = new StdioServerTransport();
await server.connect(transport);
```

## `package.json` Minimum Config

```json
{
  "type": "module",
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js"
  },
  "dependencies": {
    "@modelcontextprotocol/sdk": "^1.0.0",
    "zod": "^3.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0"
  }
}
```

`"type": "module"` is required — the SDK uses ESM imports.

## Build and Test Commands

```bash
# Build TypeScript to dist/
npm run build

# Verify server starts without error (stdio servers exit cleanly on no input)
node dist/index.js

# Inspect tools interactively before wiring into Claude Code
npx @modelcontextprotocol/inspector --server-command "node dist/index.js"

# Confirm Claude Code sees the registered server
claude mcp list
```

## Section Annotations

| Section | Why It Matters |
|---------|---------------|
| `McpServer({ name, version })` | Name shown in `claude mcp list`; version for debugging |
| Tool description string | Claude routes calls based on description text, not tool name — write it as "what this returns and when to call it" |
| Zod input schema | Validated before handler runs; `.describe()` text appears in tool signature |
| `process.env` auth read | Auth tokens come from `mcp.json` env injection at Claude Code startup |
| `throw new Error(...)` with status | MCP wraps errors opaquely — include the raw HTTP status + body so callers can diagnose |
| `StdioServerTransport` | stdio is the correct transport for local process servers; HTTP/SSE is for remote via mcp-remote |
| `await server.connect(transport)` | Must be the last call — registers the transport and enters the request loop |
