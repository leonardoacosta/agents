#!/usr/bin/env python3
"""Offline checks for first-party skill intake and local composition."""
import hashlib
import json
import re
from pathlib import Path
import unittest
import yaml

ROOT = Path(__file__).resolve().parents[2]


class FirstPartySkills(unittest.TestCase):
    def test_firecrawl_catalog_is_complete_and_unmodified(self):
        source = json.loads((ROOT / 'skill-sources.json').read_text())['firecrawl']
        self.assertEqual(source['repository'], 'https://github.com/firecrawl/skills.git')
        self.assertEqual(len(source['revision']), 40)
        self.assertEqual(len(source['skills']), 33)
        self.assertEqual({s['family'] for s in source['skills'].values()}, {'core', 'build', 'workflows'})
        for name, skill in source['skills'].items():
            directory = ROOT / 'skills' / name
            actual = {str(p.relative_to(directory)): hashlib.sha256(p.read_bytes()).hexdigest()
                      for p in directory.rglob('*') if p.is_file()}
            self.assertEqual(actual, skill['files'], name)
            metadata = yaml.safe_load((directory / 'SKILL.md').read_text().split('---', 2)[1])
            self.assertEqual(metadata['name'], name)
            self.assertIsInstance(metadata['description'], str)
            self.assertTrue(metadata['description'].strip())
        self.assertIn('ISC License', (ROOT / source['license']).read_text())

    def test_supplements_are_required_without_editing_vendor_skills(self):
        contract = (ROOT / 'agents.md').read_text()
        self.assertIn('firecrawl-policy', contract)
        self.assertIn('agent-browser-policy', contract)
        self.assertIn('first-party', contract)
        for name in ('firecrawl-policy', 'agent-browser-policy'):
            self.assertTrue((ROOT / 'skills' / name / 'SKILL.md').is_file())

    def test_official_skill_links_resolve_after_flat_install(self):
        source = json.loads((ROOT / 'skill-sources.json').read_text())['firecrawl']
        for name in source['skills']:
            for document in (ROOT / 'skills' / name).rglob('*.md'):
                for target in re.findall(r'\]\(([^)]+)\)', document.read_text()):
                    if '://' in target or target.startswith(('#', 'mailto:')):
                        continue
                    if name == 'firecrawl-website-design-clone' and target == './.firecrawl/[source]-screenshot.png':
                        continue  # Upstream example of a generated artifact, not a skill dependency.
                    self.assertTrue((document.parent / target.split('#')[0]).exists(),
                                    f'{document.relative_to(ROOT)}: {target}')

    def test_intended_harnesses_record_entire_suite_and_supplements(self):
        source = json.loads((ROOT / 'skill-sources.json').read_text())['firecrawl']
        manifest = json.loads((ROOT / 'skill-projections.json').read_text())
        required = set(source['skills']) | {'firecrawl-policy'}
        for harness in ('claude-code', 'codex', 'cursor', 'github-copilot', 'opencode'):
            self.assertTrue(required <= set(manifest['harnesses'][harness]['skills']), harness)
        for harness in ('claude-code', 'codex'):
            self.assertTrue({'agent-browser', 'agent-browser-policy'} <=
                            set(manifest['harnesses'][harness]['skills']), harness)


if __name__ == '__main__':
    unittest.main()
