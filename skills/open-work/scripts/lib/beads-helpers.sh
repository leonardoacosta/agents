#!/usr/bin/env bash
# beads-helpers.sh — Sourceable library for parsing [beads:ID] markers in tasks.md.
#
# Beads tooling was removed from the fleet (2026-09). The bd-mutation helpers
# (close_beads_all, close_orphaned_beads, bd_mint, bd_find_open_issue_or_wisp_title)
# were removed with it. What remains is the marker GRAMMAR and the read-only
# parser, because tasks.md files across the fleet still carry inert
# <!-- beads:epic:... --> and [beads:...] history markers.
#
# Functions:
#   extract_beads_ids <tasks.md>                          → sets BEADS_EPIC_ID, BEADS_FEATURE_ID, BEADS_TASK_IDS, BEADS_TASK_IDS_CHECKED
#
# Usage:
#   source <open-work-root>/lib/beads-helpers.sh
#   extract_beads_ids "openspec/my-feature/tasks.md"

# strict mode only when executed directly, never when sourced (avoid mutating the caller shell)
(return 0 2>/dev/null) || set -euo pipefail

# Guard against double-sourcing
[[ -n "${_BEADS_HELPERS_LOADED:-}" ]] && return 0
_BEADS_HELPERS_LOADED=1

# ---------------------------------------------------------------------------
# BEADS_ID_RE — canonical bead-ID grammar, confirmed 2026-07-20 against a live
# bd 1.1.0 sample (`bd list --json --limit 2000`, docs/reference/bd-1.1.0-baseline.md
# does not state the ID regex explicitly): hyphenated hash-body IDs with an
# optional dotted child suffix, e.g. `bd-alpha1`, `bd-alpha1.13`. This is the ONE
# bash definition; scripts/bin/openspec-status sources this file for it rather
# than duplicating. The Python-side twin is `BEADS_ID_RE` in scripts/bin/spec-sync,
# duplicated (with a lockstep cross-reference comment) into
# scripts/bin/{triage-list-drafts,deferred-specs,wave-plan-build,
# apply-resume-detect,wave-extend-scan}. See
# openspec/changes/shared-bead-id-marker-parser/ for the full rationale — do not
# introduce a third, independently-scoped character class anywhere in scripts/.
# ---------------------------------------------------------------------------
BEADS_ID_RE='[A-Za-z0-9][A-Za-z0-9._-]*'

# ---------------------------------------------------------------------------
# extract_beads_ids <tasks.md>
# Parses a tasks.md file and sets:
#   BEADS_EPIC_ID          — from <!-- beads:epic:XXX --> comment (first match)
#   BEADS_TASK_IDS         — space-separated, deduplicated, from ALL [beads:XXX]
#                             refs regardless of checkbox state. Kept for
#                             inventory/history purposes — no close sweep
#                             exists anymore.
#   BEADS_TASK_IDS_CHECKED — space-separated, deduplicated, from [beads:XXX]
#                             refs on lines whose checkbox is `- [x]` only.
#                             This is the set that is safe to close.
# Returns 1 if file does not exist.
# ---------------------------------------------------------------------------
extract_beads_ids() {
  local tasks_file="${1:?extract_beads_ids: tasks.md path required}"
  BEADS_EPIC_ID=""
  BEADS_FEATURE_ID=""
  BEADS_TASK_IDS=""
  BEADS_TASK_IDS_CHECKED=""

  if [[ ! -f "$tasks_file" ]]; then
    return 1
  fi

  BEADS_EPIC_ID=$(grep -oP "(?<=beads:epic:)${BEADS_ID_RE}" "$tasks_file" 2>/dev/null | head -1)
  BEADS_FEATURE_ID=$(grep -oP "(?<=beads:feature:)${BEADS_ID_RE}" "$tasks_file" 2>/dev/null | head -1)
  # Canonical grammar (BEADS_ID_RE, defined above) allows dots so dotted
  # sub-task IDs (the historical bd_mint --parent auto-suffix form, e.g.
  # bd-child1.1) match — the prior \w+-\w+ class alone silently dropped them.
  BEADS_TASK_IDS=$(grep -oP "(?<=\[beads:)${BEADS_ID_RE}(?=\])" "$tasks_file" 2>/dev/null | sort -u | tr '\n' ' ' | sed 's/ $//')
  BEADS_TASK_IDS_CHECKED=$(grep -oP "^\s*-\s*\[[xX]\].*\[beads:\K${BEADS_ID_RE}(?=\])" "$tasks_file" 2>/dev/null | sort -u | tr '\n' ' ' | sed 's/ $//')
}

