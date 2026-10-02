# Verified framework contracts

Read on 2026-10-02. These are documentation facts, not evidence that a project passed. The main skill contains chosen local policy. Resolve installed package/version compatibility before implementing. The cited public URLs are the portable sources.

## Supplied e2e documentation

| Source | Contract and planning consequence |
| --- | --- |
| [Config](https://e2e.tester.army/docs/reference/config) | `E2EConfig` is imported from `e2e`; targets use an engine such as `web()` from `@e2e-dev/web`. App startup can be owned by a configured command. Verify installed config types for target/app/model/credentials/cache/reporters/budgets instead of copying a legacy prepared-target architecture. |
| [CLI](https://e2e.tester.army/docs/reference/cli) | Use lockfile-pinned `pnpm exec e2e`, not an unpinned download. `run`, `list`, `--workers`, `--retries`, `--shard`, `--last-failed`, and `--reporter` have distinct purposes. Collection/listing is not acceptance. No-test success overrides are unsuitable for a required gate. |
| [MCP](https://e2e.tester.army/docs/reference/mcp) | `e2e mcp` exposes runner tools to coding agents. Optional diagnosis/authoring interface, not a required CI service or a substitute for execution evidence. Avoid an extra daemon merely to run the suite. |
| [Reporters](https://e2e.tester.army/docs/reference/reporters) | JSON `report.json` is always written to the output directory, default `.e2e`. `list,junit` also writes `junit.xml`. Reports include selected tests/results, step information, and artifact links. Use the actual schema to derive story status and usage, not invented cost fields. |
| [Environment](https://e2e.tester.army/docs/reference/environment) | The configured model/provider reads credentials. `gateway()` uses `AI_GATEWAY_API_KEY`, `openrouter()` uses `OPENROUTER_API_KEY`, and `openai()` uses `OPENAI_API_KEY`. Missing credentials fail on the first model call. `E2E_USER_<NAME>_USERNAME/PASSWORD` and `E2E_SECRET_<NAME>` override configured values. `E2E_TELEMETRY_DISABLED=1` disables framework telemetry, not report artifacts or model-provider data flow. |
| [Errors](https://e2e.tester.army/docs/reference/errors) | Error codes distinguish config, auth, model, startup, engine, assertions, `.only` in CI, and no-test conditions. Classify runner/infrastructure problems separately from reproducible product defects. Do not export every nonzero exit as a Linear bug. |
| [Agents](https://e2e.tester.army/docs/agents) | Configure goals/context, tools, model, personas, secrets, and budgets deliberately. Agent-visible context is a data-disclosure boundary. Supported bounds include `maxSteps`, `maxModelCalls`, `maxInputTokens`, `maxObservationBytes`, and `judgmentTimeout`. There is no documented `maxTokens` config option and these bounds are not a monetary cap. |
| [Agent steps](https://e2e.tester.army/docs/agent-steps) | `agent.act`, `agent.assert`, `agent.waitFor`, and `agent.extract` have distinct contracts. Use a narrow action goal and exact business assertions. These current docs do not establish the old `consume`/`retry`/`off` deterministic-step repair configuration, so do not carry it forward. |
| [CI](https://e2e.tester.army/docs/ci) | CI defaults: workers `1`, retries `1`, cache `read-only`; `.only` is rejected and `command.reuseExisting` is ignored. The docs show deterministic and agent tests in one job. Initial policy sets retries `0` to avoid hidden retry cost. |
| [Mobile CI](https://e2e.tester.army/docs/mobile-ci) | Mobile engine/device setup is a separate platform contract involving simulators/emulators. Do not add it to web pilots without a mobile requirement. Web Chromium-first policy is a scope decision, not a claim mobile is unsupported. |
| [GitHub](https://e2e.tester.army/docs/github) | PR comments are opt-in via the `github` reporter, which also writes job summaries. Fork PRs have read-only tokens, so posting fails with an explanation. The supplied page does not document a separate `workflow_run` publisher. Prefer artifacts/summaries without adding a privileged publishing workflow. |
| [Coding agents](https://e2e.tester.army/docs/coding-agents) | Tests/reports, instructions, and optionally MCP enable an author-run-diagnose loop. Coding agents may help author/repro defects. They do not grant permission to change cloud resources, expose secrets, or publish tickets. |
| [Engine](https://e2e.tester.army/docs/reference/engine) | Web and mobile adapters implement the runner engine contract. Use first-party engines rather than writing an adapter. Retiring Playwright **test-runner architecture** does not remove Playwright when the web engine requires it. |

## Replay, reruns, and budgets

From [CI](https://e2e.tester.army/docs/ci#model-credentials), fully replayed action steps need no model call. Live actions and agent judgments still do. Cache misses still need model execution. From [config cache](https://e2e.tester.army/docs/reference/config#cache), `cache.strict` optionally fails an existing invalid recording with `REPLAY_STALE` instead of returning to the agent, default `false`. `agent.assert`, `agent.waitFor`, and `agent.extract` are live judgments. Read-only cache prevents cache writes, not model calls. Cold execution needs the approved model path.

From [CI reruns](https://e2e.tester.army/docs/ci#rerunning-failures), `--last-failed` reads the prior report. Starting a rerun empties artifacts in the output directory, so preserve the first report and artifacts first. A diagnostic subset does not prove the full required story contract.

From [CI sharding](https://e2e.tester.army/docs/ci#sharding), each shard produces its own JSON/JUnit and document merging is not implemented. This is another reason not to introduce sharding before it materially improves measured runtime. A shard with no tests fails unless explicitly overridden.

From [CI exit codes](https://e2e.tester.army/docs/ci#exit-codes), `0` means selected tests passed, `1` means failures, and `2` means no tests selected unless no-test success was enabled. Prove required selection, not just exit `0`.

## Neon branch contracts and limits

Sources: [branch API](https://neon.com/docs/guides/branching-neon-api), [schema-only](https://neon.com/docs/guides/branching-schema-only), [branch management](https://neon.com/docs/manage/branches), [expiration](https://neon.com/docs/guides/branch-expiration).

- Schema-only branches copy structure without rows. Seed synthetic data explicitly. This does not prove copied roles/credentials are harmless.
- Pin project/parent/created branch identity and use the created branch's connection endpoint. Creation and deletion are consequential operations requiring authorization and resolved credential scope.
- Expiration is a backstop for ephemeral branches, not immediate cleanup or proof cleanup worked. Verify available API/version support and expiration constraints before setting it.
- **Compatibility discrepancy:** the fetched schema-only guide says CLI support is forthcoming, while the installed `/neon-postgres-branches` skill and a pilot provisioner show `--schema-only`. Resolve against the actual pinned CLI help/types or use the documented API. Do not claim a command was verified without checking.
- Account-specific exposed credential invalidation/scope cannot be inferred from these generic documents. An unresolved exposed-credential incident remains blocked until authoritative confirmation.

## Native TesterArmy to Linear

Sources: [requested integration overview](https://tester.army/integrations/linear), [setup documentation](https://docs.tester.army/integrations/linear).

The setup docs are more specific than marketing copy: any project member can initiate the project-shared connection, but Linear may require a workspace admin to approve. OAuth is managed by TesterArmy's auth provider with documented read and issue-creation access. Choose the default Linear team once per hosted project.

The route is **TesterArmy project → Issues → issue → Create ticket → Linear**. The dialog lets the exporter choose title, team, status, assignee, and priority. The ticket includes description, expected/actual behavior, reproduction steps, severity-mapped priority, screenshot link, and a back-link to TesterArmy. Tickets are authored by the TesterArmy app and name the teammate who exported.

Each TesterArmy issue links to at most one ticket. Re-export surfaces the existing ticket. Severity `5/4/3/<3` maps to `Urgent/High/Medium/Low`. Disconnect/revocation does not delete existing tickets.

**Not established by these pages:** CLI `.e2e/report.json` ingestion into the hosted Issues tab, automatic CI-failure export, global duplicate detection, requirement synchronization, continuous ticket updates, or bidirectional status sync. Keep that bridge explicitly unknown until supported docs or an authorized workflow proves it. Native export is preferred over adding a separate Linear credential/token or custom CI bot.
