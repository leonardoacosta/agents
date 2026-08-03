#!/usr/bin/env bash
set -euo pipefail

agents_root="$(git -C "$(dirname "$0")/../.." rev-parse --show-toplevel)"
skill="$agents_root/skills/merge-to-main/SKILL.md"
portability="$agents_root/skills/merge-to-main/references/portability-map.md"
recovery="$agents_root/skills/merge-to-main/references/recovery.md"

for path in "$skill" "$portability" "$recovery"; do
  [[ -f "$path" ]] || { printf 'missing merge-to-main skill file: %s\n' "$path" >&2; exit 1; }
done

for token in \
  'Pin the source SHA before review' \
  'Run local quality gates' \
  'Review the pinned diff' \
  'focused independent re-check' \
  'at most 10 commits' \
  'Merge the reviewed SHA' \
  'verify the remote target contains' \
  'restore the starting branch' \
  'Stop after the target branch is pushed'; do
  grep -Fq "$token" "$skill" || { printf 'missing portable invariant: %s\n' "$token" >&2; exit 1; }
done

if grep -Eiq 'bwrap|memfd|runtime[_ -]manifest|fingerprint protocol|report\.schema|custom scheduler' "$skill"; then
  grep -Eq 'Do not build a scheduler|Do not add a process wrapper' "$skill" || {
    printf 'skill contains an unguarded custom-runtime dependency\n' >&2
    exit 1
  }
fi

grep -Fq 'Harness-owned primary' "$portability"
grep -Fq 'sequential reviews preserve semantics' "$portability"
grep -Fq 'Source advanced after review' "$recovery"

printf 'PASS portable merge-to-main contract\n'
