# Personal agent skills and configuration

This repository retains Personal agent prompts, configuration, research, and migration records.
Reusable Personal skills belong in [`leonardoacosta/skills`](https://github.com/leonardoacosta/skills),
which is the canonical authoring source. This repository's copies and tracked harness links are
migration inputs only; reconciliation is pending provenance capture and canonical import. Jcode
prompt copies are snapshots, not automatically synced.

Brown skills remain private Brown-owned content; speech skill `explain-tts` belongs to Herald. They
must be preserved separately from Personal reusable skills. This repository has no custom installer:
consumers own installation and harness wiring. No active harness rewiring or remote publication is
part of this migration.

## Layout

- `prompts/jcode/` — system/swarm snapshots and standalone PR review/response prompt
- `docs/pr-comment-writing-research.md` — evaluated sources and mined writing guidance
- `docs/selective-salvage.md` — retention decisions and verification limits
- `skills/` — retained migration inputs; Personal canonical skills live in `leonardoacosta/skills`
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
the portable skill tree. Projection scripts remain temporarily for migration verification; remove
them only after canonical preservation and consumer mapping are verified.

## First-party web skills

- `agent-browser` loads the installed CLI's version-matched core. Load
  `agent-browser-policy` with it for local consent, identity, and session ownership rules.
- All 33 official Firecrawl skills are installed from the reviewed `firecrawl/skills`
  catalog: 12 core, 5 build, and 16 workflow skills. Load `firecrawl-policy` alongside
  any of them, including direct specialized-skill invocation. It preserves our learned
  operational rules without replacing upstream command guidance.
- `agents.md` declares this composition contract. Consumers must load that contract
  as well as discover the skill directories. A skill description alone does not enforce
  supplement loading in a harness that ignores the contract.
- `skill-sources.json` records the reviewed upstream revision, exact file digests,
  license location, and reproducible install command. The current skills installer writes
  its global lock under `${XDG_STATE_HOME:-$HOME/.local/state}/skills/`; the older root
  `.skill-lock.json` is historical on those installations. Never edit either lock manually.

Before a Firecrawl refresh, preserve changes to the policy skill, inspect the complete
official catalog, and use the pinned installer command with a newly reviewed revision.
Do not edit vendor files or run `setup defaults`, authentication, or MCP setup as part of
skill installation. Update source digests from the reviewed source, not from arbitrary
installed files, and append per-skill journal events. Review the installed CLI help for
version differences before invoking new commands. Keep browser profile identities in
private machine configuration outside this portable store.

Focused offline checks:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 scripts/tests/first-party-skills.test.py
PYTHONDONTWRITEBYTECODE=1 python3 scripts/tests/agent-browser-contract.test.py
PYTHONDONTWRITEBYTECODE=1 python3 scripts/tests/firecrawl-policy-contract.test.py
bash scripts/verify-skill-projections.sh
```

These checks verify composition, preserved guidance, upstream integrity, and projection
state. They do not establish live authenticated task success or comparative model-eval
scores. The existing repository-wide public-release boundary check can still fail for
unrelated private content elsewhere in the working tree.

The official build/workflow skills use upstream `inputs` and `references` frontmatter
extensions. Our strict authored-skill validator rejects those keys. Preserve upstream
bytes and validate vendor YAML, required metadata, and digests with the first-party
check instead. Native Jcode discovery loaded all 33 official skills after installation.
Do not weaken the authored-skill validator to accommodate vendor extensions.

The digest test detects drift from the reviewed manifest. It is not independent proof
of provenance if someone changes both the files and manifest. Refresh review must compare
against a separate checkout at the recorded immutable revision and the active installer
lock, as performed for this intake. Projection health claims apply only to the affected
web skills, not unrelated broken or locally owned entries in other suites.
