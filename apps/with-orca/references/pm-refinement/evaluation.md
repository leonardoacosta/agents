# Evaluation: original PM refinement automation prompt

## Summary

- **Verdict:** it asks a single agent to act as controller, PM, planning author and publisher, then constrains it so heavily that routine board maintenance disappears.
- **Adapted score:** 41/105 (39.0%), **F**. The skill-judge rubric is applied to an automation prompt, not a `SKILL.md`. D4 frontmatter/description compliance is not applicable and excluded, rather than penalizing an artifact that is not a skill. Grade uses percentage of the applicable maximum.
- **Pattern:** overloaded Process, with no role handoff or result contract.
- **Knowledge ratio:** approximately E:A:R = 35:45:20, a qualitative clause-level estimate, not a measured token classification. Project/workflow facts carry useful knowledge; general caution dominates the action contract.
- **Source:** [exact original prompt](original-prompt.md), captured from saved Orca automation `6cd22a31-f34a-49f5-80c9-a0b7d6bc27bf` on 2026-10-05. It contains 288 whitespace-separated words in one paragraph.

## Dimension scores

| Dimension | Score | Max | Evidence and improvement |
| --- | --: | --: | --- |
| D1 Knowledge delta | 9 | 20 | Neutral controller, verified mappings and stable change IDs are useful; generic prohibitions crowd out project-specific PM decisions. Keep mapping/evidence rules, remove unrelated publication ceremony. |
| D2 Mindset/procedures | 7 | 15 | “Refine intent, scope, constraints, dependencies and observable acceptance criteria” is useful, but the procedure centers proposal publication, not maintaining a board. Add status/progress/prior-answer decisions. |
| D3 Anti-patterns | 9 | 15 | “Never assume dev” and blocking only an unmapped item are concrete protections. “Do not process Ready or claimed implementation issues” is itself a harmful anti-pattern for PM reconciliation. Keep protections tied to actual failure modes. |
| D4 Skill specification | N/A | N/A | This is an automation prompt, not a skill. No skill frontmatter or activation description is required. |
| D5 Disclosure | 3 | 15 | One paragraph embeds discovery, permissions, refinement and publishing with no linked role references. Separate entry, coordinator and worker contracts with explicit loading instructions. |
| D6 Freedom calibration | 4 | 15 | “Select at most one” and “Author proposal changes only in a dedicated Orca-owned worktree” restrict reversible board work like repository publication. Allow supported edits directly, reserve Leo-only decisions. |
| D7 Pattern recognition | 4 | 10 | A rough ordered process exists, but roles and phases are interleaved. Use a small entry prompt plus Dispatch/Collect/Email and Review/Update/Return contracts. |
| D8 Practical usability | 5 | 15 | “Ask material questions ... and wait for human answers” lacks an asynchronous continuation path. No Pi dispatch, digest, prior-answer search or structured results. Define worker results and partial-failure reporting. |

## Critical issues

1. **Wrong unit of work.** One new/refining item across all projects is not a project-board review. It leaves status drift and implementation progress untouched.
2. **Wrong role ownership.** “Role: cross-repository project manager” makes the controller perform PM work instead of orchestrating specialized project agents.
3. **Wrong cost model.** Branch rules, worktree creation, planning commits and publication are bundled into basic ticket refinement. These matter for repository edits, not ordinary description/status/comment updates.
4. **Missing decision memory.** Reading existing comments helps, but the prompt does not explicitly search Leo's prior answers, check their scope or distinguish missing history from no answer.
5. **No delivery contract.** It asks for questions on an issue but not a consolidated return to Jcode or an AgentMail digest. “Wait for human answers” turns a scheduled run into a stalled conversation.

## Top three improvements

1. Make the primary prompt a short entry point loading the bundled orchestrator contract. Jcode launches and collects; it never substitutes for a project PM.
2. Give Pi a complete board-maintenance contract: all active states, five review questions, evidence-backed mutations, read-back verification and a structured partial-result path.
3. Route only unresolved Leo decisions into one email, with verified updates and honest coverage. Search previous answers first, retain still-open decisions, and avoid repeat ticket comments.

## Root failure patterns

Using skill-judge's below-70% failure-pattern calibration: **The Dump** applies structurally, not by length (several responsibilities compressed into one paragraph); **The Freedom Mismatch** applies to the one-item limit and blanket state exclusions; **The Checkbox Procedure** appears in the generic planning checklist without a complete PM decision loop. The underlying problem is role and authority design, not merely formatting.

## What to retain

Verified board mappings, project-native states, evidence-based readiness, preservation of unrelated work, and reporting an item-specific blocker without stopping other projects. These protect genuine boundaries. They should not become repeated approval gates for authorized board edits.

## Replacement and validation boundary

The bundle supplies [automation.md](automation.md), [jcode.md](jcode.md) and [pi.md](pi.md). It deliberately removes repository publication from PM refinement. It keeps explicit failure reporting for ambiguous writes, unavailable history, malformed worker results and email delivery.

The saved definition was disabled with an `exit 1` precheck when reviewed. These are configuration blockers separate from prompt quality. Local references do not change those settings. The earlier Pi smoke test produced no output for more than two minutes and was cancelled; tracker access through Pi remains unverified. File/link/schema and repository checks validate this bundle, not a live board-update workflow.
