# Skill Benchmark: ropen-preview

**Model**: <model-name>
**Date**: 2026-08-07T16:11:50Z
**Evals**: 1, 2, 3 (1 dry run per configuration)

## Summary

| Metric | With Skill | Without Skill | Delta |
|--------|------------|---------------|-------|
| Pass Rate | 100% ± 0% | 67% ± 38% | +0.33 |
| Time | 0.0s ± 0.0s | 0.0s ± 0.0s | +0.0s |
| Tokens | 0 ± 0 | 0 ± 0 | +0 |

## Analyst notes

- The strongest gain is transport discovery for a new remote preview: the baseline proposed another HTTP server, while the skill selected `ropen` and private runtime state.
- The refresh and missing-command prompts name `ropen` directly, so they are intentionally non-discriminating near-misses. They validate stable-path refresh and no-fallback safety behavior.
- Evaluations were plan-only to avoid browser, server, and network side effects. Timing and token telemetry were unavailable from the collaboration harness.
