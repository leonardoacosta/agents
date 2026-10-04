# Pi worktree guard integration

Pi loads extensions from `~/.pi/agent/extensions/` automatically. Install the canonical adapter link:

```bash
ln -s ~/.agents/skills/worktree-standard/scripts/pi-extension.ts \
  ~/.pi/agent/extensions/worktree-standard.ts
```

The adapter listens for Pi's `tool_call` event, maps `event.toolName` and `event.input` to the shared hook's `{tool_name, tool_input}` JSON payload, then runs:

```text
python3 ~/.agents/skills/worktree-standard/scripts/hook.py --client pi
```

It blocks on nonzero exit or spawn failure. Hook invocation has a 5-second timeout. The hook blocks direct Git worktree mutations; helper invocations, including explicitly authorized managed removal, and read-only commands pass. `--confirm` is not user authorization. No Pi settings edit is required.

`pi-durable`'s registered `bg_start` custom tool call is intercepted before its executor and checked by this adapter using client `pi-durable`; shell commands invoked outside Pi's tool pipeline remain outside coverage.
