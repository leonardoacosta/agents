# Feature-queue lifecycle

## Derive the queue

Build the selected set from authoritative proposal, issue, and recorded-precondition evidence.
Recompute rather than trusting a conversational list. Remove already completed or terminally
dispositioned work, then order dependencies before dependents. A feature is ready only when every
required predecessor has reached the state its dependency declares.

## Schedule safely

Dependency-independent work is not automatically concurrency-safe. Before co-scheduling
independent work, inspect shared files, repositories, migrations, deployments, credentials,
environments, services, and other mutable resources. Serialize conflicts unless the execution
environment proves isolation.

Use the complete single-feature lifecycle for every queued feature. A queue does not weaken
preflight, verification, issue, archive, or persistence requirements.

## Recompute after every terminal event

After a feature completes or fails, rebuild the ready set from durable state. Newly satisfied
dependents may enter the queue. A failed feature receives its truthful outcome; its dependents are
blocked or skipped with the causal edge. Other independent work may continue only when its
authority and mutable resources remain safe.

## Resume after interruption

Read proposals, tasks, issues, commits, archives, and harness-owned checkpoints. Preserve verified
partial progress, avoid repeating terminal external effects, and restart only unfinished work.
Never infer queue completion from the prior session's summary.
