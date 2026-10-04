import json
from pathlib import Path
import subprocess
import sys
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "hook.py"


class HookTests(unittest.TestCase):
    def run_hook(self, command, client="jcode", wrapped=False):
        data = {"command": command}
        if wrapped:
            data = {"tool_name": "Bash", "tool_input": data}
        return subprocess.run([sys.executable, str(SCRIPT), "--client", client], input=json.dumps(data), text=True, capture_output=True)

    def test_mutations_block(self):
        for operation in ("add", "remove", "prune", "move", "repair", "lock", "unlock"):
            for prefix in ("git", "git -C /repo", "git --git-dir=/repo/.git", "/usr/bin/git"):
                with self.subTest(operation=operation, prefix=prefix):
                    self.assertEqual(self.run_hook(f"{prefix} worktree {operation} /path").returncode, 2)

    def test_readonly_and_helper_allow(self):
        for command in ("git worktree list --porcelain", "git status --short", 'python3 "$HOME/.agents/skills/worktree-standard/scripts/worktree.py" create --repo /repo --client pi --task fix --session s', "echo hello"):
            self.assertEqual(self.run_hook(command).returncode, 0)

    def test_source_examples_allow(self):
        for command in ('echo "git worktree add /example"', "python3 - <<'PY'\nprint('git worktree add example')\nPY", "# git worktree remove example\ngit status"):
            self.assertEqual(self.run_hook(command).returncode, 0)

    def test_wrapped_payloads(self):
        for client in ("claude", "codex", "pi", "pi-durable", "orca"):
            self.assertEqual(self.run_hook("git worktree add /bad", client, True).returncode, 2)

    def test_cursor_response(self):
        result = self.run_hook("git worktree add /bad", "cursor", True)
        self.assertEqual(json.loads(result.stdout)["permission"], "deny")
        self.assertEqual(json.loads(self.run_hook("git status", "cursor").stdout)["permission"], "allow")

    def test_malformed_payload(self):
        result = subprocess.run([sys.executable, str(SCRIPT), "--client", "jcode"], input="bad", text=True, capture_output=True)
        self.assertEqual(result.returncode, 2)


if __name__ == "__main__":
    unittest.main()
