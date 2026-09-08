#!/usr/bin/env python3
"""Validate native orchestration packaging. Behavioral review is a separate gate."""
import json
from pathlib import Path
import re
import unittest

ROOT = Path(__file__).resolve().parents[1]
SKILL = ROOT / 'skills/jcode-orchestration/SKILL.md'
RETIRED = ('orca-cli', 'orchestration', 'jcode-command-center-orchestration')


class NativeSkillContract(unittest.TestCase):
    def test_frontmatter_and_example(self):
        text = SKILL.read_text()
        self.assertTrue(text.startswith('---\nname: jcode-orchestration\n'))
        self.assertIn('description:', text.split('---', 2)[1])
        examples = re.findall(r'```json\n(.*?)\n```', text, re.S)
        self.assertTrue(examples)
        for example in examples:
            payload = json.loads(example)
            self.assertEqual(payload['action'], 'spawn')
            self.assertTrue(payload['label'])
            self.assertTrue(payload['prompt'])
            self.assertNotIn('model', payload)
            self.assertNotIn('spawn_mode', payload)

    def test_coverage(self):
        text = SKILL.read_text()
        for concept in ('await_members', 'task_graph', 'run_plan', 'complete_node',
                        'initiative', 'schedule', 'jcode_docs', 'list_models',
                        'observation time', 'artifact', 'failed', 'stopped',
                        'timeout', 'force', 'operator', 'calling harness'):
            with self.subTest(concept=concept):
                self.assertIn(concept, text)

    def test_no_retired_active_guidance(self):
        forbidden = re.compile(r'\borca\b|jcode-command-center-orchestration', re.I)
        for folder in ('skills',):
            for path in (ROOT / folder).rglob('*'):
                if path.is_file() and path.suffix in ('.md', '.json', '.txt'):
                    with self.subTest(path=str(path.relative_to(ROOT))):
                        self.assertIsNone(forbidden.search(path.read_text(errors='replace')))
        for name in RETIRED:
            self.assertFalse((ROOT / 'skills' / name).exists())
        projections = (ROOT / 'skill-projections.json').read_text()
        self.assertIn('"jcode-orchestration"', projections)
        self.assertNotIn(RETIRED[2], projections)


if __name__ == '__main__':
    unittest.main()
