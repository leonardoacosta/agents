---
name: jcode-command-center-orchestration
description: >-
  Govern Jcode Command Center work that launches, observes, retries, cancels, approves,
  schedules, hands off, or settles Orca-backed execution. Use whenever a request combines
  Jcode initiatives, milestones, schedules, durable runs, approvals, or Command Center UI
  actions with Orca projects, worktrees, Runs, Tasks, Dispatches, workers, terminals, or
  lifecycle evidence. Load this policy bridge before `orca-cli` or `orchestration`; use the
  generic skills alone only when Jcode durable authority is not involved.
---

# Jcode Command Center Orchestration

Treat Jcode as the durable authority and Orca as the runtime authority. This skill decides
which Orca pattern is allowed and how evidence returns to Command Center. It does not copy
version-sensitive Orca commands. Load the matching generic Orca skill for mechanics.

## Start with authority

- Jcode owns initiatives, milestones, blockers, schedules, permissions, approvals,
  idempotency, rollback intent, checkpoints, and durable outcomes.
- Orca owns distinct canonical Project, Repository, and host/setup identity plus worktrees,
  Runs, Tasks, Dispatches, workers, terminals, gates, messages, and runtime health.
- Browser and desktop UI state is transient. It cannot settle durable outcomes.
- A runtime observation is evidence, not authority. Settle Jcode state only from a verified,
  correlated receipt that satisfies the declared preconditions.

Read [references/authority-and-identifiers.md](references/authority-and-identifiers.md) before
mapping identifiers or accepting a runtime-driven state transition.

## Select exactly one ownership pattern

1. **Full handoff**: true ownership transfer. Use `orca-cli` mechanics. Jcode records the
   durable command envelope, authorization/idempotency context, correlation, and verified
   final evidence without supervising intermediate lifecycle.
2. **Supervised Run/Task/Dispatch**: Jcode must monitor dependencies, gates, attempts,
   retries, or completion. Use `orchestration` mechanics.
3. **Direct terminal action**: narrow operator-driven work with no durable DAG. Use
   `orca-cli`; record only the durable action and resulting evidence required by policy.
4. **Observation only**: project runtime state without mutation.

Apply a **decision gate** as an orthogonal control when an ownership pattern must pause for
authorized human approval. Persist the approval in Jcode before forwarding it to Orca. A gate
does not replace the selected ownership pattern. For example, a supervised Run/Task/Dispatch
may also carry a decision gate.

Never silently downgrade a selected pattern. If the required runtime capability is missing,
return an unavailable or unsupported result and leave durable state unchanged.

Read [references/patterns-and-lifecycle.md](references/patterns-and-lifecycle.md) for the
selection matrix, schedule interaction, replay behavior, cleanup, and recovery.

## Preserve the complete identity envelope

Keep these domains distinct:

- Jcode initiative ID and Jcode run ID
- Orca Project ID, Repository ID, and environment/host ProjectHostSetup ID
- Orca Run ID as a namespace and inbox, not a scheduler
- Task ID for the work contract and Dispatch ID for one attempt and its lifecycle
- worktree and terminal handles for placement and routing
- correlation ID and idempotency ID
- runtime ID only as runtime-health metadata

Never place Orca runtime ID in a project-ID field. Resolve Project, Repository, and host/setup
identity separately through the version-matched Orca lookup surfaces. Scope paths to the
selected environment and host setup. Zero matches, multiple matches, command failure, or an
unknown schema means unresolved identity and a fail-closed result.

## Mutate safely

Before mutation, record durable intent, authorization, preconditions, correlation, and
idempotency. Offer only capabilities verified from the selected Orca runtime and adapter.
Do not invent a CLI command from memory.

Before selecting an executable pattern, report the capabilities exposed by both the live Orca
runtime and the installed Jcode adapter. The currently shipped status-only adapter is
observation-only: launch, retry, and cancel remain unavailable until separately implemented
and verified. Never infer adapter support from Orca CLI support alone.

On retry or cancellation, compare the current observed state with the command precondition.
On crash recovery, reconcile the stored idempotency envelope against Orca evidence before
issuing another dispatch. If worker termination is uncertain, abandon or fence the Dispatch
rather than claiming it stopped. Retain resources intentionally for live debugging. Release a
worker, terminal, or worktree only after settlement and verified cleanup evidence. Record each
released resource and mark any remainder recovery-required.

Read [references/capability-and-evidence.md](references/capability-and-evidence.md) before
implementing or approving a mutation.

## Project lifecycle evidence

Normalize messages, questions, heartbeats, gates, attempts, terminal health, completion,
escalation, retention, and release as ordered evidence scoped to the authenticated principal,
initiative, and Orca run. Unknown events remain visible but cannot mutate durable state.

A sequence gap triggers scoped replay. Authorization changes or expired retention invalidate
the cursor and require a fresh authorized snapshot. Never replay across principal, initiative,
or runtime boundaries.

## Scheduling

A schedule expresses durable eligibility, not an alternate executor. When triggered, use the
same pattern selection, permission, correlation, idempotency, and receipt-settlement path as
an interactive action. A retry creates a distinct dispatch attempt linked causally to the
original schedule and Jcode run.

## Required report

For any Command Center orchestration decision, report:

1. selected pattern and why
2. Jcode and Orca authority owners
3. canonical identity resolution status
4. command preconditions and idempotency scope
5. expected receipt or observation
6. durable state transition allowed after verification
7. cleanup or recovery obligation
8. unavailable-capability behavior
