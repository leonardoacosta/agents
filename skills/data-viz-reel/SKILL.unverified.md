---
name: data-viz-reel
description: Build animated data visualization comparison reels with neon-on-dark stacked horizontal bar charts, sequential row reveal with glow effects, tree-diagram intros, and value counters. Use whenever the user wants an animated data comparison infographic, a neon bar chart animation, an Instagram-style stats reel, a stacked horizontal bar animation, a hierarchy/data visualization reel, or any animated comparison chart with glow effects on dark backgrounds. Triggers on: data viz reel, animated bar chart, neon chart, glow bar animation, stacked bar comparison, hierarchy infographic, stats reel, data comparison animation, Instagram-style infographic.
---

# Data Viz Reel — Animated neon-on-dark data comparison reels

Build self-contained animated comparison reels using a neon-palette-on-absolute-dark design system. Every delivery route shares the same semantic data model. The visual system uses 5 high-saturation accent colors on a near-black surface with glow effects during animation and sequential row reveal.

## Output contract

> **MANDATORY before implementing any route:** Read `references/design-tokens.json` for exact hex values, spacing, and motion durations. Read `references/evaluation.md` for the validation criteria.

Three delivery routes, all sharing one data model:

| Route | File | When to use |
|---|---|---|
| HTML + WAAPI | `index.html` | Interactive preview with play/pause/replay/skip controls |
| Standalone SVG | `reconstruction.svg` | No-JS embed, SMIL animations, reduced-motion fallback |
| React component | `BarChartReel.tsx` | Integration into React apps, typed props |

All routes must produce indistinguishable visual results from the same input data.

## Shared data model

**Before building, ask yourself:**
1. What categories does each accent color encode? Map color indices (0-4) to semantic categories.
2. How many rows? ≤5 rows can all fit on screen; >8 rows consider collapsing or pagination.
3. Is there hierarchical structure? Tree-diagram intro only adds value when the data has a parent/child topology.
4. Are all values comparable on the same scale? Stacked bars assume proportional comparison.

Define the data before any rendering. Every route reads the same model:

```typescript
interface ChartData {
  title: string;           // "Data Visualization"
  totalWidth: number;      // bar area width in SVG units (e.g. 380)
  rows: ChartRow[];        // 5-10 rows
}
interface ChartRow {
  label: string;           // category label ("Category Alpha")
  segments: BarSegment[];  // 2-4 stacked segments per row
}
interface BarSegment {
  color: number;           // index into ACCENT_COLORS (0-4)
  w: number;               // width in SVG units (proportional to value)
  v: string;               // display value ("42%", "$142K")
}
```

Validate before rendering: reject duplicate labels, unknown color indices, empty rows, or a total width that doesn't fit the viewBox.

## Design system constraints

These are non-negotiable for the neon-on-dark aesthetic:

### Colors (5 accent + dark surface)
```
surface:     #0a0f1a    (near-black background — never pure #000)
text:        #ffffff    (primary labels)
text-muted:  #8892b0    (secondary/meta text)
accent[0]:   #ff2d78    (pink — category encoding)
accent[1]:   #00e676    (green)
accent[2]:   #ff6b35    (orange)
accent[3]:   #7c4dff    (purple)
accent[4]:   #00bcd4    (cyan)
border:      #1e2a45    (tree edges, subtle borders)
```

**Do not exceed 5 accent colors.** The palette is semantic — each color encodes one category. Adding a 6th color breaks the encoding system. If you need more categories, use pattern fills or segment labels instead.

**Accent colors are for data only.** Never use accent colors for text, backgrounds, or decorative elements.

### Bar segments
- Height: 22px, with 14px row gap (36px total per row)
- Corner radius: 4px
- Minimum segment width: 4px (never collapse to 0)
- Value counters: 15px bold, `font-variant-numeric: tabular-nums` (prevents layout shift during digit transitions)
- Category labels: 13px semibold, right-aligned, 40px from bar start

