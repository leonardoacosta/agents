# Test Categorization Report — Otaku Odyssey

**Date:** 2026-09-19
**Suite:** 1,561 authored specs, 14,102 collected Chromium tests
**Inventory:** 167 pages across 25 modules, 207 actions
**Methodology:** 7-axis decision framework (priceless-test-categorization)

## Executive Summary

Every inventory module exceeds its per-page ceiling. Median: 4.3× over ceiling.
The suite has approximately 7,000 tests that are candidates for retirement or
migration — but deletion must be conservative. This report flags candidates by
priority tier.

### Quick-Win Retirement (P0)

| File | Reason |
|---|---|
| 5 files already retired in prior audit | Entirely skipped with `test.describe.skip` |
| `tests/visual/visual-regression.spec.ts` | Zero committed baselines, entirely skipped |

### Duplicate Test Titles (P1)

94 test titles are duplicated across files. Top clusters:
- `"clicking"` in 5 files (vague name — likely auto-generated)
- `"landing page renders with h1 and CTA"` in 7 drawer files
- `"[4.1a] filter tab bar renders with ARIA tablist role"` in 7 staff redesign files

### Wave-Directory Amortization (P2)

Files in `tests/wave-*` and `tests/audit-wave*` directories: 37 files across
8 wave directories. Those with canonical copies in `tests/web/*` or
`tests/staff/*` are SUPERFLUOUS.

### Vitest Migration Candidates (P3)

~30% of E2E assertions are pure math (pricing, tax), pure schema validation,
pure permission predicates, or static component rendering. These can migrate
to Vitest integration tests.

## Per-Module Analysis

| Module | Specs | Ceiling | Ratio | Criticality | Action |
|---|---|---|---|---|---|
| staff-finance | 48 | 15 | 3.2x | HIGH | Deduplicate refund dialog tests |
| staff-affiliate | 71 | 15 | 4.7x | HIGH | Retain Stripe/payout paths, dedup impersonation |
| staff-programming | 78 | 8 | 9.8x | MEDIUM | Consolidate calendar/timeline views |
| staff-cosplay | 63 | 8 | 7.9x | MEDIUM | Deduplicate redesign tests |
| staff-meetups | 13 | 8 | 1.6x | MEDIUM | Borderline — audit individual tests |
| staff-vendors | 49 | 8 | 6.1x | MEDIUM | Retain payment paths, dedup booth layouts |
| staff-badges | 28 | 8 | 3.5x | MEDIUM | Consolidate badge detail views |
| public | 118 | 8 | 14.8x | LOW-MEDIUM | Most candidates for Vitest migration |
| admin | 42 | 8 | 5.3x | MEDIUM | Remove duplicated refund tests |
| auth | 53 | 8 | 6.6x | LOW-MEDIUM | Collapse to one valid-credential + one error matrix |

## Action Coverage Gaps

Compute: `actions_with_e2e / total_critical_actions`. Flagged: `public` module
(49 actions, 0 critical, no gap), `staff-finance` (14 actions, 0
security_critical in current inventory, may need review).

## Persona Coverage

27 personas in auth storage. For each page with `view_access.allow`, verify
that at least one test exercises the persona. Gaps to triage: `platformOwner`
paths, `eventOwner` paths, `safety-lead` paths.

## Jev Classification Batch

Saved to `docs/audit/test-categorization-batch.json` with 14,102
`ClassificationInput` structs for `priceless-jev-triage`.

## Consolidation Recommendations

1. **P0: Retire now** — 5 entirely skipped files (already done in prior audit)
2. **P1: Remove duplicates** — 94 test titles with canonical copies, start
   with the 9 already removed from admin-misc-journey
3. **P2: Wave amortization** — retire `tests/wave-*` duplicates where
   canonical copy exists
4. **P3: Migrate to Vitest** — move pricing/math, schema, permission
   assertions to Vitest integration tests