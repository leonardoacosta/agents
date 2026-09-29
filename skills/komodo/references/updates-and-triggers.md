# Image Updates and Triggers

Komodo has distinct ways to initiate work. **Image-digest polling** checks whether a referenced image tag now resolves to a newer digest. **Git webhooks** can notify Komodo about repository events, such as pushes, for supported resources. **Scheduled Procedures** run on a schedule, and **Resource Sync** reconciles declared resource configuration. These paths are not interchangeable; decide which event should cause which action.

## Choose the trigger by intent

| Intent | Mechanism | What it does |
| --- | --- | --- |
| Notice a newer image without changing the workload | Poll for updates | Checks the image tag's digest, shows an update indication and may alert; it does not redeploy. |
| Adopt a newer image automatically | Auto update | Checks for a newer digest and redeploys the supported Deployment or Stack. |
| React to a source repository push | Git webhook | Notifies Komodo about a Git event for a supported resource. Confirm exact provider, branch and event conditions in current docs. |
| Run a planned check or operation later | Scheduled Procedure | Executes the configured Procedure schedule; this is separate from an incoming push or image check. |
| Reconcile resource definitions | Resource Sync | Applies the resource reconciliation path; it is not an image update or application deployment trigger. |

Image polling compares the same tag over time. Auto-update therefore depends on a moving tag whose digest changes. It is not a mechanism for discovering a new immutable version tag. If the deployment pins an immutable version, update the declared reference through an intentional release process.

A Git push webhook changes deployment source only when the relevant source and webhook configuration support that flow. For Compose, the documentation describes Git-sourced files and redeployment on push. Builds also document incoming webhook-triggered builds. Do not infer that every push rebuilds every image or redeploys every Stack.

## Avoid competing writers

For each workload, name one intended owner for configuration changes and one deliberate update path. For example, enabling both automatic image redeploy and a Git-push deployment can cause separate redeploys at different points in the release. A scheduled global auto-update Procedure can also check resources whose per-resource poll or auto-update setting is enabled. Coordinate these paths when order matters, such as around backups or maintenance windows.

Webhook configuration is security-sensitive. Confirm the exact endpoint, accepted provider event, secret/signature behavior, branch filtering, reachability and resource association from current Komodo documentation before configuring or exposing it. Store webhook secrets outside tracked files. A secret value is not a substitute for restricting who can reach the endpoint or verifying which event invokes which action.

## Common pitfalls

- Treating Poll for Updates as an automatic redeploy.
- Expecting digest polling to advance a pinned image version.
- Assuming a Git push, image publication and image-digest update are one event.
- Enabling several automation paths without defining their ownership, ordering and rollback.
- Assuming webhook details from a sample or another provider match the installed Komodo version.
- Treating Resource Sync as deployment automation; it reconciles resource declarations and may change managed configuration.

## Canonical sources

- [Komodo Automatic Updates](https://komo.do/docs/deploy/auto-update)
- [Komodo Webhooks](https://komo.do/docs/automate/webhooks)
- [Komodo Build](https://komo.do/docs/build)
- [Komodo Procedures](https://komo.do/docs/automate/procedures)
- [Komodo Resource Sync](https://komo.do/docs/resources/sync)

## Refresh rules

Before configuring a trigger, verify current documentation for supported resource types, event names, branch filters, webhook security, digest-check schedule, defaults and redeploy semantics. Installed Komodo version may differ from the captured docs. The supplied research referenced `komodo-automation/webhooks.md`, but that file was not present at the requested path during authoring; therefore this reference makes no provider-specific claims. Confirm webhook details directly in the canonical Webhooks page before producing executable configuration.