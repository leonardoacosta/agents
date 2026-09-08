# Wholesale binding

Use only for the Wholesale Architecture repository. Established 2026-09-08.
Repository AGENTS.md and APPENDIX-A.md override this snapshot when updated.

## Scope and identity

- Organization: `https://brownandbrowninc.visualstudio.com`
- Project: `Wholesale Architecture`
- User-supplied board URL: `https://brownandbrowninc.visualstudio.com/Wholesale%20Architecture`
- Inventory Leo's O365 and BBAdmin assignments. Newly created items go to the verified O365 identity, not BBAdmin. Exact identity lookup has not yet succeeded in this session. Do not infer assignment IDs or silently transfer existing work.
- Use the native CLI transport/profile documented by the repository. APPENDIX-A currently selects `AZURE_CONFIG_DIR=$HOME/.azure`, with `AZURE_DEVOPS_EXT_PAT` unset and corporate proxy variables when required. Do not copy credentials, guess proxy values or substitute an identity.
- Native executable observed locally: `$HOME/.local/share/pipx/venvs/azure-cli/bin/az`. The PATH `az` is a wrapper with separate profile selection. Inspect before use. This location is machine-specific, not a portable default.

## OPSX mapping

ADO remains the issue system of record. No additional tracker is required by this skill.
At proposal authoring, inspect current board structure and propose exact bindings.
Approve mapping before implementation, then resolve new IDs and validate the graph.
Use the markdown-graphs skill for official plain-Markdown GraphTree twins, with an
exact mapping table beside them. Do not render a proposed hierarchy as live state.
The portable skill does not enforce a fixed Epic/Feature/Story/Bug hierarchy.

## Pipeline execution

Load repository deployment guidance and APPENDIX-A before queueing. Resolve the
pipeline definition from `scripts/lib/ado-pipelines.json`, never from memory.
Preflight active runs on the target pipeline/branch and avoid overlapping same-env
writers. Use `--id`, `--branch`, `--commit-id` and explicit `--parameters env=<env>`
when declared by the YAML. Confirm the pinned commit exists on the selected branch.
Prod needs explicit approval and its existing gate. Preserve manual triggers,
service-connection validation and what-if gates. Follow to terminal state and
verify runtime health; a queue ID is not deployment success.

## Unresolved live access

On 2026-09-08, native version/help JSON worked but three board query attempts
returned exit 0 with empty stdout/stderr, including an unfiltered project query.
This is not evidence of an empty project or a validated login. `az ado -h` was
unrecognized. Missing corporate skills and unexplained transport/profile behavior
remain access gaps; this new skill does not magically resolve them.

Next probe: compare the user's working native command, executable and approved
profile/transport settings without exposing credentials. Only resume live reads
when new evidence makes the probe distinct. No board writes were made during
skill discovery.
