#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
default_agents_root="$(cd -- "$script_dir/.." && pwd)"
manifest="$default_agents_root/skill-projections.json"
agents_root="$default_agents_root"
projection_home="${HOME:-}"
lock_file=""
write_mode=false
verified_release=""
audited_release=""
self_test=false

usage() {
  cat >&2 <<'EOF'
usage: reconcile-skill-projections.sh [options]

Dry-run is the default. Write mode requires both release attestations to exactly
match the revision recorded in the manifest.

  --home <path>                 Harness home to inspect
  --agents-root <path>          Repository containing skills/ (default: script parent)
  --manifest <path>             Projection manifest (default: agents-root/skill-projections.json)
  --lock-file <path>            Installer-owned global provenance lock (auto-detected by default)
  --write                       Create or replace only manifest-recorded symlinks
  --verified-release <sha>      Verified skills release revision required by --write
  --audited-release <sha>       Passed source-to-materialization audit revision required by --write
  --self-test                   Run isolated dry-run, write, conflict, and idempotency checks
EOF
}

fail() { printf 'ERROR %s\n' "$*" >&2; exit 1; }
emit() { jq -cn --arg action "$1" --arg harness "$2" --arg skill "$3" --arg path "$4" --arg detail "$5" '{action: $action, harness: $harness, skill: $skill, path: $path, detail: $detail}'; }

while (($#)); do
  case "$1" in
    --home) projection_home="$2"; shift 2 ;;
    --agents-root) agents_root="$2"; shift 2 ;;
    --manifest) manifest="$2"; shift 2 ;;
    --lock-file) lock_file="$2"; shift 2 ;;
    --write) write_mode=true; shift ;;
    --verified-release) verified_release="$2"; shift 2 ;;
    --audited-release) audited_release="$2"; shift 2 ;;
    --self-test) self_test=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) usage; exit 64 ;;
  esac
done

