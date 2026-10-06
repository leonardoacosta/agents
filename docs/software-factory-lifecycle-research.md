# Linear, OpenSpec and GitHub: software-factory lifecycle

Research date: **2026-10-06**. Approved research budget: **30 minutes**. Initial implementation: `linear-refinement`, `linear-triage`, `linear-cleanup`, and a `triage-linear` compatibility redirect. Other roles below are design recommendations, not installed agents or enabled automations.

## Executive summary

Use **Linear for work state and accountability**, **OpenSpec for planned behavior and requirements**, and **GitHub for implementation, review, CI and delivery evidence**. A status or artifact is not proof of the next system's acceptance boundary. In particular, merged code is not necessarily deployed, accepted, or delivering the intended user outcome. Linear's configurable GitHub automation must be understood before publishing links that can change issue state. [S1–S9]

Cover the entire lifecycle, but do not create a permanent agent for every responsibility. Start with an accountable human product/acceptance owner, a coordinator, an implementer, an independent verifier, and an operational/release owner when shipping a service. Dispatch specialists only when their trigger applies. Anthropic recommends simple composable patterns and distinguishes predefined workflows from model-directed agents. Parallel workers are useful for independently decomposable work, not evidence that more agents always improve delivery. [S22–S23]

The three Linear skills organize work around that factory, rather than replacing it: **triage investigates intake**, **refinement makes requirements executable**, and **cleanup reconciles evidence and recorded state**. They share existing `linear-management` governance and `jcode-handoff` execution contracts. Security, user research, operations, maintenance and retirement remain first-class lifecycle responsibilities. [S3–S7, S13–S21, S24–S25]

## Evidence and interpretation

This is a synthesis of public primary documentation, not a claim that vendors prescribe these agent names. Source-backed capabilities are identified below. The role taxonomy, minimum composition, permission model and acceptance gates are our recommended policy. Documentation was read through Firecrawl CLI 1.23.3 using public queries and HTTPS/public-DNS-gated scrapes. No private tracker data, cookies, authenticated target sessions or internal destinations were supplied.

Twenty-five distinct substantive source pages support the report. Duplicate captures, marketing pages, repository navigation, search snippets and 404 pages do not count toward that total. OpenSpec's `main` documentation is a moving reference, not a pinned release contract. NIST SSDF 1.1 and SLSA 1.0 are explicitly versioned sources, not assertions that those versions are the latest. Sources lacking a visible publication date are recorded by retrieval date rather than given an invented date.

## Key findings

### 1. Linking and completion are different operations

Linear supports closing keywords such as `Fixes TEAM-123` and non-closing keywords such as `Refs TEAM-123`. Non-closing keywords can still drive other configured workflow statuses, but **do not apply the status configured for “On PR or commit merge.”** Keywords in PR comments do not create links. PR titles/descriptions support linking several issues; one issue can have multiple linked PRs, with automation waiting for the final linked PR to reach the relevant configured state. These are integration mechanics, not proof that all acceptance criteria passed. [S1]

GitHub automation is configured per Linear team. Target-branch-specific merge rules can differ from the default. Therefore, inspect the verified team's automation and intended target branch before authorized PR publication. Use `Refs` when only linking is intended; use `Fixes` only when completing the entire issue and triggering its configured completion behavior are explicitly intended. Do not imply that `Refs` prevents every status side effect. [S1]

### 2. Map logical gates to actual workspace states

Linear issue workflows are team-specific. Its Triage inbox supports accepting, declining, duplicate handling and snoozing, but those controls do not authorize an agent to use them. “Accepted into the backlog,” “requirements executable,” “ready for merge,” and “accepted outcome” are different gates. A native status name, an agent's role name and a human's attention must not be treated as interchangeable. [S3–S5]

Keep an accountable owner and current executor distinguishable. Native Linear Agent can act on workspace context, but its capabilities are not proof that a particular installed tool has those schemas, permissions or fields. Discover the actual tool surface and preserve existing governance. [S6]

### 3. OpenSpec is an artifact workflow, not an issue-state machine

