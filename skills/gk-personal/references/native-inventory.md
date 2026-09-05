# Native inventory and updates

Verify command syntax with installed help. These interfaces were observed on CLI Core 3.1.74.

## Progressive discovery

```bash
gk version
gk workspace list --output json
gk workspace list --sync --output json
gk workspace info "Brown" --output json
gk organization list --output json
gk provider repos azure --org "<ADO org>" --output json
```

Add an already-configured `--session <name>` only when the chosen context requires it.
For bb-mac, use noninteractive SSH and its installed executable, observed at
`~/.local/bin/gk`. Check help and access there independently of Linux.

Workspace list exposes IDs, names, types, counts and active state. Info exposes
repository names and local paths. Provider repo discovery supplies accessible
hosted repos; it does not imply workspace membership. Team counts do not prove
team names or membership are discoverable. Inspect supported surfaces first.

## Native local stores

Observed under `~/.local/share/gk` on Linux:
- `repoMapping.json`: repo identity metadata and clone paths.
- `cloudWorkspaces.json`: local path associations keyed by workspace ID.
- `localWorkspaces.json`: local collections.

Prefer CLI output. These are implementation details, not a stable public schema.
Do not assume the same paths for Mac or named sessions. Read only needed fields
if the CLI cannot answer a path question. Do not print credentials or copy stores.
Do not maintain a second editable inventory alongside them.

## Mutations

Use supported `gk workspace update "<existing name>"` flags:
`--name`, `--add-repos`, `--remove-repos`, `--add-teams`, `--remove-teams`.
Check help for accepted repo identifiers and provider constraints. Cloud workspace
creation's root discovery can skip other providers. Never silently treat skipped
repos as imported. Do not convert existing local collections until you have checked
for matching cloud collections and the correct organization.

Use gk's metadata sync to refresh observations. On timeout/auth failure, stop the
reconciliation and report unavailable state, not an empty inventory. After changes,
verify stable workspace IDs and exact intended membership. Do not deduplicate by
bare repo name, assume a missing path means no clone, or overwrite another host's
path with this machine's path.
