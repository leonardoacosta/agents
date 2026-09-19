---
name: priceless-test-categorization
description: >
  Deep E2E test suite analyzer that applies a 7-axis methodology to classify
  tests as superfluous, meaningful, or critical. Use whenever the user asks to
  audit tests, categorize an E2E suite, find redundant tests, identify which
  tests can be deleted, apply test categorization methodology, consolidate test
  suites, or measure test density per page. Requires a page inventory from
  priceless-page-inventory. Start by loading that skill if not already present.
allowed-tools: Read, Glob, Grep, Bash, Write, agentgrep
---

# Priceless Test Categorization

A deep analyzer that inventories an E2E test suite against the page-inventory
contract, applies a 7-axis decision framework, and produces a categorization
report: **SUPERFLUOUS** (remove now), **MEANINGFUL** (retain with named
invariant), **CRITICAL** (retain and promote to cross-browser / quarantine-
excluded lanes).

Load `priceless-page-inventory` first if the project does not already have a
page inventory following its schema.

## Methodology: 7-Axis Decision Framework

### Axis 1: Page Criticality (Risk-Based)

Score each inventory page on seven factors:

| Factor | Weight | Trigger |
|---|---|---|
| Revenue sensitivity | 4 | Route touches checkout, payment, refund, order |
| Permission gate | 3 | Page has actions requiring scoped permissions beyond `authenticated` |
| Data mutability | 2 | Page has write/delete actions (not read-only) |
| Persona blast radius | 2 | Page is accessible to 5+ distinct personas |
| Integration surface | 2 | Page touches Stripe, Resend, Blob, Svix, or webhook |
| Public exposure | 1 | Page is accessible to anonymous users |
| Historical defect density | 1 | Page/module has 3+ regression-defect issues in past 6 months |

**Score to tier:** 0-3 → LOW, 4-7 → MEDIUM, 8-15 → HIGH.

**Per-page test ceilings:** LOW=3, MEDIUM=8, HIGH=15. These are soft — a page
can exceed its ceiling if every additional test names a unique business
invariant not proved by any other test on the same page.

### Axis 2: Persona Coverage Minimums

Every page accessible to a persona must have at least one E2E test exercising
that persona's primary navigation path. This is a floor, not a ceiling.

| Persona class | Minimum per page |
|---|---|
| anonymous | 1 path: page renders without auth redirect |
| authenticated (no scope) | 1 path: page renders after login |
| scoped (role-specific) | 1 path per role: page renders with correct gating |

Derive from `view_access.allow` in the inventory. If a page allows
`platformOwner`, there must be at least one platformOwner test.

Compute persona-path coverage: `(personas exercised in E2E) / (personas in
view_access.allow)`. Flag below 0.5.

### Axis 3: Action Sensitivity

Each inventory action maps to 0-1 E2E test. Actions requiring coverage:

| Action class | Minimum E2E |
|---|---|
| `security_critical: true` | 1 |
| `crud: "D"` or `crud: "Bulk"` | 1 |
| `side_effects` contains `stripe_*` | 1 |
| `requires` includes refund or ban | 1 |
| All others | 0 (Vitest integration preferred) |

Compute action coverage: `(actions with E2E reference) / (total critical +
destructive actions)`. Below 0.8 is sub-threshold.

### Axis 4: Flake History Penalty

A test flaked in the last 30 days loses one tier (CRITICAL → MEANINGFUL,
MEANINGFUL → SUPERFLUOUS), unless it is the sole E2E test for a
security_critical action (must be fixed, not demoted).

Data source: quarantine lifecycle JSON (look for entries with expiry within
30 days) and CI merge-report retry-pass flake counts.

### Axis 5: Duplication Tax

A test whose title appears in more than one file is taxed. The canonical copy
(in the most specific module directory) retains its tier; every duplicate
drops one tier. If 5+ copies exist, all except canonical are SUPERFLUOUS.

Pre-compute a cross-file test-title map: `title → [file_paths]`.

### Axis 6: Test-Type Allocation Ratio

Per the testing pyramid, E2E should be ≤10% of the total test suite. For any
E2E assertion that is:
- Pure math (pricing, tax, discount)
- Pure schema validation
- Pure permission predicate
- Static component rendering

