# Personal agent configuration

Agent prompts, portable workflow instructions, research, and migration records.
Reusable skills are authored in [leonardoacosta/skills](https://github.com/leonardoacosta/skills). This repository also retains the approved `skills/` materialization, `.skill-lock.json`, and `skill-journal.jsonl` for the local agent store. Speech guidance belongs to Herald.

## Layout

- `skills/`: approved agent-store materialization, with intake provenance in `.skill-lock.json` and `skill-journal.jsonl`.
- `prompts/jcode/`: system/swarm snapshots and PR review/response prompt. Snapshots are not automatically synced.
- `agents.md`: portable workflow guidance.
- `docs/`: research and migration evidence.

Consumers own installation. Use the existing skills CLI for selected canonical skills; no custom installer or active harness rewiring is included.

## Verification

Run `git diff --check`. Confirm the tracked export contains no skill materializations or machine-local inventory. Canonical skill tests belong in the skills repository, not here. Original variants, generated inventory, and retired maintenance files are preserved in verified local archives. See `docs/selective-salvage.md` for the migration ledger.
