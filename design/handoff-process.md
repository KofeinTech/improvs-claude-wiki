# Handoff Process

How designers hand off work to developers at Improvs.

## Overview

```
Designer finishes screen  -->  Marks "Ready for dev"  -->  Shares Figma link in Jira
         |                                                        |
Developer runs             /improvs:figma-export <URL>            |
         |                 (exports JSON + assets to design/)     |
         |                                                        |
Developer builds from      design/screens/*.json                  |
         |                 (Claude reads local files, no API)     |
         |                                                        |
Developer verifies         /improvs:figma-check                   |
         |                                                        |
Developer commits          design/ + implementation  -->  PR
```

## Designer checklist (before handoff)

Complete this checklist before marking a frame as "Ready for dev":

- [ ] Frame size is 393 x 852 px
- [ ] All frames use Auto Layout
- [ ] All layers have descriptive names (no "Frame 42" or "Rectangle 1")
- [ ] All colors use Figma Variables
- [ ] All text uses defined Text Styles
- [ ] All spacing values from the spacing scale
- [ ] Reusable elements are Components with variants
- [ ] All screen states designed (default, empty, loading, error)
- [ ] Dark mode verified (if applicable)
- [ ] Interactive states shown (hover, pressed, focused)
- [ ] Touch targets are 48x48 px minimum
- [ ] Contrast ratios pass (4.5:1 for regular text)
- [ ] Icons are SVG, outlined, single path
- [ ] Hidden and unused layers removed
- [ ] Animations/transitions annotated in comments

## How to mark ready

1. Select the frame in Figma
2. Right panel > Design tab > Section dropdown > "Ready for development"
3. Share the Figma link with the developer

## How to share

1. Click **Share** (top right) > enter developer's email > set to "Can view"
2. Developer opens the file and switches to **Dev Mode** (Shift + D)
3. Right-click the frame > **Copy link to selection** > send to developer

## Developer workflow

1. Receive the Figma link from designer (via Telegram or Jira ticket)
2. Open Claude Code in the project directory
3. Export the design to local files:

```
/improvs:figma-export https://www.figma.com/design/ABC123/File?node-id=12:34
```

This creates `design/screens/<screen_name>.json`, `design/tokens.json`, and SVG icons in `design/assets/`.

4. Build the screen from the local export:

```
Build the settings screen from this design:
See design/screens/settings_screen.json

Follow the feature structure in lib/features/.
Use design tokens from lib/core/theme/.
```

5. Verify the implementation matches the design:

```
/improvs:figma-check design/screens/settings_screen.json
```

6. Fix mismatches, add business logic, write tests
7. Commit both `design/` files and implementation, create PR

## What the export contains

| Property | Where to find it |
|----------|-----------------|
| Dimensions (width, height) | `size` field in screen JSON |
| Spacing (padding, gaps, margins) | `padding`, `itemSpacing` fields |
| Colors (hex + opacity) | `fills[].hex` and `fills[].opacity` |
| Typography (font, size, weight, line-height) | `typography` object on TEXT nodes |
| Shadows, borders | `effects`, `strokes` fields |
| Border radius | `cornerRadius` field |
| Assets (icons) | `design/assets/*.svg` (auto-exported) |
| Design tokens | `design/tokens.json` (colors, spacing, typography, radii) |

## When designs are unclear

Don't guess. Ask the designer to clarify:
- Ambiguous spacing or alignment
- Missing screen states
- Unclear animation or transition behavior
- Colors that don't match the design token set

Add clarity notes to the Jira ticket so future developers don't hit the same question.
