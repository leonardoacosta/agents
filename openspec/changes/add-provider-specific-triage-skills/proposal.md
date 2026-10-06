## Why
The installed Matt-style triage method supplies evidence-driven state handling and durable briefs, while Jcode's built-in command supplies safe autonomous fixes but assumes GitHub Issues. Personal/Priceless work uses Linear and Brown work uses Azure DevOps, so explicit provider skills should combine the useful parts without cross-linking workspaces or treating readiness as publication authorization.

## What Changes
- Add `/triage-linear` and `/triage-ado` as explicit-invocation skills in the existing skills repository.
- Combine Matt's prior-decision retrieval, reproduce/categorise/verify/grill process, duplicate/out-of-scope evidence and agent briefs with Jcode's five disposition buckets, bounded safe-fix loop, todo tracking and compact report.
- Delegate provider policy to `linear-management` or `writing-ado-items` plus `az-ado`; use `jcode-handoff` for implementation briefs.
- Preserve attribution and consent gates; use only verified existing provider types/states/labels, not Matt's generic role names as invented labels.
- Keep existing `/triage` and the Jcode built-in command unchanged. No tracker mutations occur during skill creation.

## Capabilities
### New Capabilities
- `provider-specific-triage`: provider-safe evidence-driven triage and optionally authorized safe implementation.
### Modified Capabilities
None.

## Impact
Owning repo: `/home/nyaptor/.agents`. Future surfaces: `skills/triage-linear/SKILL.md`, `skills/triage-ado/SKILL.md`, and focused evaluation fixtures. Reuse existing governance/brief skills; avoid copying or editing the upstream `skills/triage` and its provenance lock entry. No Tribal Cities code, Jcode Rust command changes, new service, dependency or publication.
