# Review Domains

Use this reference after the fixed trunk routes an observable diff signal to a domain. Treat every item as a hypothesis to test, not a defect by itself.

Emit a finding only after identifying a concrete trigger, reachable failure or misuse scenario, actual behavior, expected behavior, and impact. Mark unavailable evidence **Unverified** instead of guessing.

## Contents

- [1. Requirement alignment and logic or edge cases](#1-requirement-alignment-and-logic-or-edge-cases)
- [2. API, dependency, command, and configuration authenticity](#2-api-dependency-command-and-configuration-authenticity)
- [3. Security and trust boundaries](#3-security-and-trust-boundaries)
- [4. Data integrity, transactions, concurrency, retries, and idempotency](#4-data-integrity-transactions-concurrency-retries-and-idempotency)
- [5. Performance and resource usage](#5-performance-and-resource-usage)
- [6. Compatibility, migrations, deployment, observability, and rollback](#6-compatibility-migrations-deployment-observability-and-rollback)
- [7. Verification and final-diff reinspection](#7-verification-and-final-diff-reinspection)

## 1. Requirement alignment and logic or edge cases

**Observable triggers**

- Detect changed behavior, branching, validation, state transitions, parsing, mapping, error handling, defaults, or public output.
- Detect a mismatch among the user request, issue, accepted design, public contract, implementation, and tests.

**Review**

- Map each explicit or defensible inferred requirement to the production path and credible tests.
- Trace accepted requirement changes to current problem evidence and rationale; check that they are not merely descriptions written to match the implementation.
- Trace the real caller-to-effect path rather than reviewing a helper in isolation.
- Check empty, null, zero, negative, minimum, maximum, overflow, duplicate, unordered, partial, malformed, and unexpected-input behavior where relevant.
- Check off-by-one boundaries, reversed predicates, short-circuit behavior, default branches, fallthrough, stale state, and incorrect units or time bases.
- Check whether error conversion loses status, type, retryability, context, or cleanup guarantees.
- Check whether a success result can be returned before the requested effect completes.
- Check whether comments, names, or tests describe behavior that production code does not implement.
- Check whether a fix handles only the supplied example while equivalent inputs still fail.

**Finding gate**

Demonstrate a reachable input or state that violates a supported requirement or an established invariant. Describe the observable consequence. Do not report a merely different implementation choice.

## 2. API, dependency, command, and configuration authenticity

**Observable triggers**

- Detect a new or changed library, import, method, annotation, protocol, endpoint, command, flag, environment variable, configuration key, generated client, or version constraint.
- Detect completion claims that depend on an external API, undocumented default, unavailable service, or generated artifact.

**Review**

- Verify that every referenced API, method, option, command, and configuration key exists in the version actually used by the project.
- Verify signatures, return types, exception behavior, async behavior, ownership, lifecycle, and thread-safety assumptions against source, installed artifacts, lockfiles, generated code, or authoritative documentation.
- For a changed public or protected extension point, inspect existing overrides and test subclasses, and verify behavioral semantics as well as compilation and call occurrence.
- Check for hallucinated APIs, copied examples from another major version, wrong import paths, misspelled keys, unsupported flags, and incompatible transitive versions.
- Check whether a dependency is declared in the correct module and runtime scope.
- Check whether default values differ across development, test, container, and production environments.
- Check whether a new command is available in the documented toolchain and works from the repository boundary claimed by the change.
- Check whether generated clients, schemas, or checked-in outputs were regenerated from the changed source and remain internally consistent.

**Finding gate**

Show that the referenced symbol, behavior, version, flag, or configuration is absent or materially different and that the affected path will fail or misbehave. If authoritative evidence is unavailable, mark the claim **Unverified**.

## 3. Security and trust boundaries

**Observable triggers**

- Detect authentication, authorization, sessions, tokens, cryptography, permissions, untrusted input, parsing, templating, file access, process execution, deserialization, network requests, redirects, uploads, downloads, or logging of sensitive data.

**Review**

- Identify each trust boundary and the principal, resource, action, and policy being enforced.
- Check authentication separately from authorization. Verify object-level and tenant-level access on every reachable path, including alternate methods and batch endpoints.
- Trace untrusted data into SQL, templates, shells, file paths, URLs, headers, logs, interpreters, and deserializers.
- Check injection, path traversal, unsafe archive extraction, SSRF, open redirects, request smuggling assumptions, insecure deserialization, prototype or object pollution, and unsafe regular expressions where applicable.
- Check validation order, canonicalization, encoding, allowlists, size limits, content type, and extension-versus-content mismatches.
- Check secret creation, storage, transmission, masking, rotation, and accidental exposure through logs, errors, fixtures, local paths, sample configuration, or generated artifacts.
- Check certificate-chain and hostname verification, reject trust-all or insecure TLS fallbacks, verify cryptographic primitives and algorithms, key and random-number strength, token and identifier unpredictability, and required encryption at rest and in transit.
- Check whether errors disclose credentials, internal topology, filesystem locations, queries, stack traces, or cross-tenant data.
- Check rate limiting, replay resistance, CSRF or origin handling, token expiration, and privilege changes when the changed surface makes them relevant.
- Treat a security control in the client as insufficient when the server path remains reachable.

**Finding gate**

Provide a concrete attacker capability, input or request sequence, reachable sink, missing or bypassed control, and resulting confidentiality, integrity, or availability impact. Do not emit a generic hardening suggestion as a finding.

## 4. Data integrity, transactions, concurrency, retries, and idempotency

**Observable triggers**

- Detect database writes, migrations, multi-step mutations, caches, mutable shared state, async work, threads, goroutines, futures, events, messages, queues, acknowledgements, retries, timeouts, leases, or scheduled jobs.

**Review**

- Define the intended atomic unit and identify every state mutated before success.
- Check partial mutation: determine what remains committed when a later validation, write, publish, or external call fails.
- Check transaction boundaries, propagation, isolation, connection ownership, commit timing, rollback behavior, and side effects that cannot be rolled back.
- Check whether catching or translating an exception prevents rollback or makes a failed operation appear successful.
- Check check-then-act sequences for races. Verify uniqueness constraints, locks, compare-and-set operations, or other atomic enforcement at the authoritative state boundary.
- Check shared mutable state, visibility, ordering, lost updates, stale reads, deadlocks, lock scope, cancellation, and cleanup.
- Identify ownership and terminal state for every changed executor, channel, subscription, lock, semaphore, timeout budget, or client. Enumerate all consumers before applying a policy that appears local.
- When repeated local fixes add interacting state or synchronization without a stable ownership model, reconstruct the state transitions and resource-ownership table before accepting another guard.
- Check acknowledgement timing. Confirm a message is acknowledged only after the durable effect required for safe redelivery.
- Check retry ownership and multiplication across clients, workers, libraries, and infrastructure.
- Check whether retries duplicate writes, notifications, charges, or external calls. Verify stable idempotency keys, deduplication scope, expiry, and result replay.
- Check at-least-once, at-most-once, and ordering assumptions against the actual broker or scheduler contract.
- Check timeout and cancellation paths for abandoned work that can still commit later.

**Finding gate**

Describe an interleaving, failure point, retry sequence, or duplicate delivery that breaks an invariant or produces a lost, duplicated, partial, or contradictory state. State the affected data and recovery consequence.

## 5. Performance and resource usage

**Observable triggers**

- Detect loops over external calls, bulk operations, recursive work, fan-out, pagination, queues, caches, buffering, large payloads, database access, resource acquisition, polling, or changed algorithmic complexity.

**Review**

- Check N+1 queries and RPCs, repeated parsing or serialization, redundant full scans, nested loops, and accidentally quadratic or worse behavior.
- Check whether work scales with user-controlled input, total dataset size, tenant count, retry count, or queue depth.
- Check unbounded collections, queues, caches, buffers, result sets, concurrency, goroutines, threads, connections, file descriptors, payloads, and log volume.
- Check pagination completeness, limits, cursor stability, streaming, backpressure, batching, and cancellation.
- Check resource acquisition and release on success, error, timeout, and cancellation paths.
- Check cache key correctness, eviction, invalidation, stampede behavior, sensitive-data scope, and stale-result tolerance.
- Check whether a new index, query shape, or batching strategy changes write cost, lock duration, or memory use.
- Distinguish a measurable regression from a speculative optimization opportunity.

**Finding gate**

Identify the workload or input growth, the expensive or unbounded operation, and a credible latency, memory, CPU, connection, queue, or cost impact. Do not report micro-optimizations without material effect.

## 6. Compatibility, migrations, deployment, observability, and rollback

**Observable triggers**

- Detect public API, serialization, schema, database, dependency, configuration, environment, build, packaging, deployment, startup, logging, metrics, alerts, feature flags, or rollback changes.

**Review**

- Check source, binary, wire, schema, and behavioral compatibility for existing callers and stored data.
- Check field renames, enum expansion, nullability, defaults, ordering, error codes, timestamp formats, locale, and serialization differences.
- Check rolling-upgrade behavior with old and new producers, consumers, workers, and schemas running concurrently.
- Check database migrations for locks, table rewrites, destructive ordering, idempotency, reruns, partial completion, backfill scale, and expand-contract sequencing.
- Check whether deployment order is explicit and safe for mixed versions.
- Check configuration precedence, missing values, secret injection, validation, environment-specific defaults, and whether a local absolute path leaked into production artifacts.
- Check startup and health behavior when dependencies are slow, absent, misconfigured, or only partially migrated.
- Check whether new failure modes remain observable through actionable logs, metrics, traces, health signals, and alerts without leaking sensitive data.
- Check weakened operability: swallowed errors, lost correlation identifiers, noisy logs, removed metrics, misleading success health checks, or invisible background failures.
- Check rollback after data or schema changes. Determine whether the old version can read new writes and whether rollback requires data repair.
- Check generated manifests, lockfiles, schemas, snapshots, or deployment artifacts for consistency with their sources.

**Finding gate**

Describe the existing client, stored record, mixed-version topology, deployment step, configuration state, or rollback sequence that fails. State the user-facing or operational impact and whether recovery is possible.

## 7. Verification and final-diff reinspection

**Observable triggers**

- Apply to every review. Increase depth when completion claims depend on tests, builds, linters, generated code, migrations, external services, or prior command output.

**Review**

- Select documented, non-mutating project commands that exercise the changed path and its adjacent regressions.
- Read complete current output and capture the exact command, exit result, relevant failure, and environment limitations.
- Check that a passing test reaches production behavior and would fail if the claimed fix were removed.
- Check that targeted tests do not hide failures outside the selected module or filter.
- Distinguish a product defect from dependency, network, permission, fixture, environment, or harness failure.
- Reinspect repository status and the exact target diff after verification.
- Investigate generated files, formatted sources, updated snapshots, migration output, lockfile drift, coverage artifacts, and other unexpected changes.
- Compare final inspected content with the content on which findings and line locations rely.

**Finding gate**

Report a verification-related code finding only when current evidence connects the failure to changed behavior. Otherwise record the command or inspection as **Passed**, **Failed**, **Not run**, or **Inconclusive** with notes as applicable. Use **Unverified** only for evidence, requirement, or domain coverage status, never as a command or inspection result.