Current upstream documentation exposes a core workflow of `propose`, `explore`, `apply`, `update`, `sync` and `archive`. Expanded workflows include `new`, `continue`, `ff`, `verify`, `bulk-archive` and `onboard`. Invocation syntax and availability vary by tool/profile. Do not require an optional command that the installed configuration does not expose. Discover installed help and repository conventions first. [S8–S9]

Reuse an existing change when it describes the same outcome. Record verified issue identifiers and issue URLs in its artifacts, and publish a resolvable source link back to the issue only with authorization. Synchronizing delta specifications and archiving completed changes do not independently establish production acceptance or tracker completion. Requirements changes during delivery return through refinement rather than silently rewriting the acceptance boundary. [S8–S9]

### 4. Reviews, CI and release protections need explicit configuration

GitHub provides review mechanisms, protected branches, status-check requirements and deployment environments. These are configurable controls, not guarantees that a given repository enforces them. Environment features also vary by plan and repository visibility. Verify actual rules, exceptions and bypass permissions. Independent assessment should not be replaced by the author's own confidence or a second agent merely repeating the author's summary. [S10–S12]

Tie evidence to the reviewed revision. Changes after approval can invalidate a review or a test result even when the comment remains visible. Deployment authorization is separate from code acceptance, and production health is separate from deployment completion. Canary rollout can expose a change gradually, but neither rollout nor rollback mechanics are universal: discover the actual platform and its supported controls. [S12, S16]

### 5. Security and operability span the entire factory

NIST recommends integrating secure development practices into the SDLC. GitHub supply-chain guidance and SLSA address dependency visibility, vulnerabilities and provenance. Our factory should route security, privacy, threat modeling and supply-chain work when risk triggers apply, not only run a scanner at the end. This report does not certify compliance or a SLSA level. [S13–S15]

Testing covers reported behavior, integration boundaries and relevant failure cases. DORA's testing and continuous-delivery guidance supports fast feedback and shared quality ownership; a test specialist does not relieve implementers of regression checks. Operations needs actionable monitoring, incident coordination and follow-up. SRE distinguishes incident command, operational mitigation and communications, which can be separate responsibilities during a major incident. [S17, S19–S21]

### 6. User outcomes and retirement close the loop

DORA emphasizes direct user feedback informing priorities. GOV.UK describes continuous improvement over a service's lifetime and retirement that addresses user needs, transition and data handling. These sources support keeping outcome evaluation, support feedback, maintenance and retirement in the lifecycle. They do not imply every role must be staffed full-time or that agents may delete data or notify users without approval. [S18, S24–S25]

## Recommended lifecycle and gates

```text
Signal / strategy / incident / user feedback
                    |
              Intake triage
                    |
        Discovery + requirements refinement
                    |
         Design + executable plan / OpenSpec
                    |
      Claimed implementation + author verification
                    |
       Independent review + acceptance evidence
                    |
          Authorized merge / release decision
                    |
         Deployment + production verification
                    |
        Operate + measure user outcomes
                    |
       Improve / maintain / retire by decision
                    +------------> new intake

Cleanup audits evidence and links across every stage.
Changed requirements -> refinement; new defects -> triage.
Failed verification -> accountable delivery owner, not optimistic Done.
```

The sequence is a recommended control flow, not a requirement to invent new Linear statuses. Some work, such as a verified support answer, has a different acceptance boundary and does not require a feature-specification ceremony.

