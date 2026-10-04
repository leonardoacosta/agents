#!/usr/bin/env python3
"""Claude Code WorktreeCreate adapter for worktree-standard."""
import json
from pathlib import Path
import re
import subprocess
import sys

HELPER = Path(__file__).with_name("worktree.py")


def main():
    try:
        payload = json.load(sys.stdin)
        repo = Path(payload["cwd"]).expanduser().resolve(strict=True)
        session = payload["session_id"]
        if not isinstance(session, str) or not session:
            raise ValueError("missing session_id")
        name = payload.get("name", "worktree")
        slug = re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-") or "worktree"
        command = [sys.executable, str(HELPER), "create", "--repo", str(repo),
                   "--client", "claude", "--task", slug, "--type", "task",
                   "--session", session]
        result = subprocess.run(command, text=True, capture_output=True)
        if result.returncode:
            raise RuntimeError(result.stderr.strip() or "worktree helper failed")
        path = json.loads(result.stdout)["path"]
        if not Path(path).is_absolute():
            raise RuntimeError("helper returned non-absolute path")
        print(path)
        return 0
    except Exception as exc:
        print(f"worktree-create: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
