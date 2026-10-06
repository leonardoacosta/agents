## ADDED Requirements

### Requirement: Provider-specific discovery and collection
The skill catalog SHALL expose explicit `triage-linear` and `triage-ado` entrypoints and SHALL collect only from a verified matching workspace/project using existing provider governance.

#### Scenario: Linear scope
- **WHEN** triage-linear is invoked for a verified Priceless repository and Linear project
- **THEN** it reads eligible Linear items and their original discussions, prior decisions and related work rather than GitHub Issues

#### Scenario: ADO scope
- **WHEN** triage-ado is invoked for a verified Brown repository
- **THEN** it uses verified ADO organization, project and work-item metadata and does not link to Linear

#### Scenario: Ambiguous or wrong scope
- **WHEN** the provider/project mapping is missing or a focus ID belongs to another workspace
- **THEN** dependent collection and mutations stop with a bounded decision request and no guessed mapping

### Requirement: Evidence-based disposition
Every candidate SHALL receive exactly one of auto-fix, needs-info, needs-human, duplicate or question/support, independently of verified tracker types/states/labels.

#### Scenario: Reproduced low-risk issue
- **WHEN** a defect has a clear root cause, low-risk change and representative verification path
- **THEN** it may enter auto-fix with reproduction evidence and acceptance checks

#### Scenario: Unsupported claim or conflicting state
- **WHEN** reproduction fails or readiness/state signals conflict
- **THEN** the skill records the actual evidence, chooses the applicable non-auto-fix bucket and never fabricates verification or provider metadata

### Requirement: Consent and attributed publication
The skills SHALL distinguish read-only triage, requested reversible local fixes and explicitly authorized external mutations. Every posted comment/reply and PR description SHALL start with an AI disclaimer and end with a clear agent attribution naming the verified represented principal.

#### Scenario: Read-only invocation
- **WHEN** a skill is invoked without posting, label, status or publication authorization
- **THEN** it may investigate and draft recommendations but does not post, relabel, close or publish

#### Scenario: Authorized response
- **WHEN** an attributed response is authorized within verified scope
- **THEN** it is brief and factual, its final line identifies Jcode as automated triage, and no invented handle is used

#### Scenario: Rejection or concurrent change
- **WHEN** cancellation as invalid/wontfix lacks user confirmation or an item changed after the analysis snapshot
- **THEN** the dependent mutation is withheld and the changed evidence or missing decision is reported

### Requirement: Safe implementation and durable handoff
Requested auto-fixes SHALL preserve unrelated work, locate root cause, implement minimal changes and verify acceptance behavior before claiming completion. Briefs SHALL include scope, constraints, acceptance, reproduction, evidence, verification instructions and unresolved decisions.

#### Scenario: Linear fix delivery
- **WHEN** a verified Linear fix is committed or published with authorization
- **THEN** its branch/commit uses the verified identifier and PR linking uses Refs unless intended completion automation justifies Fixes

#### Scenario: ADO fix delivery
- **WHEN** a verified ADO fix is committed or published with authorization
- **THEN** its branch includes the numeric ID and commit/PR preserve AB#ID including squash guidance

#### Scenario: Blocked validation
- **WHEN** required runtime checks fail or cannot run
- **THEN** completion is not claimed and the fix is repaired or demoted with exact observed evidence
