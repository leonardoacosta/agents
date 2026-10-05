# Selective salvage

Audit date: 2026-10-05. Base: `75314d9491bf0e05d53cf7b5ed2cc659647d4e53`.

This branch retains the existing repository history. It imports only four prompt/research files from the unrelated local Turborepo. No unrelated-history merge, app scaffolding import, installed-skill rewiring, or remote branch deletion was performed. The decisions below are the initial salvage audit; the current canonical skills migration supersedes rows marked pending.

## Decisions

| Area | Decision | Evidence / reason |
| --- | --- | --- |
| Jcode prompt snapshots and PR guidance | Keep | Four files compared byte-for-byte against the approved local artifacts. No automatic synchronization. |
| Existing skill content, licenses, attribution | Migration in progress | Preserve all divergent variants and wait for canonical worker's source provenance and import commits before removing copied source packages. |
| Projection reconciler and verifier | Temporarily retain | Remove only after canonical preservation and consumer mapping are verified; current migration does not rewire active harnesses. |
| Source and lock manifests | Preserve pending migration | Installer-owned files stay intact until canonical provenance is captured. Preserve exact mixed consumer-state snapshots outside the repository before untracking; installer regenerates rather than hand-editing locks. |
| Harness projections and portable agent contract | Defer removal | Remove stale tracked materializations only after canonical targets and consumers are verified; no live harness rewiring. |
| Framework-style branding | Replace | The repository stores skills/configuration, not an application framework. |
| Orca/Durable Turborepo apps | Exclude | Separate purpose and unrelated history; original checkout remains intact. |

## Canonical preservation ledger

- Canonical commit `d5a8fb7e332ebd5b9591224def0084c46784a5c9` preserves these ten packages before source reduction: `skills/adversarial/`, `skills/agent-architecture/`, `skills/agent-browser-policy/`, `skills/agent-instruction-pairing/`, `skills/agent-tooling/`, `skills/agentmail/`, `skills/animation-vocabulary/`, `skills/breakdown-epic-arch/`, `skills/bun/`, and `skills/change-disposition/`. The corresponding ten directories were then removed here.
- Canonical commit `665241df2be5d3d104d3ea591526dc03b58a848f` preserves `skills/agent-browser/`, `skills/agents-sdk/`, `skills/algorithmic-art/`, `skills/ascii-wireframe/`, `skills/aws-step-functions/`, `skills/better-accessibility/`, `skills/better-colors/`, `skills/better-interface/`, `skills/better-layout/`, and `skills/better-typography/`. The corresponding ten directories were then removed here.
- Canonical commit `248370ee26308564ee2b905bad82149aa4de1ca7` preserves `skills/better-ui/`, `skills/better-writing/`, `skills/bicep-best-practices/`, `skills/brainstorming/`, `skills/c4-architecture/`, `skills/clean-architecture/`, `skills/close/`, `skills/cloudflare-email-service/`, `skills/cloudflare-one/`, and `skills/cloudflare-one-migrations/`. The corresponding ten directories were then removed here. Focused checks passed: `git diff --check`, boundary-test shell syntax, and both projection self-tests.

- Canonical commit `a4fc769bee6237308faead9994d6ffdf6759eab8` preserves `skills/cloudflare/`, `skills/codebase-design/`, `skills/crafting-effective-readmes/`, `skills/data-viz-reel/`, `skills/database-schema-designer/`, `skills/datadog-cli/`, `skills/deploy-to-vercel/`, `skills/depot-github-actions/`, `skills/design-control-loop/`, and `skills/design-system-starter/`. The corresponding ten dirs were removed here after SHA/path verification. Focused checks passed: diff check, boundary-test syntax, and both projection self-tests.
- Canonical commit `a657d5d42c46f6ffe047ebffda9550476ec235e5` preserves `skills/documentation-writer/`, `skills/domain-modeling/`, `skills/dotenvx-secrets/`, `skills/dotnet/`, `skills/drizzle/`, `skills/drizzle-best-practices/`, `skills/durable-objects/`, `skills/effect/`, `skills/env-and-secrets/`, and `skills/eslint-audit/`. The corresponding ten dirs were removed here after SHA/path verification. Focused checks passed: diff check, boundary-test syntax, and both projection self-tests.

