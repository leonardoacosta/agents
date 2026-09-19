---
name: rtk
description: Use RTK to reduce verbose human-facing shell output in Empryo and jcode. Load when the user asks for RTK, token-efficient command output, or an RTK-assisted build/test session. Preserve native structured tools and raw machine-readable output.
---

# RTK: explicit, opt-in shell compression

Use the installed `rtk` executable explicitly; do not install hooks or modify the project. This skill applies only while loaded, not as transparent interception.

## Select commands

Keep harness-native search, read, edit, Git, and project verification tools when required or more suitable. RTK complements shell execution; it does not replace structured tools.

For an otherwise appropriate human-facing shell command, use a supported wrapper, retaining the original working directory and arguments:

- `git status` → `rtk git status`
- `git log -5` → `rtk git log -5`
- `cargo check` → `rtk cargo check`
- `cargo test` → `rtk cargo test`

Check `rtk --version` and relevant subcommand help once per session before unfamiliar usage. Do not guess wrappers: `pnpm test` was unsupported by the installed rewrite probe. Execute unsupported commands normally.

## Preserve correctness

Use the original command without RTK for JSON, porcelain, NUL-delimited output, pipelines consumed by programs, exact file contents, patch application, full-diff review, or complete audit evidence. Never blanket-prefix compound shell expressions or shadow executables through PATH, aliases, or BASH_ENV.

RTK output is lossy. If failure details are missing, rerun the original command only when safe and repeatable; otherwise capture raw output on the first run. Preserve and report failure exit status. A compressed summary is not proof that all checks passed.

Do not change command permissions, activate production resources, skip environment validation, trust project filters, install integrations, or alter telemetry settings as part of this skill. Avoid wrapping mutations during this pilot.

Do not automate `rtk rewrite`: installed 0.44.2 returned status 3 with rewritten output for some inputs despite help documenting 0/1. `rtk proxy` is raw passthrough, not compression.

Report observed output size separately from token or cost savings; do not claim a percentage without measuring the relevant workload.