Flag as a Vitest migration candidate. Keep browser tests for: navigation, auth
session transport, visible/hidden action gating, responsive/keyboard behavior,
accessibility, provider-terminal integration.

### Axis 7: Wave/Historical Amortization

Spec files in `tests/audit-wave*`, `tests/wave-*`, or `tests/wave*` directories
are historical regression captures. Tax one tier unless they are the sole file
covering an action or persona path. Files in these directories superseded by a
canonical spec in `tests/web/*` or `tests/staff/*` with the same test title
are SUPERFLUOUS.

## Workflow

### Phase 1: Inventory

1. Locate the project's Playwright config (`playwright.config.ts` or
   `packages/e2e/playwright.config.ts`).
2. Read the test directory structure and count spec files.
3. Run `check:enrollment` or equivalent `--list` command to get the exact
   collected test count. If no such command exists, run `npx playwright test
   --list` with an inert `baseURL` (`http://localhost:3000`).
4. Locate the page inventory (`packages/inventory`, `@oo/inventory`, etc.).
   If missing, instruct the user to run `priceless-page-inventory` first.
5. Locate quarantine lifecycle data (`.json` with `entries[].lifecycle.expires`).
6. Locate CI flake reports if available.

### Phase 2: Scoring

For each inventory page, compute the criticality score (Axis 1) and tier.

For each spec file, map it to one or more inventory pages (using route-to-
directory conventions: `tests/web/vendor/*` → staff-vendors module,
`tests/web/admin/*` → admin module, etc.).

Build:
- Per-page spec counts and ceilings
- Persona coverage ratios
- Action coverage ratios
- Cross-file test-title duplicates map
- Flake history per test

### Phase 3: Classification

Apply the 7 axes to produce a three-tier classification for each test. The
classification is **conservative**: when in doubt, default to MEANINGFUL
rather than SUPERFLUOUS.

### Phase 4: Report

Produce a markdown report with this structure:

# Test Categorization Report

## Executive Summary
- Total specs, tests, pages
- Modules exceeding ceilings (with ratios)
- Quick-win retirement candidates (entirely skipped, wave-only duplicates)
- Vitest migration candidates

## Per-Module Analysis
For each logical module (public, staff-finance, admin, auth, etc.):
- Spec count vs. ceiling
- Persona coverage ratio
- Action coverage ratio
- Top consolidation candidates (named files + test titles)
- Duplicate test titles and their canonical copy

## Jev Classification Batch
A JSON array of `ClassificationInput` structs for the Jev triage agent.
See `priceless-jev-triage` for consumption.

## Consolidation Recommendations
Prioritized by effort:
1. **P0: Retire now** — entirely skipped files, tests with 0 assertions
2. **P1: Remove duplicates** — tests with canonical copies in `tests/web/*`
3. **P2: Migrate to Vitest** — pure math, schema, or permission assertions
4. **P3: Wave amortization** — superseded historical regression tests

## Output Artifacts

Write to the project's audit directory (create `docs/audit/` if needed):

1. `test-categorization-report-YYYY-MM-DD.md` — the full markdown report
2. `test-categorization-batch.json` — Jev-compatible classification inputs
3. `test-categorization-consolidation-candidates.json` — priority-ordered
   list of files to retire/migrate with rationale

## Principles

- **Conservative deletion**: When in doubt, retain. Every deletion must name
  either a surviving test or a lower-layer Vitest test that proves the same
  invariant.
- **Ceilings are signals, not laws**: A page exceeding its ceiling is a triage
  signal, not an automatic delete order. Some pages legitimately need many
  tests (Stripe checkout with refund/dispute/webhook flows).
- **Persona diversity drives test diversity**: If two personas see the same UI,
  one test may cover both. If they see different UI states (RBAC gating), each
  needs its own path.
- **Pyramid ratios are guidelines**: Multi-tenant RBAC-heavy products may
  legitimately need more E2E than a simple CRUD app.
- **Flake history is a quality signal, not a deletion signal**: A frequently
  flaking test for a security-critical action must be fixed, not deleted.
- **Report what's missing as well as what's excessive**: Persona gaps and
  action gaps are as important as oversaturated modules.