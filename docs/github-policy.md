# Proposal publishing workflow contract

## Reusable policy tool

```bash
node scripts/github-policy.ts Priceless-Development/tribal-cities
node scripts/github-policy.ts OWNER/REPO --apply --policy @policy.json
node --test scripts/github-policy.test.mjs
```

Default mode reads repository settings, rulesets and Actions permissions through the authenticated `gh` CLI. It does not publish, alter rulesets, install workflows or provision credentials. Explicit apply supports only repository merge/cleanup booleans and read-only default workflow permissions; unspecified settings and review-approval permission are preserved. Supply only settings approved for that repository. An incomplete ruleset audit is not a passing compliance verdict. Apply is not transactional: inspect the repository if a write or readback fails.

The proposal classifier is a conservative path/status gate, not evidence of proposal semantics or authorization to push. Established conventions requiring workflow/content inspection (fork CI, trusted cleanup SHA, explicit production approval and verified issue linking) are not automatically installed by this initial settings tool.

**Status: not activated.** This document specifies a future workflow; it does not authorize direct pushes, configure a ruleset, or provide a working publisher. Do not add a workflow that implies publishing is enabled until its dedicated GitHub App identity, bypass configuration, and acceptance tests are in place.

## Purpose and rule boundary

Permit an explicitly dispatched, trusted workflow to publish **proposal documents only** to `dev`. Ordinary code changes continue through pull requests. Do not grant a broad actor bypass on the current `Protected delivery branches` ruleset: bypass applies to the rules in scope, not only to proposal paths, and would permit evasion of protections unrelated to this exception.

Instead, split the policy so a dedicated App can bypass only a narrowly scoped `dev` proposal-publishing ruleset (the PR/check exception). Keep deletion and non-fast-forward protections on `dev` in a separate ruleset with **no App bypass**. Keep `main` protected by its ordinary PR and required-check rules, with no publisher bypass; publishing must never target `main`. Preserve CODEOWNERS, review-thread, deletion, and non-fast-forward protections except for the explicitly authorized `dev` PR/check exception. Verify GitHub's effective ruleset composition before activation.

## Trust and credential boundary

- Run only from the workflow definition on the protected default branch, initiated by an authorized `workflow_dispatch`. Do not execute workflow code, scripts, or actions from the proposed source revision. Pin third-party actions to immutable commit SHAs.
- Pin both source and target base to explicit full commit SHAs at run start. Confirm the source is an allowed ref/repository and the requested base is the intended `dev` commit. Never silently retarget a stale request.
- A dedicated GitHub App is required for the exception. Install it only on `Priceless-Development/tribal-cities`, grant only `Contents: Read and write`, and add that App—not a human/admin role or the general Actions actor—as bypass actor only on the narrowly scoped proposal PR/check ruleset. The workflow must mint a short-lived installation token after all validation gates pass. Do not expose the App private key or token to source code, PR jobs, or untrusted content. Keep `GITHUB_TOKEN` read-only for validation; it is not the bypass credential.
- Do not use a PAT, repository-wide admin credential, broad Actions bypass, or a token that can bypass the main/deletion/non-FF protections. Audit App installation access and workflow dispatch permissions before enabling.

## Required validation before minting the token

Treat source content, paths, commit messages, metadata, and any generated proposal as untrusted data. Do not evaluate, source, render, execute, or follow instructions contained in proposal content. Do not run source-provided scripts, templates, build steps, or actions.

1. Resolve and pin the exact source SHA and the exact `dev` base SHA. Validate the base is still the expected target and reject unexpected repository/ref inputs.
2. Enumerate every changed path and mode across **every commit** in the proposed source range, including renames and copies. Reject the whole publication unless every changed entry is an allowed proposal Markdown file or approved proposal metadata file. Reject executable or mode changes, symlinks, submodules/gitlinks, binary files, deletions, path traversal, case/Unicode path ambiguities, and any rename whose old or new path is outside the allowlist. Do not infer safety from only the final tree or a filtered diff.
3. Validate proposal schema, size/count limits, encoding, and path normalization. Metadata may describe proposals only; it cannot select commands, refs, permissions, workflow files, or destination paths outside the fixed allowlist.
4. Confirm the generated commit contains only those validated additions/updates, has no unexpected file-mode or tree changes, and preserves original author attribution where available. The publishing App is the committer, not a replacement author. Do not rewrite or squash source commits without an explicit attribution-preserving design.
5. Only after all gates pass, mint the narrowly scoped installation token and construct a commit against the pinned `dev` base. Never include the token in logs, artifacts, outputs, or child-process environments beyond the Git push operation.

## Update and push behavior

Use a normal fast-forward push to `dev`; never force-push. Before pushing, verify the remote `dev` tip still equals the pinned base SHA. If it differs, refuse publication with a clear stale-base/conflict result and require a fresh dispatch/review. Do not automatically rebase, merge, retry against a moving tip, or overwrite conflicting updates. A rejected/non-fast-forward push is a hard stop. Preserve the source author attribution and record the exact source/base/result SHAs in a non-secret run summary.

## Activation and acceptance

This contract is not evidence that GitHub settings or workflow are configured. Before activation, verify the dedicated App installation, minimal permissions, bypass scope, and separation of the `dev` PR/check exception from non-fast-forward/deletion and all `main` protections. Perform acceptance in a disposable test repository or equivalent isolated branch/ruleset setup before enabling production publication.

Required acceptance cases:

- Valid proposal Markdown plus valid metadata publishes to `dev` only, with pinned SHAs, preserved author attribution, and no `main` access.
- Changes to code, workflow/config, a disallowed metadata field/path, or any mixed proposal+code range reject the **entire** publication.
- Renames (including outside-to-allowed and allowed-to-outside), symlink, submodule, executable/mode change, deletion, binary, malformed path, traversal, and ambiguous normalized path each reject.
- A changed `dev` tip, stale base, rejected push, and conflicting update refuse without rebase, force, or automatic retry.
- Malicious instruction-like content, scripts, templates, and action references remain inert and are never executed.
- Missing/invalid App credentials or insufficient permissions fail closed before a write; logs and summaries contain no credential material.
- The App can perform only the intended `dev` proposal update; it cannot bypass `main`, deletion, non-fast-forward, or unrelated required protections.
