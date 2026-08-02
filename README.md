# Agents Standard

A public, harness-neutral skill store for AI coding agents. The canonical materialization lives in
`skills/`; harness-specific paths project selected entries from that store without changing the
underlying guidance.

The portable package subset is sourced from
[`leonardoacosta/skills`](https://github.com/leonardoacosta/skills) and pinned in
`skill-projections.json` to an immutable commit. Additional third-party skills retain their source
metadata in `.skill-lock.json`.

## Layout

- `skills/` — canonical materialized skill directories
- `skill-projections.json` — source revision and per-harness projection policy
- `scripts/reconcile-skill-projections.sh` — guarded projection reconciler
- `scripts/verify-skill-projections.sh` — read-only projection health report
- `agents.md` — portable execution and workflow contract

## Verify

```bash
bash scripts/tests/public-release-boundary.test.sh
bash scripts/reconcile-skill-projections.sh --self-test
bash scripts/verify-skill-projections.sh
```

The public-release test rejects organization, project, machine, and personal configuration from
the portable skill tree. The reconciler requires matching verified and audited source revisions
before it writes any managed projection.