### Glow effects
```
box-shadow: 0 0 12px currentColor  (during bar growth only)
```
- Glow appears during bar width animation, fades out on completion
- Never glow static bars. Glow = "this value is changing"
- Glow color matches the bar segment's accent color at ~25% opacity

## Motion specification

### Timing
| Event | Duration | Easing |
|---|---|---|
| Bar segment growth | 1.2s | `ease-out` (cubic-bezier 0.0,0.0,0.2,1.0) |
| Row stagger delay | 300ms | — |
| Row slide-in | 400ms | `ease-out` |
| Glow fade-out | 300ms | `ease-out` |
| Tree fade-out | 500ms | `ease-in` |

### Staging
```
STAGE 0: Title + Tree diagram visible (2.5s)
  └─ Tree fades out (0.5s)
    └─ STAGE 1: Row 1 slides in (0.4s)
      └─ Bar segments grow (1.2s each, staggered 0.4s)
        └─ Glows fade (0.3s)
          └─ STAGE 2: Row 2 enters (0.3s stagger)
            └─ ...repeat until all rows shown
              └─ STAGE N: All rows visible, all animations done
```

The stagger between rows is 300ms. The next row's slide-in starts **before** the current row's glow fully fades (slight overlap keeps rhythm flowing).

### Optional tree-diagram intro
A radial hierarchy diagram before the bar chart:
- Nodes: circles (12-18px radius), colored by category
- Edges: `#1e2a45`, 1.5-2px stroke, reduced opacity
- 2-3 tiers, root node at center
- Fades out before bar charts appear

Omit the tree diagram when the data has no hierarchical structure.

## Route: HTML + WAAPI

Self-contained single-file HTML. Include:

1. **Controls**: Play, Pause, Replay, Skip to End — real `<button>` elements with visible focus outlines
2. **Status**: `aria-live="polite"` region showing current animation phase
3. **Reduced motion**: CSS `@media (prefers-reduced-motion: reduce)` disables transitions + JS `matchMedia` check auto-calls `showFinal()` on load (defer via double `requestAnimationFrame` to ensure DOM is built)
4. **Keyboard**: All controls operateable, visible `:focus-visible` outlines in cyan
5. **Provenance**: Clean-room attribution section at bottom
6. **Synthetic data warning**: If using placeholder data, add a prominent ⚠️ banner

CSS custom properties for every token. SVG inline in the page (no external assets). WAAPI or `requestAnimationFrame` for bar growth + value counting.

**Key pattern — reduced motion init:**
```javascript
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
if (prefersReducedMotion.matches) {
  buildInitial();
  requestAnimationFrame(() => {
    requestAnimationFrame(() => showFinal());
  });
}
```

**Key pattern — stagger chain:**
```javascript
async function runAnimation() {
  for (let ri = 0; ri < data.rows.length; ri++) {
    await animateRow(ri);  // slide-in (400ms) + bar grow (1.2s) + glow (1.5s total)
    if (ri < data.rows.length - 1) await sleep(300);  // stagger
  }
}
```

## Route: Standalone SVG

Self-contained `.svg` file with SMIL animations. Include:

1. `<title>` and `<desc>` for accessibility
2. `role="img"` with descriptive `aria-label`
3. `<defs>` with glow filters (`feGaussianBlur` + `feComposite`)
4. SMIL `<animate>` elements for: opacity (fade in/out), width (bar growth), x (segment positioning)
5. `<set>` for text content changes at defined times
6. Attribution footer text with creator credit
7. Total duration metadata as a comment

**Key pattern — bar segment growth:**
```xml
<rect x="130" y="0" width="0" height="22" rx="4" fill="#ff2d78">
  <animate attributeName="width" from="0" to="320" dur="1.2s" begin="3.4s" fill="freeze"/>
</rect>
```

