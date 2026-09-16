# Evidence provenance

Captured 2026-09-16. Prior evidence describes its own revision, not the migration candidate.

- Jcode session `session_bear_1789495060716_e9b3e639b99c23d2`, around 00:27-02:31 UTC: user directed `ssh cpc`; hostname 346-CPC-QJXVZ; PowerShell UIAutomationClient inspected Outlook LOCAL and later Word controls. LOCAL Outlook rendered but an auth error 13006 and disabled controls were observed. Some combo patterns were available. WindowPattern and Collapse calls also failed. These are reasons to discover supported patterns, not proof of universal automation.
- Existing helper at `~/.jcode/scratch/cpc-check/remote.py` used UTF-16LE encoded PowerShell over SSH. Bundled helper adds BatchMode, timeouts and exit propagation. Encoding is not secrecy and does not authorize payload actions.
- Session `session_poodle_1789557234047_eb5e558cc07e4b2c`, 11:44-12:27 UTC: candidate path `C:\Users\leonardoacosta\dev\b3owa-sideload-test`, Outlook port 3002 observed, accidental default port 3000 also observed, missing API listener later. Prior checkout commit 6d5fec0 was shown. Do not reuse that revision as current migration evidence.
- Session `session_flamingo_1789527499846_dff85666d8659952`: Windows descendant cleanup required actual CPC verification beyond Linux tests.
- Current draft session, 15:22 UTC: fresh BatchMode SSH hostname returned 346-CPC-QJXVZ. Full UI acceptance was not rerun while drafting the initiative.

No recovered source establishes complete autonomous Word/Excel/Outlook indexing acceptance. Initiative M1 qualifies the skill, M5 reruns it on the candidate. Missing cases must remain explicit.
