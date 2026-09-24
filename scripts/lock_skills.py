#!/usr/bin/env python3
"""Regenerate .skill-lock.json from skills/ directory.
- Removes dangling entries for skill dirs no longer on disk.
- Adds missing entries for skill dirs without a lock entry.
- Recomputes integrity hashes for all locked skills.
"""

import json, hashlib, os, sys, base64

REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKILLS_DIR = os.path.join(REPO_ROOT, "skills")
LOCK_FILE = os.path.join(REPO_ROOT, ".skill-lock.json")


def hash_skill(name: str) -> str:
    path = os.path.join(SKILLS_DIR, name)
    h = hashlib.sha256()
    for root, dirs, files in sorted(os.walk(path)):
        dirs.sort()
        for fname in sorted(files):
            fpath = os.path.join(root, fname)
            rel = os.path.relpath(fpath, path)
            h.update(rel.encode())
            with open(fpath, "rb") as f:
                h.update(f.read())
    return base64.b64encode(h.digest()).decode()


def main() -> int:
    on_disk = sorted(
        d for d in os.listdir(SKILLS_DIR)
        if os.path.isdir(os.path.join(SKILLS_DIR, d))
        and os.path.isfile(os.path.join(SKILLS_DIR, d, "SKILL.md"))
    )

    lock = {}
    if os.path.exists(LOCK_FILE):
        with open(LOCK_FILE) as f:
            lock = json.load(f)

    locked = lock.get("skills", {})

    # Remove dangling
    dangling = sorted(set(locked.keys()) - set(on_disk))
    for n in dangling:
        del locked[n]
    if dangling:
        print(f"Removed {len(dangling)} dangling entries: {', '.join(dangling)}")

    # Add missing + update hashes
    added = 0
    updated = 0
    for name in on_disk:
        ch = hash_skill(name)
        if name not in locked:
            locked[name] = {"computedHash": ch}
            added += 1
        elif not locked[name].get("computedHash") or locked[name]["computedHash"] != ch:
            locked[name] = {"computedHash": ch}
            updated += 1

    lock["skills"] = dict(sorted(locked.items()))
    with open(LOCK_FILE, "w") as f:
        json.dump(lock, f, indent=2)
        f.write("\n")

    if added:
        print(f"Added {added} entries")
    if updated:
        print(f"Updated {updated} hashes")
    print(f"Total: {len(locked)} locked skills")
    return 0


if __name__ == "__main__":
    sys.exit(main())