| Gate | Evidence required | Accountable decision |
| --- | --- | --- |
| Intake accepted | Original signal, scope/workspace match, duplicate search, outcome classification | Triage recommends; authorized owner decides backlog disposition |
| Execution-ready | Bounded scope, observable acceptance, resolved material decisions/dependencies, required coherent OpenSpec artifacts | Refinement applies kind-specific governance; state writes need authorization |
| Execution claimed | Fresh issue/plan revision, identified executor, isolated mutable resources, actual claim mechanism | Coordinator/executor; a status change is not an atomic lock |
| Author complete | Scoped implementation and relevant checks at an identified revision; failures and blocked checks recorded | Implementer hands off, without self-certifying independent acceptance |
| Review accepted | Independent assessment of requirements, changed behavior and integration risk | Reviewer and designated acceptance owner |
| Merge/release authorized | Applicable review/CI policies, complete issue scope, understood automation and release risks | Authorized human or explicitly delegated release authority |
| Production accepted | Required rollout, health, functional and user acceptance checks; rollback criteria | Operational/acceptance owner according to the issue's boundary |
| Reconciled/archived | Links and recorded states match evidence; native archive eligibility; preserved history | Cleanup recommends; authorized disposition owner acts |
| Retired | Approved user transition, data/retention decision, dependency shutdown and verification | Human accountable owner; destructive actions remain separately authorized |

## Responsibility and subagent catalog

This catalog covers the general software lifecycle and common conditional specializations. It is not an assertion that every possible industry-specific role has been enumerated. Regulated, embedded, hardware, scientific or other specialized products may require additional domain experts. A **role** is a responsibility; a **subagent** is a bounded execution instance with explicit tools, resources and a return contract.

### Permission classes

- **Inspect:** read authorized evidence and draft recommendations. No external mutation.
- **Local:** requested, reversible scoped edits and checks in assigned resources. No publication.
- **External:** only the explicitly authorized external actions, targets and scope.
- **Human gate:** consequential access, security/risk acceptance, material product decisions, migrations, destructive retention, publication/deployment authority or other reserved decisions. Existing explicit authorization counts.

Every row inherits the shared handoff and concurrency rules below. The owner column names the accountable responsibility, not a new required job title.

