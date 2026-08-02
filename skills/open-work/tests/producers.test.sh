#!/usr/bin/env bash
set -euo pipefail

skill_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
open_items="$skill_root/scripts/bin/open-items"

[[ -f "$open_items" ]] || {
  echo "FAIL: packaged open-items is missing: $open_items" >&2
  exit 1
}

fixture="$(mktemp -d)"
trap 'rm -rf -- "$fixture"' EXIT
project="$fixture/project"
fake_bin="$fixture/bin"
mkdir -p "$project/.beads" "$project/openspec/changes/live-proposal" "$fake_bin"
git -C "$project" init -q
git -C "$project" config user.email fixture@example.com
git -C "$project" config user.name Fixture
printf '# fixture\n' >"$project/README.md"
git -C "$project" add README.md
git -C "$project" commit -qm init

cat >"$fake_bin/bd" <<'SH'
#!/usr/bin/env bash
printf '%s\n' "$*" >"$FAKE_BD_ARGS"
case "${FAKE_BD_MODE:-ok}" in
  fail) exit 7 ;;
  malformed) printf 'not-json\n' ;;
  *) printf '%s\n' "$FAKE_BD_JSON" ;;
esac
SH
chmod +x "$fake_bin/bd"

live_json="$(cat "$skill_root/tests/fixtures/live-beads.json")"
cached_fixture="$skill_root/tests/fixtures/cached-beads.jsonl"
cp -f "$cached_fixture" "$project/.beads/issues.jsonl"

run_open_items() {
  local mode="$1"
  (
    cd "$project"
    PATH="$fake_bin:$PATH" \
      FAKE_BD_ARGS="$fixture/bd.args" \
      FAKE_BD_MODE="$mode" \
      FAKE_BD_JSON="$live_json" \
      OPEN_WORK_ROOT="$skill_root/scripts" \
      python3 "$open_items" --json --live-beads
  )
}

live_output="$(run_open_items ok)"
jq -e '
  .beads.available == true and
  .beads.counts_source == "bd list --all --json --limit=0 (live)" and
  .beads.total_open == 6 and
  .beads.active_epics == 1 and
  ([.beads.containers[] | select(.id=="container") | .title] == ["[CAPABILITY] durable container"]) and
  .beads.active_proposal_linked == 1 and
  ([.beads.items[].id] | index("cached-only") | not) and
  ([.beads.items[] | select(.id=="live-blocked") | .bucket] == ["blocked"]) and
  ([.beads.items[] | select(.id=="live-human") | .bucket] == ["human_only"]) and
  ([.beads.items[] | select(.id=="live-progress") | .bucket] == ["in_progress"]) and
  ([.beads.items[] | select(.id=="live-answered") | .bucket] == ["open"]) and
  ([.beads.items[] | select(.id=="live-answered") | .dispositioned] == [true]) and
  ([.beads.items[] | select(.id=="live-answered") | .bucket_reason] == ["answered 08-02: proceed with the portable implementation"])
' <<<"$live_output" >/dev/null
[[ "$(cat "$fixture/bd.args")" == "list --all --json --limit=0" ]]

project_code_json="$(jq 'map(if .id == "live-open" then .title = "api migration" else . end)' <<<"$live_json")"
project_code_output="$({
  cd "$project"
  PATH="$fake_bin:$PATH" \
    FAKE_BD_ARGS="$fixture/bd.args" \
    FAKE_BD_JSON="$project_code_json" \
    OPEN_WORK_PROJECT_CODES="api,web" \
    OPEN_WORK_ROOT="$skill_root/scripts" \
    python3 "$open_items" --json --live-beads
})"
jq -e '([.beads.items[] | select(.id=="live-open") | .cross_repo] == ["api"])' \
  <<<"$project_code_output" >/dev/null

for failure_mode in fail malformed; do
  failure_output="$(run_open_items "$failure_mode")"
  jq -e '
    .beads.available == false and
    .beads.source == "live" and
    ([.. | strings] | index("cached-only") | not)
  ' <<<"$failure_output" >/dev/null
done

cached_output="$(cd "$project" && OPEN_WORK_ROOT="$skill_root/scripts" python3 "$open_items" --json)"
jq -e '
  .beads.available == true and
  .beads.counts_source == "issues.jsonl (last bd flush)" and
  ([.beads.items[].id] | index("cached-only") != null)
' <<<"$cached_output" >/dev/null

source_local_output="$(cd "$project" && env -u OPEN_WORK_ROOT PATH="$fake_bin:$PATH" FAKE_BD_ARGS="$fixture/bd.args" FAKE_BD_JSON="$live_json" python3 "$open_items" --json --live-beads)"
jq -e '.beads.available == true and .beads.source == "live"' <<<"$source_local_output" >/dev/null

large_live_json="$(jq -n '[range(0; 31) | {id:("many-" + (.|tostring)), title:"queued work", status:"open", priority:2, issue_type:"task", labels:[], dependencies:[]}]')"
truncated_output="$(
  cd "$project"
  PATH="$fake_bin:$PATH" FAKE_BD_ARGS="$fixture/bd.args" FAKE_BD_JSON="$large_live_json" \
    python3 "$open_items" --json --live-beads
)"
jq -e '.beads.total_open == 31 and .beads.truncated == true and (.beads.items | length) == 30' <<<"$truncated_output" >/dev/null

no_beads="$fixture/no-beads"
mkdir -p "$no_beads"
git -C "$no_beads" init -q
no_beads_output="$(cd "$no_beads" && OPEN_WORK_ROOT="$skill_root/scripts" python3 "$open_items" --json --live-beads)"
jq -e '.beads.available == false and .beads.source == "live"' <<<"$no_beads_output" >/dev/null

find "$skill_root/scripts" -type f -perm /111 -print -quit | grep -q . && {
  echo 'FAIL: packaged helper source must remain non-executable' >&2
  exit 1
}

echo 'PASS: live Beads is authoritative and never falls back to cached JSONL'
echo 'PASS: cached mode remains explicit and source-labelled'
echo 'PASS: bucket precedence, containers, proposal suppression, and no-Beads behavior hold'
echo 'PASS: disposition comments, progress, truncation, and source-local execution hold'
echo 'PASS: packaged helper source is interpreter-invoked read-only content'
