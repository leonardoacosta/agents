# Skill journal protocol

Use `~/.agents/skill-journal.jsonl` as the append-only governance sidecar for the tool-owned
`~/.agents/.skill-lock.json`. Read the lock; never write it outside `npx skills`.

## Schema v1

One JSON object per line, four event types:

```jsonl
{"v":1,"ts":"2026-08-01T00:00:00Z","event":"intake","skill":"firecrawl-scrape","source":"firecrawl/cli","suite":"firecrawl","rationale":"web scraping for research tasks","review_by":"2026-10-30"}
{"v":1,"ts":"...","event":"review","skill":"firecrawl-scrape","verdict":"retain|promote|remove","evidence":"session-forensics: 14 dispatches since install; skill-judge 92/120","next_review_by":"..."}
{"v":1,"ts":"...","event":"promote","skill":"...","target_package":"firecrawl-kit","proposal":"<change-id>"}
{"v":1,"ts":"...","event":"remove","skill":"...","via":"npx skills remove <name>"}
```

Rules: `intake` is required before or at first review; `review` events are never rewritten —
a changed mind is a new `review` event; suite verdicts are recorded as one `review` event per
member skill sharing the same `evidence` string plus a `suite` field.

## Write rules

- Append exactly one complete JSON object followed by a newline.
- Use UTC ISO-8601 timestamps for `ts` and ISO dates for review fields.
- Keep `verdict` to `retain`, `promote`, or `remove`.
- Add `next_review_by` only when another review is expected.
- Put the suite tag on each member's suite-review event.
- Do not add `installedAt`, `updatedAt`, `skillFolderHash`, or `localPatch`; resolve them from the
  lock when reading.
- Validate the new object with `jq -e` before appending it. Never repair a bad line by rewriting
  history; append a superseding event after preserving the original evidence.

Example safe append:

```bash
event=$(jq -cn \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg skill "$skill" --arg source "$source" --arg suite "$suite" \
  --arg rationale "$rationale" --arg review_by "$review_by" \
  '{v:1,ts:$ts,event:"intake",skill:$skill,source:$source,suite:$suite,rationale:$rationale,review_by:$review_by}')
printf '%s\n' "$event" >> ~/.agents/skill-journal.jsonl
```

## Read lock facts

Read `installedAt` and `localPatch` without mutating the lock:

```bash
jq -r '
  .skills | to_entries[]
  | {skill:.key, source:.value.source, installedAt:.value.installedAt,
     localPatch:(.value.localPatch // null)}
' ~/.agents/.skill-lock.json
```

## Read latest verdicts

Slurp the journal and select the latest review event per skill:

```bash
jq -s '
  map(select(.v == 1 and .event == "review"))
  | sort_by(.skill, .ts)
  | group_by(.skill)
  | map(last)
  | map({key:.skill, value:.})
  | from_entries
' ~/.agents/skill-journal.jsonl
```

This query derives current review state without erasing history. Join its result to the lock by
skill name whenever installation timestamps, content hashes, or patch state are needed.

## Suite verdict recording

Use one shared evidence string for every member reviewed together. State the suite default and
name exceptions in that string, then append one `review` object per member. The journal never uses
`suite-remove` as a `verdict`; suite removal is the shared assessment, while each member records
one of the three schema verdicts.

## Recovery

If an append is interrupted, inspect the final line before retrying. Append the missing complete
event only when the existing last line is valid and distinct. Do not truncate, reorder, or
deduplicate prior events. If the journal and lock disagree, treat the lock as authoritative for
installation facts and the journal as authoritative for lifecycle intent, then append a review or
removal event that records the observed reconciliation.
