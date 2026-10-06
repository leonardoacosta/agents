## Context
Provider governance already exists. This change adds workflow entrypoints, not tracker clients or a replacement state machine.

## Goals / Non-Goals
Goals: two discoverable explicit skills, source-informed evidence loop, correct workspace boundaries and verifiable implementation handoff. Non-goals: editing upstream Matt skill, changing built-in Jcode /triage, tracker configuration, status rollout, publishing anything or implementing triaged work while writing skills.

## Decisions
Each skill introduces inputs/scope, required governance skills, collect/classify/verify, mutation boundaries, optional safe-fix execution, attributed communication and compact reporting. Reference shared installed policies rather than duplicating their live state IDs. Linear collection uses available authenticated integration and verifies project/team membership; ADO uses native az devops or available ADO tools with verified org/project/work-item types. GitHub remains only a configured repository/PR surface, never the default issue inventory.

Disposition buckets: auto-fix, needs-info, needs-human, duplicate, question/support. Category/type/state mappings remain independent and refresh before mutations. Needs-info requests precise missing evidence; needs-human supplies a decision brief; duplicates link verified originals without automatic closure. Recheck item ownership/state/relations before each authorized mutation.

Fix delivery: smallest root-cause change, regression checks, preserve unrelated work, configured identity. Linear: verified issue identifier in branch/commit; Refs ID in PR, Fixes only for intended completion automation. ADO: numeric ID in branch and AB#ID in commit/PR; preserve in squash. No GitHub fixes #N for provider items. Attribution ends every posted comment/reply/PR description.

## Risks / Rollback
Unverified mappings can misroute work; fail closed for dependent actions. Overlapping upstream changes can drift; record source paths and avoid locks claiming these are upstream imports. Skill defects rollback by reverting only new skills/fixtures. No credential or tracker-state migration.

## Verification
Validate frontmatter/discovery, resolve referenced skills and documents, and run scenario evaluations with frozen synthetic tracker inventories. Include happy paths and denied-action cases for both providers; these validate instructions, not live tracker behavior. Implementation will record the actual local evaluator and outputs before claiming success.
