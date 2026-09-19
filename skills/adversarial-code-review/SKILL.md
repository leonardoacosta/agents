---
name: adversarial-code-review
description: Use when independently reviewing working-tree changes, staged changes, commits, or pull requests before merge, especially AI-generated code, large or cross-module changes, weak or rewritten tests, requirement drift, suspicious scope, unverifiable completion claims, or security, transaction, concurrency, performance, dependency, compatibility, and operational risks.
---

# Adversarial Code Review

## Review contract

- Act as a skeptical, independent senior reviewer.
- Establish the current requirement contract before judging the implementation. Use the original problem as context, incorporate accepted requirement changes, and never let the implementation redefine its own requirements.
- Treat the implementation, comments, tests, commits, pull-request description, previous reports, and completion claims as claims to verify.
- Verify claims against requirements, code, tests, the exact diff, repository context, and fresh command output.
- Treat existing review comments as questions to verify, not as the boundary of the review. Look independently for new blockers against the current requirements and final diff.
- Bind every verdict to the exact reviewed snapshot. Any later production, test, configuration, or generated-file change invalidates affected conclusions until they are reviewed again.
- Keep the review read-only unless the user separately authorizes fixes. Do not edit files, install packages, upgrade dependencies, mutate Git state, approve or merge changes, reply to review comments, or silently fix defects.
- Inspect every command before running it. Avoid commands that may format, generate, migrate, install, update snapshots, or rewrite files unless the user authorizes that mutation.
- Report only evidence-backed defects. Treat style preferences as non-findings unless they cause a concrete correctness, maintenance, operational, or security impact.

## Track progress

Create and complete a compact checklist:

- [ ] Read applicable instructions and repository context.
- [ ] Confirm the exact review target, comparison boundary, and starting snapshot.
- [ ] Establish the current requirement contract and its evidence.
- [ ] Inventory the diff and classify size and importance.
- [ ] Select the mode and route risk domains.
- [ ] Review the fixed trunk and every triggered domain.
- [ ] Run safe verification and record complete results.
- [ ] Reinspect status and prove the final snapshot still matches the reviewed work.
- [ ] Produce the evidence-scaled report.

Complete every applicable item. Mark an item unverified with a reason instead of silently skipping it.

## Establish the current requirement contract

Do this before detailed diff review. Locate the original issue or request when it exists, then inspect accepted design decisions, follow-up clarifications, public contracts, and relevant historical behavior. Separate the underlying problem and user intent from an initially proposed solution.

Reconcile requirement evolution instead of following either the oldest text or the newest implementation mechanically:

- **Accepted** — explicitly approved or recorded by an authoritative source; include it in the current contract.
- **Inferred** — necessary from repository evidence or an established invariant but not explicitly approved; label it as inferred.
- **Proposed** — suggested by the implementation, pull request, test, or discussion but not accepted; do not treat it as a requirement.
- **Contradicted** — authoritative sources disagree; record the conflict rather than choosing the source that favors the implementation.

Summarize the current problem, expected observable behavior, acceptance criteria, accepted changes and rationale, compatibility invariants, non-goals, and unresolved ambiguity. If a material requirement is unavailable or contradicted, mark it **Unverified** and do not report **Ready to merge: Yes**.

## Choose the mode

Select exactly one mode and state both the mode and its observable trigger evidence in the report.

| Mode | Select when | Required depth |
| --- | --- | --- |
| **adaptive** | Use by default when neither a focused request nor a full-review predicate applies. | Run the fixed trunk, then deeply review domains triggered by observable diff signals and screen the rest. |
| **full** | Use when the user asks for a full, deep, or comprehensive review; calls the change large, important, or core; or the mandatory classifier below triggers. | Run the fixed trunk, all relevant domains, and both independent universal passes. |
| **focused** | Use when the user explicitly names a particular risk domain. | Deeply review that focus while still covering requirements, scope, core logic, test credibility, adjacent regression risk, safe verification, and the final diff. |

