
# Azure SDK

Key Vault secret access, ADLS Gen2, App Insights / telemetry. Uses Azure SDK v12
(`Azure.*` packages) with `DefaultAzureCredential` — never connection strings or account keys.

> Environment-specific identity selection, RBAC membership, proxy or tunnel setup, and deployment
> pipeline wiring belong in a local operations overlay. This reference covers portable C# SDK use.

## Key Vault secret access

Two paths — prefer config-reference binding over an in-code client where possible.

**Config-reference (preferred):** put a Key Vault reference in `appsettings.json` and let the
config provider resolve it, so the secret binds into `IOptions<T>` like any other setting.

```json
"Databricks": {
  "Token": "@Microsoft.KeyVault(SecretUri=https://<vault-name>.vault.azure.net/secrets/<secret-name>/)"
}
```

Or register the Key Vault config provider explicitly in `Program.cs`:

```csharp
builder.Configuration.AddAzureKeyVault(
    new Uri("https://<vault-name>.vault.azure.net/"),
    new DefaultAzureCredential());
```

**In-code client** (when you need a secret at runtime, not at bind time):

```csharp
var client = new SecretClient(
    new Uri("https://<vault-name>.vault.azure.net/"),
    new DefaultAzureCredential());
KeyVaultSecret secret = await client.GetSecretAsync("<secret-name>", cancellationToken: ct);
```

Register the `SecretClient` as a singleton (it is thread-safe and caches).

## ADLS Gen2

Use `Azure.Storage.Files.DataLake` with `DefaultAzureCredential` — never an account key. The
filesystem (container) name follows the project's convention (e.g. a `DocumentClass.Slug`).

```csharp
var service = new DataLakeServiceClient(
    new Uri("https://<storage-account>.dfs.core.windows.net"),
    new DefaultAzureCredential());

DataLakeFileSystemClient fs = service.GetFileSystemClient(containerName);
DataLakeFileClient file = fs.GetFileClient(path);

await using var stream = await file.OpenReadAsync(cancellationToken: ct);
```

Register the `DataLakeServiceClient` as a singleton. For uploads use `OpenWriteAsync` /
`UploadAsync` and stream — do not buffer large blobs fully in memory.

## App Insights / telemetry

Register Application Insights and emit custom events with named properties. Inject
`TelemetryClient` where you want a custom event.

```csharp
builder.Services.AddApplicationInsightsTelemetry();   // reads APPLICATIONINSIGHTS_CONNECTION_STRING
```

```csharp
public sealed class DocumentsService(TelemetryClient telemetry)
{
    public async Task SubmitAsync(SubmitRequest req, CancellationToken ct)
    {
        // ... work ...
        telemetry.TrackEvent("documents.submitted", new Dictionary<string, string>
        {
            ["fileCount"] = req.Files.Count.ToString(),
            ["cacheHit"]  = cacheHit.ToString(),
        });
    }
}
```

Prefer structured `ILogger<T>` logging (named placeholders, not string interpolation) so App
Insights captures the properties as queryable dimensions:

```csharp
logger.LogInformation("Processed {FileCount} files in {ElapsedMs}ms", count, sw.ElapsedMilliseconds);
```

## Azure SDK conventions

| Rule | Why |
| --- | --- |
| `DefaultAzureCredential` for every Azure client | Works in App Service (managed identity) and locally (Azure CLI) with no code change |
| Register SDK clients as singletons | They are thread-safe and pool connections / cache tokens |
| Never account keys / connection-string secrets | Managed identity + RBAC is the portable default |
| Propagate `CancellationToken` to every async SDK call | Client disconnect cancels the round-trip |
| Stream large blobs (`OpenReadAsync` / `OpenWriteAsync`) | Avoids buffering multi-MB payloads in memory |

For environment-specific managed-identity resolution, RBAC membership, network access, and local
execution constraints, load the repository's operations overlay when one exists.