SMIL has limited browser support (Safari). The SVG must still be readable at the final state without animations running.

## Route: React component

Typed `.tsx` file. Export:

```typescript
export function BarChartReel({ data, autoPlay, onComplete }: BarChartReelProps)
export type { ChartData, ChartRow, BarSegment }
export { ACCENT_COLORS, GLOW_COLORS }
```

**Key pattern — phase state machine:**
```typescript
const [phase, setPhase] = useState<'intro' | 'animating' | 'complete'>('intro');
const [currentRow, setCurrentRow] = useState(-1);
const reducedMotion = useMediaQuery('(prefers-reduced-motion: reduce)');

const play = useCallback(() => {
  if (reducedMotion) { setPhase('complete'); setCurrentRow(data.rows.length); return; }
  setPhase('intro'); setCurrentRow(-1);
  timerRef.current = setTimeout(() => { setPhase('animating'); setCurrentRow(0); }, 2500);
}, [reducedMotion, data]);
```

The component:
- Accepts an optional `data` prop (falls back to bundled demo data)
- Detects `prefers-reduced-motion` via `useEffect` + `matchMedia`
- When reduced motion: renders all bars at full width immediately, skips animation
- Manages phase state machine: `intro → animating → complete`
- Cancels stale timeouts/animations on unmount, replay, and data change
- Exposes `play()`, `pause()`, `replay()`, `skipToEnd()` via ref or internal controls
- Uses inline SVG (no external dependencies)
- Value formatter: adapt based on data.v format (percentages vs dollar amounts)

## Reduced motion contract

When `prefers-reduced-motion: reduce` is active:
- All bars render at full width immediately (no growth animation)
- All values display final state (no counting animation)
- No glow effects
- No slide-in transitions
- No tree-to-bar fade — show bars directly
- The data must be fully readable without motion

This applies to ALL routes. The reduced-motion state IS the data delivery state.

## NEVER rules

1. NEVER exceed 5 accent colors — the encoding breaks
2. NEVER use accent colors for text or backgrounds — they are data-only
3. NEVER animate layout — bar height, row position, and label positions are stable topology
4. NEVER glow static bars — glow is an animation signal, not decoration
5. NEVER show all rows at once from the start — sequential reveal is part of the identity
6. NEVER use shadows for structural depth — flat design by intent
7. NEVER add background gradients, patterns, or textures — the surface is deliberately solid
8. NEVER claim content accuracy when using placeholder data — label synthetic data prominently
9. NEVER collapse bar segments to width 0 — min-width 4px
10. NEVER exceed 700 font weight — bold is the ceiling

## Validation gate

Before delivering, run these checks on every route:

```bash
# HTML
python3 -c "from html.parser import HTMLParser; HTMLParser().feed(open('index.html').read())"

# SVG
python3 -c "import xml.etree.ElementTree as ET; ET.parse('reconstruction.svg')"

# React
npx -y tsc --noEmit --jsx react-jsx --esModuleInterop BarChartReel.tsx

# WCAG contrast
python3 scripts/check_contrast.py --pair "#ffffff,#0a0f1a" --pair "#ff2d78,#0a0f1a" \
  --pair "#00e676,#0a0f1a" --pair "#ff6b35,#0a0f1a" \
  --pair "#7c4dff,#0a0f1a" --pair "#00bcd4,#0a0f1a"
```

Purple (#7c4dff) is acceptable at 3.98:1 for non-text contrast (WCAG 1.4.11 — bar segments are UI components, not text). If used for text, shift to `#9575ff` for AA normal.

## Bundled references

- `references/design-tokens.json` — DTCG-format tokens. **MANDATORY: read before implementing any route.** Contains exact hex values, spacing, radii, and motion durations.
- `references/evaluation.md` — 6-case benchmark. **Read before delivering** to verify reconstruction fidelity against the scoring dimensions.
- `eval-report.md` — Skill quality evaluation (100/120, Grade B).