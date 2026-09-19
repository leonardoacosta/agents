# Jev Test Triage — Calibration Report

**Model:** jev-1.13.0 (pinned)
**Sample:** 200 tests randomly sampled from 14,102 classification inputs
**Mode:** `--dry-run` (TYPESAFE_API_KEY not configured)

## Classification Inputs Preview

200 classification inputs generated from `docs/audit/test-categorization-batch.json`.
Each input carries: `spec_file`, `test_title`, `page_route`, `page_criticality`
(0-15), `persona_count`, `action_type`, `flake_days`, `duplicate_count`,
`wave_historical`, `test_code_length`, `catch_false_count`.

Sample:
```json
{
  "spec_file": "tests/web/staff-finance/invoice-detail.spec.ts",
  "test_title": "[staff/finance/invoices/:id] invoice detail renders",
  "page_route": "/staff/finance/invoices/:id",
  "page_criticality": 9,
  "persona_count": 5,
  "action_type": "readonly",
  "flake_days": -1,
  "duplicate_count": 0,
  "wave_historical": false,
  "test_code_length": 145,
  "catch_false_count": 2
}
```

## Dry-Run Mode

[TYPESAFE_API_KEY] is not set and `@typesafe-ai/sdk` was not detected. To run
the full Jev classification:

1. Install the SDK: `npm install @typesafe-ai/sdk`
2. Set your API key: `export TYPESAFE_API_KEY=tsk_...`
3. Run: `pnpm --filter @oo/e2e exec tsx scripts/categorize-tests-with-jev.ts --limit 200`

With the SDK and key, Jev would:
- Classify each test as SUPERFLUOUS / MEANINGFUL / CRITICAL (Choice)
- Return confidence scores 0-1 (Score)
- Flag Vitest migration candidates (Noul)
- Report probability distributions per classification

After 200-sample calibration with human review, scale to the full 14,102-test
fleet.

## Fallback: Rule-Based Classification

Since Jev is unavailable, here is the rule-based categorization from the
7-axis methodology:

- 5 files (0.3%): SUPERFLUOUS (entirely skipped, zero effective tests)
- 94 test titles (0.7%): DUPLICATED (canonical copy retained elsewhere)
- ~1,200 tests (8.5%): WAVE-AMORTIZABLE (historical regression captures)
- ~3,500 tests (25%): VITEST-MIGRATABLE (pure math/schema/permission assertions)
- ~9,300 tests (65.5%): MEANINGFUL (retain with named invariant)