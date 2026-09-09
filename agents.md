# Agentic Workflow

## Communication

- Always talk in ASD-STE100 Simplified Technical English. Always read CONTEXT.md files, and use their ubiquitous language

## Execution Mode

- Continue autonomously through the next logical steps once the user has authorized execution.
- Do not pause for progress checkpoints, interim summaries, or confirmation between already-requested steps.
- Only interrupt the user when blocked by a real decision, a destructive or irreversible action not already approved, or a conflict that risks damaging unrelated user changes.
- Otherwise, keep executing until the task is complete, then report results.
- When a CI run, test run, deploy, or monitorable workflow fails, automatically pull all relevant failure logs without waiting for the user to ask.
- Immediately after pulling logs, group failures into likely shared domains or root-cause clusters, then investigate each cluster until a reasonable lead is established.
- Once a reasonable lead is found, continue implementing and verifying the remediation when autonomous execution has already been authorized.
- The only reason to stop an otherwise autonomous run for approval is when the proposed fix would conflict with codified standards, best practices, or established project conventions.
- When such a conflict exists, stop, identify the conflict explicitly, and present the compliant alternatives or the exception that would need approval.

## OpenSpec + Beads Workflow

This file is the user-level source of truth for how proposals, implementation, issue tracking, and workflow completion relate across repositories.

### Canonical units

Use the same three units everywhere:

- **Epic**: a long-lived capability area
- **Feature**: one OpenSpec change proposal under `openspec/changes/<slug>/`
- **Task**: one scoped execution unit under a feature, or one small ad-hoc bead when proposal ceremony is not warranted

Do not create a second execution ledger. Advisory notes, plans, and scratch artifacts may inform the work, but they are never authoritative workflow state.

### Canonical lanes

There are only two lanes:

1. **Proposal lane**
   - Use this for behavior changes, multi-file work, multi-step rollout, architecture changes,
     schema changes, contract changes, or anything that benefits from explicit decomposition.
   - The authoritative design artifact is the OpenSpec proposal.

2. **Ad-hoc lane**
   - Use this only for small, bounded work that does not need proposal ceremony.
   - If there is real ambiguity, route to the proposal lane instead of ad-hoc execution.

### Disposition lane

Use `superseded` when a named replacement owns the intent, `deferred` when the intent is parked indefinitely pending a stated reopen condition, and `rejected` when the work is irrelevant or not worth doing. A dispositioned change carries exactly one marker (`SUPERSEDED.md`, `DEFERRED.md`, or `REJECTED.md`) and archives via `openspec archive <id> --skip-specs`. Close attached beads with a matching `superseded:`, `deferred:`, or `rejected:` reason prefix. Load the `change-disposition` skill for marker templates, dependent sweeps, verification, and closure mechanics.

### Canonical commands

These workflow verbs are the shared model:

- `explore`
- `feature`
- `apply`
- `apply:all`

### Command meanings

#### `explore`

`explore` assesses the request, gathers context, and determines the correct lane.

Expected outcomes:

- attach to existing work
- identify missing work
- recommend proposal lane vs ad-hoc lane
- surface blockers or ambiguity

`explore` does not create a second execution ledger.

#### `feature`

`feature` creates or updates the OpenSpec proposal artifact and completes the required closeout for
proposal authoring in that environment.

A `feature` run is not complete until:

- the proposal artifact is authored or updated correctly
- related issue state is updated when the workflow requires it
- required persistence or closeout for proposal authoring has succeeded

#### `apply`

`apply` executes one proposal from implementation through verification and finalization.

An `apply` run is not complete until all of the following are true:

- requested scope is implemented
- fresh validation evidence exists
- required issue state is updated
- the proposal is archived when the workflow requires archive-on-success
- required persistence or closeout has succeeded

#### `apply:all`

`apply:all` executes the queue of proposals in order, using the same completion contract as
`apply` for each one.

`apply:all` must:

- use authoritative workflow state, not chat memory, to determine what is next
- continue autonomously through already-requested work
- stop only for real blockers, policy conflicts, or user decisions that cannot be resolved locally
- avoid ceremonial pauses between already-requested items

### Portable beads doctrine

When a repository uses beads, `bd` is the canonical issue tracker and workflow ledger.

#### Required behavior

- Use `bd` for task tracking.
- Do not use markdown TODO files or alternate task trackers as a second ledger.
- Run `bd prime` when entering a beads-backed repository unless tighter repository instructions already define the entry path.
- Before substantial scoped execution, attach to or claim the active bead when the workflow supports it.
- Keep bead state current as work moves from intake to execution to completion.
- Create follow-up beads for real remaining work; do not hide remaining scope in prose.

#### Portable label families

The shared workflow recognizes these label families:

