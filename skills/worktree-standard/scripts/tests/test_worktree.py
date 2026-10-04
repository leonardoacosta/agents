import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "worktree.py"


def git(repo, *args):
    return subprocess.run(["git", "-C", str(repo), *args], check=True,
                          stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True).stdout.strip()


class WorktreeTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.root = Path(self.tmp.name) / "worktrees"
        self.repo = Path(self.tmp.name) / "source"
        self.repo.mkdir()
        git(self.repo, "init", "-q")
        git(self.repo, "config", "user.name", "Test")
        git(self.repo, "config", "user.email", "test@example.invalid")
        (self.repo / "file.txt").write_text("initial\n")
        git(self.repo, "add", "file.txt")
        git(self.repo, "commit", "-qm", "initial")

    def cli(self, *args, success=True):
        result = subprocess.run([sys.executable, str(SCRIPT), *map(str, args)],
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout)
        return result

    def test_remove_success(self):
        created = self.create()
        path = Path(created["path"])
        result = self.cli("remove", "--path", path, "--root", self.root, "--confirm")
        report = json.loads(result.stdout)
        self.assertTrue(report["removal_performed"])
        self.assertFalse(path.exists())
        self.assertNotIn(str(path), git(self.repo, "worktree", "list", "--porcelain"))
        git(self.repo, "show-ref", "--verify", "refs/heads/" + created["branch"])
        self.assertTrue((self.repo / "file.txt").exists())

    def test_remove_requires_confirmation_without_mutation(self):
        created = self.create()
        path = Path(created["path"])
        result = self.cli("remove", "--path", path, "--root", self.root, success=False)
        self.assertTrue(path.exists())
        self.assertIn(str(path), git(self.repo, "worktree", "list", "--porcelain"))
        self.assertIn("--confirm", result.stderr)

    def test_remove_refuses_dirty_and_ignored_files(self):
        for name, contents in (("dirty.txt", "dirty"), ("ignored.txt", "ignored")):
            created = self.create(task=name.split(".")[0])
            path = Path(created["path"])
            if name == "ignored.txt":
                git(self.repo, "config", "core.excludesfile", str(Path(self.tmp.name) / "global-ignore"))
                (Path(self.tmp.name) / "global-ignore").write_text("ignored.txt\n")
                (path / name).write_text(contents)
                self.assertEqual(git(path, "check-ignore", name), name)
            else:
                (path / name).write_text(contents)
            refusal = self.cli("remove", "--path", path, "--root", self.root, "--confirm", success=False)
            report = json.loads(refusal.stdout)
            self.assertFalse(report["eligible"])
            self.assertFalse(report["removal_performed"])
            self.assertTrue(path.exists())
            git(path, "reset", "--hard", "HEAD")
            (path / name).unlink(missing_ok=True)
            git(self.repo, "worktree", "remove", str(path))

    def test_remove_refuses_locked_and_primary_worktrees(self):
        created = self.create()
        path = Path(created["path"])
        git(self.repo, "worktree", "lock", str(path))
        report = json.loads(self.cli("remove", "--path", path, "--root", self.root, "--confirm", success=False).stdout)
        self.assertIn("worktree is locked", report["blockers"])
        self.assertTrue(path.exists())
        git(self.repo, "worktree", "unlock", str(path))
        primary = json.loads(self.cli("remove", "--path", self.repo, "--root", self.tmp.name, "--confirm", success=False).stdout)
        self.assertIn("primary checkout cannot be removed", primary["blockers"])

    def test_remove_refuses_metadata_mismatch_and_unregistered_target(self):
        created = self.create()
        path = Path(created["path"])
        gd = Path(git(path, "rev-parse", "--git-dir"))
        metadata_file = (path / gd / "worktree-standard.json") if not gd.is_absolute() else gd / "worktree-standard.json"
        metadata = json.loads(metadata_file.read_text())
        metadata["branch"] = "wrong/branch"
        metadata_file.write_text(json.dumps(metadata))
        report = json.loads(self.cli("remove", "--path", path, "--root", self.root, "--confirm", success=False).stdout)
        self.assertTrue(any("branch/path ownership mismatch" in b for b in report["blockers"]))
        git(self.repo, "worktree", "remove", "--force", str(path))
        detached = self.root / "source" / "jcode" / "unregistered"
        detached.mkdir(parents=True)
        report = json.loads(self.cli("remove", "--path", detached, "--root", self.root, "--confirm", success=False).stdout)
        self.assertTrue(any("unknown ownership" in b or "git status unknown" in b for b in report["blockers"]))

    def test_remove_refuses_malformed_client_metadata(self):
        created = self.create()
        path = Path(created["path"])
        gd = Path(git(path, "rev-parse", "--absolute-git-dir"))
        metadata_file = gd / "worktree-standard.json"
        metadata = json.loads(metadata_file.read_text())
        metadata["client"] = []
        metadata_file.write_text(json.dumps(metadata))
        self.assertFalse(self.check(path)["eligible"])
        result = self.cli("remove", "--path", path, "--root", self.root, "--confirm", success=False)
        self.assertFalse(json.loads(result.stdout)["removal_performed"])
        self.assertNotIn("Traceback", result.stderr)
        self.assertTrue(path.exists())

    def test_remove_reports_git_failure_without_force(self):
        sub = Path(self.tmp.name) / "submodule-source"
        sub.mkdir()
        git(sub, "init", "-q")
        git(sub, "config", "user.name", "Test")
        git(sub, "config", "user.email", "test@example.invalid")
        (sub / "content").write_text("submodule\n")
        git(sub, "add", "content")
        git(sub, "commit", "-qm", "submodule")
        git(self.repo, "-c", "protocol.file.allow=always", "submodule", "add", str(sub), "sub")
        git(self.repo, "commit", "-qm", "add submodule")
        created = self.create()
        path = Path(created["path"])
        git(path, "-c", "protocol.file.allow=always", "submodule", "update", "--init")
        self.assertTrue(self.check(path)["eligible"])
        report = json.loads(self.cli("remove", "--path", path, "--root", self.root, "--confirm", success=False).stdout)
        self.assertIn("git worktree remove failed", report["error"])
        self.assertFalse(report["removal_performed"])
        self.assertTrue((path / "sub" / "content").exists())
        self.assertIn(str(path), git(self.repo, "worktree", "list", "--porcelain"))


    def create(self, task="sample", **opts):
        args = ["create", "--repo", self.repo, "--client", opts.pop("client", "jcode"),
                "--task", task, "--session", "session-1", "--root", self.root]
        for key, value in opts.items():
            args += ["--" + key.replace("_", "-"), value]
        return json.loads(self.cli(*args).stdout)

    def check(self, path):
        return json.loads(self.cli("check", "--path", path, "--root", self.root).stdout)

    def test_collision_generates_distinct_worktree_and_branch_ids(self):
        first = self.create()
        second = self.create()
        self.assertNotEqual(first["id"], second["id"])
        self.assertNotEqual(first["path"], second["path"])
        self.assertTrue(Path(first["path"]).is_dir())

    def test_bad_slug_rejected(self):
        self.cli("plan", "--repo", self.repo, "--client", "jcode", "--task", "../oops", "--root", self.root, success=False)

    def test_leading_dash_refs_rejected(self):
        self.cli("create", "--repo", self.repo, "--client", "jcode", "--task", "safe",
                 "--session", "s", "--root", self.root, "--base", "--help", success=False)
        self.cli("create", "--repo", self.repo, "--client", "jcode", "--task", "safe",
                 "--session", "s", "--root", self.root, "--branch", "--help", success=False)

    def test_origin_credentials_not_in_repo_key_or_output(self):
        git(self.repo, "remote", "add", "origin", "https://user:topsecret@example.com/Owner/Repo.git?token=secret")
        out = self.cli("plan", "--repo", self.repo, "--client", "jcode", "--task", "safe", "--root", self.root)
        self.assertNotIn("topsecret", out.stdout)
        self.assertNotIn("token=secret", out.stdout)
        self.assertEqual(json.loads(out.stdout)["repo_key"], "example.com--owner--repo")

    def test_existing_branch_name_preserved(self):
        git(self.repo, "branch", "feature/existing")
        created = self.create(existing="feature/existing")
        self.assertEqual(created["branch"], "feature/existing")
        self.assertEqual(git(created["path"], "branch", "--show-current"), "feature/existing")

    def test_dirty_and_untracked_files_block(self):
        created = self.create()
        Path(created["path"], "untracked").write_text("x")
        self.assertIn("dirty or untracked files", self.check(created["path"])["blockers"])

    def test_unpublished_commit_blocks(self):
        created = self.create()
        wt = Path(created["path"])
        (wt / "new").write_text("new")
        git(wt, "add", "new")
        git(wt, "commit", "-qm", "unpublished")
        self.assertIn("HEAD commit is not reachable from another local branch or cached remote ref",
                      self.check(wt)["blockers"])

    def test_locked_worktree_blocks(self):
        created = self.create()
        git(self.repo, "worktree", "lock", "--reason", "active-session", created["path"])
        report = self.check(created["path"])
        self.assertIn("worktree is locked", report["blockers"])
        self.assertFalse(report["eligible"])
        self.assertFalse(report["removal_performed"])

    def test_owner_path_mismatch_blocks(self):
        created = self.create()
        path = Path(created["path"])
        gd = Path(git(path, "rev-parse", "--git-dir"))
        if not gd.is_absolute():
            gd = path / gd
        meta_path = gd / "worktree-standard.json"
        meta = json.loads(meta_path.read_text())
        meta["path"] = str(path.parent / "moved")
        meta_path.write_text(json.dumps(meta))
        self.assertIn("ownership/path mismatch", self.check(path)["blockers"])

    def test_local_repo_key_stable_from_linked_worktree(self):
        first = self.create()
        second_repo = Path(first["path"])
        out = self.cli("plan", "--repo", second_repo, "--client", "pi", "--task", "again", "--root", self.root)
        self.assertEqual(json.loads(out.stdout)["repo_key"], json.loads(self.cli(
            "plan", "--repo", self.repo, "--client", "pi", "--task", "again", "--root", self.root).stdout)["repo_key"])

    def test_git_errors_do_not_echo_remote_credentials(self):
        git(self.repo, "remote", "add", "origin", "https://user:secret@example.com/owner/repo.git")
        out = self.cli("create", "--repo", self.repo, "--client", "jcode", "--task", "safe",
                       "--session", "s", "--root", self.root, "--base", "no-such-ref", success=False)
        self.assertNotIn("secret", out.stderr)

    def test_root_symlink_rejected(self):
        real = Path(self.tmp.name) / "real-root"
        real.mkdir()
        link = Path(self.tmp.name) / "linked-root"
        link.symlink_to(real, target_is_directory=True)
        self.cli("create", "--repo", self.repo, "--client", "jcode", "--task", "safe",
                 "--session", "s", "--root", link, success=False)

    def test_symlink_escape_rejected(self):
        outside = Path(self.tmp.name) / "outside"
        outside.mkdir()
        self.root.mkdir()
        (self.root / "example.com--owner--repo").symlink_to(outside, target_is_directory=True)
        git(self.repo, "remote", "add", "origin", "https://example.com/owner/repo.git")
        self.cli("create", "--repo", self.repo, "--client", "jcode", "--task", "safe",
                 "--session", "s", "--root", self.root, success=False)
        self.assertEqual(list(outside.iterdir()), [])


if __name__ == "__main__":
    unittest.main()
