# Otaku Odyssey E2E suite redundancy audit

Date: 2026-09-19
Repository: `/home/nyaptor/dev/priceless/otaku-odyssey`

## Executive summary

The suite is large, but the strongest available baseline is the existing static enrollment evidence: **1,562 authored spec files and 14,219 collected Chromium tests**. A fresh source scan found **1,561 spec files**, **551,676 source lines**, **7,821 lexical `test`/`it`/`specify` declarations**, **6,117 skip constructs**, **76 serial-mode files**, and **7,897 `.catch(() => false)` occurrences**. The lexical declaration count is lower than Playwright's collected count because parameterized tests, generated cases, and nested collection are not recoverable from regex alone.

The suite is not safe to prune by raw file count. The clearest high-confidence redundancy is repeated browser assertion of lower-layer contracts, repeated persona login-success checks, and duplicate title families. Delete or migrate only after preserving a named invariant in Vitest or real-DB integration coverage.

## Quantified findings

| Metric | Result | Interpretation |
|---|---:|---|
| Collected Chromium tests | 14,219 | Existing authoritative enrollment baseline from `docs/audit/testing-stack-audit-2026-09-19.md` |
| Authored spec files | 1,562 documented, 1,561 fresh scan | Small repository-state/count drift; rerun enrollment before deletion |
| Spec source lines | 551,676 | Maintenance cost is substantial |
| Lexical test declarations | 7,821 | Lower bound, not collected-test count |
| Skip constructs | 6,117 | Large pool of conditional or permanently skipped coverage |
| Serial files | 76 | State coupling and consolidation candidates |
| `.catch(() => false)` | 7,897 | Weak-oracle signal, not automatic deletion proof |
| Repeated exact test titles | 109 titles, 174 extra occurrences | Candidate duplicate families; inspect semantics before deleting |
| Inventory page files | 25 | Inventory contains 207 route literals in the page modules |

Artifacts: `suite-inventory.json`, `module-summary.json`, and `inventory-ceilings.json`.

## Per-page ceilings

The repository already defines a documented prototype ceiling in `packages/e2e/scripts/categorize-tests-with-jev.ts`:

- **LOW:** 3 tests per page
- **MEDIUM:** 8 tests per page
- **HIGH:** 15 tests per page

Criticality scoring gives points for revenue routes, permission-bearing actions, destructive/bulk actions, broad persona access, integration surfaces, and anonymous access. These ceilings should be treated as a review budget, not an automated delete rule. The current categorizer still creates one synthetic representative input per page and returns `duplicate_count: 0`, so it does not yet produce trustworthy per-page actual-vs-ceiling data.

Recommended operating rule:

1. Keep one page-render/navigation test for every page.
2. Add one test per unique security boundary: allowed persona, denied persona, and redirect/error behavior where applicable.
3. Add one test per unique destructive or externally integrated invariant.
4. Cap ordinary LOW pages at 3, MEDIUM pages at 8, and HIGH pages at 15 unless an exception names the extra invariant and its defect history.
5. Count parameterized cases by invariant, not by persona multiplication.

## Modules with the strongest overgrowth signal

The existing audit gives the following file-count hotspots: **staff 202**, **public 84**, **programming 48**, **admin 44**, **vendor 36**, **attendee 35**, **cosplay 33**, and **apply 31**. These are module-level file counts, not proof that every test is redundant. They are the first queues for test-title and invariant review.

The largest journey files called out by the existing audit are:

- `vendor-invoice` approximately 9.9k lines
- `staff-misc` approximately 6.9k lines
- `badge-purchase` approximately 5k lines
- `affiliate-dashboard` approximately 4.3k lines
- `schedule-management` approximately 4.2k lines
- `admin-invoice` approximately 4k lines

These files should be split or consolidated by business invariant, not historical bug wave. Prioritize files with both high line count and `.catch(() => false)` or serial mode.

## Duplicate candidates

The static scan found 109 repeated exact test titles across files. Exact-title duplication is a useful lead, but not sufficient evidence for deletion because the same title can legitimately run against different routes, personas, or browser projects. A candidate is high confidence only when all of the following match:

- same normalized title and same route/page;
- same persona and auth state;
- same project/browser requirements;
- same setup and external side effects;
- no distinct defect or lower-layer invariant;
- one surviving test has an explicit, stronger oracle.

The full duplicate-title list with files is in `suite-inventory.json`.

## Move-to-Vitest candidates

### High confidence

Move assertions that do not require a real browser, cookie transport, deployed routing, hydration, CSS, focus, or cross-page navigation:

- inventory binding integrity, duplicate routes, critical-action coverage;
- permission predicates and negative global-role safety;
- route/action metadata and persona permission matrices;
- Zod validation and promo codecs;
- pure pricing/math and state-transition calculations;
- UI component static rendering and heading/copy/slot contracts;
- helper/parser/cleanup contract logic.

The existing audit confirms working lower-layer proofs for inventory RBAC, auth pure functions, UI rendering, and validators. Preserve E2E only for rendered visibility, real authenticated navigation, visible/hidden action gating, responsive behavior, keyboard/focus, accessibility, and full API→DB→UI round trips.

### Keep in Playwright

- one true credential journey and one unauthenticated error matrix;
- one real remember-me test using a new browser context;
- one real Stripe terminal checkout journey;
- webhook tests that validate browser-visible consequences or deployed/local routing;
- representative finance/invoice create/edit, refund/void, and email/export journeys;
- representative schedule mutation, public rendering, and timezone/calendar behavior;
- minimal cross-browser coverage tied to actual layout or browser-engine risk.

### Do not move blindly

Mocked fluent-chain tests prove call shape, not persistence correctness. Replace redundant E2E persistence checks with real-DB integration tests, not mocks, before deleting browser coverage.

## Recommended deletion/consolidation order

1. Fix governance trust first: persona manifest drift, quarantine lifecycle drift, unwired script, and Vitest threshold placement.
2. Repair the `@oo/inventory test-impact` CLI wiring so router diffs provide `proceduresToRoutes`; otherwise selective deletion can silently skip RBAC coverage.
3. Build a collected-test manifest keyed by `{file, title, project, persona, route, invariant}`. The current categorizer is not enough because it synthesizes one test per page.
4. Deduplicate exact-title families after semantic normalization. Keep the strongest oracle and delete only proven equivalent copies.
5. Migrate lower-layer candidates with a named Vitest/real-DB replacement test and a temporary deletion ledger.
6. Re-run CI-owned E2E acceptance through the repository workflow. Local collection and unit tests supplement but do not replace browser acceptance.

## Limitations

No browser execution was performed in this audit. The fresh counts are static lexical metrics. Existing collected-test and architecture numbers are cited from the repository's same-day audit report. A precise per-page ceiling breach report requires parsing Playwright's JSON list output and joining each test to inventory routes, actions, permissions, persona, and project. The generated JSON preserves the raw material for that next step.
