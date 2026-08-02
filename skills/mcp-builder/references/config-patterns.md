# mcp.json Config Patterns

Configuration lives at `~/.claude/mcp.json`. Claude Code reads it at startup and registers each
entry as an available MCP server.

## Pattern 1: Docker Container (write-access servers)

Use when the server can mutate external state (create issues, send messages, deploy). Docker
provides isolation and restart safety.

```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "GITHUB_PERSONAL_ACCESS_TOKEN",
        "ghcr.io/github/github-mcp-server"
      ],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Key points:**
- `-i` keeps stdin open (required for stdio transport inside Docker)
- `--rm` removes container on exit (no orphaned containers)
- `-e KEY` forwards the env var into the container environment
- `env` block in `mcp.json` injects the value from Claude Code's shell env at startup

## Pattern 2: mcp-remote / OAuth (browser-auth services)

Use when the service uses browser-based OAuth (Vercel, Figma, PostHog, Slack). `mcp-remote`
handles the OAuth handshake and proxies calls to the remote SSE endpoint.

```json
{
  "mcpServers": {
    "vercel": {
      "command": "npx",
      "args": ["mcp-remote", "https://mcp.vercel.com/sse"]
    }
  }
}
```

**Key points:**
- No `env` block needed — OAuth token stored by `mcp-remote` after browser login
- First run opens a browser window for OAuth; subsequent runs use the cached token
- The `sse` suffix in the URL is the transport endpoint — do not omit it
- Works for any service that exposes an SSE MCP endpoint

## Pattern 3: Local Process (read-only / dev tools)

Use for servers you build locally that only read data. Faster than Docker; no isolation overhead.

```json
{
  "mcpServers": {
    "my-service": {
      "command": "node",
      "args": ["/home/user/.claude/mcp-servers/my-service/dist/index.js"],
      "env": {
        "MY_SERVICE_API_KEY": "${MY_SERVICE_API_KEY}"
      }
    }
  }
}
```

**Key points:**
- Use absolute path to `dist/index.js` — relative paths break when Claude Code is opened from
  a different working directory
- Auth token is injected via `env` block using `${VAR}` syntax (see below)
- Build the TypeScript server before adding to `mcp.json` — `node` runs the compiled output

## The `${VAR}` Env Injection Syntax

`${VAR}` in an `env` block value reads `VAR` from the shell environment where Claude Code was
launched (e.g., from your `~/.zshrc` exports or a `.env.local` sourced in your shell profile).

```json
"env": {
  "MY_SERVICE_API_KEY": "${MY_SERVICE_API_KEY}"
}
```

This does NOT read from Doppler or any secrets manager — it reads the raw shell env at Claude Code
startup. For Doppler-managed secrets, export them in your shell profile first, or launch Claude
Code with `doppler run -- claude`.

## Common mcp.json Mistakes

| Mistake | Effect | Fix |
|---------|--------|-----|
| Hardcoded token in `env` value | Secret in plaintext config file | Use `${VAR}` syntax |
| Relative path in `args` | Server fails when CWD differs | Use absolute path |
| Missing `-i` in Docker args | stdin closed, server hangs on first call | Add `-i` to `docker run` args |
| No `--rm` in Docker args | Orphaned containers accumulate | Add `--rm` |
| Wrong server key name | Tools appear under unexpected name in Claude | Match key to server's `name` field in code |
| Forgetting to rebuild after code change | Claude sees stale compiled output | `npm run build` before restarting Claude Code |
| Using HTTP port for stdio server | Port conflict or no-op | stdio servers do not bind ports — remove any port config |
