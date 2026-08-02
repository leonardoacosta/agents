# Durable recovery

## Reconstruct before resuming

Treat a conversation summary as context, never as authoritative workflow state. Re-read repository
guidance, proposals, tasks, issues, decisions, authorization records, commits, working-tree state,
archives, validation output, deployments, and harness-owned checkpoints. Compare them to the
recorded baselines before choosing the next action.

Classify every expected mutation or task as not started, verified partial progress, completed,
conflicting, or unverifiable. Preserve attributable verified work, reconcile safe drift, and stop
when another owner or incompatible change has claimed the same mutable resource.

## Avoid duplicate effects

Before repeating an externally visible action, inspect the destination or its idempotency record.
Repeat only when durable evidence proves the earlier attempt did not reach its terminal effect, or
when the operation's documented idempotency makes repetition safe. A timeout or missing chat reply
does not prove failure.

## Resume the minimum unfinished scope

Restart from the earliest unmet dependency, not from the beginning of the feature. Re-run stale
validation whenever inputs changed. Keep completed task claims only when their underlying evidence
still matches the current bytes and environment.

If durable sources disagree, name the conflict and preserve both sides. Do not manufacture a clean
state, discard another owner's edits, or infer completion merely to continue.

## Recover after lease loss

When a workflow lease expires or a takeover advances its fence, treat the former owner as
read-only. A stale fence cannot authorize mutation, finalization, release, commit, push, deploy, or
publish. Inspect the current holder and reconcile attributable repository and external effects
before requesting a new lease. A living PID does not restore authority, and a dead PID does not
prove that takeover is safe before expiry.

Cooperative coordination cannot prevent an uninstrumented writer from bypassing the lease. Detect
that case through fresh baseline and destination checks, preserve both sides when ownership is
unclear, and resume only after durable effects and the current fence agree.
