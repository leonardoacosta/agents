# Skill vs Agent Mapping

## The Core Distinction

A **skill** is on-demand knowledge loaded into an existing agent's context — instructions,
reference tables, procedures, gotchas. It doesn't get its own context window or tool scope; it
augments whatever agent invokes it.

An **agent** is a separately-dispatched actor with its own context window, its own tool scope,
and (usually) its own model choice. Dispatching one costs a fresh context and a round-trip; it's
justified when the task benefits from isolation (a fresh window uncontaminated by the parent's
history), a narrower tool scope (e.g. read-only investigation), or genuine parallelism (fanning
the same task out across N targets at once).

**Rule of thumb**: if the work can be done by handing the current agent a procedure to follow,
it's a skill. If the work needs its own perspective — a clean context, a restricted toolset, or
to run concurrently with other work — it's an agent.

## When to Reach for a Skill

- The behavior is a body of domain knowledge (conventions, gotchas, a decision table) that
  should be available on demand rather than always resident in the system prompt.
- The behavior doesn't need isolation from the caller's context — the caller benefits from
  *keeping* its accumulated context while following the skill's guidance.
- The behavior is reusable across many different agents/tasks (a cross-cutting discipline like
  test-driven development or verification-before-completion belongs in a skill precisely
  *because* it should apply everywhere, not to one agent's job description).

## When to Reach for a Dedicated Agent

- The task benefits from a clean context window — e.g. a read-only investigation that shouldn't
  be able to see (or be biased by) the orchestrating agent's prior reasoning.
- The task needs a narrower or different tool scope than the calling agent has (a read-only
  analyst spawned from a read-write orchestrator).
- The task is naturally parallel — the same procedure needs to run against N independent
  targets and the results only need to be merged afterward, not interleaved.
- The task warrants a different model than the caller (a cheaper/faster model for a narrow,
  well-specified sub-task).

## Engineering-Discipline Skills Are Broad By Design

Some skills cross-cut nearly every agent that writes or reviews code — a
test-driven-development discipline, a verification-before-completion discipline, a
receiving-code-review discipline. These are broad on purpose: unlike a domain-specific skill
tied to one kind of task, a cross-cutting discipline skill earns its place in *every* engineer's
recommended-skills list because the discipline itself (not the domain) is what's being
reused. When authoring this kind of skill, resist the urge to narrow its trigger to one agent —
the whole point is that it applies wherever code gets written or reviewed.

## Discovery Patterns

How an agent finds a skill it needs, ordered by how targeted the search is:

| Method | When to Use |
| --- | --- |
| Invoke a known skill by name | The caller already knows which skill applies |
| A skill-discovery/search skill | Unsure what skills exist for the current task |
| An agent's own curated "recommended skills" list | Check whether the dispatched agent's own definition already names a relevant skill |

## Maintaining a Skill-to-Agent Mapping

If you maintain a per-agent "recommended skills" table for your own project:

- Keep it short (3-5 skills per agent) — not exhaustive, just the clearest matches. An
  exhaustive list stops being a curation signal and becomes noise.
- Review it periodically as your skill library grows; skills you add later won't retroactively
  appear in an agent's list unless someone updates it.
- Treat the list as additive, not exclusive — an agent can still discover and use a skill that
  isn't in its list via whatever general skill-discovery mechanism your setup provides.
- When an agent definition is renamed, merged, or removed, either update every table row that
  references it or explicitly flag the drift (a stale row that still names a defunct agent is
  worse than an empty one, because it silently misleads the next reader).
