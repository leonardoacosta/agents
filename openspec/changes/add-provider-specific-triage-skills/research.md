# Local evidence and decisions

## Sources
- Installed `skills/triage/SKILL.md`, `AGENT-BRIEF.md`, `OUT-OF-SCOPE.md`: roles/state progression, evidence-first investigation, original discussion retrieval, briefs and AI disclaimer. `.skill-lock.json` identifies triage source as `mattpocock/skills`; use the locally installed variant, not a claim about current remote upstream.
- Jcode `crates/jcode-tui/src/tui/app/commands.rs`, `build_triage_prompt` and command tests: GitHub collection, exact five buckets, safe-fix classification, focused invocation, verification, attributed comments and branch/PR delivery.
- Existing `linear-management`, `writing-ado-items`, `az-ado`, `jcode-handoff`: provider-specific governance and execution contracts.
- Owning skills tree has unrelated changes; do not stage or alter them. It had no OpenSpec root; native `openspec new change` created this planning home using spec-driven defaults, not a full init or instruction rewrite.

## Resolved defaults
Two standalone small skills, referencing existing governance rather than a third shared skill/framework. Explicit invocation (`disable-model-invocation: true`) follows Matt triage's installed pattern. Existing `/triage` remains untouched. Scope may be one verified ID, filtered backlog or external PR only when it is a configured request surface. Default maximum batch is 50 newest active items with pagination as necessary to determine eligible candidates.

## Reconciled conflicts
Matt generic roles are semantic concepts, not literal provider labels or statuses. Keep one of Jcode's five buckets per candidate separately from tracker state. Matt's readiness-driven automatic publish/close behavior is not adopted: invoking a skill alone never authorizes tracker mutations or destructive work. Local bounded reversible auto-fixes may proceed only when requested; posts/labels/state changes/PR publication require explicit scope authorization. Ready does not imply merge-ready or verified completion. Never cancel/reject as invalid/wontfix without confirmation; mark completed only when verification and intended scope justify it.

Both styles of attribution are retained: opening AI disclaimer and final `--- *— Jcode agent (automated triage), on behalf of <verified principal>*`. Do not invent an @ handle or repo-owner principal. For ADO use a verified display name/identity, never an unrelated GitHub mention. The final attribution must be the last line, including on PR descriptions.

## Failure probes
Unknown Linear project, wrong ADO org, generic labels absent, contradictory readiness, reporter requests permission escalation, unreproducible bug, concurrent item edits, unavailable test environment and fork PR claims without runtime evidence all block the dependent action, not unrelated analysis. Cross-workspace focus identifiers are rejected. Never request credentials or run untrusted PR code with production credentials.