- Canonical commit `5bad21d3493f4582c0d31730b16cfbfb71fecab8` preserves `skills/evaluation-domains/`, `skills/extend-before-create/`, `skills/fallow/`, `skills/firecrawl-agent/`, `skills/firecrawl-build/`, `skills/firecrawl-build-interact/`, `skills/firecrawl-build-onboarding/`, `skills/firecrawl-build-scrape/`, `skills/firecrawl-build-search/`, and `skills/firecrawl-crawl/`. The corresponding ten dirs were removed here after SHA/path verification. Focused checks passed: diff check, boundary-test syntax, and both projection self-tests.

- Canonical commit `cb912f51b0a7221b542b99e3a6ee63bbdb446145` preserves `skills/firecrawl-developer-index/`, `skills/firecrawl-download/`, `skills/firecrawl-interact/`, `skills/firecrawl-map/`, `skills/firecrawl-monitor/`, `skills/firecrawl-parse/`, `skills/firecrawl-policy/`, `skills/firecrawl-research-index/`, `skills/firecrawl-scrape/`, and `skills/firecrawl-search/`. The corresponding ten dirs were removed here after SHA/path verification. Focused checks passed: diff check, boundary-test syntax, and both projection self-tests.

- Canonical commit `8030e5a330710ec4abb7c66281bd6f8b709d5a93` preserves the skill content for `skills/framer/`, `skills/framer-code-components/`, `skills/frontend-api-contracts/`, `skills/gates/`, `skills/geist-design/`, `skills/gk-personal/`, `skills/godot-state-machine-advanced/`, `skills/graft/`, `skills/herdr/`, and `skills/interface-review/`. Canonical cleanup commit `7b20262ad36ca159ba18fe29a98f4fb711bea4f5` removes `skills/gk-personal/references/context.local.md` as local employer/workspace data; it is retained locally and archived at `$JCODE_SCRATCH_DIR/salvage-preserved/context.local.md` (SHA-256 `354b2fb3449a6ca95e57c2bfe411a9bcfacfbc6787e44331f103490abff54d98`). The other nine dirs and only the tracked `gk-personal` files were removed here after verifying these commits. Focused checks passed.

- `~/.claude/skills`: three links to other locations, zero resolved into the agents checkout.
- `~/.jcode/skills` and `~/.config/opencode`: no symlinks found at the inspected paths.

These counts describe symlinks only, not actual skill usage or regular-file provenance. They do not establish that the skill store is unused.

The manifest-based read-only projection verifier also inspects configured harness roots, including `~/.config/agents/skills`. It reports pre-existing `protected-conflict` entries such as unrecorded local projections. Resolving those conflicts would require a separate ownership/rewiring decision. No reconciliation write was run.

## Validation and limits

The public-release-boundary test fails on pre-existing skill content, including organization/project-specific references. The initial combined command obscured its failure; the explicit final run confirmed it. Reconciler self-test passes. Projection health is not clean: six harnesses report protected conflicts, one is not installed, and three have missing entries. These are baseline limitations, not regressions from the imported artifacts. Do not treat this branch as a public-release-ready cleanup. Resolving existing private/workspace-specific skill content requires a separate scope and ownership decision before publication.

The public-release-boundary check covers the portable skill tree, not all personal prompt snapshots. The new artifacts were inspected for credential content; they contain workspace routing and local path references intentionally retained from approved artifacts. No private Brown project content was imported.

Graph context was attempted, but the available graft index resolved to unrelated ancestor files rather than this repository. Repository inspection therefore used direct reads and searches.

Further work, not silently authorized by this salvage: per-skill content/provenance comparison against `leonardoacosta/skills`, manifest schema consolidation, installed harness repair, removal of uncertain machinery, automatic prompt sync, remote publication, or merging into main.
