---
name: agent-architecture
description: Design AI agent architectures with orchestrator patterns, agent composition, tool selection, context management, and multi-agent coordination. Use when planning agent systems, defining orchestration strategies, or designing agent-tool interfaces.
license: MIT
metadata:
  version: 1.0.0
  tags: [agents, orchestration, ai-architecture, multi-agent, context-management, tool-selection]
---

# Agent Architecture

Design effective AI agent systems with clear orchestration patterns, well-defined agent roles, and explicit tool/context strategies. This skill is specifically tuned for Claude Code agent ecosystems but the patterns are broadly applicable.

---

## Quick Start

Describe your agent design challenge:

```
Design an orchestration pattern for a multi-project audit system with parallel agents
```

The skill provides orchestrator design, agent taxonomy, tool mapping, context strategies, and coordination patterns.

---

## Triggers

| Trigger | Example |
|---------|---------|
| Agent system design | "Design the agent architecture for X" |
| Orchestrator pattern | "How should the orchestrator manage these agents?" |
| Agent composition | "What agents do we need and how do they relate?" |
| Tool selection | "Which MCP tools should agent X have access to?" |
| Context management | "How do we manage context across agent sessions?" |
| Multi-agent coordination | "How should these agents coordinate their work?" |

---

## Core Principle: Orchestrator-First

**The orchestrator does not write code. The orchestrator directs work.**

Every agent architecture starts from this separation:

```
Orchestrator (Master)
  |
  |-- Does: Read, route, synthesize, decide
  |-- Does NOT: Write code, run builds, execute tests
  |
  +-- Spawns agents that DO the work
        |-- Analysts: Read, discover, report
        |-- Architects: Read, plan, propose
        |-- Engineers: Write, implement, build
        |-- Reviewers: Read, validate, verify
```

This is not optional. It is the foundational constraint that makes agent systems reliable.

---

## Agent Taxonomy

### Naming Convention

```
{domain}-{role}
```

| Role Suffix | Capability | Tools Available | Can Write? |
|-------------|-----------|-----------------|------------|
| `-analyst` | Read, discover, report findings | Read, Grep, Glob, WebSearch | No |
| `-architect` | Read, plan, propose designs | Read, Grep, Glob, WebSearch | No |
| `-engineer` | Read, write, implement changes | Read, Write, Edit, Bash, Grep | Yes |
| `-reviewer` | Read, validate, verify quality | Read, Grep, Glob, Bash (read-only) | No |

### Agent Design Template

```markdown
## Agent: {name}

### Role
{One sentence: what this agent does}

### Inputs
- {What information does this agent receive?}
- {What files/context does it need?}

### Outputs
- {What does this agent produce?}
- {Where does its output go?}

### Tools
- Required: {list of tools this agent must have}
- Optional: {list of tools that enhance but aren't required}

### Context Budget
- Estimated tokens: {input context size}
- Recommended model: {model for cost/capability balance}

### Failure Modes
- {What can go wrong and how to handle it}
```

---

## Orchestration Patterns

### Pattern 1: Sequential Pipeline

```
Orchestrator --> Agent A --> Orchestrator --> Agent B --> Orchestrator --> Agent C
```

**When to use:** Tasks with strict ordering. Output of A is input to B.

**Example:** Discovery --> Planning --> Implementation --> Validation

**Trade-offs:**
- Simple to reason about
- Slow (no parallelism)
- Each agent gets full orchestrator context between steps

### Pattern 2: Parallel Fan-Out / Fan-In

```
Orchestrator --+--> Agent A --+
               |              |
               +--> Agent B --+--> Orchestrator (synthesize)
               |              |
               +--> Agent C --+
```

**When to use:** Independent tasks that can run simultaneously.

**Example:** Codebase research + Web research + Related work search

**Trade-offs:**
- Fast (parallel execution)
- Agents cannot see each other's work
- Orchestrator must synthesize potentially conflicting findings

### Pattern 3: Iterative Loop (Ralph Pattern)

```
Orchestrator --> Agent --> Check --> (incomplete?) --> Agent --> Check --> ... --> Done
```

**When to use:** Tasks requiring refinement until a quality threshold is met.

**Example:** Fix bugs until tests pass. Refine plan until ambiguity score < threshold.

**Trade-offs:**
- Self-correcting
- Can get stuck in loops (always set max iterations)
- Each iteration has full context of previous work via filesystem

