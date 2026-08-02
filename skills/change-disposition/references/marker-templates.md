# Superseded marker

```markdown
# Superseded: <change-id>

- decided: YYYY-MM-DD
- decided-by: <session, handoff, decision record, or proposal>
- superseded-by: <change-id>
- tasks-at-closure: <done>/<total>

## Reason

<What changed and why the replacement now owns this intent.>

## Dependents swept

- <active-change-id>: <amended | flagged as follow-up disposition candidate>
```

# Deferred marker

```markdown
# Deferred: <change-id>

- decided: YYYY-MM-DD
- decided-by: <session, handoff, decision record, or proposal>
- reopen-when: <observable condition>
- tasks-at-closure: <done>/<total>

## Reason

<Why work is parked indefinitely and why the intent remains valid.>

## Dependents swept

- <active-change-id>: <amended | flagged as follow-up disposition candidate>
```

# Rejected marker

```markdown
# Rejected: <change-id>

- decided: YYYY-MM-DD
- decided-by: <session, handoff, decision record, or proposal>
- tasks-at-closure: <done>/<total>

## Reason

<Why the work is irrelevant, unjustified, or not worth doing.>

## Dependents swept

- <active-change-id>: <amended | flagged as follow-up disposition candidate>
```

Use `- none` when a complete active-proposal search finds no dependents. Do not omit the section.

## Worked example: runtime-neutral distribution cutover

The following illustrates the 2026-07-31 Pi supersession rewritten into the canonical template:

```markdown
# Superseded: complete-runtime-neutral-distribution-cutover

- decided: 2026-07-31
- decided-by: Pi runtime-delivery direction change
- superseded-by: establish-pi-utility-extension-program
- tasks-at-closure: 0/15

## Reason

The project no longer pursues the shared runtime-neutral distribution cutover described by this
change. The Pi utility extension program now owns Pi-local runtime delivery, while any future
cross-harness publication requires a separately approved release change. Uncompleted cutover
obligations are retired rather than represented as delivered.

## Dependents swept

- publish-pi-ask-user: flagged as a follow-up disposition candidate
- establish-pi-utility-extension-program: public-release dependency requires amendment
```

The example is a template rewrite, not permission to modify or disposition those changes.

## Beads close reasons

Use exactly one matching prefix:

```text
superseded: <replacement-change-id>
deferred: <reopen-condition>
rejected: <rationale>
```

Do not substitute `abandoned`, `cancelled`, `wontfix`, or any other free-text category.
