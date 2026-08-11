#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_root="$repo_root/skills/jcode-command-center-orchestration"
skill_file="$skill_root/SKILL.md"
evals_file="$skill_root/evals/evals.json"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

require_file() {
  local relative_path="${1#"$repo_root"/}"
  [[ -f "$1" ]] || fail "missing file: $relative_path"
}

require_text() {
  local pattern="$1"
  local file="$2"
  grep -Eiq -- "$pattern" "$file" || fail "missing required guidance '$pattern' in ${file#"$repo_root"/}"
}

require_file "$skill_file"
require_file "$skill_root/references/authority-and-identifiers.md"
require_file "$skill_root/references/patterns-and-lifecycle.md"
require_file "$skill_root/references/capability-and-evidence.md"
require_file "$evals_file"

head -n 10 "$skill_file" | grep -Eq '^name: jcode-command-center-orchestration$' \
  || fail "invalid skill frontmatter name"
head -n 12 "$skill_file" | grep -Eq '^description:' \
  || fail "missing skill frontmatter description"

for pattern in \
  'Full handoff' \
  'Supervised Run/Task/Dispatch' \
  'Direct terminal action' \
  'Observation only'; do
  require_text "$pattern" "$skill_file"
done

require_text 'Select exactly one ownership pattern' "$skill_file"
require_text 'decision gate.*orthogonal control' "$skill_file"
require_text 'does not replace the selected ownership pattern' "$skill_file"
require_text 'decision gate is an orthogonal control, not a fifth ownership pattern' \
  "$skill_root/references/patterns-and-lifecycle.md"
require_text 'supervised Run/Task/Dispatch plus decision gate' "$evals_file"

require_text 'Jcode.*durable authority' "$skill_file"
require_text 'Orca.*runtime authority' "$skill_file"
require_text 'initiative ID.*run ID' "$skill_file"
require_text 'Project ID, Repository ID.*ProjectHostSetup ID' "$skill_file"
require_text 'Run ID as a namespace and inbox, not a scheduler' "$skill_file"
require_text 'Task ID for the work contract.*Dispatch ID for one attempt' "$skill_file"
require_text 'worktree.*terminal' "$skill_file"
require_text 'correlation ID.*idempotency ID' "$skill_file"
require_text 'Never place Orca runtime ID in a project-ID field' "$skill_file"
require_text 'authenticated principal' "$skill_file"
require_text 'Never replay across principal' "$skill_file"
require_text 'currently shipped status-only adapter is' "$skill_file"
require_text 'observation-only: launch, retry, and cancel remain unavailable' "$skill_file"
require_text 'abandon or fence the Dispatch' "$skill_file"
require_text 'Scope paths to the' "$skill_file"
require_text 'unavailable or unsupported.*durable state unchanged' "$skill_file"
require_text 'same pattern selection, permission, correlation, idempotency' "$skill_file"
require_text 'worker-start.*--model.*--effort' "$repo_root/skills/orchestration/SKILL.md"

if grep -Rni --exclude-dir=.git 'llmtrim' \
  "$repo_root/skills/orca-cli" \
  "$repo_root/skills/orchestration" >/dev/null; then
  fail "obsolete llmtrim guidance remains in generic Orca skills"
fi

python3 - "$evals_file" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, encoding="utf-8") as handle:
    payload = json.load(handle)

if payload.get("skill_name") != "jcode-command-center-orchestration":
    raise SystemExit("FAIL: eval skill_name does not match")

evals = payload.get("evals")
if not isinstance(evals, list) or len(evals) != 8:
    raise SystemExit("FAIL: expected exactly 8 evaluation cases")

expected_ids = list(range(1, 9))
actual_ids = [case.get("id") for case in evals]
if actual_ids != expected_ids:
    raise SystemExit(f"FAIL: eval IDs must be {expected_ids}, got {actual_ids}")

for case in evals:
    if not case.get("prompt") or not case.get("expected_output"):
        raise SystemExit(f"FAIL: eval {case.get('id')} lacks prompt or expected_output")
PY

printf 'PASS: Jcode Command Center orchestration skill contract\n'
