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
mkdir -p "$project"
git -C "$project" init -q
git -C "$project" config user.email fixture@example.com
git -C "$project" config user.name Fixture
printf '# fixture\n' >"$project/README.md"
git -C "$project" add README.md
git -C "$project" commit -qm init

# Beads tooling was removed from the fleet (2026-09). The beads source in
# open-items output is now a stable "unavailable" shape: no bd, no cached
# JSONL, no fake-binary fixture. These tests pin the degraded contract and
# the still-live producers (proposals, plans, triage).

inv="$(cd "$project" && OPEN_WORK_ROOT="$skill_root/scripts" python3 "$open_items" --json)"
jq -e '
  .beads.available == false and
  .beads.source == "none" and
  .summary.open_beads == 0 and
  (has("error") | not)
' <<<"$inv" >/dev/null

# --live-beads was removed with the tooling: passing it is an unsupported argument.
jq -e '.error == "unsupported arguments" and (.arguments == ["--limit=all"])' \
  <<<"$(cd "$project" && python3 "$open_items" --json --limit=all)" >/dev/null
jq -e '.error == "unsupported arguments" and (.arguments == ["--live-beads"])' \
  <<<"$(cd "$project" && python3 "$open_items" --json --live-beads)" >/dev/null

# One unreadable source degrades that key alone — never the whole document.
if [[ "$(id -u)" != 0 ]]; then
  mkdir -p "$project/plans"
  printf '| # | Title | Status |\n| 001 | a plan | OPEN |\n' >"$project/plans/README.md"
  chmod 000 "$project/plans/README.md"
  isolation_output="$(cd "$project" && OPEN_WORK_ROOT="$skill_root/scripts" python3 "$open_items" --json)"
  chmod 644 "$project/plans/README.md"
  rm -rf "$project/plans"
  jq -e '
    .plans.available == false and (.plans.error | length) > 0 and
    .beads.available == false and
    (has("error") | not)
  ' <<<"$isolation_output" >/dev/null
fi

# triage-list-drafts frontmatter regression. No fixture previously gave that producer a
# proposal.md WITH frontmatter, so parse_frontmatter's return shape was uncovered: a
# tuple-returning success path crashed both `--next-order-code` and the main draft scan
# with AttributeError, while every existing test stayed green because collect_drafts
# skips a directory that has no proposal.md.
triage_bin="$skill_root/scripts/bin/triage-list-drafts"
triage_fixture="$fixture/triage-repo"
mkdir -p "$triage_fixture/openspec/changes/sample-change"
git -C "$triage_fixture" init -q
printf -- '---\norder: 0804a\nafter: other-slug -- waits on the other one\n---\n\n# Proposal\n\n## Context\n- depends on: `other-slug`\n' \
  >"$triage_fixture/openspec/changes/sample-change/proposal.md"
printf -- '## DB Batch\n\n- [ ] 1.1 do the thing\n' \
  >"$triage_fixture/openspec/changes/sample-change/tasks.md"

triage_out="$(cd "$triage_fixture" && python3 "$triage_bin" --json)"
jq -e '
  (.drafts | length) == 1 and
  (.drafts[0].order == "0804a") and
  (.drafts[0].after == "other-slug") and
  (.drafts[0].depends_on == ["other-slug"]) and
  (.drafts[0].bead_unknown == true) and
  (has("error") | not)
' <<<"$triage_out" >/dev/null

# The next order code advances past a fixed one in the fixture. The absolute
# value is date-derived (MMDD + suffix); assert only that it differs from the
# fixture's order and is well-formed — the hardcoded 0804b expectation drifted
# with the calendar (pre-existing failure, fixed here).
order_out="$(cd "$triage_fixture" && python3 "$triage_bin" --next-order-code --json)"
jq -e '(.order_code | test("^[0-9]{4}[a-z]$")) and .order_code != "0804a" and (has("error") | not)' \
  <<<"$order_out" >/dev/null

# beads-helpers grammar remains the single canonical parser for inert markers.
helpers="$skill_root/scripts/lib/beads-helpers.sh"
tasks_with_markers="$fixture/markers/tasks.md"
mkdir -p "$(dirname "$tasks_with_markers")"
printf '<!-- beads:epic:cap-1 -->\n\n## Tasks\n\n- [x] 1.1 done thing [beads:bd-aaa]\n- [ ] 1.2 open thing [beads:bd-bbb.2]\n' \
  >"$tasks_with_markers"
bash -c "
  source '$helpers'
  extract_beads_ids '$tasks_with_markers'
  [[ \"\$BEADS_EPIC_ID\" == 'cap-1' ]] || exit 10
  [[ \"\$BEADS_TASK_IDS\" == 'bd-aaa bd-bbb.2' ]] || exit 11
  [[ \"\$BEADS_TASK_IDS_CHECKED\" == 'bd-aaa' ]] || exit 12
  # dotted IDs survive the grammar
  [[ \"\$BEADS_TASK_IDS\" == *'bd-bbb.2'* ]] || exit 13
" || { echo 'FAIL: beads-helpers grammar regression' >&2; exit 1; }

find "$skill_root/scripts" -type f -perm /111 -print -quit | grep -q . && {
  echo 'FAIL: packaged helper source must remain non-executable' >&2
  exit 1
}

echo 'PASS: beads source is a stable unavailable shape after tooling removal'
echo 'PASS: --live-beads is rejected as an unsupported argument'
echo 'PASS: an unreadable source degrades alone, not the whole inventory'
echo 'PASS: triage-list-drafts parses frontmatter and stays permissive (bead_unknown)'
echo 'PASS: next order code is date-derived and well-formed (hardcoded 0804b drift fixed)'
echo 'PASS: beads-helpers grammar parses inert markers, checked/unchecked split holds'
echo 'PASS: packaged helper source is interpreter-invoked read-only content'
