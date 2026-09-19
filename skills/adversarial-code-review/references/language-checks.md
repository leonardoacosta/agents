# Language and Database Checks

Use only the sections matching languages or database artifacts changed by the review target.

These lists supplement risk reasoning. They cannot create a finding without an observable trigger, reachable behavior or misuse scenario, and concrete impact. Mark version-specific behavior **Unverified** unless the repository or authoritative evidence confirms it.

## Contents

- [Java and Spring](#java-and-spring)
- [JavaScript and TypeScript](#javascript-and-typescript)
- [Python](#python)
- [Go](#go)
- [SQL and database migrations](#sql-and-database-migrations)

## Java and Spring

**Apply when** Java, JVM configuration, Spring, Jakarta, persistence, build, or serialization artifacts change.

- Check integer overflow, narrowing conversions, signedness assumptions, floating-point comparison, **BigDecimal** scale and equality, and timezone or clock use.
- Check nullability, autounboxing, **Optional** misuse, empty collections, equality and hash contracts, comparator consistency, mutable keys, and unsafe collection exposure.
- Check stream reuse, lazy execution, side effects in streams, parallel-stream safety, concurrent collection semantics, and iteration during mutation.
- Check checked and unchecked exception conversion, interrupted-status restoration, resource cleanup, suppressed exceptions, and broad catches that hide rollback or retry signals.
- Check **CompletableFuture** executor choice, blocking joins, exception propagation, cancellation, timeouts, and lost context.
- Check Spring proxy boundaries: self-invocation, private or final methods, wrong bean instance, async methods, cache annotations, and transaction annotations that never intercept.
- Check transaction propagation, read-only assumptions, rollback rules, isolation, lazy loading after session close, flush timing, cascade behavior, orphan removal, and N+1 queries.
- Check bean scopes, singleton mutable state, lifecycle ordering, conditional beans, configuration-property names, validation, and environment precedence.
- Check controller binding, validation order, authentication and authorization annotations, exception-to-status mapping, content type, and mass assignment.
- Check Jackson or other serializer behavior for constructors, records, unknown fields, nulls, enums, polymorphism, dates, renamed properties, and backward compatibility.
- Check dependency and plugin versions across Maven or Gradle modules, runtime versus test scope, annotation processors, shading, and Java target compatibility.

**Finding gate:** Show the relevant JVM, framework, proxy, persistence, serialization, or build behavior and a reachable failure in the version and configuration used.

## JavaScript and TypeScript

**Apply when** JavaScript, TypeScript, Node.js, browser, package, build, or frontend framework artifacts change.

- Check erased runtime assumptions hidden by type assertions, non-null assertions, **any**, **unknown** casts, disabled checks, suppressed diagnostics, or declarations that disagree with runtime values.
- Check optional properties, discriminated unions, exhaustive handling, index access, truthiness bugs for zero or empty strings, and string-versus-number identifiers.
- Check promise chains, missing **await**, floating promises, unhandled rejection, error swallowing, async callbacks passed to non-awaiting APIs, and multiple settlement.
- Check cancellation, timeout cleanup, event-listener removal, timers, subscriptions, streams, sockets, and component unmount behavior.
- Check closure capture, stale state, dependency arrays, update ordering, race-prone request results, and state mutation when framework code changes.
- Check object spread and merge behavior, prototype pollution, inherited properties, unsafe dynamic keys, and mutation through shared arrays or objects.
- Check Node.js path handling, process execution, shell interpolation, URL parsing, SSRF, redirect handling, file permissions, and environment-variable defaults.
- Check browser trust boundaries, HTML or URL injection, dangerous DOM sinks, cross-origin assumptions, token storage, CSRF, and server-side enforcement.
- Check number precision, date parsing, timezone, locale, Unicode normalization, regular-expression complexity, and JSON serialization.
- Check package exports, module type, CommonJS and ESM interop, tree shaking, browser and server boundaries, polyfills, and supported runtime targets.
- Check dependency updates, lockfile churn, peer requirements, lifecycle scripts, bundled output, and API availability in the resolved version.

**Finding gate:** Trace a runtime value, async sequence, framework lifecycle, environment, or package resolution to an observable failure or security impact. A type-style preference is not a finding.

## Python

**Apply when** Python, packaging, framework, task-worker, or data-processing artifacts change.

- Check mutable default arguments, shared class attributes, late-bound closures, shallow copies, iterator exhaustion, mutation during iteration, and hash or equality assumptions.
- Check truthiness versus explicit **None**, numeric and boolean overlap, bytes-versus-text boundaries, encoding, Unicode normalization, and timezone-aware datetime use.
- Check broad **except**, bare re-raise behavior, exception chaining, cleanup in context managers, partial file writes, temporary files, and swallowed cancellation.
- Check async code for blocking I/O, un-awaited coroutines, orphan tasks, event-loop ownership, cancellation propagation, timeout scope, and concurrency limits.
- Check thread, process, and coroutine shared state; check locks, queues, fork safety, connection reuse, and serialization across worker boundaries.
- Check path traversal, symlink handling, archive extraction, subprocess argument construction, shell use, unsafe deserialization, dynamic evaluation, and SSRF.
- Check decorators, descriptors, dataclasses, default factories, model validation, ORM session lifetime, lazy loading, transaction scope, and N+1 queries.
- Check generators and streaming for cleanup, backpressure, exception timing, and materialization of unbounded input.
- Check import side effects, circular imports, optional dependencies, package metadata, version constraints, editable-install assumptions, and runtime-versus-test dependencies.
- Check test monkeypatch scope, mocks that ignore signatures, fixture leakage, and production branches activated only under tests.

**Finding gate:** Demonstrate the relevant Python runtime or library behavior, reachable inputs or scheduling, and concrete correctness, security, data, or resource impact.

## Go

**Apply when** Go source, modules, generated code, services, or concurrency paths change.

- Check every returned error, wrapped error identity, sentinel comparison, partial result, named return, and deferred mutation of return values.
- Check nil interfaces, typed nil pointers, zero values, map initialization, missing-map-key behavior, slice bounds, slice aliasing, append reallocation, and mutation through shared backing arrays.
- Check goroutine lifetime, cancellation, context propagation, channel ownership, send or close ordering, select defaults, blocked sends, wait groups, and loop-variable capture for the project's Go version.
- Check shared maps and state for races, lock copying, lock order, atomicity, publication, and unsafe reuse through pools.
- Check **defer** inside loops, response-body closure, file and connection cleanup, timer and ticker stopping, and cancellation on all exits.
- Check HTTP server and client timeouts, request-body limits, redirect behavior, URL construction, header trust, SSRF, and error-to-status mapping.
- Check JSON field tags, omitted versus zero values, unknown fields, enum handling, numeric precision, timestamps, and wire compatibility.
- Check database transaction ownership, **Rows** errors, scan types, context cancellation, partial writes, retry safety, and connection-pool limits.
- Check module replacements, indirect dependency changes, build tags, platform-specific files, generated artifacts, and minimum Go version.

**Finding gate:** Provide a concrete input, error path, goroutine interleaving, resource lifecycle, platform, or wire payload that produces the stated impact.

## SQL and database migrations

**Apply when** SQL, ORM mappings, schema definitions, migrations, seed data, queries, indexes, or stored routines change.

- Check null semantics, three-valued logic, empty sets, **NOT IN** with nulls, comparison and collation rules, timezone conversion, precision, truncation, and implicit casts.
- Check join cardinality, duplicate amplification, missing predicates, outer-join filters, aggregation level, nondeterministic ordering, pagination stability, and update or delete scope.
- Check parameter binding and identifier construction separately. Check SQL injection in dynamic filters, sorting, table names, and migration helpers.
- Check constraints, defaults, uniqueness, foreign keys, cascades, generated columns, triggers, and ORM expectations as one invariant.
- Check indexes for actual predicate and ordering use, write amplification, uniqueness behavior, partial-index predicates, and concurrent build support.
- Check transaction boundaries, isolation, locks, deadlocks, long-running statements, partial batches, savepoints, retries, and idempotency.
- Check migrations for reruns, partial application, expand-contract ordering, mixed-version reads and writes, backfill scale, table rewrites, lock duration, and replication impact.
- Check destructive changes, irreversible transformations, data validation before tightening constraints, duplicate or invalid historical data, and backup or recovery assumptions.
- Check rollback against data already written by the new version. Verify whether old code and schema can coexist during rolling deployment.
- Check dialect and version support for syntax, online operations, transactional DDL, default evaluation, and concurrent index creation.
- Check secrets, production identifiers, local filesystem paths, environment-specific endpoints, and generated migration artifacts committed by mistake.

**Finding gate:** Identify the database engine and version when relevant, the data shape or concurrent operation, the executed statement or migration phase, and the resulting integrity, availability, compatibility, or recovery impact.
