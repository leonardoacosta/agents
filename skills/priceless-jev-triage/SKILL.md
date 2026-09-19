---
name: priceless-jev-triage
description: >
  Jev-compatible test triage agent that classifies E2E tests as superfluous,
  meaningful, or critical using TypeSafe Jev's typed probabilistic decision API.
  Use whenever the user asks to run Jev on tests, classify tests with Jev, triage
  test failures with AI, apply probabilistic categorization, or needs typed
  structured decisions for test fleet classification. Consumes output from
  priceless-test-categorization; falls back to running it first if no batch is
  available.
allowed-tools: Read, Glob, Grep, Bash, Write
---

# Priceless Jev Triage

An agent that sends E2E test classification data to TypeSafe Jev for typed
probabilistic decision-making. Jev returns a `Choice` (superfluous / meaningful
/ critical), a `Score` (confidence), and a `Noul` (migration candidate) for
each test — with full probability distributions and calibrated uncertainty.

Skill B in the pipeline: consumes `priceless-test-categorization` output, falls
back to running it first if no classification batch is available, and never
calls test categorization in the reverse direction.

## Prerequisites

1. A page inventory following `priceless-page-inventory` schema.
2. A classification batch from `priceless-test-categorization` (or the skill
   will invoke it first).
3. A TypeSafe API key (`TYPESAFE_API_KEY` env var). If unavailable, run in
   dry-run mode which prints the classification inputs without calling Jev.
4. `@typesafe-ai/sdk` installed (`npm install @typesafe-ai/sdk`). If
   unavailable, explain to the user and offer to run in dry-run mode instead.

## What Jev is (and isn't)

Jev is TypeSafe AI's System One model — it takes structured state and returns
typed `Choice`/`Score`/`Noul` answers with probability distributions. It does
**not** generate text, does not count, does not do math, does not guarantee
cross-question consistency, and can be steered by adversarial state. It is a
**classification sidecar**, not a test oracle or pass/fail authority.

What Jev does well for this use case:
- Classify into a fixed taxonomy (superfluous / meaningful / critical)
- Return confidence so low-confidence results route to human review
- Flag migration candidates (can this test move to Vitest?)

What Jev must NOT do:
- Decide a test passed or failed
- Silently heal or rewrite a test
- Approve production
- Receive raw secrets, cookies, PII-laden screenshots, or untrusted page text

## Classification Schema

Each test produces one Jev `systemOne` call:

```typescript
interface ClassificationInput {
  spec_file: string;
  test_title: string;
  page_route: string;
  page_criticality: number;     // 0-15, from Axis 1
  persona_count: number;
  action_type: string;          // "security_critical"|"destructive"|"stripe"|"escalation"|"readonly"
  flake_days: number;           // -1 = never flaked
  duplicate_count: number;
  wave_historical: boolean;
  test_code_length: number;
  catch_false_count: number;
}

// Jev questions per test:
questions: {
  classification: Choice(
    "Classify this E2E test into one of three tiers.",
    {
      superfluous: "Remove now — redundant, dead, or below threshold",
      meaningful: "Retain with named invariant — meets minimum coverage",
      critical: "Retain AND promote — cross-browser, quarantine-excluded"
    }
  ),
  confidence: Score(
    "How confident is this classification?",
    ["low", "medium", "high"]
  ),
  migration_candidate: Noul(
    "Can this test's assertions be migrated to Vitest without losing coverage?",
    { true: "Pure math, schema, or permission logic", false: "Browser-dependent" }
  )
}
```

State sent to Jev must be **redacted**: no raw auth cookies, no
screenshots with PII, no untrusted page text. Preprocess and normalize
before sending.

## Workflow

### Step 1: Locate or produce classification inputs

Look for the file produced by `priceless-test-categorization`:
`docs/audit/test-categorization-batch.json`. If not found, invoke
`priceless-test-categorization` first (load that skill and follow its
workflow), then return here.

### Step 2: Validate prerequisites

1. Check `TYPESAFE_API_KEY` is set. If not, ask the user to set it
   or offer `--dry-run`.
