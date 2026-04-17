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

## Pixel-perfect implementation rules

These rules are mandatory when building from exported design JSON. Violating them
causes the most common rework.

### Spacing must be exact

- Read `padding` and `itemSpacing` from every node in the design JSON
- Reproduce them exactly in Flutter using `EdgeInsets` and `SizedBox`/gap
- Never guess or approximate spacing -- the JSON has the exact values
- If a Figma value doesn't match a design token, use the exact Figma value and flag it

### Alignment must match the design

- `primaryAxisAlignItems` maps to `MainAxisAlignment`:
  - `MIN` → `MainAxisAlignment.start`
  - `CENTER` → `MainAxisAlignment.center`
  - `MAX` → `MainAxisAlignment.end`
  - `SPACE_BETWEEN` → `MainAxisAlignment.spaceBetween`
- `counterAxisAlignItems` maps to `CrossAxisAlignment`:
  - `MIN` → `CrossAxisAlignment.start`
  - `CENTER` → `CrossAxisAlignment.center`
  - `MAX` → `CrossAxisAlignment.end`
  - `STRETCH` → `CrossAxisAlignment.stretch`
- `textAlignHorizontal` maps to `TextAlign`:
  - `LEFT` → `TextAlign.left`
  - `CENTER` → `TextAlign.center`
  - `RIGHT` → `TextAlign.right`
  - `JUSTIFIED` → `TextAlign.justify`
- If the design says CENTER, the code must say center. Do not default to start.

### Child sizing must match the design

- `layoutAlign: STRETCH` on a child means it fills the parent's cross-axis dimension. In Flutter: set `width: double.infinity` (Column child) or `height: double.infinity` (Row child), or use `CrossAxisAlignment.stretch` on parent
- `layoutGrow: 1` means the child expands to fill remaining space. In Flutter: wrap in `Expanded()`
- `primaryAxisSizingMode: AUTO` means hug content. In Flutter: `MainAxisSize.min`
- `primaryAxisSizingMode: FIXED` means fill container. In Flutter: `MainAxisSize.max`

### Text must be pixel-perfect

Line height in Flutter is a ratio: Figma 24px line height on 16px font = `height: 1.5`

**Critical -- the #1 cause of pixel drift:** Flutter distributes line-height leading differently than Figma. Every Text widget with custom `height` MUST have:

```dart
Text(
  'Your text',
  style: TextStyle(fontSize: 16.sp, height: 1.5),
  textHeightBehavior: const TextHeightBehavior(
    leadingDistribution: TextLeadingDistribution.even,
  ),
)
```

Without `TextLeadingDistribution.even`, text will be visibly offset by 1-3px vs Figma.

### Absolute positioning (non-auto-layout frames)

If a Figma frame has no `layoutMode`, use `Stack` + `Positioned`:
- Never force absolute-positioned elements into Row/Column with negative margins
- `constraints.horizontal: LEFT` maps to `Positioned(left: x)`
- `constraints.horizontal: STRETCH` maps to `Positioned(left: x, right: offset)`

### Components must match exactly

- Buttons: match border radius, padding, background color, text style, and height from the design JSON
- Do not use Flutter default component styling -- always override with design values
- Check fills, strokes, cornerRadius, and effects on every interactive element
- If a component has variants in the design, implement all variants

### Shadows and effects

- `DROP_SHADOW` maps to `BoxShadow(offset: Offset(x, y), blurRadius: blur, spreadRadius: spread, color: color)`
- Multiple shadows render back-to-front in Flutter -- reverse order from Figma
- `INNER_SHADOW` not natively supported -- requires custom painter
- Prefer `color.withValues(alpha:)` over `Opacity` widget for performance

### Other tips

- Export icons as SVG, use `flutter_svg` to render. Some icons fall back to PNG @3x (boolean operations)
- Use `flutter_screenutil` for responsive scaling across devices
- Test both light and dark modes if the design supports them

## Common pitfalls

Issues found during real developer testing -- avoid these:

| Pitfall | What goes wrong | Fix |
|---------|----------------|-----|
| Missing TextHeightBehavior | Text vertically offset from Figma by 1-3px | Add `TextHeightBehavior(leadingDistribution: TextLeadingDistribution.even)` to every Text with custom height |
| Ignoring alignment values | Text defaults to `start` instead of `center` | Always read `primaryAxisAlignItems` / `counterAxisAlignItems` / `textAlignHorizontal` |
| Missing Expanded | Child doesn't fill available space | `layoutGrow: 1` in design JSON = wrap in `Expanded()` |
| Missing stretch | Child doesn't span full cross-axis | `layoutAlign: STRETCH` = `width: double.infinity` or `CrossAxisAlignment.stretch` |
| Approximate spacing | 12px used instead of Figma's 16px | Copy exact `padding` and `itemSpacing` values from JSON |
| Default button styling | Flutter Material defaults override design | Always apply `cornerRadius`, `padding`, `fills` from the design node |
| SVG boolean ops fail | Icons exported as empty/broken SVGs | Export skill now falls back to PNG @3x for boolean operations |
| Generic image names | `image-13.png` tells dev nothing | Export skill names by parent/context -- verify names make sense |
| Missing SizedBox gaps | Items stack with no spacing | Every `itemSpacing` in the JSON = a `SizedBox` between children |
| Shadow order reversed | Shadows render in wrong visual order | Flutter renders back-to-front -- reverse from Figma layer order |

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