- `owner:<agent-or-person>`
- `type:<work-domain>`
- `source:<workflow-origin>`
- `hitl:<state>`
- `standalone`

Extend these only when repository workflow genuinely requires more specificity.

#### Workflow invocation authorization

An explicit user invocation of a documented workflow skill, command, or prompt counts as an explicit request for every action that its published completion contract declares required. This includes commit, Git push, and Beads/Dolt persistence when the invoked contract requires them; do not ask for a second confirmation merely because a repository otherwise uses a conservative profile. Automatic skill selection without an explicit user invocation does not grant this authority.

The grant remains limited to the invoked workflow's declared scope and does not authorize force pushes, destructive cleanup, adoption of unrelated dirty changes, or bypassing required cross-repository and overlap gates. A current explicit prohibition such as “do not commit” or “do not push” still wins.

#### Session close and persistence

When a beads-backed repository requires closeout, work is not complete until the repository's beads and git persistence steps have succeeded.

Typical closeout may include:

- bead state updates
- archive of the implemented proposal
- `bd dolt push`
- `git push`

The active repository instructions decide which of those are mandatory, but agents must treat them as completion work, not optional cleanup.

### Completion contract

Work is not complete until the active lane's required closeout has succeeded.

For proposal-lane work, that means:

- artifact state is correct
- validation is fresh
- bead state is current when beads are in use
- archive is complete when required
- remote persistence is complete when required by the repository workflow

For ad-hoc work, that means:

- implementation is complete
- validation is fresh when the claim requires it
- issue state and remote persistence are complete when the repository workflow requires them

Do not stop at "code is written" or "tests passed" if the active workflow still requires archive, issue updates, or remote persistence.

#### Non-bypassable apply terminal gate

For `apply` and `apply:all`, verification, independent review, and archival are mandatory terminal states for proposal-lane work. They are not suggestions, cleanup, or model-selected skills.

The workflow must enter the terminal state only in this order:

1. Run fresh gates for the final diff and record their commands and results.
2. Run an independent review after those gates, against the final diff and requirements.
3. Repair blocking or actionable review findings and rerun affected gates and the review.
4. Update task and issue state from the verified result.
5. Commit the verified implementation and workflow-state changes with clear, scoped history.
6. Archive only after required tasks, fresh gates, independent review, and commits pass.
7. Confirm the archive, commit history, and required persistence succeeded before reporting completion.

If any state is missing, stale, failed, or unverifiable, the workflow is `blocked` or `in_progress`, never `completed`. A worker report, passing task-local test, clean-looking diff, or uncommitted working tree cannot substitute for the terminal gate. The final review must inspect the commit range and confirm task, proposal, and archive changes are in scope. Harnesses must not expose or honor a normal execution flag that skips verification, independent review, archive, or required commits. User-decision gates may park work, but they do not permit a completion claim.

## First-party web skills and local policy

For every `agent-browser` task, load `agent-browser-policy` and the installed CLI's
first-party `core` skill through the `agent-browser` loader. For every `firecrawl`
or `firecrawl-*` task, including direct specialized-skill invocation, load
`firecrawl-policy` alongside the selected official skill. The policy skills supplement
upstream workflows. They are not replacement command manuals.

Installed CLI help owns supported syntax. First-party skills own product workflows.
Local policy owns stricter consent, credential handling, transport, private identity,
and task-session boundaries. Upstream examples never authorize bypassing those rules.
If a capability or safeguard is unsupported, report the boundary rather than guessing
flags, exporting credentials, installing another transport, or changing harness defaults.

Keep official Firecrawl files unchanged. Record their reviewed catalog revision and
file digests in `skill-sources.json`, separate from installer-owned locks. Preserve
learned rules in the policy skills and host-specific identities outside this repository.
Load only the relevant official skill and references, not the entire installed suite.

## Skill discovery and installer provenance

Skill discovery and installer provenance are separate concerns. Native registries scan
`skills/<name>/SKILL.md`; harness-specific directories project selected entries through
links. Inspect actual discovery and `scripts/verify-skill-projections.sh` output rather
than assuming a lock entry proves loading or its absence prevents loading.

Use the installed `npx skills --help` for supported intake commands. The current CLI
owns its global lock at `${XDG_STATE_HOME:-$HOME/.local/state}/skills/.skill-lock.json`.
Older installations retain `~/.agents/.skill-lock.json`. Read the active lock for source
facts, never rewrite locks manually, and append governance events to
`~/.agents/skill-journal.jsonl` using the skill-intake-lifecycle protocol.

Record intended projections in `skill-projections.json`. Preserve locally owned paths,
verify canonical targets before creating missing links, and do not run a broad write
reconciliation when only one skill suite is authorized. Reload the native registry and
verify the requested names are discoverable after changing the materialized skill set.
