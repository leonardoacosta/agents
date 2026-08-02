# Logs, metrics, KQL, and Resource Graph

Use a bounded UTC time window and exact resource scope. Start broad enough to see the onset, then narrow by operation, revision, instance, correlation ID, or dependency.

## Correlate telemetry

Inspect these signal groups together:

- request rate, failures, and latency;
- exceptions and stack traces;
- dependency duration and failure rate;
- CPU, memory, connections, queue depth, and service-specific saturation;
- deployment, configuration, scale, and identity changes.

Prefer a logs or metrics capability exposed by the active environment. Otherwise use Azure Monitor, Application Insights, or Log Analytics commands after inspecting their installed help.

## KQL starting points

Recent exceptions:

```kusto
AppExceptions
| where TimeGenerated between (datetime(<utc-start>) .. datetime(<utc-end>))
| project TimeGenerated, OperationName, Message, InnermostMessage, ProblemId
| order by TimeGenerated desc
| take 100
```

Failed requests:

```kusto
AppRequests
| where TimeGenerated between (datetime(<utc-start>) .. datetime(<utc-end>))
| where Success == false
| summarize failures=count(), p95=percentile(DurationMs, 95)
    by Name, ResultCode, bin(TimeGenerated, 5m)
| order by TimeGenerated desc
```

Dependency failures:

```kusto
AppDependencies
| where TimeGenerated between (datetime(<utc-start>) .. datetime(<utc-end>))
| where Success == false
| summarize failures=count() by Name, Target, ResultCode
| order by failures desc
```

Table and column names vary by telemetry mode. Inspect the workspace schema instead of silently rewriting a query against the wrong table.

## Resource Graph correlation

Use Resource Graph for inventory, configuration state, provisioning failures, and cross-subscription discovery—not for high-volume application logs.

```kusto
Resources
| where id =~ '<resource-id>' or id startswith '<resource-scope>/'
| project id, name, type, location, resourceGroup,
    provisioningState=tostring(properties.provisioningState), tags
```

Scope subscriptions explicitly and limit returned columns and rows. Install or enable required Azure CLI extensions only with user approval when that changes local state.

## Interpret absence carefully

No returned logs may mean no events, the wrong workspace, ingestion delay, insufficient permission, disabled diagnostic settings, an incorrect time window, or a schema mismatch. Report which alternatives were tested.
