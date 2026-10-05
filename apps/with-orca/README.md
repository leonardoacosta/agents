# With Orca

Run `pnpm orca:validate` or explicitly register disabled definitions with `pnpm orca:install` from the repo root. See [WORKFLOW.md](WORKFLOW.md) and [config/tribal-cities.json](config/tribal-cities.json). Installation never enables schedules or runs agents.

## Project PM refinement reference bundle

Local-only replacement for the cross-project PM automation:

- [Evaluation and captured original](references/pm-refinement/evaluation.md)
- [Primary automation entry prompt](references/pm-refinement/automation.md)
- [Jcode orchestrator prompt](references/pm-refinement/jcode.md)
- [Pi project PM system prompt](references/pm-refinement/pi.md)

The primary prompt loads Jcode's contract, which dispatches Pi from each project directory. These references are not wired into `config/tribal-cities.json`; reinstalling that older config can overwrite matching saved definitions.

### Manual test: 2026-10-05

Updated saved Orca automation `6cd22a31-f34a-49f5-80c9-a0b7d6bc27bf` to `automation.md`, Jcode provider, and a reference/Pi-availability precheck instead of `exit 1`. Schedule remains disabled. Manually triggered run `359a5005-7ac6-4509-88d4-92dd4b9a3816`.

**Acceptance failed.** Orca opened an idle Jcode terminal without submitting the prompt and prematurely recorded `completed`. The supervising session submitted it manually. The coordinator later hung connecting AgentMail; interruption and a resume prompt recovered collection. Four project results reported 25 Tribal Cities, 2 Otaku Odyssey, 1 Recon and 10 of 320 Wholesale ADO items examined. No board writes were reported. Those counts are worker-reported, not independent item-by-item verification.

Artifact audit found the coordinator replaced `pi.md`'s result contract with an alternate schema: all collected objects lack `status` and `coverage`. Therefore four returned results do **not** mean four contract-valid complete reviews. Brown/homelab mappings and prior-answer history also remained incomplete. The orchestrator reference now prohibits schema replacement/sample-only inventory and bounds mail attempts, but those prompt fixes have not passed a fresh live run.

The supervising session, not the automation coordinator, sent the limitations email through AgentMail: message ID `<010001a10a50b8f4-6fa729df-f314-4b89-b989-b5bbae15d010-000000@email.amazonses.com>`. Local evidence: `/home/nyaptor/dev/.pmref-tmp/` (worker events/results and digest). Unattended launch, full coverage, valid worker contracts and coordinator email delivery remain unvalidated. Keep the schedule disabled.
