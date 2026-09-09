#!/usr/bin/env python3
"""Contract tests for the supplemental Firecrawl policy skill."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
POLICY = ROOT / "skills/firecrawl-policy/SKILL.md"
EVALS = ROOT / "skills/firecrawl-policy/evals/evals.json"
LEGACY = ROOT / "skills/firecrawl-policy/references/legacy-guidance.md"
APP = ROOT / "skills/firecrawl-policy/references/app-integration.md"


def test_supplement_frontmatter_and_scope() -> None:
    text = POLICY.read_text()
    assert "name: firecrawl-policy" in text
    assert "supplement" in text.lower()
    assert "mandatory" in text.lower()
    assert "firecrawl-" in text
    assert "not a comprehensive manual" in text.lower()


def test_policy_overrides_upstream_on_safety_boundaries() -> None:
    text = POLICY.read_text().lower()
    for marker in (
        "installed help is the syntax source of truth",
        "no live api/auth/network operations",
        "sdk may be added only to shipped code",
        "private parse egress",
        "firecrawl setup defaults",
        "unsupported redirect enforcement limitation",
        "fail-closed",
        "explicit action-level consent",
        "command -v firecrawl",
        "firecrawl --version",
        "firecrawl --status",
        "bounded recovery",
        "output as a refusal",
        "api keys, access tokens",
        "path b: shipped application integration",
        "bare `firecrawl`",
    ):
        assert marker in text, marker


def test_legacy_guidance_and_app_reference_are_preserved() -> None:
    assert LEGACY.exists()
    assert APP.exists()
    assert "Path B: Firecrawl in shipped application code" in APP.read_text()
    assert "Choose one intent path" in LEGACY.read_text()


def test_evals_are_retargeted_and_retain_app_integration_cases() -> None:
    data = json.loads(EVALS.read_text())
    assert data["skill_name"] == "firecrawl-policy"
    assert data["evals"]
    serialized = json.dumps(data).lower()
    assert "app-integration.md" in serialized
    assert "redirect" in serialized


if __name__ == "__main__":
    failures = 0
    for name, test in list(globals().items()):
        if name.startswith("test_"):
            try:
                test()
                print(f"PASS {name}")
            except AssertionError as error:
                failures += 1
                print(f"FAIL {name}: {error}")
    raise SystemExit(failures)