| Family / role | Trigger and input | Output / exit evidence | Owner and independent check | Default authority |
| --- | --- | --- | --- | --- |
| Governance: product/acceptance owner | Strategy, users, constraints, competing outcomes | Priority, acceptance boundary, reserved decisions and funding/retirement choice | Human product owner; stakeholder/domain review | Human gate |
| Governance: factory coordinator | Approved work graph, capacity, dependencies and permissions | Dispatch, claim/resource ownership, checkpoints, recovery and next gate | Accountable coordinator; independent gate owners | Inspect; delegated Local/External only |
| Intake: `linear-triage` | New signals, issue/filter, reports or explicitly requested safe fixes | Reproduction/classification, duplicate evidence, disposition recommendation, refinement/cleanup handoff | Intake owner; evidence review and designated acceptance | Inspect; requested low-risk Local fixes |
| Requirements: `linear-refinement` | Accepted candidate, ambiguous requirements, scope invalidation | Decision-ready acceptance, dependencies/non-goals, native OpenSpec plan and readiness evidence | Product/requirements owner; design/domain review | Inspect and requested Local planning |
| Reconciliation: `linear-cleanup` | Stale state, broken links, duplicate claims, reopened or disputed acceptance | Observed/proposed reconciliation, evidence, owner and next gate | Lifecycle owner; fresh-state comparison/human disposition | Inspect |
| Discovery: customer/domain researcher | Unknown user problem, product hypothesis, support patterns | Traceable findings, conflicting evidence, proposed experiments | Product owner; source/participant-privacy review | Inspect; research/contact permission separately |
| Portfolio: planner/prioritization analyst | Outcomes spanning issues, capacity or dependency conflicts | Sequencing, milestones, dependency risks and explicit decision options | Product owner/coordinator; delivery review | Inspect; no invented projects/commitments |
| Design: UX/content/accessibility specialists | New/changed user flow, usability or accessibility risk | Validated flow, copy, interaction/accessibility acceptance and evidence | Design owner; users/accessibility verifier | Inspect and assigned Local artifacts |
| Design: architect/domain/API specialist | Cross-boundary behavior, unfamiliar domain or contract change | Alternatives, interfaces, compatibility and failure model | Technical owner; independent architecture/domain review | Inspect and assigned Local design |
| Design: data/privacy/migration specialist | Data shape, access, retention, schema or migration change | Data contract, privacy assessment, migration/recovery and validation plan | Data owner; security/operations review | Inspect/Local plan; execution Human gate |
| Design: threat-model/security/compliance specialist | Sensitive flows, trust-boundary change, regulated controls | Threats, mitigations, test requirements and unresolved risk decisions | Security/domain owner; independent evidence review | Inspect; risk acceptance Human gate |
| Planning: implementation planner | Ready requirements and existing repository capabilities | Dependency-ordered tasks, checks, integration and rollback boundaries | Technical owner; implementer/verifier review | Inspect/Local planning |
| Delivery: implementer and technology subagents | Approved bounded task and claimed resources | Small scoped change, regression checks and exact revision handoff | Delivery owner; independent reviewer/verifier | Local; publication only External |
| Delivery: integration/refactoring specialist | Multi-package boundary, conflicting changes or justified technical debt | Integrated behavior, compatibility/migration evidence, preserved attribution | Technical owner; regression verifier | Assigned Local |
| Quality: independent code/architecture reviewer | Author-complete revision and original requirements | Evidence-backed findings, scope/risk verdict and re-review conditions | Independent reviewer; acceptance owner | Inspect; posting only External |
| Quality: behavior/API/integration/E2E verifier | Changed acceptance or integration boundary | Reproduction, real-interface checks, failure cases and blocked-check distinctions | Verification owner; acceptance owner | Local isolated test resources |
| Quality: accessibility/performance/reliability specialists | Relevant acceptance or latency/resource/failure risk | Measured baseline/changed results and limits, not proxy-only acceptance | Verification owner; relevant domain reviewer | Local isolated checks; load target permission |
| Quality: adversarial/security/dependency assessor | Attack surface, dependencies or privilege-bearing change | Abuse cases, vulnerable dependencies, remediation and residual risks | Security owner; independent review | Inspect/isolated Local; target permission |
| Knowledge: documentation/developer-experience/support specialist | New contracts, changed behavior, release or handoff | Correct user/operator/API docs, support runbook and example verification | Delivery/support owner; user/operator review | Local; public communications only External |
| Release: release manager | Review/acceptance evidence, release scope and target | Versioned release plan, approval, rollout/rollback criteria and linked evidence | Release owner; operations/acceptance check | Inspect; publishing/deployment External |
| Release: build/CI/supply-chain specialist | Build pipeline, dependency/provenance or packaging risk | Reproducible checks, artifact identity, provenance and policy evidence | Technical/release owner; security review | Local; credentials/CI permissions Human gate |
| Release: deploy/rollback executor | Explicit target and authorized release/rollback plan | Recorded rollout, health checks and rollback outcome | Release/operations owner; production verifier | Exact External scope only |
| Release: migration executor | Approved data plan, backups, target and recovery boundary | Migration results, data/invariant checks and recovery evidence | Data/operations owner; independent validator | Exact authorized migration only |
| Operations: observability/reliability owner | Running service, service objectives and failure signals | Dashboards/alerts, health evidence, error-budget/service-risk decisions | Operations owner; service/acceptance review | Inspect; changes only delegated scope |
| Operations: incident commander/mitigator/communications subagents | Declared incident and response authority | Clear command, mitigation, timeline, stakeholder updates and recovery | Incident commander; post-incident independent review | Inspect; mitigations/messages only authorized |
| Operations: support/defect investigator | User incident, support request, regression or abuse report | Verified answer/defect signal, impacted scope and triage handoff | Support/service owner; evidence review | Inspect; communications External |
| Outcomes: product analyst/experiment evaluator | Shipped feature, user feedback and measurable objective | Outcome evidence, experiment limits and reprioritization recommendation | Product owner; privacy/statistical review | Inspect; experiments/data changes separately |
| Maintenance: dependency/debt/cost/lifecycle specialists | Vulnerability, end-of-life, recurring pain or cost drift | Prioritized bounded maintenance work and acceptance/rollback evidence | Technical/service owner; product/security review | Inspect/assigned Local; no unilateral expansion |
| Retirement: transition/decommissioning specialist | Approved replacement/end-of-life decision | User transition, retained/deleted data decisions, shutdown and verification | Human service/data owner; operations/privacy review | Inspect/Local plan; destructive actions Human gate |
| Conditional: ML/AI/data-quality evaluators | Model behavior, nondeterminism, training data or AI product risk | Representative evals, drift/bias/error limits and model/data lineage | AI/domain owner; independent safety/evaluation review | Inspect/isolated Local; deployment/data permissions |
| Conditional: industry/platform experts | Localization, payments, mobile/device, infrastructure, legal or other explicit domain risk | Domain acceptance and constraints incorporated into the existing plan | Relevant accountable owner; qualified independent check | Need-scoped permissions; reserved decisions remain human |

