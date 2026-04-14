# Figma Structure

How to organize Figma files so AI can generate accurate Flutter code.

## Why structure matters

Figma designs are exported to JSON (`/improvs:figma-export`) and Claude Code generates Flutter code from the local `design/` folder. The quality of generated code depends entirely on how well the Figma file is structured. Bad structure = bad code = rework.

## Frame size

Always use **393 x 852 px** as the base frame size for all screens.

## Auto Layout is mandatory

Use Auto Layout on every frame. No exceptions.

| Figma Auto Layout | Flutter equivalent |
|-------------------|--------------------|
| Horizontal direction | `Row()` |
| Vertical direction | `Column()` |
| Gap between items | `SizedBox` or `MainAxisAlignment` |
| Padding | `EdgeInsets` |
| Fill container | `Expanded()` |
| Hug contents | Default sizing |
| Fixed size | `SizedBox(width, height)` |

Never drag elements freely. Never use absolute positioning. Never eyeball spacing.

## Name every layer

Use semantic names that describe what the element is:

| Good | Bad |
|------|-----|
| `SubmitButton` | `Rectangle 1` |
| `UserAvatar` | `Frame 42` |
| `PriceLabel` | `Group 7` |
| `NavigationBar` | `Vector` |

## Use components and variants

| Component | Required variants |
|-----------|-------------------|
| Button | Primary, Secondary, Disabled, Loading |
| Input Field | Default, Focused, Error, Disabled, Filled |
| Card | Default, Selected, Expanded |
| Toggle/Switch | On, Off, Disabled |
| Navigation Item | Active, Inactive, Badge |
| Snackbar/Toast | Success, Error, Warning, Info |

Naming convention: use slashes for folders -- `Button / Primary`, `Input / Text / Default`

## Design all screen states

Every screen must have all states designed side by side:

| State | What to design | Example |
|-------|---------------|---------|
| Default | Normal view with data | Product list with items |
| Empty | No data yet | "No orders yet" + illustration |
| Loading | Skeleton or spinner | Shimmer effect on cards |
| Error | Something went wrong | "Failed to load" + retry button |
| No Internet | Offline fallback | "Check connection" screen |

Name them: `Orders - Default`, `Orders - Empty`, `Orders - Error`

## Design tokens (variables)

Set up Figma Variables for:

- **Colors:** base palette (blue/500, gray/100) + purpose colors (primary, background, error)
- **Spacing:** 8pt grid scale: 4, 8, 16, 24, 32, 40, 48, 64
- **Typography:** text styles for every combination (Heading/H1, Body/Regular, Caption)
- **Shadows:** presets (shadow/sm for cards, shadow/md for dropdowns, shadow/lg for modals)
- **Border radius:** none (0), small (4), medium (8), large (12), xl (16), full (9999)

## Dark mode

- Both themes use the same variable names -- only values change
- Use Figma's variable modes (Light / Dark)
- Test every screen in both modes

## File organization

```
Page: Cover        -- project thumbnail and description
Page: Tokens       -- colors, typography, spacing, shadows
Page: Components   -- all reusable components with variants
Page: Icons        -- all icon assets (SVG)
Page: Screens - Auth
Page: Screens - Home
Page: Screens - Settings
Page: Prototypes   -- interactive flows
```

## Icons and assets

- Export icons as SVG (outlined, single path, consistent grid 24x24)
- Export photos as PNG/WebP at 1x, 2x, 3x
- Never export icons as PNG -- they blur when scaled

## Name image layers

Image layers must have descriptive names. The export tool uses layer names for
filenames. Generic names like `image-13` or `Rectangle` make it impossible for
developers to know which image goes where.

| Good | Bad |
|------|-----|
| `OnboardingHeroPhoto` | `image-13` |
| `ProfileAvatar` | `Rectangle 5` |
| `ProductBanner` | `Frame 17` |
| `StepOneIllustration` | `image` |

If a screen has multiple images (e.g., onboarding carousel), name them with
the step or position: `OnboardingStep1Image`, `OnboardingStep2Image`, etc.

## Before handoff

See [Handoff Process](handoff-process.md) for the full checklist.
