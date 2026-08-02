# Workflow lease

Use a workflow lease when apply work needs coordinated ownership of mutable resources across
sessions or harnesses. The shared standard defines outcomes and invariants. Each active harness
supplies its own identity adapter and talks to the common authority; this package does not ship a
broker, command, hook, daemon, or writable store.

## Resolve one authority

Resolve the same coordination namespace and atomic authority for every participant targeting the
same repository or external resource identity. An adapter using a private store cannot claim
cross-harness exclusion. If the authority is unavailable, acquisition and mutation fail closed;
cached inspection data is informative only.

Before mutation, canonicalize the complete resource set, including all repositories, paths, refs,
indexes, migration targets, deployment environments, credentials, services, release channels, and
other mutable effects. Sort and acquire the whole set atomically. Grant all resources or none of
them. Do not acquire incrementally: partial grants can deadlock and do not establish authority for
the workflow.

Disjoint execution resources may run concurrently. Shared persistence surfaces still require a
separate finalization slot before commit, push, migration, deployment, or release.

## Attribute owner and creator separately

The owner identifies the accountable root workflow session for the entire lease lifetime:

- `harness_id`: an open, non-empty harness identifier;
- `session_id`: the stable root session identifier;
- `session_id_source`: `native` when supplied by the harness or `adapter` when a stable surrogate
  maps to durable recovery state;
- `process`: optional root-process diagnostics containing host, boot, PID, and process start.

Never emit `unknown` as an owner or substitute a transient child PID for the root session. If a
native session identifier is unavailable, the adapter must mint a stable, traceable surrogate.

The creator identifies the actor that issued acquisition on the owner's behalf. It may contain an
agent identifier, parent-agent identifier, and creator-process diagnostics. A child remains a
creator; it does not silently become the root owner. Omit unavailable identity fields and record
the capability as unavailable instead of inventing evidence.

Process identity is diagnostic only. Treat host, boot, PID, and process start as one tuple because
PIDs are local and reusable. A dead process does not authorize early takeover, and a living process
does not keep an expired lease authoritative.

## Use owner-bound authority and fences

On acquire, mint an opaque owner credential and return it only to the adapter. Durable lease state
stores the owner credential digest, never the raw credential. Also issue a monotonic fence. Every
mutation and finalization boundary must verify the current fence; takeover advances it so an older
holder can never resume authority.

The coordination authority clock alone determines expiry. Adapter clocks are display-only. A
lease is live only while authority time is earlier than `expires_at` and owner-bound renewal
succeeds.

## Operation outcomes

Adapters may choose their transport and command shapes, but these observable outcomes are fixed:

| Operation | Required inputs | Outcome |
| --- | --- | --- |
| `acquire` | Namespace, complete resources, owner, creator, requested TTL | Grants the full lease, owner credential, and current fence, or returns bounded conflict evidence with no mutation authority. |
| `inspect` | Namespace plus a resource or lease selector | Returns conflicting resources, owner and creator attribution, acquisition and expiry times, and the non-secret fence. |
| `renew` | Lease ID, owner credential, and current fence | Extends expiry while preserving owner, creator, resources, acquisition time, and fence, or refuses the request. |
| `release` | Lease ID, owner credential, current fence, and terminal outcome | Idempotently closes the current lease without affecting a newer holder. |
| `takeover` | Expired lease plus a new complete acquire request | Atomically confirms expiry, issues a newer fence, and permanently rejects the old authority. |
| `finalize` | Live execution lease plus finalization resources | Grants a short slot for shared closeout without replacing or extending the execution lease. |

Renew and release require both valid owner authority and the current fence. Repeating a valid
release returns the already-closed result. A wrong owner, stale credential, stale fence, or expired
execution lease cannot renew, release, mutate, finalize, commit, push, deploy, or publish.

## Inspect without leaking authority

A conflict response should identify:

- the coordination namespace, lease, and canonical conflicting resources;
- owner harness, stable root session, and `session_id_source`;
- acquisition, renewal, and expiry times;
- available root-owner and creator process diagnostics;
- bounded workflow labels and the current non-secret fence.

Never include the raw owner credential, prompts, commands, environment values, file contents, or
served content in inspection, logs, or audit events. Store only a credential digest suitable for
equality verification.

## Recover and finalize safely

An expired or taken-over owner becomes read-only. Reconcile repository baselines, commits,
deployments, migrations, releases, and terminal records before requesting a new lease. Do not
repeat an externally visible effect unless durable evidence proves it did not complete or its
documented idempotency makes repetition safe.

Keep the execution lease live through required persistence or recorded recovery. Use a short-lived
finalization slot for shared indexes, target refs, migration targets, deployment environments, and
release channels. After obtaining that slot, refresh the baseline and recheck the execution fence.
Failure records recovery evidence and releases or expires the slot; it never makes an incomplete
execution lease completed.

Cooperative leases cannot stop direct or uninstrumented writes. Baseline drift checks remain the
backstop: reconcile unexpected effects, refuse unsafe persistence, and reacquire authority only
after the durable state is understood.
