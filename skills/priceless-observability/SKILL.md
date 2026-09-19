---
name: priceless-observability
description: >
  Priceless fleet observability naming and query canon for Grafana, Loki, OpenReplay,
  OTel, Vercel log drains, telemetry event names, service.name labels, and project slugs.
  Use this whenever adding or reviewing telemetry, writing Grafana/Loki queries, wiring
  OpenReplay, naming observability events, migrating from Sentry/PostHog/Better Stack,
  or debugging cross-project observability for otaku-odyssey, tribal-cities, civalent,
  modern-visa, tavern-ledger, las-vegas, or sibling Priceless projects.
user-invocable: true
allowed-tools: Read, Glob, Grep, Bash
---

# Priceless Observability

This is a thin operational wrapper. The source of truth is the bundled reference.

## Always read first

Read `references/naming-canon.md` before you do any of these:

- Add or rename a Grafana, Loki, OpenReplay, OTel, or Vercel-drain label.
- Add a server or client telemetry event.
- Write a LogQL query for a Priceless project.
- Wire or review OpenReplay instrumentation for `NEXT_PUBLIC_OPENREPLAY_PROJECT_KEY`, `NEXT_PUBLIC_OPENREPLAY_INGEST_POINT`, or Expo equivalents.
- Add `service.name`, `service_name`, `project`, `job`, or `environment` labels.
- Migrate telemetry away from Sentry, PostHog, Better Stack, Logtail, or vendor analytics.

## Working rules

1. Prefer the canon over local precedent when adding new names. Local drift is evidence, not permission to continue drift.
2. Do not mass-rename existing events without a migration plan. Bridge old names in queries and dashboards first.
3. Queries should assert metadata and counts. Do not print raw Loki log bodies or secret-bearing payloads.
4. Keep vendor credentials out of application contracts. In dotenvx-enabled CI, deployment systems should broker only the environment private key.
5. When unsure whether a string is a product name, project slug, service name, event name, or label value, classify it using the reference before writing code.

## Quick decision checklist

- **Project label:** use repo slug, kebab-case, e.g. `otaku-odyssey`, `tribal-cities`, `civalent`.
- **Service name:** use `<short-project>-<component>`, e.g. `oo-api`, `tc-api`, `ct-web`.
- **Environment:** use `development`, `test`, `preview`, or `production`.
- **Server event:** use dot-delimited `<domain>.<entity?>.<outcome|action>`.
- **Client/OpenReplay event:** use the same dot-delimited taxonomy as server events.
- **OpenReplay dashboards:** keep `Product Analytics`, `Monitors`, and `Web Analytics` as dashboard lenses under the same project slug, not separate project identities.
- **OpenReplay replay fidelity:** if a replay looks unstyled, diagnose CSS/font/icon capture before trusting visual evidence.
- **Legacy names:** query them only for backward compatibility, then create a tracked cleanup task.
