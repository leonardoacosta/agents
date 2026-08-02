# Container Apps and Functions

Correlate Azure health, deployment state, service logs, metrics, and recent changes before applying a remediation.

## Container Apps

For an unhealthy Azure Container Apps workload, inspect:

1. application and environment provisioning state;
2. active and inactive revisions, replicas, and traffic weights;
3. system logs and console logs for the failing revision;
4. image registry reachability and pull authorization;
5. ingress target port and the application's listening address;
6. startup, liveness, and readiness probe type, port, path, timing, and failure count;
7. CPU, memory, replica count, requests, and restart patterns;
8. secret references and managed identity access without exposing values.

```bash
az containerapp show --name <app> --resource-group <resource-group>
az containerapp revision list --name <app> --resource-group <resource-group> --output table
az containerapp logs show --name <app> --resource-group <resource-group> --type system
```

An image pull failure may come from a missing image or tag, registry DNS/network reachability, expired credentials, or incorrect managed identity roles. A probe failure may come from an application crash, a port/path mismatch, or timing that is too aggressive. Prove which condition exists before changing it.

## Functions

For an Azure Functions incident, inspect:

1. Function App state and recent deployments;
2. host startup logs and function invocation telemetry;
3. trigger and binding configuration;
4. required application settings by name, without printing secret values;
5. storage account reachability and authorization;
6. runtime version, extension or dependency compatibility, and deployment package state;
7. timeout, cold-start, memory, and scaling signals;
8. Application Insights or linked Log Analytics workspace identity.

Use KQL to correlate failed invocations with exceptions and dependencies. Distinguish "no invocation reached the host" from "the invocation ran and failed"; the former points toward triggers, listeners, networking, or authorization, while the latter points toward application or dependency behavior.

## Remediation discipline

Do not restart, activate a revision, modify a probe, rotate a credential, or change scale merely because it is a common fix. Capture the failing evidence, obtain authorization for the mutation, change one causal variable, and repeat the same health/log/metric checks afterward.