Prefer the deeper mode when predicates conflict. Do not let a focused request suppress a mandatory **full** classification.

## Run the fixed trunk

1. Read repository and nested instructions, including applicable **AGENTS.md**, **CLAUDE.md**, **CONTRIBUTING.md**, relevant README or design documents, and CI, build, test, and formatting conventions.
2. Confirm the target as working-tree changes, staged changes, a commit or commit range, or a pull request with an explicit base and head. Record the starting base, head, worktree state, and comparison boundary; resolve ambiguity before drawing conclusions.
3. Establish the current requirement contract using the process above. Do not begin from the implementation or limit the contract to existing review comments.
4. Inventory changed files, effective changed lines, generated, vendor, and lock-only noise, affected modules, layers, and services, production-to-test relationships, and changes to APIs, dependencies, configuration, migrations, or deployment.
5. Trace real execution paths from every current requirement to its effect. For a changed shared policy, helper, timeout, lifecycle state, or extension point, enumerate its callers, consumers, and overrides before deciding the change is local.
6. Assess test credibility against the production diff. Check whether tests would fail for the defect they claim to prevent and whether old guarantees remain protected.
7. Verify material claims with safe, fresh commands when possible. Read complete output and distinguish code failures from environment or tooling failures.
8. Reinspect repository status and resolve the final base, head, and diff after verification. Detect generated files, snapshot rewrites, formatting changes, or other accidental mutations.
9. Compare the final snapshot with the reviewed snapshot. If it changed, repeat the affected requirement, code, test, domain, and verification checks before reporting; never carry a stale verdict forward.

## Classify size and importance

Treat the change as large or important and require **full** mode plus both independent universal passes when any condition holds:

- At least 10 changed non-generated files.
- At least 500 effective changed lines after excluding generated, vendor, and lock-only noise.
- At least 3 affected modules, layers, or services.
- A public API, database schema, dependency, or architecture boundary is introduced or changed.
- Refactoring is mixed with behavior changes.
- Existing tests are substantially rewritten, deleted, or weakened.
- The user calls the change large, important, or core, or requests a comprehensive review.

Upgrade a change below these thresholds only when observable evidence supports the higher risk. State that evidence in the report.

## Route risk domains

Read [references/review-domains.md](references/review-domains.md) and route domains from observable signals:

- Route authentication, authorization, untrusted input, file handling, deserialization, or network access to security and trust boundaries.
- Route database, migration, persistence, mutable state, or multi-step writes to transactions and data integrity.
- Route asynchronous work, shared state, messages, acknowledgements, queues, retries, or scheduled work to concurrency, retries, and idempotency.
- Route a new or changed API, dependency, configuration key, command, endpoint, or generated client to authenticity and compatibility.
- Route loops, bulk work, caches, queues, fan-out, large payloads, or resource acquisition to performance and resource usage.
- Route public contracts, serialization, environment behavior, schema changes, deployment files, logging, metrics, or rollback paths to compatibility and operations.

Read [references/language-checks.md](references/language-checks.md) only for languages or database artifacts actually changed.

Record every relevant domain in a coverage ledger with exactly one state:

| State | Meaning |
| --- | --- |
| **Deeply reviewed** | Trace the relevant paths and inspect evidence in depth. |
| **Screened** | Check the domain for triggers and find no evidence requiring deeper work. |
| **Not applicable** | Establish from the diff that the domain does not apply. |
| **Unverified** | Identify relevant evidence that cannot be inspected or verified. |

Give a short reason for every state. Never silently omit a triggered domain.

## Run universal scope and test checks

Always perform a basic scope-discipline and test-integrity screen. Read [references/scope-and-test-integrity.md](references/scope-and-test-integrity.md).

For **full** mode, a large or important change, or a direct scope or test trigger, run both separately named passes:

