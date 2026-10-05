# PM refinement automation

Run the PM refinement workflow using this local bundle.

1. Resolve the bundle at `apps/with-orca/references/pm-refinement` in the Agents repository. If running from the neutral `/home/nyaptor/dev` controller on this host, its repository is `/home/nyaptor/dev/personal/agents`. On another host, resolve the registered Agents repository rather than guessing a path.
2. Read `jcode.md` and follow it as the orchestration contract.
3. Launch project-scoped Pi workers with `pi.md` as their specialized system prompt. Jcode coordinates; Pi agents inspect and update their own boards.
4. Collect every worker result, consolidate Leo-only decisions, and send one digest through AgentMail to `leo@leonardoacosta.dev`.

Finish with email send confirmation and project coverage. If a worker fails, report that project and continue collecting the others. If the bundle cannot be resolved, report the missing path and stop rather than reverting to a generic PM prompt.
