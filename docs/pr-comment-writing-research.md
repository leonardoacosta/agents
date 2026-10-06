# Pull request comment-writing research

Evaluated 2026-10-05. Scope: inline reviewer comments, review summaries, and author replies. This is a source-based evaluation, not an empirical benchmark or a marketplace-wide survey. No third-party skill was installed and no PR comment was published.

## Recommendation

Reuse the installed `adversarial-code-review` for finding real defects and `receiving-code-review` for author replies. Add the small writing contract below rather than installing another broad review skill. Conventional Comments is the strongest direct formatting source; Google's reviewer guidance is the strongest rationale and tone source.

## Candidate evaluation

| Candidate | Fit | Useful material to mine | Limitations / decision |
| --- | --- | --- | --- |
| Installed `adversarial-code-review` | High for review findings | Verified defects, exact snapshot, requirements-first review, read-only boundaries | Review methodology, not a dedicated prose skill. Reuse as evidence layer. |
| Installed `receiving-code-review` and [obra upstream](https://github.com/obra/superpowers/blob/main/skills/receiving-code-review/SKILL.md) | High for author replies | Verify before accepting; explain disagreement technically; report actual fixes; avoid performative praise | Primarily receiving feedback. Its blanket ban on thanking reviewers is stronger than necessary. Mine evidence-first replies, not rigid interpersonal rules. |
| [Sentry `code-review`](https://github.com/getsentry/skills/blob/main/skills/code-review/SKILL.md) | Medium-high for reviewer comments | Explain why; concrete alternatives; distinguish blocking issues from suggestions; avoid complete rewrites | Sentry-specific context and examples. Question-first advice should not disguise a confirmed blocker as optional. Mine, do not install wholesale. |
| Installed `writing-guidelines` | Medium | Clear wording and concise structure | General documentation guidance; does not establish defect evidence or review severity. Supplemental only. |
| Installed `no-ai-slop` | Medium | Remove boilerplate, inflated certainty, generic praise | Editing layer only. Do not erase necessary caveats or technical precision for style. |
| [Conventional Comments](https://conventionalcomments.org/) | Very high for inline format | `issue`, `suggestion`, `question`, `nitpick`, `praise`; explicit blocking/non-blocking intent | A standard, not an agent skill. Labels cannot substitute for a demonstrated defect. |
| [Google: Writing review comments](https://google.github.io/eng-practices/review/reviewer/comments.html) | Very high for communication | Be kind; explain why; guide rather than take over; label optional points; discuss code, not people | Engineering guidance, not an installable skill. Best source to mine for prose. |

Local sources: `~/.agents/skills/{adversarial-code-review,receiving-code-review,writing-guidelines,no-ai-slop}/SKILL.md`. Local versions may differ from upstream.

## Mined writing contract

1. Verify the behavior before writing a finding. Identify the exact file/line or code path, triggering condition, and observable consequence. Separate confirmed defects from questions.
2. Write one concern per comment. Open with the concrete problem, not a generic compliment or a restatement of the diff.
3. Explain why it matters. Include a reproducible input, violated requirement, test, or concise causal chain when available. Never invent test results or line numbers.
4. Make intent explicit: `issue (blocking)` for a demonstrated merge blocker, `suggestion (non-blocking)` for an optional improvement, `question` for unresolved information, and `nitpick (non-blocking)` for minor style. Follow repository severity conventions when they already exist.
5. Request the smallest useful correction. Suggest a direction without unnecessarily rewriting the author's implementation. Use a GitHub suggestion block only for a precise replacement you have checked.
6. Be direct about confirmed defects. Use genuine questions for uncertainty, not polite-sounding questions that obscure a mandatory correction.
7. Discuss behavior and tradeoffs, not the author's competence, intent, or use of AI. Specific praise is optional, never a quota.
8. Avoid repeated comments about one root cause. Put broad concerns in the review summary and point to representative lines.
9. In author replies, distinguish implemented, investigated, deferred, and disputed feedback. Name the changed behavior and actual verification. Do not say “fixed” before verifying.
10. Drafting does not authorize publication, approval, merging, issue-state changes, or remote mutations. Never include secrets or unrelated private context.

## Templates and examples

Examples below are illustrative, not findings against an actual PR.

### Confirmed finding

```text
issue (blocking): The retry path can charge the same invoice twice.

If the provider accepts the first request but the response times out, this path
creates a new idempotency key for the retry. The provider treats that as a new
charge. Reuse the invoice's key across attempts and add a timeout-after-accept test.
```

### Optional improvement

```text
suggestion (non-blocking): Name this `pendingInvoices` to match the filter.

The current name implies it contains paid invoices too. No behavior change needed.
```

### Genuine uncertainty

```text
question: Can this callback run after the connection closes?

I could not find a lifecycle guarantee at the caller. If it can, this access needs
a closed-state check; otherwise, please point to the guarantee.
```

### Author reply after verification

```text
Reused the invoice idempotency key across retries in <commit>.
The timeout-after-accept regression test passes with the change and fails without it.
```

Use that test statement only if both runs actually occurred. Otherwise report what was run and its limits.

### Evidence-backed disagreement

```text
I kept this check because the public caller accepts an empty list, unlike the
internal caller. <test or contract reference> covers that case. Removing the check
would return <observed incorrect result>.
```

### Review summary

```text
Reviewed <snapshot> against <requirement>.
Blocking: <count and short root-cause descriptions>.
Non-blocking: <optional improvements, if any>.
Verification: <checks actually run>. Not checked: <relevant limits>.
```

Do not manufacture zero findings, approval, or a ship verdict from prose review alone.

## Evaluation checks

Before publishing a draft, check:

- Could the author identify the location and reproduce the concern?
- Does each blocking comment demonstrate a real consequence?
- Are uncertainty and optional suggestions labeled honestly?
- Is the requested correction bounded and actionable?
- Are replies supported by actual changes and verification?
- Is the comment free of personal criticism, boilerplate, secrets, and unrelated work?

## Research limits

Firecrawl CLI was unavailable on this host. Built-in web search hit an anti-bot challenge, so external acquisition used known public URLs through `webfetch`. Sentry's initially guessed plugin path returned 404; the repository's `skills/code-review/SKILL.md` path succeeded. Candidate evaluations cover inspected text, not installation safety, upstream licensing for redistribution, or measured performance. This document paraphrases the sources rather than vendoring their skills.