- **Pass A — Scope discipline and over-engineering**
- **Pass B — Test integrity and pseudo-regression protection**

Prefer independent subagents or fresh contexts when available. Otherwise, separate the passes explicitly in the same context and rebuild each pass from its own evidence. Do not ask permission before running required passes.

For an ordinary-sized review, finish the main review and ask exactly:

是否需要再进行两轮独立专项复审：①过度设计与范围膨胀；②测试弱化与伪回归验证？

Suppress this question only when both passes already ran, the user explicitly declined them, or the user requested a non-interactive report.

## Apply finding discipline

Emit a finding only when a concrete failure or misuse scenario and impact are supported. Include:

- Severity: **S0 Critical**, **S1 High**, **S2 Medium**, or **S3 Low**.
- Confidence: **High**, **Medium**, or **Low**.
- The narrowest reliable file and line location.
- The triggering inputs, state, deployment condition, or execution path.
- Actual behavior and expected behavior.
- User, data, security, compatibility, operational, or maintenance impact.
- Evidence and reasoning, including relevant requirement and verification output.
- The smallest credible correction direction without implementing it.

Use **S0** for catastrophic or broadly exploitable impact, **S1** for serious correctness, security, data, or operational failure, **S2** for meaningful but bounded impact, and **S3** for a small concrete risk. Do not use **S3** for taste.

Treat **Unverified** as an evidence, requirement, or coverage state only, never as a severity. Put a candidate that lacks enough evidence for a finding in residual risks or unverified evidence without a **Severity** field; do not format or label it as a finding.

Avoid speculative flooding. Lower confidence or mark a domain **Unverified** when evidence is incomplete. Never invent requirements, line numbers, command results, file contents, dependency behavior, or external verification.

## Verify claims safely

- Prefer documented project commands and the narrowest safe command that can verify the claim.
- Read actual, complete output. Do not rely on a prior report or a claimed passing run.
- Record each command or inspection, result, and notes. Use only **Passed**, **Failed**, **Not run**, or **Inconclusive** as the result.
- Mark a command **Passed** only when it completed successfully during the current review.
- Mark unavailable API, dependency, configuration, service, or environment evidence **Unverified**.
- Do not treat a verification failure as a code defect until evidence establishes causality. Separate product failures from setup, permission, network, dependency, and test-harness failures.
- Reinspect status and the final diff after commands that might have created or rewritten artifacts.
- Treat any change to the reviewed snapshot as new evidence. Re-run affected checks before relying on earlier findings or a no-blocker conclusion.

## Report

Lead with:

> ## Verdict
>
> **Ready to merge: Yes | No | With fixes**

Explain the decision and the selected mode with trigger evidence. Put the following heading immediately after that explanation and include only severity groups that contain findings:

> ## Findings

State the current requirement contract and its sources. Separate accepted and inferred requirements from proposed, contradicted, or unavailable evidence. A single simple requirement may use one sentence; use a matrix when multiple requirements exist. Matrix results may use only **Satisfied**, **Partially satisfied**, **Missing**, **Contradicted**, **Unverified**, or **Not applicable**.

Classify production-behavior requirements from implementation or current runtime evidence: use **Satisfied**, **Partially satisfied**, or **Contradicted** only when that evidence supports the state. When production implementation and runtime evidence are unavailable, record the production requirement as **Unverified**. Express test-protection status separately in the scope and test assessment or a test-integrity finding.

Always include the reviewed base, head, worktree state, and final-snapshot freshness; verification evidence; the four-state review coverage ledger; the scope and test assessment; residual risks; and a final recommendation. Scale their detail to risk and evidence; keep empty or minimal residual-risk and recommendation content concise. Do not mechanically reproduce other empty sections for a small review with one clear finding.

When no defect is found, state what was inspected, which commands ran, which risk classes were checked, what behavior remains unverified, and why the available evidence is sufficient or insufficient.

Append the exact optional two-pass question only when its ordinary-review predicate applies.
