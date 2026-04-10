# /improvs:figma-export -- Export Figma Design to Local Files

Export a Figma frame to the project's `design/` folder as structured JSON and SVG assets. Uses the Figma REST API with a shared Personal Access Token.

## Usage

```
/improvs:figma-export <FIGMA_URL>
```

Example: `/improvs:figma-export https://www.figma.com/design/ABC123/App?node-id=12:34`

## Who uses this

Any developer who needs to build a UI screen from a Figma design. Run this before coding -- it prepares local design files that Claude Code reads during implementation.

## Prerequisites

Set the `FIGMA_API_KEY` environment variable with a shared Figma Personal Access Token:

```bash
export FIGMA_API_KEY=figd_xxxxx
```

Ask your lead for the key. Keys come from designers who already have Full seats -- no extra cost.

## What happens when you run it

1. **Parses the Figma URL** -- extracts file key and node ID
2. **Fetches the design** via Figma REST API (2-4 API calls total)
3. **Extracts design tokens** -- colors, typography, spacing, border radii
4. **Exports SVG icons** -- vector nodes and icon components
5. **Saves to `design/` folder:**

```
design/
  tokens.json                  -- design tokens (merged across exports)
  screens/
    settings_screen.json       -- screen structure (layout, spacing, colors, children)
  assets/
    icon-settings.svg          -- SVG icons from the design
```

## What the screen JSON contains

The JSON is a simplified, Claude-friendly version of the Figma data:
- Node hierarchy with `type`, `name`, `children`
- Layout: `layoutMode` (VERTICAL/HORIZONTAL), `primaryAxisAlignItems`, `counterAxisAlignItems`
- Spacing: `padding` (top/right/bottom/left), `itemSpacing`
- Size: `width`, `height`
- Visual: `fills` (hex colors), `cornerRadius`, `strokes`, `effects`
- Text: `characters`, `typography` (fontFamily, fontSize, fontWeight, lineHeight)

## Re-exporting

When a designer updates the Figma file, re-run the export with the same URL. The screen JSON overwrites, tokens merge (new values added, existing kept).

## Rate limits

Each export uses 2-4 Figma API calls. The shared PAT has a budget of 15 requests/minute and ~200/day on Professional plan. At 2-4 calls per export, you can run ~50-100 exports per day across the whole team sharing that key.

## Related

- [/improvs:figma-check](figma-check.md) -- verify implementation matches the exported design
- [/improvs:start](../workflow/start.md) -- auto-detects local design exports for UI tasks
- [Figma to Code](../../figma-to-code.md) -- full workflow guide
- [Design Handoff](../../../design/handoff-process.md) -- designer-to-developer process
