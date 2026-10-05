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
- Focused checks after first batch passed: `git diff --check`, boundary-test shell syntax, and both projection script self-tests. This is not a full clean-export or release verdict. Second batch awaits the same focused checks.

No existing executable machinery or skill was removed in this pass. Safe simplification is limited
 to branding and explicit repository scope. Any future deletion requires consumer evidence, not an assumption of disuse.

## Local consumer observations

Recursive symlink inspection found:

- `~/.agents/skills`: 11 links to `~/dev/personal/skills`, two to other locations, zero resolved into `~/dev/personal/agents`.
- `~/.claude/skills`: three links to other locations, zero resolved into the agents checkout.
- `~/.jcode/skills` and `~/.config/opencode`: no symlinks found at the inspected paths.

These counts describe symlinks only, not actual skill usage or regular-file provenance. They do not establish that the skill store is unused.

The manifest-based read-only projection verifier also inspects configured harness roots, including `~/.config/agents/skills`. It reports pre-existing `protected-conflict` entries such as unrecorded local projections. Resolving those conflicts would require a separate ownership/rewiring decision. No reconciliation write was run.

## Validation and limits

The public-release-boundary test fails on pre-existing skill content, including organization/project-specific references. The initial combined command obscured its failure; the explicit final run confirmed it. Reconciler self-test passes. Projection health is not clean: six harnesses report protected conflicts, one is not installed, and three have missing entries. These are baseline limitations, not regressions from the imported artifacts. Do not treat this branch as a public-release-ready cleanup. Resolving existing private/workspace-specific skill content requires a separate scope and ownership decision before publication.

The public-release-boundary check covers the portable skill tree, not all personal prompt snapshots. The new artifacts were inspected for credential content; they contain workspace routing and local path references intentionally retained from approved artifacts. No private Brown project content was imported.

Graph context was attempted, but the available graft index resolved to unrelated ancestor files rather than this repository. Repository inspection therefore used direct reads and searches.

Further work, not silently authorized by this salvage: per-skill content/provenance comparison against `leonardoacosta/skills`, manifest schema consolidation, installed harness repair, removal of uncertain machinery, automatic prompt sync, remote publication, or merging into main.
