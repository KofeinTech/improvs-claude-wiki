# /figma-check -- Verify UI Against Figma

Compare your implemented UI against the Figma design. Checks spacing, colors, typography, and layout. Smart about rounding -- snaps to nearest design token and ignores 1-2px differences.

## Usage

```
/figma-check [FIGMA_NODE_URL]
```

Example: `/figma-check https://www.figma.com/file/abc123?node-id=42-1337`

If no URL provided, uses the Figma URL saved during `/start`.

## Who uses this

Developers who built a UI screen and want to verify it matches the design before creating a PR.

## What happens when you run it

1. **Reads the Figma design** via Figma MCP -- layout, spacing, colors, typography, borders, shadows
2. **Reads the project's design tokens** -- theme file, color constants, spacing scale
3. **Compares implementation vs design** -- checks each property
4. **Reports differences** with severity:
   - **Mismatch** -- wrong value that doesn't match any token
   - **Close** -- within 1-2px, probably fine
   - **Missing** -- element in design not found in code

## What it checks

- Layout direction and alignment
- Padding, margin, gaps (all spacing)
- Colors (hex, opacity)
- Font family, size, weight, line height
- Border radius, borders, shadows
- Icon sizes
- Image aspect ratios

## Related

- [/start](start.md) -- saves Figma URL during task setup
- [/finish](finish.md) -- should run /figma-check before finishing UI tasks
