# Figma to Code

How to generate Flutter code from Figma designs at Improvs.

## Overview

```
Designer creates in Figma    Developer opens Claude Code    Dev reviews & refines
  (follows Figma rules)   -->  (reads via Figma MCP)     -->  (adjusts, tests)
```

## Prerequisites

- Figma MCP server configured (org-wide, automatic)
- Designer has marked the frame as "Ready for dev" in Figma
- Designer followed the [Figma Structure](../design/figma-structure.md) rules

## Step by step

### 1. Get the Figma link

Ask the designer for the Figma frame URL. Right-click the frame in Figma > "Copy link to selection."

### 2. Open Claude Code in your project

```bash
cd ~/code/your-project
claude
```

### 3. Describe the task with the Figma link

```
Build the settings screen from this Figma design:
[paste Figma URL]

Follow the existing feature structure in lib/features/.
Use our design tokens from lib/core/theme/.
```

### 4. Claude reads the design

Claude uses the Figma MCP server to:
- Read frame dimensions, spacing, colors, typography
- Identify components and variants
- Extract design tokens (if using Figma Variables)
- Understand auto-layout structure (maps to Row/Column/Stack)

### 5. Claude generates Flutter code

Claude creates:
- Screen widget with correct layout
- Theme-referenced colors and typography
- Reusable widgets for repeated elements
- GoRouter route registration
- Riverpod providers if state is needed

### 6. You review and refine

- Compare the running app against the Figma design
- Check spacing, colors, font sizes
- Test on different screen sizes
- Fix any mismatches

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
- [/improvs:figma-check](skills/quality/figma-check.md) -- verify your implementation matches the design
- [Best Practices](best-practices.md) -- general Claude Code tips
