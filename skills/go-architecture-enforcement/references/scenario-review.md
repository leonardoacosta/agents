# Scenario review

These scenarios calibrate the skill using target-repository evidence without claiming consumer rollout.

| Scenario | Expected behavior | Limitation to report |
|---|---|---|
| Go allowed edge | Selects nonempty packages and keeps a permitted import green. | Tool help/version and package-pattern behavior must be observed in the target repository. |
| Go forbidden edge | Uses a real import fixture and records the failing architecture result. | The linter does not prove authorization or write persistence. |
| .NET allowed assembly dependency | Uses the existing test project, Debug output, and nonempty assembly selections. | Reflection sees compiled artifacts, not every source/build condition. |
| .NET forbidden dependency | Keeps a real failing rule example active and runs through the normal test runner. | ArchUnitNET API details and assembly loading vary by resolved package version. |
| Missing dependency/selection | Fails setup clearly when package references or selected assemblies are absent. | A successful test run alone cannot prove selectors cover every intended project. |
| Go target-repository gate | Target evidence reports the checker gate, 11 real checker tests, `make lint`, and seven Go packages passing; repair preserved policy and gate hashes. | The repository module declares Go 1.26, while the observed toolchain was `go1.27.1-X:nodwarf5 linux/amd64`; compatibility was verified under that installed toolchain, not a standalone Go 1.26 runtime. |

For each real review, record the observed tool help, versions, commands, selections, and unresolved limitations.
Do not infer consumer adoption or CI authorization from these scenarios.
