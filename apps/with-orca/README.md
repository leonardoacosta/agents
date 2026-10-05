# With Orca

Run `pnpm orca:validate` or explicitly register disabled definitions with `pnpm orca:install` from the repo root. See [WORKFLOW.md](WORKFLOW.md) and [config/tribal-cities.json](config/tribal-cities.json). Installation never enables schedules or runs agents.

## Project PM refinement reference bundle

Local-only replacement for the cross-project PM automation:

- [Evaluation and captured original](references/pm-refinement/evaluation.md)
- [Primary automation entry prompt](references/pm-refinement/automation.md)
- [Jcode orchestrator prompt](references/pm-refinement/jcode.md)
- [Pi project PM system prompt](references/pm-refinement/pi.md)

Load the primary prompt into an automation only when installing this workflow is requested. It loads Jcode's contract, which dispatches Pi from each project directory. These references are not wired into `config/tribal-cities.json`; existing installation and saved automations remain unchanged. Live Pi startup and tracker access still require verification before activation.
