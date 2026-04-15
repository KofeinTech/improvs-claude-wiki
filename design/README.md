# Design

How designers prepare Figma files for AI-powered Flutter development.

## Guides

| Guide | Description |
|-------|-------------|
| [Designer Guide](designer-guide.md) | Your role in the workflow, how your Figma files become code |
| [Figma Structure](figma-structure.md) | Auto-layout, naming, components, tokens, file organization |
| [Design System](design-system.md) | Design tokens, themes, component library |
| [Color Scheme](color-scheme.md) | M3 ColorScheme -- all 46 color roles, surface hierarchy, extensions |
| [Text Theme](text-theme.md) | M3 TextTheme -- all 15 text styles, semantic roles, customization |
| [Handoff Process](handoff-process.md) | Step-by-step designer-to-developer handoff |

## Key principle

Structure your Figma files for AI. Figma designs are exported to local JSON (`/improvs:figma-export`) and Claude Code generates Flutter code from them. The quality of generated code depends entirely on how well the Figma file is structured.

Auto-layout, semantic naming, and design tokens are mandatory -- not optional.
