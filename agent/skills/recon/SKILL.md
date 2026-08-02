---
name: recon
description: "Discover and invoke the canonical recon CLI without treating a harness-local folder as evidence ownership."
---
# Recon

Use recon for external-source analysis whose report, source metadata, and supporting assets must
be saved as one canonical evidence record. The runtime and vault belong to the `recon` repository,
not to this skill package or the calling harness.

1. Produce the report bundle in a temporary working directory.
2. Invoke the canonical runtime's `record` command with the source URL/type and every report asset.
3. Query the canonical vault for prior coverage instead of scanning a harness-local `docs/recon` tree.

```bash
recon record \
  --vault /path/to/recon/vault \
  --source-url https://github.com/owner/repo \
  --source-type git \
  --artifact /tmp/recon-report.md \
  --artifact /tmp/recon-report.html
```

The record is source-addressed at
`vault/.mx/evidence/sources/<source-id>/recon/<recon-id>/`. Do not create a mirror, symlink, or
sidecar in a harness-owned vault. Unknown legacy artifacts must be imported through
`recon import-legacy`, which quarantines them for identity review rather than guessing a target.
