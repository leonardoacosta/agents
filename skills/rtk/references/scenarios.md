# RTK scenarios

These fixtures use invented disposable paths and are review cases, not commands to execute during skill loading.

## Supported read

- Given a supported human-facing repository read, invoke `rtk` explicitly.
- Check the command exit status.
- Measure native and RTK output bytes before describing reduction.

## Structured output

- Given JSON, porcelain, NUL-delimited output, patch content, or a machine-consumed pipeline, run the native command.
- Do not rewrite or compress it.

## Unsupported command

- Given a command without a verified RTK wrapper, run it natively.
- Do not infer support from a similar command.

## Missing or broken binary

- Given `/home/example/.local/bin/rtk` is absent or fails its version probe, report the limitation.
- Run the safe native fallback.
- Do not install, mutate PATH, or retry a non-repeatable command.

## Failure detail

- Given an explicit RTK read returns a nonzero status or insufficient diagnostics, preserve that status.
- Rerun the native command only if the operation is safe and repeatable.
