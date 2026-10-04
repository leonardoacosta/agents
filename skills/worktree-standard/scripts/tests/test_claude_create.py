import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
import importlib.util
from unittest.mock import patch

ADAPTER = Path(__file__).resolve().parents[1] / "claude-create.py"
spec = importlib.util.spec_from_file_location("claude_create", ADAPTER)
claude_create = importlib.util.module_from_spec(spec)
spec.loader.exec_module(claude_create)

class ClaudeCreateTests(unittest.TestCase):
    def test_creates_managed_worktree_and_stdout_is_path_only(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            repo = root / "repo"
            repo.mkdir()
            subprocess.run(["git", "init", "-q", str(repo)], check=True)
            subprocess.run(["git", "-C", str(repo), "-c", "user.name=Test", "-c", "user.email=test@example.invalid", "commit", "--allow-empty", "-qm", "init"], check=True)
            real_run = subprocess.run
            def with_temp_root(command, **kwargs):
                return real_run(command + ["--root", str(root / "worktrees")], **kwargs)
            out = io.StringIO()
            with patch.object(sys, "stdin", io.StringIO(json.dumps({"cwd": str(repo), "session_id": "session-1", "name": "My Task!"}))), patch.object(sys, "stdout", out), patch.object(claude_create.subprocess, "run", side_effect=with_temp_root):
                self.assertEqual(claude_create.main(), 0)
            path = Path(out.getvalue().strip())
            self.assertEqual(out.getvalue().strip(), str(path))
            self.assertTrue(path.is_absolute() and path.is_dir())
            self.assertIn("/claude/my-task--", str(path))

    def test_missing_payload_fails_without_stdout(self):
        out, err = io.StringIO(), io.StringIO()
        with patch.object(sys, "stdin", io.StringIO("{}")), patch.object(sys, "stdout", out), patch.object(sys, "stderr", err):
            self.assertEqual(claude_create.main(), 1)
        self.assertEqual(out.getvalue(), "")

if __name__ == "__main__":
    unittest.main()
