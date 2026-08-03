#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
agents_root="$(cd -- "$script_dir/.." && pwd)"
source_root=""
source_revision=""

usage() {
  printf 'usage: %s --source-root <path> --source-revision <sha> [--agents-root <path>]\n' "${0##*/}" >&2
}

fail() { printf 'ERROR %s\n' "$*" >&2; exit 1; }

while (($#)); do
  case "$1" in
    --source-root) source_root="$2"; shift 2 ;;
    --source-revision) source_revision="$2"; shift 2 ;;
    --agents-root) agents_root="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 64 ;;
  esac
done

[[ -n "$source_root" && -n "$source_revision" ]] || { usage; exit 64; }
source_root="$(realpath -e "$source_root")" || fail "source root does not exist: $source_root"
agents_root="$(realpath -e "$agents_root")" || fail "Agents root does not exist: $agents_root"
git -C "$source_root" cat-file -e "$source_revision^{commit}" 2>/dev/null \
  || fail "source revision is not a commit: $source_revision"

lock="$agents_root/skills-lock.json"
[[ -f "$lock" && ! -L "$lock" ]] || fail "skills-lock.json is missing or not a regular file"
jq -e '
  .version == 1 and
  .skills.recon.source == "leonardoacosta/recon" and
  .skills.recon.sourceType == "github" and
  .skills.recon.skillPath == "packages/recon-kit/skills/recon/SKILL.md" and
  (.skills.recon.computedHash | type == "string" and length > 0)
' "$lock" >/dev/null || fail "skills-lock.json does not pin the Recon package"

expected="$(mktemp)"
trap 'rm -f "$expected"' EXIT
git -C "$source_root" show "$source_revision:packages/recon-kit/skills/recon/SKILL.md" >"$expected" \
  || fail "published Recon skill is absent at $source_revision"
canonical="$agents_root/.agents/skills/recon/SKILL.md"
[[ -f "$canonical" && ! -L "$canonical" ]] || fail ".agents/skills/recon/SKILL.md is missing or not a regular file"
cmp -s "$canonical" "$expected" || fail ".agents/skills/recon/SKILL.md differs from published Recon"

for relative in .claude/skills/recon skills/recon agent/skills/recon; do
  candidate="$agents_root/$relative"
  [[ -L "$candidate" ]] || fail "$relative must be a compatibility symlink"
  resolved="$(realpath -e "$candidate" 2>/dev/null)" || fail "$relative is a dangling symlink"
  [[ "$resolved" == "$agents_root/.agents/skills/recon" ]] \
    || fail "$relative resolves outside .agents/skills/recon: $resolved"
done

printf 'Recon materialization valid at %s\n' "$source_revision"
