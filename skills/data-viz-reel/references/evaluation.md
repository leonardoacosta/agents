# Data Viz Reel — Evaluation Criteria

6 test cases across 7 scoring dimensions.

## Scoring dimensions

- **Color hex extraction** (weight: 20%): per hex: ±10 ΔE = 1pt, ±20 ΔE = 0.5pt, >20 ΔE = 0pt
- **Semantic role assignment** (weight: 15%): exact match = 1pt, semantic equivalent = 0.5pt, wrong = 0pt
- **Font family/scale detection** (weight: 10%): correct family = 1pt, plausible fallback = 0.5pt
- **Component detection count** (weight: 15%): precision/recall of component catalog
- **Motion channel identification** (weight: 20%): correct channel + easing = 1pt, correct channel only = 0.5pt
- **Confidence marker accuracy** (weight: 10%): high where justified, medium/low for inferences — penalize overconfident wrong answers
- **Do's/Don'ts groundedness** (weight: 10%): each rule anchored to observable evidence = 1pt, generic advice = 0pt

## Thresholds
- **production_ready**: ≥80%
- **acceptable**: ≥65%
- **needs_work**: ≥50%
- **broken**: ≥0%

### palette-primary
_Title screen with tree diagram — all accent colors visible against dark surface_

**Expected findings:**
- Dark navy background (near-black, not pure black)
- At least 4 distinct neon accent colors
- White primary text
- Tree nodes are circular with colored fills

### palette-bar-chart
_Mid-animation bar chart — orange and additional colors visible in bar segments_

**Expected findings:**
- Orange bar segments present (5th accent color)
- Category labels in muted secondary text color
- Bar segments are stacked horizontally

### typography-scale
_Title and tree diagram — assess typography detection_

**Expected findings:**
- Title uses bold weight with large size
- Node labels use smaller size but still bold/semibold
- Tabular-nums or monospace for values (not visible in this frame)

### component-catalog
_Full frame set — how many distinct components are detected?_

**Expected findings:**
- At least 4 generic components identified
- At least 1 signature component identified
- Components have associated tokens (colors, radii, spacing)

### motion-analysis
_Full 30s video — identify motion channels, timing, and staging_

**Expected findings:**
- Bar width animation identified as primary motion channel
- Glow/box-shadow effect noted during animation
- Sequential/staggered row revelation identified
- Tree diagram fade-out transition to bar chart
- Timing estimates within reasonable ranges

### brand-rules-validity
_Meta-evaluation: are the generated Do's/Don'ts grounded in observable evidence from the frames?_

**Expected findings:**
- Each Do traces to an observed pattern in the frames
- Each Don't prevents a common design drift from the observed system
- No generic UX platitudes ('maintain consistency', 'use white space')
- Tokens cited explicitly in rules wherever possible
