#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
agents_root="$(cd -- "$script_dir/../.." && pwd)"
verifier="$agents_root/scripts/verify-recon-materialization.sh"
source_root="${1:?usage: recon-materialization-parity.test.sh <source-root> <source-revision>}"
source_revision="${2:?usage: recon-materialization-parity.test.sh <source-root> <source-revision>}"

"$verifier" --source-root "$source_root" --source-revision "$source_revision"

fixture="$(mktemp -d)"
trap 'rm -rf "$fixture"' EXIT

seed_fixture() {
  rm -rf "$fixture/agents"
  mkdir -p "$fixture/agents/.agents/skills/recon" "$fixture/agents/.claude/skills" \
    "$fixture/agents/skills" "$fixture/agents/agent/skills"
  cp "$agents_root/skills-lock.json" "$fixture/agents/skills-lock.json"
  git -C "$source_root" show "$source_revision:packages/recon-kit/skills/recon/SKILL.md" \
    >"$fixture/agents/.agents/skills/recon/SKILL.md"
  ln -s ../../.agents/skills/recon "$fixture/agents/.claude/skills/recon"
  ln -s ../.agents/skills/recon "$fixture/agents/skills/recon"
  ln -s ../../.agents/skills/recon "$fixture/agents/agent/skills/recon"
}

assert_stale_named() {
  local expected="$1" output
  shift
  if output=$("$verifier" --agents-root "$fixture/agents" --source-root "$source_root" --source-revision "$source_revision" 2>&1); then
    printf 'expected stale fixture to fail: %s\n' "$expected" >&2
    exit 1
  fi
  [[ "$output" == *"$expected"* ]] || {
    printf 'stale fixture did not name %s: %s\n' "$expected" "$output" >&2
    exit 1
  }
}

seed_fixture
printf '\n# stale\n' >>"$fixture/agents/.agents/skills/recon/SKILL.md"
assert_stale_named ".agents/skills/recon/SKILL.md"

seed_fixture
jq '.skills.recon.source = "untrusted/recon"' "$fixture/agents/skills-lock.json" >"$fixture/lock.tmp"
mv "$fixture/lock.tmp" "$fixture/agents/skills-lock.json"
assert_stale_named "skills-lock.json"

for relative in .claude/skills/recon skills/recon agent/skills/recon; do
  seed_fixture
  rm "$fixture/agents/$relative"
  mkdir -p "$fixture/agents/$relative"
  cp "$fixture/agents/.agents/skills/recon/SKILL.md" "$fixture/agents/$relative/SKILL.md"
  assert_stale_named "$relative"
done

printf 'PASS Recon materialization parity\n'
