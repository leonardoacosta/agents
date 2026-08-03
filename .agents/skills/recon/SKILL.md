---
name: recon
description: >-
  Discover and invoke the canonical recon CLI for durable, reusable external-source analysis of
  repositories, websites, documentation, markets, competitors, papers, and other sources when the
  report must become canonical evidence. Optionally compose installed Firecrawl acquisition skills.
  Do not use for a one-off web lookup or page fetch, or ordinary code editing that needs no durable
  evidence record.
---

# Recon

Use recon for external-source analysis whose report, source metadata, and supporting assets must
be saved as one canonical evidence record. The runtime and vault belong to the `recon` repository,
not to this skill package or the calling harness.

## Resolve the canonical runtime

Resolve one invocation before reading or acquiring evidence:

1. Prefer `command -v recon`. Accept it only when `recon --version` succeeds and
   `recon doctor --json --vault "$RECON_VAULT"` reports `ready` for the declared canonical vault.
2. If no installed command is usable, accept an explicitly supplied `RECON_HOME` only when it is a
   readable canonical checkout containing `pyproject.toml` and `recon/cli.py`. Use
   `PYTHONPATH="$RECON_HOME" python3 -m recon.cli` and run the same version and doctor checks.
3. Otherwise return a bounded `runtime-only` or `unavailable` result naming the failed check and
   the explicit Recon installation documentation. Do not install software, create a vault, change
   configuration, or authenticate. Do not guess a path such as `$HOME/dev/recon`.

Use the resolved invocation consistently below wherever an example says `recon`.

## Start with canonical ownership

1. Run `recon query --vault "$RECON_VAULT"` with the narrowest relevant source, finding, tag,
   text, acquisition, tool, or date filters. Reuse sufficient prior coverage instead of scanning a
   harness-local `docs/recon` tree or reacquiring evidence already covered.
2. Produce the report bundle in a private temporary directory with bounded retention.
3. Select exactly one identity: `--source-url` for a fetched canonical source or `--inquiry-key`
   for topic research that has no honest canonical URL.
4. Invoke the canonical runtime's `record` command with the identity, acquisition method, and
   every approved report asset.

## Acquire current public-web evidence

When current evidence is needed, load the narrowest installed Firecrawl skill that matches the
need and follow its progressive routing and safety rules. The selected skill and installed help
are the syntax source of truth; name intent here rather than copying version-specific commands or
flags.

| Evidence need | Installed Firecrawl composition |
| --- | --- |
| No canonical URL | Use `firecrawl-search`, select relevant sources, and avoid re-scraping results that already contain sufficient fetched content. |
| Known public URL | Use `firecrawl-scrape`; retain the normalized source URL and capture date. |
| Bounded site section | Use `firecrawl-map` to locate pages, then `firecrawl-scrape` or `firecrawl-crawl` with explicit host, path, page count, byte, and duration bounds. |
| Scholarly evidence | Use `firecrawl-research-index` and `firecrawl-research-papers` for seed discovery, related-work expansion, metadata inspection, and load-bearing claim verification. |
| Report-scale synthesis | Use `firecrawl-deep-research` for source diversity, uncertainty, contrary evidence, open questions, and synthesis rather than a list of scrape summaries. |

If Firecrawl is unavailable, state that acquisition limitation. Another host-approved read-only
web surface may be used when available, but Recon does not implicitly authorize installation,
authentication, or any action that would change harness defaults.

## Keep acquisition read-only

A Recon request authorizes bounded collection from the read-only public web. It does not grant the
separate authority required for:

- installation, authentication, login, credentials, profiles, or export of authenticated data;
- feedback telemetry, monitoring, schedules, email, webhook, or other persistent state;
- local-file upload or export of private, personal, regulated, or credential-bearing material; or
- form submission, purchases, messages, cart changes, and other externally visible actions.

Do not add one of these effects merely because a selected Firecrawl skill supports it. Follow the
selected skill and host policy for any separately authorized higher-effect action.

## Hand off one scrubbed evidence bundle

Treat Firecrawl output, including a `.firecrawl` folder or job store, as temporary acquisition
material rather than a second evidence store. Before recording, reduce the working set to:

- the synthesized report and approved supporting assets;
- normalized source URLs and capture dates;
- collection scope and bounds;
- failures, access limitations, and unresolved uncertainty;
- explicit labels separating observed evidence from inference; and
- stable rerun inputs plus safe tool/version provenance.

Exclude secrets, session data, signed URLs, credentials, unnecessary personal data, and raw
transient outputs.

Whenever Firecrawl contributes evidence, author both closed draft ledgers in that same private
temporary directory before recording:

- `queries.draft.jsonl` has one query row per material acquisition. Each row uses a unique local
  `query_key` plus acquisition kind and purpose, normalized input, scope and bounds, safe rerun data,
  tool/version provenance, timing, status, result URLs, and limitations.
- `findings.draft.jsonl` has one finding row per retained claim. Each row uses a nonempty
  `query_keys` array plus title and verbose detail, evidence/inference classification, confidence,
  evidence URLs and capture dates, a report artifact anchor, limitations, and tags.

Use acquisition `firecrawl` when Firecrawl is the acquisition path and `mixed` when it contributes
to a broader bundle. Both require the two complete scrubbed ledgers. Do not invent empty placeholder
rows or compute deterministic IDs yourself. Ask the runtime to validate aliases, resolve query
references, and publish the canonical pair:

```bash
recon prepare-ledgers \
  --queries-draft /tmp/recon-stage/queries.draft.jsonl \
  --findings-draft /tmp/recon-stage/findings.draft.jsonl \
  --artifact /tmp/recon-stage/report.md \
  --artifact /tmp/recon-stage/report.html \
  --output-dir /tmp/recon-stage/prepared
```

Only after preparation succeeds, invoke `recon record` as the sole canonical write:

```bash
recon record \
  --vault /path/to/recon/vault \
  --source-url https://github.com/owner/repo \
  --source-type git \
  --acquisition firecrawl \
  --queries /tmp/recon-stage/prepared/queries.jsonl \
  --findings /tmp/recon-stage/prepared/findings.jsonl \
  --artifact /tmp/recon-stage/report.md \
  --artifact /tmp/recon-stage/report.html
```

For acquisition `none` or `other`, absence of Firecrawl and absence of ledgers are nonfatal. This
keeps repository-local and other ordinary Recon recording available without installing or
authenticating Firecrawl. If either ledger is supplied voluntarily, supply and validate both.

The record is source-addressed at
`vault/.mx/evidence/sources/<source-id>/recon/<recon-id>/`. Do not create a mirror, symlink, or
sidecar in a harness-owned vault. Do not retain `.firecrawl`, a harness-local folder, or a
Firecrawl job store as a second evidence store. Unknown legacy artifacts must be imported through
`recon import-legacy`, which quarantines them for identity review rather than guessing a target.