2. Check `@typesafe-ai/sdk` is installed. Try `npm ls @typesafe-ai/sdk`
   or equivalent. If not, explain to the user: "This skill requires the
   TypeSafe AI SDK (`npm install @typesafe-ai/sdk`). I can run in dry-run
   mode instead, which will show you the classification inputs without
   calling Jev."
3. Pin the Jev model version: use `jev-1.13.0` (not `jev-latest`). The
   alias moves when a new version ships; pinning ensures threshold-tuned
   behavior doesn't silently change.

### Step 3: Calibration (first use only)

If running Jev for the first time against this project:

1. Limit to 200 randomly sampled tests: pick every Nth entry from the
   batch to get a representative spread across page criticality tiers.
2. Run the 200 through Jev.
3. For each result, record: classification, probabilities, confidence,
   latency, and cost.
4. After all 200 complete, produce a calibration report:
   - Distribution of classifications (superfluous / meaningful / critical)
   - Distribution of confidence levels
   - Tests flagged as migration candidates
   - Tests with confidence < 0.5 (human review required)
   - Latency percentiles (p50, p95, p99)
   - Approximate cost (200 classifications × $0.042/Mtok)

Present the calibration to the user and ask whether to proceed to the
full fleet (remaining N-200 tests) or adjust thresholds.

### Step 4: Fleet classification

After calibration approval, classify the remaining tests. Stream results
to a JSONL file (`docs/audit/test-categorization-jev-results.jsonl`),
one object per line:

```json
{"spec_file":"...","classification":"critical","confidence":0.87,"probabilities":{"superfluous":0.02,"meaningful":0.11,"critical":0.87},"migration":false}
```

### Step 5: Aggregate and report

After all classifications complete:

1. Merge calibration and fleet results into a single summary.
2. Produce a markdown report with:
   - Classification distribution (superfluous / meaningful / critical counts
     and percentages)
   - High-confidence vs. low-confidence splits
   - Migration candidates (count and examples)
   - Top retirement candidates (high-confidence SUPERFLUOUS)
   - Top promotion candidates (high-confidence CRITICAL)
   - Flagged-for-review tests (low-confidence, any tier)
3. Save to `docs/audit/test-categorization-jev-report-YYYY-MM-DD.md`.

### Step 6: Human review gate

Jev's output is **advisory only**. All actions require human confirmation:

- SUPERFLUOUS classifications: do not delete tests automatically
- CRITICAL classifications: do not change CI configuration automatically
- Low-confidence results: require explicit human review
- Never fail CI solely because Jev is unavailable or uncertain

Always present the report and ask: "I've classified N tests. X% are
SUPERFLUOUS, Y% MEANINGFUL, Z% CRITICAL. Z% are low-confidence and need
your review. Would you like me to prepare a batch of retirement candidates,
or review specific categories first?"

## Dry-run mode

If Jev is unavailable (no API key, no SDK, or user requests `--dry-run`),
print the classification inputs as JSON:

```bash
# Dry-run: prints classification inputs without calling Jev
cat docs/audit/test-categorization-batch.json | head -200
```

Report: "[dry-run] N classification inputs ready for Jev. Set TYPESAFE_API_KEY
and install @typesafe-ai/sdk to run full classification."

## Error handling

- **429 (rate limit)**: Retry with backoff. Jev rate limits are dynamic
  (250k tokens/sec, 1,200 requests/min nominal). If 429s persist, report
  and ask whether to continue at reduced concurrency.
- **Jev unavailable**: Fail open. Report the failure and fall back to
  the rule-based categorization from `priceless-test-categorization`.
  Never block CI or deployment on Jev availability.
- **Low confidence (< 0.5)**: Flag for human review. Do not act on these.
- **Model alias drift**: If using `jev-latest`, log which versioned model
  responded. Prefer `jev-1.13.0` pinned.

## Principles

- Jev is a classification sidecar, not a test oracle
- Confidence is a distribution statistic, not a correctness probability
- Adversarial state can steer Jev — redact before sending
- Never send raw auth cookies, PII, or untrusted page text as state
- Fail open on unavailability — default to rule-based categorization
- Pin model version for threshold-tuned behavior
- Calibrate on labeled data before scaling to the fleet