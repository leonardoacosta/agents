# Selective salvage

Audit date: 2026-10-05. Base: `75314d9491bf0e05d53cf7b5ed2cc659647d4e53`.

This branch retains the existing repository history. It imports only four prompt/research files from the unrelated local Turborepo. No unrelated-history merge, app scaffolding import, installed-skill rewiring, or remote branch deletion was performed.

## Decisions

| Area | Decision | Evidence / reason |
| --- | --- | --- |
| Jcode prompt snapshots and PR guidance | Keep | Four files compared byte-for-byte against the approved local artifacts. No automatic synchronization. |
| Existing skill content, licenses, attribution | Keep pending deeper per-skill triage | 250 top-level SKILL.md entries. Lack of a direct checkout link does not establish disuse: installed materializations can be regular files. |
| Projection reconciler and verifier | Keep | Reconciler self-test passes; verifier detects protected local conflicts rather than overwriting them. |
| Source and lock manifests | Defer consolidation | Scripts/tests reference projection and lock metadata. Filenames alone do not prove duplication; preserve provenance until consumers and schema equivalence are established. |
| Harness projections and portable agent contract | Defer removal | Existing composition and projection contracts may have consumers. Current projections are not healthy enough to justify automatic replacement or deletion. |
| Framework-style branding | Replace | The repository stores skills/configuration, not an application framework. |
| Orca/Durable Turborepo apps | Exclude | Separate purpose and unrelated history; original checkout remains intact. |

No existing executable machinery or skill was removed in this pass. Safe simplification is limited to branding and explicit repository scope. Any future deletion requires consumer evidence, not an assumption of disuse.

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
