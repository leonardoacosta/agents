#!/usr/bin/env python3
"""Contract tests for the portable agent-browser loader and policy supplement."""
from __future__ import annotations

import json
import re
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
SKILL = ROOT / "skills/agent-browser/SKILL.md"
POLICY = ROOT / "skills/agent-browser-policy/SKILL.md"
EVALS = ROOT / "skills/agent-browser/evals/evals.json"


def test_portable_skill_is_a_thin_upstream_loader() -> None:
    text = SKILL.read_text()
    for marker in ("agent-browser skills get core", "agent-browser skills path core", "agent-browser-policy", "fail closed", "--pin-tab"):
        assert marker in text, marker
    assert len(text.splitlines()) <= 45


def test_portable_skill_has_no_host_specific_or_credential_material() -> None:
    text = SKILL.read_text().lower()
    for marker in ("/home/", "your chrome", "leos", "priceless", "cookie", "token", "password"):
        assert marker not in text, marker


def test_policy_covers_strict_boundaries() -> None:
    text = POLICY.read_text().lower()
    for marker in ("confirmation", "credential", "cookie", "shared cookies", "private profile", "private context path", "harness", "cli", "cleanup", "task-unique", "cdp", "pin-tab", "profile lock", "temporary snapshot", "managed chromium", "human-owned browser process", "owned tabs", "private context"):
        assert marker in text, marker


def test_references_are_reachable_from_loader() -> None:
    text = SKILL.read_text()
    assert re.search(r"agent-browser skills get core --full", text)
    assert re.search(r"agent-browser skills path core", text)


def test_evals_have_concrete_scenarios_and_assertions() -> None:
    data = json.loads(EVALS.read_text())
    assert set(data["comparison"]["variants"]) == {"original-custom", "installed-upstream-core", "upstream-plus-policy"}
    scenarios = {item["id"] for item in data["evals"]}
    assert {"stale-refs", "auth-denial", "same-cwd-isolation", "shared-cdp", "private-profile"} <= scenarios
    for item in data["evals"]:
        assert item["expected_assertions"]
        assert item["prompt"]


def test_optional_installed_core_smoke_and_missing_executable() -> None:
    try:
        missing = subprocess.run(("agent-browser", "skills", "get", "core"), env={"PATH": "/nonexistent"}, text=True, capture_output=True, check=False)
    except FileNotFoundError:
        missing = None
    assert missing is None or missing.returncode != 0

    executable = shutil.which("agent-browser")
    if executable is None:
        print("SKIP installed-core smoke: agent-browser is not installed")
        return
    result = subprocess.run((executable, "skills", "get", "core"), text=True,
                            capture_output=True, check=False, timeout=15)
    assert result.returncode == 0, "Installed CLI does not provide core; report compatibility gap"
    assert "agent-browser core" in result.stdout


if __name__ == "__main__":
    tests = [value for name, value in globals().items() if name.startswith("test_")]
    failures = 0
    for test in tests:
        try:
            test()
            print(f"PASS {test.__name__}")
        except AssertionError as error:
            failures += 1
            print(f"FAIL {test.__name__}: {error}")
    raise SystemExit(failures)
