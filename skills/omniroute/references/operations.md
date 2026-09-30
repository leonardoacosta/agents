# Installation and operations

## Choose an installation

Upstream's CLI skill specifies Node.js ≥22.22.2 or ≥24. Verify current release requirements before installing. Inspect `omniroute --version`, `omniroute --help`, and `omniroute serve --help` first if already installed.

```bash
npm install -g omniroute@3.8.52
omniroute serve --port 20128 --no-open
```

`serve` supports daemon, recovery, tray, readiness timeout, and TLS flags. Use `serve --help` for the installed contract. `omniroute stop` and `restart` interrupt work, so confirm the service is yours and the interruption is acceptable. The server CLI is distinct from source development (`npm run dev`). Do not assume npm package internals match source paths.

Container image: `diegosouzapw/omniroute`. `latest` follows the highest published stable SemVer, not git main. Pin a published release or digest for reproducibility. Check registry availability rather than treating a source package version as proof an image tag exists.

The self-host compose manifest uses container port `20128`, `DATA_DIR=/app/data`, a named volume mounted there, and `NODE_ENV=production`. A host-local deployment should bind `127.0.0.1:20128:20128`. Change that only for an intentional network-access requirement. Existing private-network deployments keep their approved policy.

## Storage and secrets

- Explicit `DATA_DIR` is preferred. Source preserves an existing legacy `~/.omniroute` directory. Otherwise Windows uses `%APPDATA%/omniroute`, explicit `XDG_CONFIG_HOME` uses `${XDG_CONFIG_HOME}/omniroute`, and the fallback is `~/.omniroute`. Some deployment docs instead describe XDG data paths, so inspect the running instance rather than assuming them.
- An unwritable configured directory can fall back to the default user directory. Check startup logs and effective storage to avoid an apparently fresh, empty instance caused by volume permissions.
- Main database: `storage.sqlite`; managed snapshots: `db_backups/`. Preserve the existing store instead of creating a second empty one.
- Relevant variables: `JWT_SECRET`, `API_KEY_SECRET`, `STORAGE_ENCRYPTION_KEY`, `INITIAL_PASSWORD`, `AUTH_REQUIRED`, `REQUIRE_API_KEY`. They have different roles. Do not invent a single shared key.
- Use unique secrets supplied via an approved secret store. Never copy `CHANGEME` or documentation placeholders into deployment. `INITIAL_PASSWORD` bootstraps management auth, not inference auth. Existing persisted password state takes precedence over bootstrap input, so editing it is not a safe password-reset workflow.
- Feature flag overrides in the database take precedence over environment values. Inspect effective settings if an environment change appears ignored.

See `docs/reference/ENVIRONMENT.md`, `.env.example`, `docker-compose.selfhost.yml`, `src/lib/dataPaths.ts`, `src/lib/db/core.ts`, and `src/lib/auth/managementPassword.ts` at the research revision.

## Backup and upgrade

Prefer the application's managed snapshot workflow for a live database. SQLite WAL means copying only a live `storage.sqlite` can omit recent writes. If backing up the whole data directory offline, stop the service through its existing deployment manager and preserve ownership and file permissions.

`GET /api/db/backups` lists managed snapshots. `POST /api/db/backups` creates one and requires management auth. Inspect installed CLI `backup --help` rather than guessing its syntax. These paths are management operations, not inference endpoints.

Before upgrading: record deployed version/image digest, snapshot data, securely preserve secrets, and keep a rollback artifact. Preserve `DATA_DIR` and encryption material when moving hosts. A JSON export is not automatically a complete portable backup of encrypted credentials. Upstream backup docs themselves warn that exports can contain secrets and restoring replaces live state.

Restore only after explicit approval. Verify dashboard access, provider connections, model catalog, and one approved inference request afterward. Do not claim an upgrade works based only on container health.

## Diagnose in order

1. Reachability: root URL, container port mapping, DNS/reverse proxy, `/api/health`, startup logs.
2. Persistence: writable effective `DATA_DIR`, mounted volume, ownership, native SQLite startup errors.
3. Authentication: distinguish discovery, inference, and management gates in [API reference](api-and-clients.md).
4. Provider/model: connected account, runtime ID, OAuth expiry, quota/rate limit, cooldown state.
5. Streaming: reverse-proxy buffering and timeouts, gateway idle timeout, client transport compatibility.

Do not resolve these by deleting the database, resetting a password, adding a public tunnel, or disabling authentication. Capture redacted error/status, version, endpoint, and request shape instead.
