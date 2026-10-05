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

### Acceptance follow-up: real interfaces

A fresh read-only Pi worker was launched from the real Recon repository through the installed Pi CLI and authenticated Orca Linear interface, without replacing the bundled schema. It returned all required fields and reviewed the board's one active item, PRICE-24. First attempt incorrectly reported `complete` despite a history gap. After clarifying `pi.md` that history gaps require `partial`, a second real run exited 0 in 65 seconds, reported `partial`, discovered/reviewed 1, remaining 0, pagination complete, and disclosed unavailable external history plus truncated item context. No mutations were requested in these validation runs. This is concrete improvement in the worker contract, not full automation acceptance.

| Requirement / changed output | Real observation | Verdict |
| --- | --- | --- |
| Saved primary prompt loads bundled Jcode/Pi references | Orca `automations show` read-back matches entry prompt, provider `jcode`, schedule disabled | Passed configuration boundary |
| Manual automation starts Jcode without intervention | First run opened idle terminal; supervisor submitted prompt | Failed, external launcher boundary |
| Jcode orchestrates project-scoped Pi workers | Four worker event/result artifacts collected from manual-recovery run | Exercised, required intervention |
| Correct tracker routing | Linear workers read Tribal Cities/Otaku/Recon; ADO worker inventoried Wholesale | Exercised, other mappings incomplete |
| Five PM checks and exact worker result contract | Fresh Recon Pi read actual description/comments/relations/activity; final JSON has exact required fields | Passed schema boundary; context remained partial |
| Honest coverage and prior-answer gaps | Live retest reports `partial` and both history gaps instead of complete | Improved, observed on actual board |
| All project boards reviewed | ADO detailed coverage 10/320; Brown umbrella and homelab unresolved | Failed coverage requirement |
| Evidence-backed board updates/read-back | No supported writes reported; live retests deliberately read-only | Not validated, no artificial mutation made |
| Coordinator collects and emails digest | Coordinator mail connect hung; supervisor recovered collection and sent digest | Failed unattended coordination/mail boundary |
| Email actually sent to Leo | AgentMail `get_message` returned `sent` label, exact recipient/subject/message ID above | Passed supervisor-send boundary, not inbox receipt |
| Local reference/package regressions | `pnpm check`, `pnpm test`, `pnpm orca:validate` passed | Passed local checks, not full workflow |

The mail timeout/schema-preservation instructions in `jcode.md` have not been exercised by a fresh full orchestrator run. The external launch/MCP failures and unresolved mappings prevent claiming closed end-to-end acceptance.
