# /improvs:figma-check -- Verify UI Against Design

Compare your implemented UI against the Figma design. Checks spacing, colors, typography, and layout. Smart about rounding -- snaps to nearest design token and ignores 1-2px differences.

## Usage

```
/improvs:figma-check [DESIGN_SOURCE]
```

`DESIGN_SOURCE` can be:
- A local design export: `/improvs:figma-check design/screens/login_screen.json` (recommended)
- A Figma URL: `/improvs:figma-check https://www.figma.com/file/abc123?node-id=42-1337`

If no argument provided, checks `design/screens/` for available exports first, then falls back to any Figma URL saved during `/improvs:start`.

## Who uses this

Developers who built a UI screen and want to verify it matches the design before creating a PR.

## What happens when you run it

1. **Reads the design** from local JSON export in `design/screens/` (created by `/improvs:figma-export`)
2. **Reads the project's design tokens** -- theme file, color constants, spacing scale
3. **Compares implementation vs design** -- checks each property, snapping both sides to the nearest design token before comparing
4. **Reports findings** in three groups:
   - **Matches** -- properties that match within tolerance (briefly listed for confirmation)
   - **Mismatches** -- properties where the implementation differs from the design beyond tolerance, with the suggested fix
   - **Designer inconsistencies** -- values in the Figma design that don't match any project design token. These are likely designer mistakes (e.g. font-size 15px when the scale only has 14 and 16). Claude flags them so you can ask the designer to confirm rather than blindly implementing the off-token value.

## What it checks

- Layout direction and alignment
- Padding, margin, gaps (all spacing)
- Colors (hex, opacity)
- Font family, size, weight, line height
- Border radius, borders, shadows
- Icon sizes
- Image aspect ratios

## Related

- [/improvs:figma-export](figma-export.md) -- export Figma design to local JSON (run this first)
- [/improvs:start](../workflow/start.md) -- saves Figma URL during task setup
- [/improvs:finish](../workflow/finish.md) -- should run /improvs:figma-check before finishing UI tasks
- [Figma to Code](../../figma-to-code.md) -- full workflow guide
