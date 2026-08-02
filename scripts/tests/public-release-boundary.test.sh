#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

# Keep the private identifiers out of the public test itself while enforcing their absence.
private_pattern="$(printf '\127\110\123')|$(printf '\102\046\102')|$(printf '\102\162\157\167\156\040\046\040\102\162\157\167\156')|$(printf '\142\162\157\167\156\141\156\144\142\162\157\167\156')|$(printf '\142\142\055\141\172\165\162\145\055\157\160\163')|$(printf '\142\162\151\144\147\145\163\160\145\143\151\141\154\164\171')|$(printf '\163\141\164\145\154\154\151\164\145\040\146\154\145\145\164')|$(printf '\143\154\157\165\144\160\143\040\123\117\103\113\123')"
personal_pattern="$(printf '\154\145\157\156\141\162\144\157\141\143\157\163\164\141')|$(printf '\156\171\141\160\164\157\162')|$(printf '\160\162\151\143\145\154\145\163\163')|$(printf '\164\162\151\142\141\154\055\143\151\164\151\145\163')|$(printf '\156\145\170\165\163\055\151\157\163')|$(printf '\150\157\155\145\154\141\142')|$(printf '\143\154\157\165\144\160\143')"
machine_pattern='~/dev/[A-Za-z0-9._-]+|~/.ssh/|gui/[0-9]+|uid-[0-9]+|DEVELOPMENT_TEAM=[A-Z0-9]+'
personal_author_pattern="(^|[^[:alnum:]_])$(printf '\114\145\157')([^[:alnum:]_]|$)"
private_corpus_pattern="(^|[^[:alnum:]_])$(printf '\143\143')([^[:alnum:]_]|$)|$(printf '\143\143\055\160\162\141\143\164\151\143\145\163\055\143\165\162\162\145\156\164')|$(printf '\154\145\157\055\167\162\151\164\151\156\147\055\166\157\151\143\145')"
private_ticket_pattern="$(printf '\143\143')-[[:alnum:]]{5,}([.][0-9]+)?"
private_project_pattern="(^|[^[:alnum:]_])($(printf '\164\143')|$(printf '\156\170'))-[[:alnum:]]{5,}([.][0-9]+)?|(^|[^[:alnum:]_])$(printf '\155\170')-[0-9][[:alnum:]]{3,}([.][0-9]+)?|(^|[^[:alnum:]_])($(printf '\157\157')|$(printf '\164\154')|$(printf '\163\163')|$(printf '\170\170'))('s|/)"

scan_roots=(
  "$repo_root/skills/dotnet"
  "$repo_root/skills/wayfinder"
  "$repo_root/skills/frontend-design/references/icon-sourcing.md"
)

matches="$(grep -RIlE "$private_pattern" "${scan_roots[@]}" || true)"
[[ -z "$matches" ]] || fail "organization-specific content remains in: ${matches//$'\n'/, }"

matches="$(grep -RIlEi "$personal_pattern" "$repo_root/skills" || true)"
[[ -z "$matches" ]] || fail "personal or project-specific content remains in: ${matches//$'\n'/, }"

matches="$(grep -RIlE "$machine_pattern" "$repo_root/skills" || true)"
[[ -z "$matches" ]] || fail "machine-specific content remains in: ${matches//$'\n'/, }"

matches="$(grep -RIlE "$personal_author_pattern" "$repo_root/skills" || true)"
[[ -z "$matches" ]] || fail "personal author language remains in: ${matches//$'\n'/, }"

matches="$(grep -RIlE "$private_corpus_pattern" "$repo_root/skills" || true)"
[[ -z "$matches" ]] || fail "private corpus assumptions remain in: ${matches//$'\n'/, }"

matches="$(grep -RIlE "$private_ticket_pattern" "$repo_root/skills" || true)"
[[ -z "$matches" ]] || fail "private ticket identifiers remain in: ${matches//$'\n'/, }"

matches="$(grep -RIlE "$private_project_pattern" "$repo_root/skills" || true)"
[[ -z "$matches" ]] || fail "private project aliases remain in: ${matches//$'\n'/, }"

private_asset_prefix="$(printf '\142\142')-"
private_assets="$(find "$repo_root/skills/wayfinder" -type f -name "$private_asset_prefix*" -print)"
[[ -z "$private_assets" ]] || fail "organization-specific Wayfinder assets remain"

[[ ! -e "$repo_root/skills/wayfinder/references/${private_asset_prefix}style.md" ]] \
  || fail 'organization-specific Wayfinder reference remains'

grep -Fq 'C# / .NET / ASP.NET Core conventions' "$repo_root/skills/dotnet/SKILL.md" \
  || fail 'portable dotnet router is missing'
grep -Fq 'references/style-globals.md' "$repo_root/skills/wayfinder/SKILL.md" \
  || fail 'portable Wayfinder default style is missing'

validator="$repo_root/skills/skill-creator/scripts/quick_validate.py"
for portable_skill in dotnet wayfinder swift effect; do
  PYTHONDONTWRITEBYTECODE=1 python3 "$validator" "$repo_root/skills/$portable_skill" >/dev/null \
    || fail "$portable_skill does not satisfy the portable skill contract"
done

[[ -z "$(find "$repo_root" -path "$repo_root/.git" -prune -o -type f -name '*.pyc' -print)" ]] \
  || fail 'generated Python bytecode remains'
[[ -z "$(find "$repo_root/skills/framer/projects" -mindepth 1 -maxdepth 1 -type d ! -name '__template__' -print)" ]] \
  || fail 'generated Framer project context remains'
if grep -RIlE '/home/[^/]+/dev/agents' "$repo_root/skills" >/dev/null; then
  fail 'a personal absolute agents path remains'
fi
if grep -RIlE '/Users/[A-Za-z0-9._-]+' "$repo_root/skills" >/dev/null; then
  fail 'a named macOS home path remains'
fi

printf 'PASS public release boundary\n'
