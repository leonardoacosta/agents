# Provenance and upstream capability index

Reviewed 2026-09-30. Repository: https://github.com/diegosouzapw/OmniRoute

Pinned source revision: `dbe703a0000b303cd7b1cf5879cb8740e5bfce71`. Its `package.json` reports **3.8.52**. Several documentation pages still report **3.8.50**. This skill favors route implementations and effective settings over blanket prose claims.

Build a pinned source URL with:

```text
https://github.com/diegosouzapw/OmniRoute/blob/dbe703a0000b303cd7b1cf5879cb8740e5bfce71/<path>
```

Fetch a specialized upstream skill only when the corresponding task needs it:

```text
https://raw.githubusercontent.com/diegosouzapw/OmniRoute/dbe703a0000b303cd7b1cf5879cb8740e5bfce71/skills/<family>/SKILL.md
```

| Need | Upstream family |
| --- | --- |
| Server lifecycle and management CLI connection | `cli-serve` |
| Provider/account connections | `omni-providers`, `cli-providers` |
| Models and multimodal inference | `omni-models`, `omni-inference` |
| Auth and scoped API keys | `omni-auth`, `omni-api-keys` |
| Combos and routing | `omni-combos-routing`, `cli-routing` |
| Coding-client configuration | `omni-cli-tools`, `config-codex-cli` |
| Circuit breakers, rate limits, queueing | `omni-resilience` |
| MCP and A2A | `omni-mcp`, `omni-agents-a2a`, `cli-mcp`, `cli-a2a` |
| Backups and settings | `omni-db-backups`, `omni-settings` |
| Budget, cache, compression, observability | `omni-budget`, `omni-cache`, `omni-compression`, `omni-usage-logs` |

Many upstream skills are generated. Read their custom sections and check implementation rather than copying every endpoint example. Upstream examples sometimes use `https://localhost` although default startup is plain HTTP. Use the instance's actual scheme.

## Evidence map

| Local knowledge | Authoritative upstream paths |
| --- | --- |
| Installation, runtime, persistent container data | `skills/cli-serve/SKILL.md`, `docs/getting-started/SELF_HOST_GUIDE.md`, `docs/guides/DOCKER_GUIDE.md`, `docker-compose.selfhost.yml`, `package.json` |
| Storage paths and database filename | `src/lib/dataPaths.ts`, `src/lib/db/core.ts:117-121` |
| Bootstrap management password | `src/lib/auth/managementPassword.ts`, `docs/reference/ENVIRONMENT.md`, `.env.example` |
| Health shape | `src/app/api/health/route.ts` |
| Auth split and effective flags | `docs/security/INFERENCE_AUTH_POSTURE.md`, `src/server/authz/policies/clientApi.ts`, `src/server/authz/policies/management.ts`, `src/shared/utils/featureFlags.ts` |
| Model discovery and synthetic combos | `src/app/api/v1/route.ts:12-19`, `src/app/api/v1/models/catalog.ts:349-359`, `src/app/api/v1/models/catalogRequest.ts:46-88` |
| API capability paths | `src/app/api/v1/**/route.ts`, `skills/omni-inference/SKILL.md` |
| Combo API shape and management guard | `src/app/api/combos/route.ts:18-51`, `skills/omni-combos-routing/SKILL.md` |
| Backup sensitivity and restore semantics | `docs/ops/BACKUP_RESTORE.md`, `skills/omni-db-backups/SKILL.md` |
| Codex protocol and long-running settings | `docs/guides/CODEX-CLI-CONFIGURATION.md`, `skills/config-codex-cli/SKILL.md` |
| MCP transports, scopes, and A2A | `docs/frameworks/MCP-SERVER.md`, `docs/frameworks/A2A-SERVER.md`, `src/server/authz/policies/management.ts`, `src/app/api/a2a/_auth.ts` |

## Known drift worth preserving

1. OpenAPI says all proxy endpoints require Bearer. Runtime inference depends on effective `REQUIRE_API_KEY`, so that generalization is unsafe.
2. Model-discovery auth and inference auth differ. Discovery rejection alone cannot establish inference protection.
3. MCP prose mentions a `manage` key. Current transport policy also accepts `mcp:connect` on its narrow carve-out.
4. Deployment prose describes XDG data paths, but `dataPaths.ts` uses legacy `~/.omniroute`, explicit `XDG_CONFIG_HOME`, or Windows AppData. A configured unwritable directory can fall back. Inspect actual storage.
5. Provider counts, free-model claims, quota totals, and compression savings are marketing/version snapshots, not operational guarantees.

## Validation boundary

Packaging validator, local reference links, upstream skill-family paths, API route-file existence, JSON scenario syntax, and skill discovery passed. A bounded Jev evidence check supported the auth split, narrow MCP scope, and source-versus-runtime distinction. Five regression prompts are stored in `../evals/evals.json`; they have not been run as model benchmarks. No live deployment, OAuth flow, billable inference, upgrade, or restore was exercised.

## Refresh procedure

Determine the installed version first. Resolve its upstream tag/commit, inspect changed route/schema/settings implementations, then update facts and the pinned revision together. Never silently move links to `main` while leaving old claims in place. Verify advertised CLI flags with that installed version's `--help` and record actual deployment checks separately from source inspection.
