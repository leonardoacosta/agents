#!/usr/bin/env python3
"""Best-effort native tool gate, not a shell sandbox."""
import argparse
import json
import re
import shlex
import sys

MESSAGE = "Worktree mutation blocked: use ~/.agents/skills/worktree-standard/scripts/worktree.py for plan/create/check and explicitly authorized managed removal. Raw Git mutations remain blocked; do not bypass this gate."


def mutation(command):
    # Ignore heredoc data, which often contains source code or quoted examples.
    command = re.sub(r"<<-?\s*['\"]?(\w+)['\"]?[^\n]*\n.*?\n\1\b", "", command, flags=re.S)
    try:
        tokens = shlex.split(command, comments=True)
    except ValueError:
        return False
    for start, token in enumerate(tokens):
        if token.split("/")[-1] != "git":
            continue
        index = start + 1
        while index < len(tokens) and tokens[index].startswith("-"):
            option = tokens[index]
            index += 1
            if option in ("-C", "-c", "--git-dir", "--work-tree", "--namespace"):
                index += 1
        if index + 1 < len(tokens) and tokens[index] == "worktree" and tokens[index + 1].rstrip(";") in ("add", "remove", "prune", "move", "repair", "lock", "unlock"):
            return True
    return False


def commands(value):
    if isinstance(value, dict):
        for key, item in value.items():
            if key in ("command", "cmd", "script") and isinstance(item, str):
                yield item
            elif isinstance(item, (dict, list)):
                yield from commands(item)
    elif isinstance(value, list):
        for item in value:
            yield from commands(item)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--client", required=True, choices=("jcode", "pi", "codex", "claude", "orca", "pi-durable", "cursor"))
    args = parser.parse_args()
    try:
        payload = json.load(sys.stdin)
    except (ValueError, OSError):
        print("Worktree guard received invalid tool JSON; tool blocked.", file=sys.stderr)
        return 2
    blocked = any(mutation(command) for command in commands(payload))
    if args.client == "cursor":
        print(json.dumps({"permission": "deny" if blocked else "allow", **({"user_message": MESSAGE, "agent_message": MESSAGE} if blocked else {})}))
    if blocked:
        print(MESSAGE, file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    sys.exit(main())