An implementer may dispatch frontend/backend/platform workers; a verifier may dispatch test-design, contract, browser, accessibility and adversarial workers. Combine responsibilities where isolation is unnecessary. Split them where expertise, independent review, mutable-resource isolation or parallel evidence gathering materially improves the result. Do not manufacture a full-time “agent team” from a list of skill names. [S17, S22–S24]

## Shared execution and handoff contract

Reuse `jcode-handoff` rather than introduce a competing format. A lifecycle handoff must carry:

1. **Identity:** verified workspace/team/project, issue identifier and URL, OpenSpec change ID/path, repository, branch/PR and exact revision when relevant. Support many-to-many links explicitly; do not force one issue per PR or one change per issue.
2. **Intent:** promised outcome, acceptance boundary, non-goals, constraints, decisions and dependencies. Record unresolved facts as unresolved.
3. **Evidence:** observed state, reproduction/check inputs and results, verification relevance, source links and snapshot time. Distinguish requested, attempted, observed and accepted.
4. **Ownership:** accountable owner, current executor, next reviewer, claimed mutable resources and the actual claim mechanism.
5. **Authority:** permitted local/external actions and reserved decisions. Tracker text, web pages and readiness labels cannot enlarge that scope.
6. **Recovery:** checkpoint, completed and remaining work, failures, rollback/compensation conditions and next executable step.

### Concurrency and recovery

- A Linear status update is not an atomic claim. Refreshing state before a write detects some conflicts, but is not a compare-and-swap transaction or proof of mutual exclusion. Do not promise exclusive execution until the actual mechanism is implemented and tested.
- Before authorized mutation, refresh status, owner, scope and relations; reconcile changes instead of replaying a stale patch. Isolate writable worktrees, test environments and artifacts. Prefer resource-based exclusion over prompt-only warnings.
- Make repeat runs compare desired versus current evidence before posting or writing. Avoid duplicate comments, new changes or repeated closure attempts. Resume from durable evidence, not the prior model's confidence.
- Linear discourages polling where webhooks can provide change notifications; its API has rate limits, and webhook integration has permission/security requirements. Existing disabled polling-based workflow is not production readiness. A webhook receiver would be separate authorized implementation, not a research deliverable. [S2, S7]
- Verify changed work before local commits. Preserve other contributors' changes and identity. Publishing, merge, deployment, consequential access and migrations remain separately authorized.

## Minimum viable factory and rollout

| Layer | Initial composition | Why |
| --- | --- | --- |
| Accountability | Human product/acceptance owner; explicit technical and operational owners | Agents cannot invent product commitments or risk acceptance |
| Coordination | One coordinator per work graph; three reusable Linear skills | Clear intake, executable requirements and evidence reconciliation without a new runtime |
| Delivery | Bounded implementer plus independent reviewer/verifier | Keeps authoring separate from independent acceptance |
| Service lifecycle | Release/operational owner when deployment or a running service is in scope | Merge is not release health or user acceptance |
| Specialists | Dispatch the catalog's capabilities on risk/unknowns | Avoid permanent idle agents, duplicated authority and coordination overhead |

Current implementation changes only the three reusable Linear skill contracts, their evals, the old-name redirect, and Jcode prompt routing. `linear-management` remains an installed dependency; this work does not silently copy or replace it. The existing Orca PM/lead/reviewer definitions remain disabled, with their current fail-closed prechecks. No Linear state mapping, exclusive-claim runtime, webhook receiver or remote action is enabled.

