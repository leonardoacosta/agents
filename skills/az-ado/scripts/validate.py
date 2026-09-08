"""Validate the installed help-derived skill without contacting ADO."""
import json
import re
from pathlib import Path

root = Path(__file__).resolve().parents[1]
body = (root / 'SKILL.md').read_text()
assert body.startswith('---\nname: az-ado\ndescription: ')
assert len(body.splitlines()) < 500
for target in re.findall(r'\]\(([^)]+)\)', body):
    if not target.startswith('https://'):
        assert (root / target).is_file(), target
coverage = json.loads((root / 'references/coverage.json').read_text())
rows = coverage['commands']
paths = {row['command'] for row in rows}
assert len(paths) == len(rows) == coverage['help_pages'] == 269
assert max(len(path.split()) - 1 for path in paths) == 5
assert sum(not row['children'] for row in rows) == 206
for row in rows:
    assert all(child in paths for child in row['children']), row['command']
    domain = row['command'].split()[1]
    reference = (root / f'references/{domain}.md').read_text()
    assert f"## {row['command']}\n" in reference
for path in [
    'az boards work-item relation list-type',
    'az boards area project create',
    'az devops security permission update',
    'az repos pr policy list',
    'az pipelines variable-group variable update',
    'az artifacts universal download',
]:
    assert path in paths, path
lookup = {row['command']: row for row in rows}
assert '--wiql' in lookup['az boards query']['flags']
assert '--user' in lookup['az devops user show']['flags']
assert {'--id', '--branch', '--commit-id', '--parameters'} <= set(lookup['az pipelines run']['flags'])
assert '--project' not in lookup['az boards work-item update']['flags']
for path in root.rglob('*'):
    if path.is_file() and path.suffix in {'.md', '.json', '.py'}:
        text = path.read_text()
        assert text.isascii(), path
print('PASS: 269 help nodes, 206 leaves, five domains, depth 5, child closure, links, key flags and ASCII')
