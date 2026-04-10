# Figma to Code

How to generate Flutter code from Figma designs at Improvs.

## Overview

```
Designer creates in Figma    /improvs:figma-export    Developer builds from local JSON
  (follows Figma rules)   -->  (exports to design/)  -->  (Claude reads design/*.json)
```

## How it works

Figma designs are exported to local JSON files in the project's `design/` folder using the `/improvs:figma-export` skill. This uses Figma's REST API with a shared Personal Access Token from a designer who already has a Full seat.

Once exported, Claude Code reads the design from local files. No API calls, no rate limits, works offline.

## Prerequisites

- `FIGMA_API_KEY` environment variable set (shared designer PAT -- ask your lead)
- Designer has marked the frame as "Ready for dev" in Figma
- Designer followed the [Figma Structure](../design/figma-structure.md) rules

## Step by step

### 1. Get the Figma link

Ask the designer for the Figma frame URL. Right-click the frame in Figma > "Copy link to selection."

### 2. Export the design

```
/improvs:figma-export https://www.figma.com/design/ABC123/FileName?node-id=12:34
```

This creates:
```
design/
  screens/settings_screen.json   -- layout, spacing, colors, typography
  tokens.json                    -- design tokens (merged across exports)
  assets/
    icon-settings.svg            -- SVG icons from the design
```

### 3. Build the screen from the export

```
Build the settings screen from this design:
See design/screens/settings_screen.json

Follow the existing feature structure in lib/features/.
Use our design tokens from lib/core/theme/.
```

Claude reads the local JSON and generates Flutter code. No Figma API calls needed.

### 4. Claude generates Flutter code

Claude creates:
- Screen widget with correct layout
- Theme-referenced colors and typography
- Reusable widgets for repeated elements
- GoRouter route registration
- Riverpod providers if state is needed

### 5. You review and refine

- Compare the running app against the Figma design
- Check spacing, colors, font sizes
- Test on different screen sizes
- Run `/improvs:figma-check design/screens/settings_screen.json` to verify

### 6. Commit the design files

The `design/` folder is committed to the repo so the whole team can reference it. Re-export when the designer updates the Figma file.

## The design/ folder

Every project that uses Figma designs has a `design/` folder at the root:

```
design/
  tokens.json              -- colors, typography, spacing, border radii (merged)
  screens/
    login_screen.json      -- one file per exported Figma frame
    settings_screen.json
    profile_screen.json
  assets/
    icon-email.svg         -- SVG icons extracted from designs
    icon-lock.svg
```

- `tokens.json` grows as you export more screens (tokens merge, not overwrite)
- Screen files overwrite on re-export (always latest from Figma)
- Assets are SVG icons ready for `flutter_svg`

## FIGMA_API_KEY setup

The team shares Figma API keys from designers who already have Full seats:

```bash
# Add to your shell profile (~/.zshrc or ~/.bashrc)
export FIGMA_API_KEY=figd_xxxxx
```

Ask your lead for the key. Keys are split by project -- designers on project A share their key with project A developers. This stays within Figma's rate limits (15 req/min per key).

## What makes a good Figma file for AI

The quality of generated code depends entirely on how well the designer structured the Figma file:

| Good | Bad |
|------|-----|
| Auto-layout on every frame | Absolute positioning |
| Semantic names: `SubmitButton` | Default names: `Frame 42` |
| Design tokens for colors/spacing | Hardcoded hex values |
| Component variants for states | Duplicate frames per state |
| All screen states designed | Only happy path |

See [Figma Structure](../design/figma-structure.md) for the full rules.

## Pixel-perfect tips

- Line height in Flutter is a ratio: Figma 24px line height on 16px font = `height: 1.5`
- Always use exact values from Figma, never approximate
- Export icons as SVG, use `flutter_svg` to render
- Use `flutter_screenutil` for responsive scaling across devices
- Test both light and dark modes if the design supports them

## When it doesn't work well

AI struggles with:
- Complex animations (Lottie, custom transitions)
- Heavily customized widgets without clear Figma structure
- Designs that break auto-layout rules

If you hit a wall, solve manually and create an [ai-gap ticket](../processes/ai-gap-pipeline.md).

## Related

- [Figma Structure](../design/figma-structure.md) -- how designers should set up Figma files
- [Design Handoff](../design/handoff-process.md) -- the full designer-to-developer process
- [/improvs:figma-export](skills/quality/figma-export.md) -- export Figma design to local JSON
- [/improvs:figma-check](skills/quality/figma-check.md) -- verify your implementation matches the design
- [Best Practices](best-practices.md) -- general Claude Code tips