run_self_test() {
  local fixture revision output output_again source_lock
  fixture="$(mktemp -d)"
  trap 'rm -rf "$fixture"' RETURN
  mkdir -p "$fixture/agents/skills" "$fixture/home/.codex/skills" "$fixture/home/.cursor/skills" \
    "$fixture/home/.copilot/skills" "$fixture/home/.config/opencode/skills"
  cp "$manifest" "$fixture/agents/skill-projections.json"
  source_lock="$(resolve_lock_file)"
  cp "$source_lock" "$fixture/agents/.skill-lock.json"
  [[ -r "$agents_root/skills-lock.json" ]] && cp "$agents_root/skills-lock.json" "$fixture/agents/skills-lock.json"
  while IFS= read -r skill; do mkdir -p "$fixture/agents/skills/$skill"; done < <(jq -r '[.harnesses[].skills[]] | unique[]' "$manifest")
  revision="$(jq -r '.release.revision' "$manifest")"
  ln -s missing-target "$fixture/home/.codex/skills/frontend-design"
  ln -s /unrecorded-target "$fixture/home/.codex/skills/user-added"
  mkdir -p "$fixture/home/.cursor/skills/firecrawl" "$fixture/home/.copilot/skills/firecrawl"

  output="$("$0" --home "$fixture/home" --agents-root "$fixture/agents" --manifest "$fixture/agents/skill-projections.json" --lock-file "$fixture/agents/.skill-lock.json")"
  jq -s -e '[.[] | select(.action == "create" and .harness == "codex" and .skill == "firecrawl")] | length == 1' <<<"$output" >/dev/null || fail "self-test dry run did not plan a recorded missing projection"
  jq -s -e '[.[] | select(.action == "replace" and .harness == "codex" and .skill == "frontend-design")] | length == 1' <<<"$output" >/dev/null || fail "self-test dry run did not plan recorded dangling-link repair"
  [[ ! -e "$fixture/home/.codex/skills/firecrawl" ]] || fail "self-test dry run mutated a projection"
  if "$0" --write --verified-release "$revision" --audited-release invalid --home "$fixture/home" --agents-root "$fixture/agents" --manifest "$fixture/agents/skill-projections.json" --lock-file "$fixture/agents/.skill-lock.json" >/dev/null 2>&1; then
    fail "self-test accepted an invalid source-audit release"
  fi

  output="$("$0" --write --verified-release "$revision" --audited-release "$revision" --home "$fixture/home" --agents-root "$fixture/agents" --manifest "$fixture/agents/skill-projections.json" --lock-file "$fixture/agents/.skill-lock.json")"
  jq -s -e '[.[] | select(.action == "protected-conflict" and .harness == "cursor" and .skill == "firecrawl")] | length == 1' <<<"$output" >/dev/null || fail "self-test did not preserve regular-directory conflict"
  [[ -d "$fixture/home/.cursor/skills/firecrawl" && ! -L "$fixture/home/.cursor/skills/firecrawl" ]] || fail "self-test overwrote protected directory"
  [[ "$(realpath -e "$fixture/home/.codex/skills/firecrawl")" == "$fixture/agents/skills/firecrawl" ]] || fail "self-test did not create canonical link"
  # A skill pinned only by skills-lock.json (vendored third-party upstream, absent from the
  # installer lock) must project exactly like a release-pinned one.
  jq -e '.skills.cloudflare.sourceType == "github"' "$fixture/agents/skills-lock.json" >/dev/null \
    && ! jq -e '.skills.cloudflare' "$fixture/agents/.skill-lock.json" >/dev/null 2>&1 \
    || fail "self-test fixture does not isolate a vendored-only projection"
  [[ "$(realpath -e "$fixture/home/.codex/skills/cloudflare")" == "$fixture/agents/skills/cloudflare" ]] \
    || fail "self-test did not project a vendored-lane skill"

  output_again="$("$0" --write --verified-release "$revision" --audited-release "$revision" --home "$fixture/home" --agents-root "$fixture/agents" --manifest "$fixture/agents/skill-projections.json" --lock-file "$fixture/agents/.skill-lock.json")"
  jq -s -e '[.[] | select(.action == "create" or .action == "replace")] | length == 0' <<<"$output_again" >/dev/null || fail "self-test write mode is not idempotent"
  "$script_dir/verify-skill-projections.sh" --home "$fixture/home" --agents-root "$fixture/agents" --manifest "$fixture/agents/skill-projections.json" \
    | jq -e '
        (.harnesses | length == 10) and
        ([.harnesses[] | select(.harness == "codex") | .entries[] | select(.skill == "firecrawl" and .state == "healthy")] | length == 1) and
        ([.harnesses[] | select(.harness == "codex") | .entries[] | select(.skill == "user-added" and .state == "protected-conflict")] | length == 1) and
        ([.harnesses[] | select(.harness == "github-copilot") | .entries[] | select(.skill == "firecrawl" and .state == "stale-copy")] | length == 1)
      ' >/dev/null \
    || fail "self-test post-reconcile verification did not preserve expected states"
  mkdir -p "$fixture/agents/skills/firecrawl-build"
  printf '%s\n' '---' 'name: firecrawl-build' 'description: contains an unquoted colon: invalid' '---' >"$fixture/agents/skills/firecrawl-build/SKILL.md"
  if "$script_dir/verify-skill-projections.sh" --home "$fixture/home" --agents-root "$fixture/agents" --manifest "$fixture/agents/skill-projections.json" >/dev/null 2>&1; then
    fail "self-test accepted malformed materialized Firecrawl frontmatter"
  fi
  printf 'PASS reconcile-skill-projections self-test\n'
}

resolve_lock_file() {
  if [[ -n "$lock_file" ]]; then
    printf '%s\n' "$lock_file"
    return
  fi
  local state_lock="${XDG_STATE_HOME:-${HOME:-}/.local/state}/skills/.skill-lock.json"
  if [[ -r "$state_lock" ]]; then
    printf '%s\n' "$state_lock"
  else
    printf '%s\n' "$agents_root/.skill-lock.json"
  fi
}

if [[ "$self_test" == true ]]; then
  run_self_test
  exit 0
fi

[[ -r "$manifest" ]] || fail "manifest is not readable: $manifest"
[[ -n "$projection_home" ]] || fail "HOME must be set, or pass --home"
jq -e '
  .schemaVersion == 2 and
  .managedBy == "agents-skill-projections/v1" and
  (.release.revision | type == "string" and length == 40) and
  (.harnesses | keys | sort == ["amp", "antigravity-cli", "claude-code", "codex", "cursor", "gemini-cli", "github-copilot", "opencode", "pi", "zed"]) and
  ([.harnesses[] | .root | strings | select(startswith("/") or contains(".."))] | length == 0)