Recommended later order, subject to separate scope approval: validate real workspace mappings and consumer behavior; validate one complete issue-to-acceptance workflow; implement an actual claim/recovery mechanism; then consider enabling bounded automation. Add release/operations integrations only for the product's real deployment environment.

## Contrarian views and failure modes

- **Too many agents:** Parallel research is a useful example, not general proof of factory throughput. More agents can increase cost, latency, conflicting edits and handoff loss. Prefer the smallest composition that satisfies the gates. [S22–S23]
- **Too much specification:** Answer/support tasks and small proven defects need appropriate kind-specific gates, not mandatory feature paperwork. Conversely, undocumented scope drift during implementation should not bypass refinement.
- **Automation surprises:** Native status updates can happen even when the agent only intends a link. Non-closing keywords reduce merge-completion effects, not all status effects. Verify actual configuration before publication. [S1]
- **False independence:** A second agent that reads only the author's summary is not a sufficient independent review. It needs original requirements, changed revision and fresh evidence.
- **Synthetic green:** Schema checks, instruction simulations and unit tests cannot certify native skill activation, live tracker behavior, deployment health or user acceptance. Record each boundary honestly.
- **Automatic cleanup:** Age, merged PRs, archived specs and empty queues are not sufficient evidence for Done or deletion. Preserve history and distinct duplicate outcomes. Retirement requires explicit user/data decisions. [S25]
- **Metric gaming:** Count user outcomes, delivery health and escaped failures, not agent sessions, issue closures or specifications produced. DORA's outcome associations are not guarantees of causal improvement in this environment. [S18]

## Verification and unresolved runtime decisions

The role packages include behavioral prompt scenarios for authorization, workspace boundaries, incomplete acceptance, duplicate differences, metadata/schema discovery, updated snapshots, repeat runs and compatibility invocation. Scenario responses are synthetic model evaluations, not live integration tests. The skills repository's package checks and unit tests validate packaging/tooling, not the software factory itself.

Observed checks on 2026-10-06: **284 packages structurally valid**, **120 skills-repository unit tests passed**, **24/24 synthetic behavioral scenarios passed**, and all four adopted skill names loaded through Jcode's skill discovery. Independent canonical-skill assessments using the eight-dimension `skill-judge` rubric scored triage 106/120, refinement 101/120 and cleanup 108/120. These judgments are not runtime certification. Agents tests/build passed with caching bypassed; touched report formatting, eval identities, whitespace and redacted owned-output secret checks passed. The repository-wide `pnpm check` still reports the same pre-existing formatting issues in `prompts/jcode/system-prompt.md` and `prompts/jcode/swarm-prompt.md`; unrelated reformatting was left out of scope.

Still unverified: actual workspace state mappings; live issue/PR automation and plan/visibility-dependent GitHub controls; atomic exclusive claims; native OpenHands invocation; deployed service/incident workflow; any future specialized regulatory requirements. These do not block authoring reusable contracts, but do block claims that the factory is enabled or acceptance-tested end to end.

## Sources

All retrieved **2026-10-06**. Dates below are publication/version dates only when visible or explicit. Each numbered page contributes substantive evidence; repeated copies of the same document are excluded.