### Pattern 4: Hierarchical Delegation

```
Master Orchestrator
  |
  +-- Sub-Orchestrator (Domain A)
  |     +-- Agent A1
  |     +-- Agent A2
  |
  +-- Sub-Orchestrator (Domain B)
        +-- Agent B1
        +-- Agent B2
```

**When to use:** Complex multi-domain work where each domain needs its own coordination.

**Example:** Multi-project audit with per-project orchestrators.

**Trade-offs:**
- Clean separation of concerns
- Expensive (more agent sessions)
- Coordination between sub-orchestrators is complex

### Pattern 5: Gate-Sequenced Batches

```
Orchestrator --> [Batch 1: A, B parallel] --> Gate --> [Batch 2: C, D parallel] --> Gate --> ...
```

**When to use:** Groups of parallel work with validation checkpoints between groups.

**Example:** DB schema (parallel) --> typecheck gate --> API routes (parallel) --> build gate --> UI

**Trade-offs:**
- Balances parallelism with safety
- Gates catch errors early
- Clear rollback boundaries

### Pattern 6: Tiered Model Review

```
Orchestrator --> haiku triage --> (skip if N/A) --> sonnet summary --> [4 parallel: 2 sonnet compliance + 2 opus bug-finder] --> Orchestrator (synthesize)
```

**When to use:** Multi-agent review where different sub-tasks have different cost/capability needs. Cheap triage (haiku) decides whether to spend more; structural review (sonnet) parallelizes against criteria; deep bug-hunting (opus) runs separately.

**Example:** PR review where:
- haiku gate skips closed/draft/already-reviewed PRs (cheap)
- sonnet summarizes the diff (medium)
- 2 sonnet agents check CLAUDE.md compliance in parallel
- 2 opus agents hunt bugs in parallel (one for diff-only obvious bugs, one for introduced-code logic errors)

**Trade-offs:**
- Cost-aware: cheap models do the cheap work
- Multiple confidence sources via parallel agents
- Synthesis burden is real — orchestrator must merge findings + apply confidence filters
- Worth it only when the work splits cleanly along cost lines

