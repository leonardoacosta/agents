# Health and AppLens-style analysis

Use this playbook to distinguish Azure platform health, resource configuration, and application behavior.

## Establish scope

Record the exact Azure resource ID, deployment revision, region, UTC incident window, and the first observed symptom. Confirm the subscription context before querying.

## Check platform and resource health

Prefer a resource-health or service-health capability exposed by the active environment. Otherwise inspect the Azure portal or use Resource Graph and the activity log.

```bash
az monitor activity-log list \
  --resource-id <resource-id> \
  --start-time <utc-start> \
  --end-time <utc-end>
```

Resource Health describes the availability of a specific resource. Service Health describes broader Azure incidents and planned maintenance. A healthy platform does not prove the workload is configured correctly.

Useful Resource Graph patterns include:

```kusto
HealthResources
| where type =~ 'microsoft.resourcehealth/availabilitystatuses'
| where id startswith '<resource-id>'
| project id, availabilityState=tostring(properties.availabilityState),
    reasonType=tostring(properties.reasonType),
    summary=tostring(properties.summary)
```

```kusto
ServiceHealthResources
| where type =~ 'microsoft.resourcehealth/events'
| where tostring(properties.Status) =~ 'Active'
| project name, title=tostring(properties.Title),
    impact=tostring(properties.Impact), status=tostring(properties.Status)
```

## Run AppLens-style diagnosis

If an AppLens-style capability is installed, provide:

- the exact resource ID;
- a plain-language symptom;
- the UTC time window;
- the deployment or revision associated with the symptom.

Treat its detected signals, supporting evidence, and recommendations separately. Verify a recommendation against logs, metrics, configuration, or health data before changing state.

If that capability is unavailable, use the resource's Diagnose and solve problems experience in the Azure portal or continue with the relevant logs, metrics, and service playbook. Record that automated analysis was unavailable.

## Correlate recent changes

Use the activity log, deployment history, and application release metadata to find changes immediately preceding the incident. Do not infer causation from timing alone; compare the suspected change with the first failing signal and a known-good interval.