| ID | Primary source | Contribution / qualification |
| --- | --- | --- |
| S1 | [Linear: GitHub](https://linear.app/docs/github) | Keyword linking, multi-PR/issue behavior, team and branch-specific automation |
| S2 | [Linear: rate limiting](https://linear.app/developers/rate-limiting) | API rate limits, bounded queries and avoiding polling |
| S3 | [Linear: Triage](https://linear.app/docs/triage) | Intake inbox, review actions and responsibility |
| S4 | [Linear: issue status](https://linear.app/docs/configuring-workflows) | Team-specific statuses and reserved duplicate state |
| S5 | [Linear: concepts](https://linear.app/docs/conceptual-model) | Workspace/team/issue/project boundaries and outcomes |
| S6 | [Linear Agent](https://linear.app/docs/linear-agent) | Native agent capabilities, not an installed-tool permission guarantee |
| S7 | [Linear: webhooks](https://linear.app/developers/webhooks) | Change notifications and integration scope/permissions |
| S8 | [OpenSpec README](https://github.com/Fission-AI/OpenSpec/blob/main/README.md) | Specification-driven change workflow; moving `main` reference |
| S9 | [OpenSpec commands](https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md) | Core/expanded workflows and tool-specific invocation; moving `main` |
| S10 | [GitHub: reviewing proposed changes](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request) | Review context, dependency inspection and review decisions |
| S11 | [GitHub: protected branches](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches) | Configurable reviews/checks and branch protection; short overview |
| S12 | [GitHub: deployment environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) | Deployment protection, reviewer/secrets gates and plan limitations |
| S13 | [GitHub: software supply-chain security](https://docs.github.com/en/code-security/supply-chain-security/understanding-your-software-supply-chain/about-supply-chain-security) | Dependency visibility and vulnerability response |
| S14 | [NIST SP 800-218, SSDF 1.1](https://csrc.nist.gov/pubs/sp/800/218/final) | Secure-development framework baseline, published 2022 |
| S15 | [SLSA 1.0 levels](https://slsa.dev/spec/v1.0/levels) | Versioned build provenance/security levels, not certification |
| S16 | [Google Cloud Deploy: canary](https://docs.cloud.google.com/deploy/docs/deployment-strategies/canary) | Platform-specific phased rollout mechanics |
| S17 | [DORA: test automation](https://dora.dev/capabilities/test-automation/) | Fast reliable checks and shared quality responsibilities |
| S18 | [DORA: user-centric focus](https://dora.dev/capabilities/user-centric-focus/) | User feedback informing priorities and outcomes |
| S19 | [DORA: continuous delivery](https://dora.dev/capabilities/continuous-delivery/) | Integrated testing/security and delivery capabilities |
| S20 | [Google SRE: incident response](https://sre.google/workbook/incident-response/) | Incident coordination, mitigation and communications |
| S21 | [Google SRE: monitoring distributed systems](https://sre.google/sre-book/monitoring-distributed-systems/) | Service-health signals and actionable monitoring |
| S22 | [Anthropic: building effective agents](https://www.anthropic.com/engineering/building-effective-agents) | Simple composable workflows versus agents; 2024-12-19, tooling caveat |
| S23 | [Anthropic: multi-agent research system](https://www.anthropic.com/engineering/multi-agent-research-system) | Bounded research subagents; 2025-06-13, system-specific results not generalized |
| S24 | [GOV.UK: sustainable service lifecycle](https://www.gov.uk/service-manual/agile-delivery/running-your-service-in-a-sustainable-way) | Continuous improvement, user research and service resources |
| S25 | [GOV.UK: retiring your service](https://www.gov.uk/service-manual/agile-delivery/retiring-your-service) | User transition, replacement and data communication responsibilities |

## Rerun inputs and collection limitations

- Workflow: `firecrawl-deep-research`; topic: complete software-factory responsibilities integrating Linear, OpenSpec and GitHub; budget: 30 minutes; output: cited Markdown plus three reusable role contracts.
- Research angles: tracker/linking/state automation; native specification lifecycle; reviews/CI/releases; security/provenance; tests/operations/incidents; user outcomes/retirement; conditional agent delegation.
- Search discovery used bounded public queries without automatic result scraping. Selected URLs passed HTTPS/hostname/public-DNS checks before submission. Provider-managed redirects are trusted under the public-research policy; unseen hops were not independently verified.
- One research worker exceeded its assigned six-query cap, making 15 bounded queries. Further searching was stopped. A second worker captured a duplicate and unsuccessful URLs. These are recorded deviations, not evidence of extra coverage. Scoped recovery filled missing lifecycle pages without expanding into a new integration service.
- Raw transient captures are private and removed after review; retain scrubbed source assertions, CLI/version/status and actual usage manifests. No raw research, private evaluation logs or secrets are committed.
- The 25-source catalog is not a systematic literature review or a guarantee of every industry-specific role. Source recency, vendor configuration and specialized domain obligations must be rechecked before a later runtime implementation.
