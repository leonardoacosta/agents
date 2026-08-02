# Provenance

## Source

- Original author recorded by source metadata: Microsoft
- Original skill name: `azure-diagnostics`
- Original metadata version: `1.0.0`
- License recorded by source metadata: MIT
- Reviewed source snapshot: Brown repository commit `b22c9b96f950dadd20c36c1ffd07908ac15037b9`
- Upstream repository and upstream revision: not recorded in the available source snapshot
- Portable adaptation date: 2026-08-02

## Adaptation

The portable skill retains the source diagnostic domains: resource health, AppLens-style analysis, Azure Monitor logs and metrics, KQL, Resource Graph, Container Apps, Functions, and network troubleshooting.

The adaptation:

- replaces registered integration identifiers with capability-first selection;
- adds safe Azure CLI and portal fallbacks;
- consolidates source references into four package-local playbooks;
- distinguishes observed, unavailable, and inferred evidence;
- preserves the MIT license text in `LICENSE.txt`;
- omits organization-specific operating procedures and identifiers.

Content added after the Microsoft-derived snapshot remains an adaptation under the same package license record. This file does not claim an upstream revision that the reviewed source did not preserve.
