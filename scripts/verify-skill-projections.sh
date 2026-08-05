#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
default_agents_root="$(cd -- "$script_dir/.." && pwd)"
manifest="$default_agents_root/skill-projections.json"
agents_root="$default_agents_root"
projection_home="${HOME:-}"

usage() {
  printf 'usage: %s [--home <path>] [--agents-root <path>] [--manifest <path>]\n' "${0##*/}" >&2
}

while (($#)); do
  case "$1" in
    --home) projection_home="$2"; shift 2 ;;
    --agents-root) agents_root="$2"; shift 2 ;;
    --manifest) manifest="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 64 ;;
  esac
done

fail() { printf 'ERROR %s\n' "$*" >&2; exit 1; }
json_entry() {
  jq -cn --arg skill "$1" --arg state "$2" --arg path "$3" --arg detail "$4" \
    '{skill: $skill, state: $state, path: $path, detail: $detail}'
}

[[ -r "$manifest" ]] || fail "manifest is not readable: $manifest"
[[ -n "$projection_home" ]] || fail "HOME must be set, or pass --home"
jq -e '
  .schemaVersion == 1 and
  .managedBy == "agents-skill-projections/v1" and
  (.release.revision | type == "string" and length == 40) and
  (.harnesses | keys | sort == ["amp", "antigravity-cli", "claude-code", "codex", "cursor", "gemini-cli", "github-copilot", "opencode", "pi", "zed"]) and
  ([.harnesses[] | .root | strings | select(startswith("/") or contains(".."))] | length == 0)
' "$manifest" >/dev/null || fail "manifest does not satisfy schema v1"

# An exclusion records a skill whose local copy diverges from the canonical store on purpose, so
# projecting it would destroy the divergence. Absent allowedHarnesses, no harness may project it.
projected_exclusions="$(jq -r '
  (.exclusions // {}) as $ex
  | [ .harnesses | to_entries[] as $h
      | $h.value.skills[]? as $skill
      | ($ex[$skill] // empty) as $rule
      | select(($rule.allowedHarnesses // []) | index($h.key) | not)
      | "\($h.key)/\($skill) (\($rule.cause))" ]
  | join(", ")
' "$manifest")"
[[ -z "$projected_exclusions" ]] || fail "excluded skills appear in harness rosters: $projected_exclusions"

agents_root="$(realpath -e "$agents_root")" || fail "agents root does not exist: $agents_root"
store="$(realpath -e "$agents_root/skills")" || fail "canonical skill store does not exist: $agents_root/skills"
projection_home="$(realpath -m "$projection_home")"

validate_firecrawl_frontmatter() {
  command -v yq >/dev/null 2>&1 || fail "yq is required to validate materialized Firecrawl frontmatter"
  local skill_file
  while IFS= read -r -d '' skill_file; do
    if ! awk 'NR == 1 { if ($0 != "---") exit 1; next } /^---$/ { exit } { print }' "$skill_file" \
      | yq -e '.name != null and .description != null' >/dev/null 2>&1; then
      fail "malformed materialized Firecrawl frontmatter: $skill_file"
    fi
  done < <(find "$store" -mindepth 2 -maxdepth 2 -path '*/firecrawl*/SKILL.md' -print0 | sort -z)
}

validate_firecrawl_frontmatter

classify_projection() {
  local skill="$1" candidate="$2" target="$3"
  if [[ ! -e "$target" || ! -d "$target" ]]; then
    json_entry "$skill" "source-missing" "$candidate" "canonical materialization is absent"
  elif [[ -L "$candidate" ]]; then
    local resolved
    if ! resolved="$(realpath -e "$candidate" 2>/dev/null)"; then
      json_entry "$skill" "broken" "$candidate" "dangling symlink: $(readlink "$candidate")"
    elif [[ "$resolved" == "$target" ]]; then
      json_entry "$skill" "healthy" "$candidate" "resolves to canonical materialization"
    else
      json_entry "$skill" "protected-conflict" "$candidate" "symlink resolves outside canonical materialization: $resolved"
    fi
  elif [[ ! -e "$candidate" ]]; then
    json_entry "$skill" "missing" "$candidate" "recorded projection is absent"
  elif [[ -d "$candidate" ]]; then
    if diff -qr -- "$candidate" "$target" >/dev/null 2>&1; then
      json_entry "$skill" "stale-copy" "$candidate" "regular directory matches canonical materialization"
    else
      json_entry "$skill" "protected-conflict" "$candidate" "regular directory is locally owned"
    fi
  else
    json_entry "$skill" "protected-conflict" "$candidate" "non-symlink local path is locally owned"
  fi
}

groups=()
while IFS= read -r harness; do
  relative_root="$(jq -r --arg h "$harness" '.harnesses[$h].root' "$manifest")"
  root="$projection_home/$relative_root"
  native="$(jq -r --arg h "$harness" '.harnesses[$h].nativeCanonical // false' "$manifest")"
  entries=()

  if [[ "$native" == true ]]; then
    if [[ -d "$root" ]] && [[ "$(realpath -e "$root")" == "$store" ]]; then
      entries+=("$(json_entry "<canonical-store>" "healthy" "$root" "native canonical consumption")")
      group_state="healthy"
    elif [[ -e "$root" || -L "$root" ]]; then
      entries+=("$(json_entry "<canonical-store>" "protected-conflict" "$root" "native root differs from canonical store")")
      group_state="protected-conflict"
    else
      entries+=("$(json_entry "<canonical-store>" "not-installed" "$root" "native root is absent")")
      group_state="not-installed"
    fi
  elif [[ ! -d "$root" ]]; then
    entries+=("$(json_entry "<root>" "not-installed" "$root" "harness root is absent")")
    group_state="not-installed"
  else
    while IFS= read -r skill; do
      target="$store/$skill"
      candidate="$root/$skill"
      entries+=("$(classify_projection "$skill" "$candidate" "$target")")
    done < <(jq -r --arg h "$harness" '.harnesses[$h].skills[]' "$manifest")

    while IFS= read -r path; do
      skill="${path##*/}"
      if ! jq -e --arg h "$harness" --arg s "$skill" '.harnesses[$h].skills | index($s) != null' "$manifest" >/dev/null; then
        entries+=("$(json_entry "$skill" "protected-conflict" "$path" "unrecorded local projection")")
      fi
    done < <(find "$root" -mindepth 1 -maxdepth 1 -print | sort)

    group_state="healthy"
    for entry in "${entries[@]}"; do
      state="$(jq -r '.state' <<<"$entry")"
      if [[ "$state" != "healthy" ]]; then group_state="$state"; break; fi
    done
  fi

  entries_json="$(printf '%s\n' "${entries[@]}" | jq -s '.')"
  groups+=("$(jq -cn --arg harness "$harness" --arg root "$root" --arg state "$group_state" --argjson entries "$entries_json" '{harness: $harness, root: $root, state: $state, entries: $entries}')")
done < <(jq -r '.harnesses | keys[]' "$manifest")

printf '%s\n' "${groups[@]}" | jq -s --arg manifest "$(realpath -m "$manifest")" --arg store "$store" \
  '{manifest: $manifest, canonicalStore: $store, harnesses: .}'
