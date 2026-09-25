# Scenario review

These scenarios calibrate the skill without claiming a live consumer rollout.

| Scenario | Expected behavior | Limitation to report |
|---|---|---|
| Allowed assembly edge | Selects nonempty production assemblies and keeps a permitted dependency green. | Reflection sees compiled artifacts, not every source/build condition. |
| Forbidden namespace edge | Keeps a real failing rule example active and runs it through the normal test runner. | ArchUnitNET API and assembly-loading details vary by resolved package version. |
| Missing dependency/selection | Fails setup clearly when package references or selected assemblies are absent. | A green test cannot prove selectors cover every intended project. |
| Behavior boundary | Adds focused authorization and write tests beside architecture checks. | Architecture rules do not prove runtime authorization or persistence behavior. |

For each real review, record the resolved ArchUnitNET version, target framework, Debug command, selected
assembly names, and unresolved limitations. A Mesh pilot result belongs to its coordinator and must not be
inferred from these scenarios.
