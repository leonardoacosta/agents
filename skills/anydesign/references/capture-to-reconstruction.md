# Capture-to-reconstruction pipeline

Use this reference when the user wants more than an analysis. Pipeline mode captures a dynamic
visual source, studies it, reconstructs the observed behavior in working code, and codifies the
reusable pattern in a skill or project reference.

Typical triggers include:

- "Run this video through AnyDesign and rebuild it in HTML, SVG, and React."
- "Capture this X post animation and turn the pattern into a skill."
- "Use the last AnyDesign capture-to-code pipeline on this motion reference."
- "Reverse-engineer this interaction from the recording and package the reusable behavior."

Do not use pipeline mode for a normal design-system analysis, a static element-copy prompt, or
motion analysis without implementation. Use full mode or element mode instead. If the user explicitly
asks for capture, reconstruction, and skill codification, that request authorizes direct
implementation. Do not add a separate design approval gate unless the user asks for one.

## Contents

- [Outcome contract](#outcome-contract)
- [Route selection](#route-selection)
- [P1. Establish scope and provenance](#p1-establish-scope-and-provenance)
- [P2. Capture the source media](#p2-capture-the-source-media)
- [P3. Build a temporal evidence set](#p3-build-a-temporal-evidence-set)
- [P4. Analyze the dynamic element](#p4-analyze-the-dynamic-element)
- [P5. Build the clean-room reconstruction](#p5-build-the-clean-room-reconstruction)
- [P6. Preserve meaning and accessibility](#p6-preserve-meaning-and-accessibility)
- [P7. Codify the reusable pattern](#p7-codify-the-reusable-pattern)
- [P8. Close the feedback loop](#p8-close-the-feedback-loop)
- [P9. Deliver the handoff](#p9-deliver-the-handoff)
- [Failure handling](#failure-handling)
- [NEVER rules](#never-rules)

## Outcome contract

Pipeline mode has three required outputs and one conditional output:

1. **Evidence**: the original media, media properties, sampled frames, contact sheets, source URL,
   capture time, and provenance notes.
2. **Study**: a focused `element.md`, concrete tokens, motion states, accessibility notes, confidence,
   and open questions.
3. **Reconstruction**: a working page plus the requested standalone and framework routes. HTML,
   standalone SVG, and typed React are the default paired routes when the user names all three.
4. **Reusable pattern, when requested**: a skill or reference that explains when to use the pattern, its invariants,
   delivery routes, validation rules, and failure modes.

The outputs must agree. Use one semantic model for the reconstruction routes. Do not copy values
between three unrelated implementations.

## Route selection

| User intent | Route |
|---|---|
| Analyze motion only | Capture evidence, then use element mode. Stop after the study. |
| Reconstruct one dynamic element | Capture evidence, produce `element.md`, then build the requested code route. |
| HTML, SVG, and React handoff | Build a study page, one self-contained SVG, one typed React component, and a shared model. |
| Reconstruct and codify | Complete all pipeline stages, then update or create the reusable skill. |

Pipeline mode starts only when the user requests a runtime implementation. Capture, frame extraction,
and motion analysis alone stay in element mode. Skill packaging is conditional and cannot move an
analysis-only request into pipeline mode.

When a repository has local output, package, specification, issue, or persistence rules, those rules
control file paths and closeout. Otherwise, default the artifact root to `~/.anydesign/<slug>/`
where `<slug>` is `<source-id>-<short-label>` (e.g. `mdx-graphs`, `sequential-state-machine`).
Keep generated evidence and implementations together in that root. Update the `~/.anydesign/README.md`
registry when the study closes.

### Tool portability

Describe required capabilities, not one mandatory tool name:

- use an authenticated browser when the source needs a signed-in session
- use a media probe and frame extractor for video evidence
- use the destination framework's own build and test tools for code routes
- use a real browser and an accessibility runner for interaction checks

Prefer the environment's documented tool for each capability. If it is absent, use a compatible
equivalent. If no equivalent exists, complete the unaffected stages and report the exact blocker.
Do not invent an issue tracker, specification system, preview service, or persistence step that the
repository does not define.

## P1. Establish scope and provenance

Record these facts before capture:

- original URL or local file path
- source platform and account, when visible
- stable source ID, such as a post ID or the local file stem
- requested delivery routes
- whether the source is public, authenticated, or supplied by the user
- whether analysis is visual-only or may inspect rendered HTML and CSS
- destination repository and its local instructions

Use the source ID in artifact names. This keeps repeated runs separate and makes evidence traceable.

Treat a video-based reconstruction as a clean-room reconstruction unless the user explicitly asks
for an implementation audit. In clean-room work, observe rendered pixels, timing, controls, and
public metadata. Do not claim source-code equivalence, hidden design tokens, or pixel identity.

## P2. Capture the source media

### Social-post or authenticated URL

1. Use the available authenticated browser flow when the page needs a signed-in session. Load the
   `agent-browser` skill or the environment's browser guidance when it is available.
2. Preserve the visible post URL and attribution.
3. Locate the user-authorized media through the page, browser network evidence, or the platform's
   permitted download surface.
4. Download the original media when possible. Use a screen recording only when no original media is
   available, and mark that limitation.
5. Never print session cookies, authorization headers, signed media URLs, or other secrets in logs or
   generated artifacts.

### Local video

Copy or reference the supplied media according to repository rules. Do not transcode the only copy.
Keep the original bytes as evidence and derive frames from that file.

### Capture verification

Use `ffprobe` or an equivalent media probe. Record:

- codec
- pixel width and height
- duration
- file size
- frame rate when it affects timing analysis
- audio presence when sound is part of the interaction

When evidence integrity matters, record a SHA-256 hash. A successful browser playback is not a
substitute for probing the captured file.

## P3. Build a temporal evidence set

Extract enough frames to explain the sequence, not only its opening state.

1. Include the first stable frame and the final stable frame.
2. Sample 9 to 15 evenly distributed frames for a short clip.
3. Add frames at important state boundaries when the even sample misses them.
4. Create one or more contact sheets with timestamps or stable frame numbers.
5. Keep the source aspect ratio. Do not stretch frames to fit a review page.

For longer clips, segment by scene or interaction stage. Increase the frame count only when it adds a
new state, route, or timing fact.

A useful evidence directory is:

```text
<anydesign-study>/
├── source-page.png          optional page context
├── source-media.mp4         original or repository-approved reference
├── frames/
│   ├── frame-01.png
│   └── ...
├── contact-sheet.png
├── source.json              URL, capture time, probe data, hash, timestamps
├── element.md
├── element-a11y.md
├── design-tokens.json
└── index.html               study and evidence page
```

Use repository-required paths instead of this example when they exist.

## P4. Analyze the dynamic element

Read `element-copy.md` and classify the target as `code`, `asset`, or `hybrid`. Most interface
animations that end in HTML, SVG, and React are `code` or `hybrid`.

Extend the normal `element.md` analysis with a temporal model:

- **stable topology**: elements that never move or resize
- **states**: visible start, intermediate, paused, complete, and reduced-motion states
- **actors**: nodes, cards, tokens, cursors, labels, paths, or assets that change
- **motion channels**: transform, opacity, stroke, color, mask, clip, or content change
- **causal stages**: what must complete before the next event starts
- **timing**: delays, durations, overlap, easing confidence, and total duration
- **semantics**: the data or rule that determines what continues to the next stage
- **controls**: play, pause, replay, speed, scrub, or other observed behavior
- **uncertainty**: observed facts versus inferred geometry, timing, typeface, and implementation

If the animation explains a computation, state the computation as structured data. Display strings
are not enough. For example, set membership, operation inputs, and results must be machine-checkable.

Generate `element-a11y.md` when motion, contrast, controls, or media alternatives need a separate
report. Concrete tokens must use DTCG format in `design-tokens.json`. If the repository also has a
different canonical token format, generate the DTCG artifact and document or generate the required
mapping.

## P5. Build the clean-room reconstruction

Load the appropriate frontend implementation guidance before code work. When available, use the
`frontend-design` skill for visual quality and `motion-and-transitions` for state transitions.

### Shared model first

Define the data before choreography:

- stable IDs
- visible labels and values
- geometry or layout inputs
- routes and path data
- semantic operations and results
- journey or stage timing
- palette and type roles
- total duration

Validate the model before rendering. Reject duplicate IDs, unknown references, invalid dimensions,
invalid timing, operation cycles, semantic mismatches, and a total duration that ends before the
latest stage.

### HTML route

The page is the review and interaction surface. It should include:

- the working reconstruction
- real keyboard-operable controls when controls are part of the route
- playback status in a polite live region
- source and reconstruction comparison
- clean-room provenance
- links to the study, standalone output, framework output, and shared data
- responsive desktop and mobile layouts

### Standalone SVG route

The SVG must work without an application runtime. Include a stable `viewBox`, `<title>`, `<desc>`,
final nodes and routes, self-contained motion, total-duration metadata, and a static reduced-motion
result. Transient motion objects must be `aria-hidden` and must not carry the only explanation.

Use presentation attributes for values that SVG animation changes. Author CSS can override SMIL
presentation attributes and keep tokens invisible.

### React route

Keep graph or sequence data separate from rendering. Use explicit TypeScript types. Expose only the
controls needed by the host, such as replay, pause, play, final state, and speed. Cancel stale
animations and callbacks on replay, data replacement, preference changes, and unmount.

The component must have a useful static result when Web Animations are unavailable.

## P6. Preserve meaning and accessibility

The final state must explain the interaction without motion. Also require:

- `prefers-reduced-motion` support
- pause or stop control for long autoplay motion
- keyboard-operable controls and visible focus
- an accessible title and description for meaningful SVG
- captions, transcript, or a visual-description track for meaningful source video
- text alternatives for every computed or causal result
- WCAG contrast checks for small text and controls
- no horizontal overflow at a narrow mobile viewport

Animation can add sequence and causality. It cannot be the only semantic carrier.

## P7. Codify the reusable pattern

Only start this stage when the user asks for reuse, packaging, or a skill.

1. Search existing skills and references first. Extend the canonical owner when the new behavior fits
   its trigger and output contract.
2. Create a separate skill only when the trigger, semantic model, or delivery contract is distinct.
3. Remove source-specific labels, IDs, brand content, and palette from the reusable instructions.
4. Keep provenance in the study and implementation, not in generic skill examples.
5. Define strict trigger boundaries and explicit exclusions.
6. Route standalone, React, and paired delivery to separate references when their contracts differ.
7. Record invariants, adaptable choices, lifecycle rules, validation, reduced motion, and NEVER rules.
8. Follow the destination package boundary. A documentation-only package must not gain executable
   runtime files, generated assets, hooks, or local evidence.
9. Reload or re-index the skill when the host supports it, then validate frontmatter, local links,
   code fences, and progressive-disclosure references.
10. Test routing with at least one positive pipeline prompt and negative prompts for full analysis,
    static element copy, and motion analysis without reconstruction.

Use `skill-creator` for the authoring loop. Use `skill-judge` or an equivalent independent reviewer
after the final edits. Repair material findings and rerun the affected gates.

## P8. Close the feedback loop

Validation must cover each requested route.

### Evidence checks

- the source file exists and has nonzero size
- the probe reports the expected codec, dimensions, and duration
- representative frames and contact sheets open successfully
- the source URL and capture time are recorded

### Artifact checks

- HTML parses
- standalone SVG parses as XML
- JavaScript syntax checks pass
- the React component builds with the target toolchain
- token JSON parses and follows the required schema
- the latest motion end time does not exceed total duration
- semantic regression checks prove the declared final result

### Browser checks

Use a real browser at desktop and narrow mobile widths. Test:

- initial playback
- pause, play, replay, and speed changes when present
- final state
- reduced-motion state
- keyboard focus
- no horizontal overflow
- source and standalone embeds
- console and network errors
- automated accessibility checks plus manual contrast review

### Repository and skill checks

Run every package, specification, test, lint, build, diff, and issue-tracker gate that the repository
defines. Do not invent missing gate systems. At minimum, run the relevant artifact checks, browser
checks when a browser is available, and an independent skill-quality review against the final skill
and its implementation evidence. If a required browser or repository gate cannot run, report the
exact blocker and do not describe that path as verified.

A passing unit test does not replace browser verification. A clean browser screenshot does not
replace semantic or package validation.

## P9. Deliver the handoff

Present:

- the primary reconstruction preview
- the AnyDesign study preview
- the main generated files
- the validation results
- the clean-room and attribution note
- issue, specification, and persistence state required by the repository

Use a remotely reachable preview URL when the user reviews from another machine. Do not present a
loopback URL as the handoff when repository instructions require a tailnet or published preview.

## Failure handling

- If original media cannot be captured, preserve screenshots and explain the fidelity limit.
- If exact timing cannot be measured, use ranges and mark confidence. Do not invent frame-perfect
  values.
- If one delivery route is impossible in the current stack, complete the other requested routes and
  state the exact blocker.
- If packaging rules prohibit the implementation, keep runtime evidence outside the package and put
  only permitted documentation inside it.
- If the source has no meaningful reusable pattern, stop before skill creation and explain why.

## NEVER rules

- NEVER claim source-code, DOM, or pixel equivalence from video evidence.
- NEVER expose authenticated browser secrets or signed media URLs.
- NEVER animate layout when stable topology is part of the observed behavior.
- NEVER duplicate semantic data across HTML, SVG, and React routes.
- NEVER use animation as the only explanation.
- NEVER add a fake replay, pause, or speed control.
- NEVER package source media or local evidence in a distribution-only skill.
- NEVER declare completion before the requested routes and repository-defined gates have fresh evidence.
