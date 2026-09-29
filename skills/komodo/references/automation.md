# Automation: procedures, actions, schedules, and webhooks

Use this reference when the user wants to orchestrate Komodo executions, schedule recurring work, or trigger a resource from a Git provider webhook. It describes Komodo's task model. It is not a locally verified operational runbook. Check the live documentation for version-sensitive behavior before constructing configuration, and get explicit authorization before enabling schedules or triggers that execute changes.

## Choose a task model

- **Procedure**: Compose executions into named stages. Executions within one stage run in parallel; stages run sequentially. Komodo waits for every execution in a stage before advancing.
- **Action**: Write a TypeScript script that calls the Komodo API through the pre-initialized `komodo` client. The client exposes `read`, `write`, and `execute` calls, plus `execute_server_terminal`; the UI editor provides type-aware suggestions and inline documentation. Actions are scripts, not Procedure stages, so they do not inherit Procedure parallel/sequential stage semantics. Review every API write or execution in the script, including loops and terminal commands, before running it. See the [official Procedures and Actions docs](https://komo.do/docs/automate/procedures) and [tagged v2.3.3 source](https://github.com/moghtech/komodo/blob/v2.3.3/docsite/docs/automate/procedures.md) (released 2026-09-01). Confirm details against the installed Komodo version before authoring executable scripts.
- **Schedule**: Attach scheduling fields to a Procedure or Action to run it automatically.
- **Webhook**: Let a Git provider trigger a resource execution from an incoming request. This is separate from the schedule mechanism.

For a build-then-deploy workflow, a Procedure can put the build in an earlier stage and deployments in a later stage. Independent deployments may share a stage when their parallel execution is intended. Review parallelism and ordering against dependencies before enabling it.

## Scheduling model

The documented schedule configuration includes `schedule_format` (`English` or `Cron`), `schedule`, `schedule_enabled`, `schedule_timezone`, `schedule_alert`, and `failure_alert`. The documentation lists English format and enabled schedule as defaults, an empty expression and timezone as defaults, and alerts enabled by default. An empty timezone uses Core's timezone. Natural-language examples, cron syntax, and supported time-zone identifiers can change; consult the current [Schedules documentation](https://komo.do/docs/automate/schedules).

Before activating recurring work, establish the intended timezone, cadence, target resources, expected overlap/concurrency behavior, alert destinations, and failure response. Confirm that enabling the schedule is wanted. A schedule can cause repeated deployments or other state-changing executions.

## Git provider webhooks

The documented webhook endpoint has the shape `https://<HOST>/listener/<AUTH_TYPE>/<RESOURCE_TYPE>/<ID_OR_NAME>/<EXECUTION>`. GitHub authentication validates `X-Hub-Signature-256`; GitLab authentication validates `X-Gitlab-Token`. The documentation says Gitea's default webhook type works with GitHub authentication. Supported resource types and execution suffixes depend on resource type; use the current [Webhooks documentation](https://komo.do/docs/automate/webhooks) rather than inventing a route.

Treat webhook URLs, signing secrets, and tokens as sensitive. Do not publish them in source, logs, chat, or examples. Confirm reachability and authentication configuration without exposing secret values. Choose a stable resource ID if names may change. For Procedures and Actions, branch selection affects which commits can trigger runs, so verify the intended branch filter before enabling the integration.

## Sources

- [Procedures and Actions](https://komo.do/docs/automate/procedures)
- [Schedules](https://komo.do/docs/automate/schedules)
- [Webhooks](https://komo.do/docs/automate/webhooks)
