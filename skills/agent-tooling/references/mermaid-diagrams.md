# Mermaid Diagrams

> Rendering, syntax gotchas, and tooling for `.mmd` diagrams

## Tooling

| Tool | What | When |
|------|------|------|
| `mmdc` (mermaid-cli) | Local render to PNG/SVG/PDF | **Primary** — all rendering |

**No MCP server needed** — `mmdc` handles rendering locally; don't reach for a hosted rendering
service or an MCP wrapper around it.

## mermaid-cli (mmdc)

```bash
# Install globally (e.g. via pnpm)
pnpm add -g @mermaid-js/mermaid-cli

# Render to PNG (transparent background)
PUPPETEER_EXECUTABLE_PATH=/path/to/chrome-headless-shell \
  mmdc -i input.mmd -o output.png -b transparent

# Render to SVG
PUPPETEER_EXECUTABLE_PATH=/path/to/chrome-headless-shell \
  mmdc -i input.mmd -o output.svg -b transparent

# If Chrome is missing or the version changed: install headless shell, then update the path above
npx puppeteer browsers install chrome-headless-shell
```

**Puppeteer gotcha**: `mmdc` pins a specific puppeteer version, and its bundled
`chrome-headless-shell` binary lives in a versioned cache directory. `PUPPETEER_EXECUTABLE_PATH`
must be the exact resolved path — shell globs (e.g. `linux-*`) do NOT expand inside env var
assignments, so a glob left in the path silently fails to resolve. Re-resolve the exact path
every time the puppeteer/chrome-headless-shell version bumps.

**IMPORTANT**: Always use `mmdc` for rendering. Do NOT generate Mermaid Live URLs as a rendering
shortcut — they're fragile (pako encoding issues, padding bugs, `<br/>` incompatibilities) and
may not even open on the machine you're working from if the render target differs from where
you'll view it.

## Syntax Rules (Flowcharts)

**Line breaks:**

| Context | `<br/>` | `\n` |
|---------|---------|------|
| **Node labels** `["text"]` | Works | Literal `\n` shown |
| **Edge labels** `\|"text"\|` | Breaks parser | Literal `\n` shown |
| **Subgraph titles** `["title"]` | Works | Literal `\n` shown |

**Rule**: Use `<br/>` in node labels, plain text in edge labels. Edge labels don't support HTML.

**Comments (`%%`):**
- `%%` comments work at the top level of a flowchart
- `%%` comments **break inside subgraphs** — some renderers throw JSON parse errors
- To "comment out" nodes inside subgraphs, delete them instead

**Special characters in edge labels:**
- No HTML entities (`&mdash;`, `&rarr;`) — use ASCII (`--`, `->`, `to`)
- No emoji — can cause JSON parse errors in some renderers
- Keep edge labels short and plain: `|"status: success, ready"|`

**Unicode in node labels:**
- Emoji work in node labels but may render inconsistently across platforms
- Prefer ASCII descriptions over emoji for reliability

## `stateDiagram-v2` Label Caveat

Transition labels in `stateDiagram-v2` have a strict parser — colons, parentheses, `<br/>`, HTML
entities, and most special characters cause silent parse failures ("Syntax error in text"). If
your labels need any of these, use `flowchart LR` instead with rounded nodes and quoted edge
labels (`|"label text"|`) — flowcharts handle all special characters and support `<br/>` for
line breaks. Reserve `stateDiagram-v2` for simple single-word or plain-text labels.

## Choosing Mermaid vs an Alternative

| Diagram type | Approach | Why |
|---|---|---|
| Architecture (topology-focused: connections matter more than card content) | Mermaid | Automatic edge routing for many connections |
| Architecture (text-heavy: rich card content matters more than topology) | CSS/HTML cards | Mermaid nodes can't hold rich descriptions, code snippets, or tool lists |
| Flowchart / pipeline | Mermaid | Automatic node positioning and edge routing |
| Sequence diagram | Mermaid | Lifelines, messages, and activation boxes need automatic layout |
| ER / schema diagram | Mermaid | Relationship lines between many entities need auto-routing |
| State machine | Mermaid (or `flowchart LR` — see label caveat above) | State transitions with labeled edges need automatic layout |
| Mind map | Mermaid | Hierarchical branching needs automatic positioning |
| Data table / comparison | A real `<table>` element | Semantic markup, accessibility, and copy-paste behavior beat any diagramming tool |
| Timeline | CSS (central line + cards) | Simple linear layout doesn't need a layout engine |

## File Placement

Diagram source files: `docs/*.mmd`
Rendered output: `docs/*.svg` or `docs/*.png`, committed beside the source.