(Adopted from a third-party code-review plugin's `/code-review` command, 2026-05-20. The plugin was cut after adopting this pattern.)

---

## Context Management

### The Context Problem

AI agents have finite context windows. Effective architecture manages this explicitly.

**Context Budget Planning:**

```markdown
### Context Budget: {Agent Name}

Total available: ~200k tokens

Allocation:
  System prompt + instructions: ~5k tokens
  Project context (CLAUDE.md, rules): ~10k tokens
  Task description + spec: ~15k tokens
  Code context (files to read): ~50k tokens
  Working space (reasoning + output): ~120k tokens

Risk: Context overflow at ~75% (150k tokens)
Mitigation: Progressive disclosure, summarize intermediate results
```

### Context Strategies

| Strategy | Mechanism | When to Use |
|----------|-----------|-------------|
| Minimal Context | Give agent only what it needs | Simple, focused tasks |
| Progressive Disclosure | Load context in stages as needed | Multi-phase tasks |
| Summary Handoff | Summarize Agent A's output for Agent B | Pipeline patterns |
| Shared Filesystem | Agents read/write to common files | Parallel work patterns |
| Context Reset | Start new session with synthesized summary | Long-running tasks approaching 75% |

### Anti-Patterns

| Anti-Pattern | Why It Fails | Better Approach |
|-------------|-------------|-----------------|
| Dump everything into context | Wastes tokens, dilutes focus | Curate relevant context per agent |
| Agent-to-agent direct communication | Not supported in CLI, unreliable | Orchestrator mediates all communication |
| Shared mutable state | Race conditions, inconsistency | Each agent writes to its own output path |
| No context budget planning | Agents hit limits mid-task | Plan token budget before spawning |
| Relying on agent memory | Agents have no cross-session memory | Use filesystem for persistence |

---

## Tool Selection Framework

### Tool Categories

| Category | Tools | Purpose |
|----------|-------|---------|
| Discovery | Glob, Grep, Read, WebSearch | Finding and reading information |
| Modification | Write, Edit, Bash | Creating and changing files/state |
| Validation | Bash (build/test/lint) | Verifying correctness |
| External | MCP servers (Playwright, Sentry, etc.) | Interacting with external systems |
| Orchestration | Task tool, SendMessage | Managing sub-agents |

### Tool Assignment Principles

1. **Least privilege** -- Give agents only the tools they need
2. **Read agents cannot write** -- Analysts and reviewers never get Write/Edit
3. **Engineers get full toolkit** -- They need to actually change things
4. **Orchestrator avoids Bash** -- Except for read-only status commands
5. **MCP tools are costly** -- Only assign when the task specifically needs them

### Decision Matrix

```
Does this agent need to modify files?
  Yes --> Engineer (Write, Edit, Bash, Read, Grep, Glob)
  No  --> Does it need to run commands?
            Yes --> Reviewer (Bash read-only, Read, Grep, Glob)
            No  --> Does it need web access?
                      Yes --> Researcher (Read, Grep, Glob, WebSearch, WebFetch)
                      No  --> Analyst (Read, Grep, Glob)
```

---

## Multi-Agent Coordination

### Task Distribution

```markdown
### Work Distribution: {Project}

Total tasks: {N}

Batch 1 (Parallel):
  Agent: db-engineer   | Tasks: 1.1, 1.2 | Gate: typecheck
  Agent: db-engineer   | Tasks: 1.3      | Depends: 1.1, 1.2

Batch 2 (Parallel, after Batch 1 gate passes):
  Agent: api-engineer  | Tasks: 2.1, 2.2 | Gate: build
  Agent: types-engineer| Tasks: 2.3      | Parallel with 2.1

Batch 3 (Parallel, after Batch 2 gate passes):
  Agent: ui-engineer   | Tasks: 3.1, 3.2, 3.3 | Gate: build

Batch 4 (Sequential):
  Agent: e2e-engineer  | Tasks: 4.1      | Gate: test
```

### Conflict Prevention

| Conflict Type | Prevention | Detection | Resolution |
|--------------|-----------|-----------|------------|
| File conflict | Assign file ownership per agent | Git status after each batch | Orchestrator merges |
| Schema conflict | DB batch runs first, alone | Typecheck gate | Fix before proceeding |
| API conflict | Types-engineer validates contracts | Build gate | Update contracts |
| State conflict | Each agent gets clean working state | Diff review | Orchestrator decides |

### Communication Protocol

In Claude Code's agent system:

1. **Orchestrator --> Agent:** Task description via Task tool prompt
2. **Agent --> Orchestrator:** Results via task output (files + response)
3. **Agent --> Agent:** NOT DIRECT. Always through filesystem or orchestrator
4. **Broadcast:** Only via orchestrator (expensive, use sparingly)

---

## Cost Model

### Token Estimation

| Agent Type | Typical Session | Tokens (Approx) |
|-----------|----------------|-----------------|
| Explore (read-only) | 1 turn, research | 10k-30k |
| Analyst | 1-3 turns, focused | 20k-50k |
| Engineer (simple) | 1-5 turns, implementation | 30k-80k |
| Engineer (complex) | 5-15 turns, multi-file | 80k-200k |
| Orchestrator turn | Synthesize + dispatch | 5k-15k per turn |

### Cost Optimization

| Strategy | Savings | Trade-off |
|----------|---------|-----------|
| Use Explore for read-only tasks | 50-70% vs general agent | Cannot write files |
| Batch related tasks per agent | Fewer sessions | Larger context per session |
| Summarize findings before passing | 30-50% context reduction | Some detail loss |
| Use haiku-class for simple tasks | 80% cost reduction | Less capability |
| Skip unnecessary agents | 100% of skipped cost | Less thoroughness |

---

## Design Checklist

Before finalizing an agent architecture:

- [ ] Orchestrator has NO write-code responsibilities
- [ ] Every agent has a clear, single-purpose role
- [ ] Agent naming follows `{domain}-{role}` convention
- [ ] Tool assignments follow least-privilege
- [ ] Context budgets planned per agent
- [ ] Communication is orchestrator-mediated (no agent-to-agent)
- [ ] Failure modes documented per agent and per interaction
- [ ] Gate checks defined between sequential phases
- [ ] Cost model estimated for the full workflow
- [ ] Max iterations set for any iterative/ralph patterns
- [ ] File ownership is unambiguous (no two agents writing same file)
- [ ] Resume strategy defined (what happens if interrupted mid-workflow)
