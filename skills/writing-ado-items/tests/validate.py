#!/usr/bin/env python3
"""Focused offline contract checks for the writing-ado-items skill."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILL = (ROOT / "SKILL.md").read_text()
FIXTURE = json.loads((ROOT / "tests/fixtures/wholesale-writing.json").read_text())


def check(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    required = [
        "SNOW request and change identifiers", "Execute CHG", "Fortify -",
        "B3 Admin Tool", "Do not use em dashes", "Application Insights",
        "PRimate", "WHS-346", "All-Wholesale", "O365", "BBAdmin",
        "Do not reassign items owned by somebody else", "read back",
        "Do not claim atomicity",
    ]
    for phrase in required:
        check(phrase.lower() in SKILL.lower(), f"skill is missing rule: {phrase}")
    check("square brackets or parentheses" in SKILL, "title bracket rule is missing")
    check("lookup-values/{id}" in SKILL, "technical braces rule is missing")
    check("decus-direct" in SKILL and "doc-db" in SKILL, "compound identifier rule is missing")
    check("Review application architecture and delivery workflow" in SKILL, "dangling DOC rewrite is missing")
    check("parent ambiguity" in SKILL, "parent ambiguity handling is missing")
    check("explicit ID mappings" in SKILL, "explicit mapping precedence is missing")
    check("parent chain leaves that owned project scope" in SKILL, "outside-parent exclusion is missing")

    for case in FIXTURE["title_cases"]:
        if case["name"] == "preserves_technical_braces":
            check("lookup-values/{id}" in case["expected"], case["name"])
        else:
            check("[" not in case["expected"] and "]" not in case["expected"], case["name"])
            check("(" not in case["expected"] and ")" not in case["expected"], case["name"])
        check("\u2014" not in case["expected"], case["name"])
        for retained in case.get("body_retains", []):
            check(retained in case["input"], f"fixture retention is not in input: {retained}")

    routes = {(case["title"], case["type"]): case["parent"] for case in FIXTURE["routing_cases"]}
    check(routes[("PRimate", "Feature")] == "WHS-346", "PRimate routing changed")
    check(routes[("Shared Fortify library upgrade", "Story")] == "Fortify", "shared Fortify routing changed")
    check(routes[("Legacy Subscription renewal", "Story")] == "All-Wholesale", "legacy subscription routing changed")

    ownership = {(case["owner"], case["action"]): case["allowed"] for case in FIXTURE["ownership_cases"]}
    check(ownership[("O365", "create")], "O365 creation must be allowed")
    check(not ownership[("BBAdmin", "create")], "BBAdmin creation must be rejected")
    check(not ownership[("Other verified owner", "reassign")], "other-owner reassignment must be rejected")
    print("PASS writing-ado-items contract")


if __name__ == "__main__":
    main()
