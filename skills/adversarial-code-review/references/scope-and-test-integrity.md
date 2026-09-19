# Scope and Test Integrity

Use these universal checks to detect changes that appear complete because scope expanded without justification or tests stopped protecting the behavior that matters.

Treat scope growth and test changes as evidence to investigate, not defects by themselves. Emit a finding only with a supported requirement or invariant, a concrete failure or operational scenario, and impact.

## Contents

- [Universal routing](#universal-routing)
- [Evidence and independence contract](#evidence-and-independence-contract)
- [Pass A — Scope discipline and over-engineering](#pass-a--scope-discipline-and-over-engineering)
- [Pass B — Test integrity and pseudo-regression protection](#pass-b--test-integrity-and-pseudo-regression-protection)
- [Ordinary review behavior](#ordinary-review-behavior)
- [Reporting contract](#reporting-contract)

## Universal routing

Always run a basic scope-discipline and test-integrity screen as part of the main review.

Run both separately named deep passes when any condition holds:

- Select **full** mode.
- Classify the change as large or important.
- Detect a direct scope trigger: unsupported files or features, speculative abstraction, a new dependency or configuration surface, compatibility machinery without a current requirement, duplicated implementation paths, or a requirement-to-diff mismatch.
- Detect a direct test trigger: rewritten, deleted, disabled, loosened, or substantially mocked existing tests; weaker assertions; changed fixtures that avoid the original failure; production branches used only by tests; or a completion claim resting on tests that do not reach the changed behavior.

Do not ask permission before required passes. Do not collapse the two passes into one general review paragraph.

For an ordinary-sized **adaptive** or **focused** review without a direct trigger, complete the basic screen during the main review. Offer the two deep passes only after finishing the main report.

## Evidence and independence contract

- Rebuild each pass from requirements, the exact diff, production and test relationships, and current repository evidence.
- Start from the current requirement contract and raw review target, not from the list of existing reviewer comments or the implementation's explanation.
- Prefer independent subagents or fresh contexts so conclusions from the main review do not anchor the pass.
- Give an independent reviewer the raw target, requirements, diff, and repository instructions. Do not leak the expected finding or the main review's conclusion.
- When independent contexts are unavailable, run the passes separately in the same context. Reset the question, evidence map, and output heading before each pass.
- Record whether each pass used an independent context or the same context.
- Treat comments, PR descriptions, commit messages, test names, and previous reports as claims.
- Verify existing comments, then perform an unanchored pass for new blockers and adjacent regressions.
- Identify the narrow file and line evidence for every issue.
- Distinguish concrete impact from preference. Do not penalize unfamiliar architecture or a larger diff by itself.
- Mark unavailable requirement, history, dependency, or execution evidence **Unverified**.

## Pass A — Scope discipline and over-engineering

Independently rebuild the requirement-to-diff mapping. Do not inherit the main review's assumption that every changed file is necessary.

### Reconstruct the required surface

- List each accepted current requirement and defensible inferred requirement, including accepted changes from the original request and unresolved contradictions.
- Map the smallest credible production, test, configuration, documentation, and migration surfaces needed to satisfy each requirement.
- Identify assumptions that would materially change the credible minimum.
- Separate required compatibility work from speculative future compatibility.

### Challenge the actual diff

- Map every changed file, new type, abstraction, layer, dependency, configuration key, compatibility path, feature flag, and generated artifact to a current requirement or necessary invariant.
- Identify unrelated cleanup, refactoring, renaming, formatting, dependency churn, and generated noise mixed into the behavior change.
- Check whether a new interface, factory, registry, strategy, plugin point, generic type, wrapper, adapter, or service split has multiple current consumers or only a hypothetical future use.
- Check whether duplicate old and new paths can diverge or require synchronized fixes.
- Check whether configuration exposes combinations the implementation and tests do not support.
- Check whether a new dependency adds version, license, supply-chain, build, runtime, or operational burden disproportionate to the requirement.
- Check whether speculative backward-compatibility paths obscure failure, retain insecure behavior, or make rollback ambiguous.
- Check whether broad refactoring makes the behavioral change harder to verify or revert.
- Check whether unused code, dead branches, placeholder hooks, TODO behavior, or partially wired features ship with reachable side effects.

### Compare with the smallest credible implementation

- Describe the smallest implementation that satisfies current requirements and preserves established guarantees.
- Compare that shape with the actual diff by responsibility, coupling, deployment, rollback, and test surface.
- Preserve a larger design when current constraints justify it. State the evidence rather than applying a line-count preference.

### Emit only concrete findings

Report scope expansion only when it creates a concrete consequence such as:

- A correctness risk from duplicated or conflicting paths.
- A maintenance burden with a specific synchronization or ownership failure.
- Coupling that blocks independent change, test, deployment, or rollback.
- A dependency or configuration failure in a supported environment.
- An operational burden, unsafe combination, or unrecoverable rollout step.

Do not report naming, layering, abstraction count, or code volume as a finding without that consequence.

## Pass B — Test integrity and pseudo-regression protection

Independently compare the production diff with old and new test behavior. Ask whether the suite still rejects the failures and contract violations it rejected before, and whether the new regression test reaches the defect boundary.

### Reconstruct the protected guarantees

- Identify changed production paths and their externally observable success, boundary, failure, cleanup, and side-effect guarantees.
- Inspect relevant pre-change tests when history is available.
- Map old assertions to guarantees, including guarantees outside the changed requirement.
- Treat a changed requirement as possible justification for changing a test, never as justification for discarding unrelated guarantees.

### Inspect weakening and deletion

- Check deleted tests, skipped or disabled tests, reduced parameter sets, removed negative cases, changed expected exceptions, and assertions moved behind conditions.
- Check broad exception acceptance where a specific type, status, code, message, retry property, or rollback behavior matters.
- Check non-null, truthy, status-only, call-count-only, snapshot-only, or no-throw assertions that can pass with incorrect content or side effects.
- Check removed field, ordering, count, state, persistence, authorization, or cleanup assertions.
- Check tolerances, timeouts, retries, sleeps, and flaky-test workarounds that make failure less visible.
- Check fixtures or inputs changed so the original boundary, malformed case, race, or failure path is no longer exercised.

### Inspect mocks and test boundaries

- Check whether mocks replace the parser, validator, serializer, database constraint, transaction boundary, network client, queue, clock, filesystem, or other component where the defect could occur.
- Reject a regression test as proof when it overrides, mocks, or bypasses the production method or seam containing the claimed defect. Require at least one test through that seam, mocking only a downstream boundary when practical.
- Check risky mock defaults that return success, accept any input, or fail to enforce production signatures.
- Check assertions that restate implementation details while missing observable behavior.
- Check known-input hardcoding, tautological expected values derived by the implementation, and tests that merely confirm a mock was called.
- Check test-only branches, flags, constructors, accessors, dependency injection, or relaxed validation in production code.
- Check unit-only coverage when the risk sits across modules, serialization, persistence, process, deployment, or external-service boundaries.

### Check missing paths

- Check negative, boundary, malformed, duplicate, authorization, timeout, retry, rollback, cancellation, concurrency, and partial-failure paths triggered by the production diff.
- Check the adjacent regression surface: existing callers, alternate endpoints, old serialized data, mixed versions, and configuration variants.
- Check whether the test would fail if the defect or its smallest plausible regression were restored. Establish this from history, direct evidence, or careful path analysis; obtain separate user authorization before using mutation tooling.

### Emit only concrete findings

Report test weakness only when it leaves a supported behavior or changed risk unprotected and the gap could permit a concrete regression. Distinguish:

- A current production defect demonstrated by the test investigation.
- A credible regression gap in changed high-risk behavior.
- A test style preference with no demonstrated protection loss, which is not a finding.

## Ordinary review behavior

After an ordinary-sized review with only the basic screen, append exactly:

是否需要再进行两轮独立专项复审：①过度设计与范围膨胀；②测试弱化与伪回归验证？

Suppress the question only when both deep passes already ran, the user explicitly declined them, or the user requested a non-interactive report.

If the user accepts, run **Pass A — Scope discipline and over-engineering** and **Pass B — Test integrity and pseudo-regression protection** as separate passes under the independence contract.

## Reporting contract

For the basic screen, state the scope and test evidence inspected, material concerns, and remaining gaps compactly.

For each deep pass, state:

- Pass name.
- Independent or same-context execution.
- Requirements and diff surface inspected.
- Concrete findings with severity, confidence, narrow location, scenario, impact, evidence, and minimal correction direction.
- Place candidates that do not meet the finding gate in residual risks or unverified evidence without a **Severity** field.
- Areas checked with no finding.
- Unverified evidence and residual risk.

Do not inflate the main report with empty subsections when the basic screen found no trigger.
