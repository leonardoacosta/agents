#!/usr/bin/env python3
"""Create, assess, and explicitly remove managed Git worktrees."""

import argparse
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import uuid
from urllib.parse import urlsplit

CLIENTS = {"jcode", "pi", "codex", "claude", "orca", "pi-durable", "cursor"}
DEFAULT_ROOT = Path.home() / "worktrees"
META_NAME = "worktree-standard.json"


class WorktreeError(Exception):
    pass


def git(repo, *args, check=True):
    result = subprocess.run(["git", "-C", str(repo), *args], text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if check and result.returncode:
        raise WorktreeError(f"git {' '.join(args)} failed (exit {result.returncode})")
    return result


def repo_info(repo):
    repo = Path(repo).expanduser().resolve()
    common = git(repo, "rev-parse", "--git-common-dir").stdout.strip()
    common_path = (repo / common).resolve() if not Path(common).is_absolute() else Path(common).resolve()
    rem = git(repo, "remote", "get-url", "origin", check=False)
    if rem.returncode == 0:
        remote = rem.stdout.strip()
        host, tail = "", ""
        if "://" in remote:
            parsed = urlsplit(remote)
            host, tail = parsed.hostname or "", parsed.path
        else:
            m = re.match(r"^(?:[^/@:]+@)?([^/:]+):(.+)$", remote)
            if m:
                host, tail = m.groups()
        pieces = [re.sub(r"[^a-z0-9-]+", "-", p.lower()).strip("-") for p in tail.strip("/").split("/") if p]
        if pieces:
            pieces[-1] = pieces[-1].removesuffix("-git")
        if host and all(pieces):
            return repo, common_path, "--".join([host.lower(), *pieces])
    primary = Path(common_path).parent.resolve() if Path(common_path).name == ".git" else Path(common_path).resolve()
    base = re.sub(r"[^a-z0-9-]+", "-", primary.name.lower()).strip("-") or "repo"
    digest = __import__("hashlib").sha256(str(common_path).encode()).hexdigest()[:10]
    return repo, common_path, f"{base}-{digest}"


def validate_slug(value, label):
    if not re.fullmatch(r"[a-z0-9]+(?:-[a-z0-9]+)*", value or ""):
        raise WorktreeError(f"{label} must be lowercase kebab-case")


def worktree_meta_dir(repo, branch):
    # Worktree-specific Git metadata (not files in its tracked working tree).
    result = git(repo, "worktree", "list", "--porcelain").stdout.splitlines()
    wanted = str(Path(repo).resolve())
    listed = False
    for line in result:
        if line.startswith("worktree ") and str(Path(line[9:]).resolve()) == wanted:
            listed = True
        elif listed and line.startswith("branch ") and line[7:] == f"refs/heads/{branch}":
            break
    if not listed:
        raise WorktreeError("created worktree is not registered")
    gd = git(wanted, "rev-parse", "--absolute-git-dir").stdout.strip()
    return Path(gd).resolve()


def compute(repo, client, task, kind, root, branch=None, base="HEAD"):
    if client not in CLIENTS:
        raise WorktreeError(f"unknown client {client!r}; expected one of {', '.join(sorted(CLIENTS))}")
    validate_slug(task, "task")
    validate_slug(kind, "type")
    repo, common, key = repo_info(repo)
    root = Path(root).expanduser().absolute()
    ident = uuid.uuid4().hex[:12]
    leaf = f"{task}--{ident}"
    path = root / key / client / leaf
    new_branch = branch if branch else f"{client}/{kind}/{leaf}"
    return repo, common, key, root, path, ident, new_branch


def do_plan(args):
    repo, _, key, root, path, ident, branch = compute(args.repo, args.client, args.task, args.type, args.root, args.branch, args.base)
    print(json.dumps({"repo": str(repo), "repo_key": key, "path": str(path), "branch": branch, "base": args.base, "id": ident}, indent=2))


def do_create(args):
    repo, _, key, root, path, ident, branch = compute(args.repo, args.client, args.task, args.type, args.root, args.branch, args.base)
    # Validate the primary repo and requested ref before changing Git state.
    git(repo, "rev-parse", "--show-toplevel")
    if args.branch:
        if args.branch.startswith("-") or git(repo, "check-ref-format", "--branch", args.branch, check=False).returncode:
            raise WorktreeError("invalid existing branch name")
        exists = git(repo, "show-ref", "--verify", "--end-of-options", f"refs/heads/{branch}", check=False)
        if exists.returncode:
            raise WorktreeError(f"existing local branch not found: {branch}")
    else:
        if args.base.startswith("-"):
            raise WorktreeError("base ref must not begin with '-'")
        git(repo, "rev-parse", "--verify", "--end-of-options", f"{args.base}^{{commit}}")
    if path.exists() or path.is_symlink():
        raise WorktreeError(f"destination already exists: {path}")
    if root.resolve() != root:
        raise WorktreeError("managed root or its ancestry must not contain symlinks")
    root.mkdir(parents=True, exist_ok=True)
    root_real = root.resolve()
    if root_real != root:
        raise WorktreeError("managed root or its ancestry must not contain symlinks")
    if not path.parent.resolve().is_relative_to(root_real):
        raise WorktreeError("destination escapes managed root")
    path.parent.mkdir(parents=True, exist_ok=True)
    if args.branch:
        git(repo, "worktree", "add", str(path), branch)
    else:
        git(repo, "worktree", "add", "-b", branch, str(path), args.base)
    try:
        gd = worktree_meta_dir(path, branch)
        payload = {"client": args.client, "session": args.session, "repo_key": key,
                   "branch": branch, "path": str(path.resolve()), "id": ident}
        (gd / META_NAME).write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    except Exception as exc:
        print(f"created worktree {path} on branch {branch}, but ownership metadata could not be written: {exc}", file=sys.stderr)
        raise WorktreeError("worktree preserved; inspect it manually")
    print(json.dumps({"path": str(path), "branch": branch, "repo_key": key, "id": ident}, indent=2))


def assess(args):
    supplied_path = Path(args.path).expanduser().absolute()
    root = Path(args.root).expanduser().absolute()
    path = supplied_path.resolve()
    root_real = root.resolve()
    blockers = []
    if supplied_path.is_symlink() or root.resolve() != root:
        blockers.append("target path or managed root ancestry contains a symlink")
    if not supplied_path.is_relative_to(root) or not path.is_relative_to(root_real):
        blockers.append("outside managed root")
    try:
        toplevel = Path(git(path, "rev-parse", "--show-toplevel").stdout.strip()).resolve()
        gd = Path(git(path, "rev-parse", "--absolute-git-dir").stdout.strip()).resolve()
    except Exception as exc:
        return {"path": str(path), "eligible": False, "blockers": blockers + ["git status unknown"],
                "removal_performed": False, "note": "Eligibility is an assessment only; remote refs are local snapshots."}
    try:
        metadata = json.loads((gd / META_NAME).read_text(encoding="utf-8"))
    except Exception:
        metadata = None
    parts = path.relative_to(root_real).parts if path.is_relative_to(root_real) else ()
    if metadata is None or not isinstance(metadata, dict):
        blockers.append("unknown ownership")
        metadata = None
    if metadata is not None:
        if metadata.get("path") != str(path) or toplevel != path or not supplied_path.is_relative_to(root):
            blockers.append("ownership/path mismatch")
        branch = git(path, "symbolic-ref", "--short", "-q", "HEAD", check=False)
        if (not isinstance(metadata.get("client"), str) or metadata.get("client") not in CLIENTS or len(parts) < 3 or parts[1] != metadata.get("client")
                or metadata.get("branch") != branch.stdout.strip()):
            blockers.append("unknown client or branch/path ownership mismatch")
        if metadata.get("repo_key") != repo_info(path)[2]:
            blockers.append("ownership/repository mismatch")
    listing_result = git(path, "worktree", "list", "--porcelain", "-z", check=False)
    listing = listing_result.stdout.split("\0") if listing_result.returncode == 0 else []
    current = False
    registered = False
    locked = False
    for record in listing:
        if record.startswith("worktree "):
            current = Path(record[9:]).resolve() == path
            registered |= current
        elif current and (record == "locked" or record.startswith("locked ")):
            locked = True
    if not registered:
        blockers.append("worktree is not registered")
    if locked:
        blockers.append("worktree is locked")
    status = git(path, "status", "--porcelain=v1", "--untracked-files=all", "--ignored", check=False)
    if status.returncode:
        blockers.append("git status unknown")
    elif status.stdout.strip():
        blockers.append("dirty or untracked files")
    head = git(path, "rev-parse", "HEAD", check=False)
    if head.returncode:
        blockers.append("HEAD unknown")
    else:
        branch_res = git(path, "symbolic-ref", "--short", "-q", "HEAD", check=False)
        current_branch = branch_res.stdout.strip() if branch_res.returncode == 0 else ""
        refs = git(path, "for-each-ref", "--format=%(refname)", "refs/heads", "refs/remotes", check=False)
        preserve = False
        if refs.returncode == 0:
            for ref in refs.stdout.splitlines():
                if ref == f"refs/heads/{current_branch}":
                    continue
                if git(path, "merge-base", "--is-ancestor", head.stdout.strip(), ref, check=False).returncode == 0:
                    preserve = True
                    break
        if not preserve:
            blockers.append("HEAD commit is not reachable from another local branch or cached remote ref")
    primary = Path(repo_info(path)[1]).parent.resolve()
    if path == primary:
        blockers.append("primary checkout cannot be removed")
    output = {"path": str(path), "eligible": not blockers, "blockers": blockers,
              "removal_performed": False,
              "note": "Eligibility is an assessment only; remote refs are local snapshots."}
    return output


def do_check(args):
    print(json.dumps(assess(args), indent=2))


def do_remove(args):
    if not args.confirm:
        raise WorktreeError("explicit --confirm is required; no worktree was removed")
    output = assess(args)
    target = Path(output["path"]) if output else Path(args.path).expanduser().absolute().resolve()
    if not output or not output["eligible"]:
        if output:
            print(json.dumps(output, indent=2))
        raise WorktreeError("worktree is not eligible for removal")
    common = Path(git(target, "rev-parse", "--git-common-dir").stdout.strip())
    common = (target / common).resolve() if not common.is_absolute() else common.resolve()
    survivor = None
    for record in git(target, "worktree", "list", "--porcelain", "-z").stdout.split("\0"):
        if record.startswith("worktree "):
            candidate = Path(record[9:]).resolve()
            if candidate != target and candidate.exists() and (candidate / ".git").exists():
                c = Path(git(candidate, "rev-parse", "--git-common-dir", check=False).stdout.strip())
                c = (candidate / c).resolve() if not c.is_absolute() else c.resolve()
                if c == common:
                    survivor = candidate
                    break
    if survivor is None:
        output["error"] = "no surviving checkout available to remove worktree"
    else:
        result = git(survivor, "worktree", "remove", str(target), check=False)
        if result.returncode:
            output["error"] = f"git worktree remove failed (exit {result.returncode}): {result.stderr.strip()}"
        elif target.exists() or target.is_symlink():
            output["error"] = "target path still exists after removal"
        else:
            remaining = git(survivor, "worktree", "list", "--porcelain", "-z", check=False)
            if remaining.returncode or any(r.startswith("worktree ") and Path(r[9:]).resolve() == target for r in remaining.stdout.split("\0")):
                output["error"] = "target remains registered after removal"
    output["removal_performed"] = not output.get("error")
    print(json.dumps(output, indent=2))
    if output.get("error"):
        raise WorktreeError(output["error"])


def parser():
    p = argparse.ArgumentParser(description=__doc__)
    sub = p.add_subparsers(dest="command", required=True)
    for name in ("plan", "create"):
        c = sub.add_parser(name)
        c.add_argument("--repo", required=True)
        c.add_argument("--client", required=True)
        c.add_argument("--task", required=True)
        c.add_argument("--type", default="task")
        c.add_argument("--base", default="HEAD")
        c.add_argument("--branch", help="existing local branch to check out")
        c.add_argument("--existing", dest="branch", help=argparse.SUPPRESS)
        c.add_argument("--root", type=Path, default=DEFAULT_ROOT)
        if name == "create":
            c.add_argument("--session", required=True)
        c.set_defaults(func=do_plan if name == "plan" else do_create)
    c = sub.add_parser("check")
    c.add_argument("--path", required=True)
    c.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    c.set_defaults(func=do_check)
    c = sub.add_parser("remove")
    c.add_argument("--path", required=True)
    c.add_argument("--root", type=Path, default=DEFAULT_ROOT)
    c.add_argument("--confirm", action="store_true")
    c.set_defaults(func=do_remove)
    return p


def main(argv=None):
    args = parser().parse_args(argv)
    try:
        args.func(args)
        return 0
    except (WorktreeError, OSError) as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
