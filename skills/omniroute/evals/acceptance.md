# Installed-skill acceptance

Date: 2026-09-30. Tested content includes MCP correction commit `84efb41`.

A fresh Jcode worker loaded `omniroute` through the real `skill_manage.load` public interface, followed its local reference pointers, and answered three operational user requests. It did not receive upstream source or prior review findings. This exercises skill discovery, loading, reference routing, and advice generation, which are the deliverable's actual usage path. It does not exercise an OmniRoute deployment.

| Requirement | Observed behavior | Result |
| --- | --- | --- |
| Separate discovery auth from inference protection | Answer explicitly rejected `/v1/models` 401 as proof of protection, named effective `REQUIRE_API_KEY`, and proposed invalid-input no-credential inference probing rather than anonymous billable prompts | Pass |
| Correct MCP transport and least-privilege advice | Answer rejected WebSocket/20131 and admin grants, selected application `/api/mcp/sse` or `/api/mcp/stream`, checked enabled/local-only posture, and recommended narrow `mcp:connect` with approval | Pass |
| Safe live SQLite migration advice | Answer rejected copying only live `storage.sqlite`, explained WAL omissions, and selected managed snapshots or stopped-service full-directory backup preserving permissions and secrets | Pass |
| Route users to relevant material | Worker reported reading SKILL.md and api-and-clients.md, routing-and-agents.md, and operations.md through installed paths | Pass |

The transport scenario demonstrates the review fix propagates through actual skill use: the worker did not repeat the removed WebSocket or dedicated-port claim. All three answers matched source-grounded acceptance criteria without mutating systems.

Packaging validation, reference/path checks, installed integrity hash, and Jcode skill reload also passed. The five prompts in evals.json are not a full benchmark: three related operational scenarios were exercised in this acceptance run; Codex configuration and auto-routing scenarios remain unrun. There was no baseline comparison, so no quantitative quality gain is claimed.

Limits: no live OmniRoute requests, OAuth, deployment migration, or restore were performed. Those are outside this skill-authoring acceptance run and would require a selected authorized instance and, for consequential operations, approval.