' "$manifest" >/dev/null || fail "manifest does not satisfy schema v1"

revision="$(jq -r '.release.revision' "$manifest")"
if [[ "$write_mode" == true ]] && { [[ "$verified_release" != "$revision" ]] || [[ "$audited_release" != "$revision" ]]; }; then
  fail "--write requires --verified-release and --audited-release equal to manifest revision $revision"
fi

agents_root="$(realpath -e "$agents_root")" || fail "agents root does not exist: $agents_root"
store="$(realpath -e "$agents_root/skills")" || fail "canonical skill store does not exist: $agents_root/skills"
lock_file="$(resolve_lock_file)"
[[ -r "$lock_file" ]] || fail "materialization lock is not readable: $lock_file"
expected_source="$(jq -r '.release.source' "$manifest")"
vendor_lock="$agents_root/skills-lock.json"
projection_home="$(realpath -m "$projection_home")"

# A projection is legitimate under either provenance ledger. The installer-owned lock pins
# skills materialized from the manifest's own release; skills-lock.json pins skills vendored
# into this repository from a third-party upstream. Requiring the first alone stranded the
# vendored lane outside projection entirely -- it could be materialized but never linked.
skill_is_pinned() {
  local skill="$1"
  jq -e --arg skill "$skill" --arg source "$expected_source" \
    '.skills[$skill].sourceUrl == $source' "$lock_file" >/dev/null 2>&1 && return 0
  [[ -r "$vendor_lock" ]] || return 1
  jq -e --arg skill "$skill" '
    .skills[$skill]
    | (.sourceType == "github")
      and (.source | type == "string" and length > 0)
      and (.computedHash | type == "string" and length > 0)
  ' "$vendor_lock" >/dev/null 2>&1
}

while IFS= read -r harness; do
  [[ "$(jq -r --arg h "$harness" '.harnesses[$h].nativeCanonical // false' "$manifest")" == true ]] && continue
  relative_root="$(jq -r --arg h "$harness" '.harnesses[$h].root' "$manifest")"
  root="$projection_home/$relative_root"
  if [[ ! -d "$root" ]]; then
    emit "not-installed" "$harness" "<root>" "$root" "harness root is absent; reconciler will not create it"
    continue
  fi
  root="$(realpath -e "$root")"

  while IFS= read -r skill; do
    candidate="$root/$skill"
    target="$store/$skill"
    if ! skill_is_pinned "$skill"; then
      emit "source-unpinned" "$harness" "$skill" "$candidate" "neither lock pins this projection"
    elif [[ ! -d "$target" ]]; then
      emit "source-missing" "$harness" "$skill" "$candidate" "canonical materialization is absent"
    elif [[ -L "$candidate" ]]; then
      if resolved="$(realpath -e "$candidate" 2>/dev/null)" && [[ "$resolved" == "$target" ]]; then
        emit "no-change" "$harness" "$skill" "$candidate" "manifest-owned link resolves canonically"
      elif [[ "$write_mode" == true ]]; then
        tmp_dir="$(mktemp -d "$root/.agents-projection.XXXXXX")"
        relative_target="$(realpath --relative-to="$root" "$target")"
        ln -s "$relative_target" "$tmp_dir/$skill"
        mv -Tf "$tmp_dir/$skill" "$candidate"
        rmdir "$tmp_dir"
        emit "replace" "$harness" "$skill" "$candidate" "replaced manifest-owned symlink with canonical target"
      else
        emit "replace" "$harness" "$skill" "$candidate" "dry-run: manifest-owned symlink would be replaced"
      fi
    elif [[ -e "$candidate" ]]; then
      emit "protected-conflict" "$harness" "$skill" "$candidate" "regular local path is not reconciler-owned"
    elif [[ "$write_mode" == true ]]; then
      relative_target="$(realpath --relative-to="$root" "$target")"
      ln -s "$relative_target" "$candidate"
      emit "create" "$harness" "$skill" "$candidate" "created manifest-owned canonical link"
    else
      emit "create" "$harness" "$skill" "$candidate" "dry-run: manifest-owned link would be created"
    fi
  done < <(jq -r --arg h "$harness" '.harnesses[$h].skills[]' "$manifest")
done < <(jq -r '.harnesses | keys[]' "$manifest")
