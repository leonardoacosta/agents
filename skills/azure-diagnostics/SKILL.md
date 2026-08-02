---
name: azure-diagnostics
description: Diagnose Azure incidents involving unhealthy resources, application failures, logs, metrics, KQL, Container Apps, Functions, networking, NSGs, DNS, or private endpoints by selecting available capabilities and safe Azure CLI fallbacks.
---

# Azure Diagnostics

Build an evidence chain before changing a resource. Start with symptom, scope, time window, and recent changes; then select the narrowest diagnostic capability available in the active environment.

## Diagnose systematically

1. Identify the affected resource ID, subscription, resource group, region, service, deployment revision, and UTC time window.
2. Check Azure service and resource health plus the activity log before interpreting application symptoms.
3. Use an AppLens-style automated diagnosis capability when the environment exposes one. Supply the exact resource scope and symptom, and retain the resulting observations rather than treating recommendations as proof.
4. Correlate logs, metrics, dependency signals, and recent configuration or deployment changes.
5. Route service-specific symptoms to the relevant playbook.
6. Record evidence, unavailable evidence, hypotheses, attempted remediation, and the result.

Do not invent evidence when a specialized integration is unavailable. Use a documented Azure CLI, portal, KQL, or Resource Graph fallback when it is safe and applicable.

## Select a playbook

| Symptom | First evidence | Playbook |
| --- | --- | --- |
| Platform outage or degraded resource | Service health, resource health, activity log | [Health and AppLens-style analysis](references/health-and-applens.md) |
| Exceptions, latency, dependency failures, saturation | Application Insights, Log Analytics, metrics | [Logs, metrics, KQL, and Resource Graph](references/logs-metrics-kql.md) |
| Image pull, revision, probe, cold start, invocation, binding, or timeout | Service health, revision/deployment state, service logs | [Container Apps and Functions](references/container-apps-and-functions.md) |
| Connect timeout, name-resolution failure, NSG deny, route, or private endpoint | DNS, NSG rules, effective routes, endpoint state | [Network diagnostics](references/network-diagnostics.md) |

## Use a capability-first interface

When a diagnostic adapter is available, choose it by what it can establish:

- resource or service health at an Azure resource scope;
- AppLens-style analysis of a specific symptom;
- logs or metrics for a bounded time window;
- KQL execution against Application Insights or Log Analytics;
- Resource Graph inventory and cross-subscription correlation.

Give the adapter the resource ID, time range, query or diagnosis intent, and required subscription scope. Confirm its returned scope and timestamps. If it cannot establish a fact, state the limitation and use an independent source where practical.

## Safe initial CLI evidence

Inspect installed command help when syntax or extension availability is uncertain.

```bash
az resource show --ids <resource-id>
az monitor activity-log list --resource-id <resource-id> --offset 2h
az monitor metrics list --resource <resource-id> --interval PT5M
az graph query --graph-query '<bounded-query>' --subscriptions <subscription-id>
```

Read-only diagnosis is the default. Ask before restarts, configuration changes, scale changes, revision activation, or other mutations, and capture the pre-change state first.

## Report the outcome

Separate:

- observed facts with source and UTC time range;
- evidence that was unavailable or incomplete;
- the leading hypothesis and reasonable alternatives;
- any remediation performed and its authorization;
- post-remediation health, logs, and metrics.

Escalate only after presenting the evidence that rules out the narrower service, configuration, identity, DNS, NSG, route, and private endpoint causes.

## Provenance

This skill adapts Microsoft-authored MIT-licensed diagnostic guidance into a portable, capability-first form. See [PROVENANCE.md](PROVENANCE.md) and [LICENSE.txt](LICENSE.txt).
