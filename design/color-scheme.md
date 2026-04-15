# Material 3 -- ColorScheme Guidelines

## For Designers -- Flutter Token Reference

> Every token name here maps 1:1 to a Flutter `ColorScheme` property. Use these exact names in Figma styles and handoff specs.

---

## Overview

Flutter's `ColorScheme` contains **46 semantic color roles** (plus 3 deprecated legacy tokens). Designers define colors by **role** (what the color *does*), not by hex value. A single seed color can generate the entire palette via `ColorScheme.fromSeed()`.

---

## Key Colors

Material 3 derives its full palette from **5 key colors**:

| Key Color        | Semantic Meaning                                                             |
|------------------|------------------------------------------------------------------------------|
| Primary          | Your brand's core identity. Conveys the most important actions and states    |
| Secondary        | A complementary voice. Supports primary without competing for attention      |
| Tertiary         | A contrasting accent. Adds depth, variety, and visual interest               |
| Neutral          | The quiet backdrop. Communicates nothing itself -- lets content speak         |
| Neutral Variant  | A slightly tinted neutral. Adds subtle warmth/coolness to borders and chrome |

> **Tooling:** Use [Material Theme Builder](https://m3.material.io/theme-builder) to generate all tokens from your brand's primary color.

---

## Accent Color Roles

Each accent group (Primary, Secondary, Tertiary) follows the same 8-token structure. Understanding the **semantic pattern** lets you apply it consistently across all three groups:

| Role Pattern              | Semantic Meaning                                                              |
|---------------------------|-------------------------------------------------------------------------------|
| `{color}`                 | **The action itself.** Highest emphasis -- "this is the thing to do"          |
| `on{Color}`               | **Legibility on action.** Content that must be readable on the action color. Must meet 4.5:1 contrast ratio. |
| `{color}Container`        | **The context around action.** A softer, toned surface that groups related content -- less aggressive than the raw color |
| `on{Color}Container`      | **Legibility in context.** Content readable on the container surface          |
| `{color}Fixed`            | **Persistent identity.** Stays the same in light AND dark themes -- use when an element must remain visually anchored across themes |
| `{color}FixedDim`         | **Emphasized persistence.** A stronger fixed variant for more visual weight   |
| `on{Color}Fixed`          | **Legibility on persistent surfaces.**                                        |
| `on{Color}FixedVariant`   | **De-emphasized legibility on persistent surfaces.** Lower-contrast option    |

### Primary Group -- Full Semantic Mapping

| Flutter Token             | Meaning                                                         | Typical Usage                                    |
|---------------------------|-----------------------------------------------------------------|--------------------------------------------------|
| `primary`                 | "This is the most important action on screen"                   | FAB, prominent buttons, active tab indicator     |
| `onPrimary`               | "Read me on top of that action"                                 | Text/icon inside a filled primary button         |
| `primaryContainer`        | "This area is related to the primary action, but softer"        | Tonal filled buttons, selected chips, input fills|
| `onPrimaryContainer`      | "Read me inside that softer area"                               | Text inside a primary-toned card                 |
| `primaryFixed`            | "I represent the brand and I don't change between themes"       | Persistent accent that ignores light/dark switch |
| `primaryFixedDim`         | "Same as above, but I want more visual weight"                  | Stronger variant of the above                    |
| `onPrimaryFixed`          | "Read me on the fixed surface"                                  | Text on fixed primary surfaces                   |
| `onPrimaryFixedVariant`   | "Read me too, but I'm secondary information"                    | Subdued text on fixed primary                    |

> **Secondary** and **Tertiary** groups follow the identical 8-token pattern. Replace "primary" with "secondary" or "tertiary" in the token name.

### Choosing Between Accents

| Accent    | Communicates                                  | Examples                                          |
|-----------|-----------------------------------------------|---------------------------------------------------|
| Primary   | "This matters most -- act here"               | Submit button, selected navigation, FAB            |
| Secondary | "This supports the main action"               | Filter chips, toggles, secondary buttons           |
| Tertiary  | "This adds contrast or categorization"        | Category tags, chart accents, input focus rings, decorative highlights |

---

## Error Roles

| Flutter Token       | Meaning                                                      | Typical Usage                                 |
|---------------------|--------------------------------------------------------------|-----------------------------------------------|
| `error`             | "Something went wrong -- pay attention now"                  | Error icons, destructive action buttons       |
| `onError`           | "Read me on top of the error signal"                         | Text inside an error-filled button            |
| `errorContainer`    | "This whole area is affected by the problem"                 | Error banners, error-state text field fills   |
| `onErrorContainer`  | "Read the details about what went wrong"                     | Explanation text inside error banners         |

> M3 does NOT ship success, warning, or info roles. Define custom tokens if your product needs them (see **Extending the Color System** below).

---

## Surface & Background Roles

Surfaces communicate **spatial hierarchy** -- what's in front, what's behind, what's the ground. M3 replaces shadow-based depth with **tonal steps**: higher containers are tonally distinct, not just shadowed.

**Deprecated tokens:** `background`, `onBackground`, and `surfaceVariant` are deprecated in M3. Use `surface`, `onSurface`, and `surfaceContainerHighest` respectively. These deprecated tokens still exist for backwards compatibility but should not be used in new designs.

| Flutter Token              | Meaning                                                              | Typical Usage                                      |
|----------------------------|----------------------------------------------------------------------|----------------------------------------------------|
| `surface`                  | "The ground plane -- the default canvas everything sits on"          | Scaffold body, long scroll areas, page background  |
| `onSurface`                | "Primary content sitting on the ground"                              | Body text, icons, headings on any surface          |
| `onSurfaceVariant`         | "Secondary content -- present but not competing for attention"       | Helper text, placeholder text, secondary icons     |
| `surfaceDim`               | "A receded ground -- pushes content above it forward"                | Dimmed canvas behind modals or featured areas      |
| `surfaceBright`            | "An elevated ground -- lighter, more open feeling"                   | Bright canvas alternative                          |
| `surfaceTint`              | "I subtly tint surfaces to show elevation tonally"                   | Applied automatically for tonal elevation          |

### Surface Containers -- Depth Through Tone

These replace elevation shadows. Each step communicates "I'm one layer closer to the user."

```
surfaceContainerLowest  ->  surfaceContainerLow  ->  surfaceContainer  ->  surfaceContainerHigh  ->  surfaceContainerHighest
    "furthest back"                                                                                    "closest to user"
```

| Flutter Token              | Meaning                                                    | Typical Usage                           |
|----------------------------|------------------------------------------------------------|-----------------------------------------|
| `surfaceContainerLowest`   | "I'm barely distinct from the ground"                      | Lowest-elevation containers             |
| `surfaceContainerLow`      | "I'm a subtle layer above the canvas"                      | Cards at low elevation                  |
| `surfaceContainer`         | "I'm the standard raised surface"                          | Standard cards, sheets, menus           |
| `surfaceContainerHigh`     | "I need more attention than a regular card"                 | Dialogs, navigation drawers             |
| `surfaceContainerHighest`  | "I'm the most prominent surface below actions"             | Top app bars, search bars, text field fills |

---

## Utility Roles

| Flutter Token       | Meaning                                                         | Typical Usage                               |
|---------------------|-----------------------------------------------------------------|---------------------------------------------|
| `outline`           | "I define boundaries -- where one element ends and another begins"| Text field borders, dividers, outlines      |
| `outlineVariant`    | "I'm a softer boundary -- decorative, not structural"           | Decorative dividers, subtle card borders    |
| `shadow`            | "I cast depth beneath elevated elements"                        | Drop shadows on elevated components         |
| `scrim`             | "I dim the world behind a focused element"                      | Modal overlays, bottom sheet backdrops      |
| `inverseSurface`    | "I'm a surface with flipped contrast -- I stand out from the page" | Snackbar / tooltip backgrounds            |
| `onInverseSurface`  | "Read me on that flipped surface"                               | Text inside snackbars and tooltips          |
| `inversePrimary`    | "I'm a primary action on a flipped surface"                     | Action text/links in a snackbar             |

---

## Text + Color Pairing Rules

The `on{X}` color tokens tell you which text color to use on each surface. Always pair them -- never mix arbitrarily:

| Background             | Text Color            | Communicates                                       |
|------------------------|-----------------------|----------------------------------------------------|
| `surface`              | `onSurface`           | Standard content on the default canvas             |
| `surface`              | `onSurfaceVariant`    | De-emphasized content -- "this is secondary info"  |
| `primaryContainer`     | `onPrimaryContainer`  | Content within a primary-branded area              |
| `secondaryContainer`   | `onSecondaryContainer`| Content within a supporting-accent area            |
| `tertiaryContainer`    | `onTertiaryContainer` | Content within a contrasting-accent area           |
| `errorContainer`       | `onErrorContainer`    | Details about what went wrong                      |
| `inverseSurface`       | `onInverseSurface`    | Content on flipped-contrast surfaces (snackbars)   |

---

## Extending the Color System (`ThemeExtension`)

The 46 built-in roles cover most UI needs, but your product may require **additional semantic colors** that M3 doesn't provide out of the box. Flutter supports this through `ThemeExtension`, which lets you define custom color roles that live alongside the standard `ColorScheme` and participate in light/dark theming.

### When to extend

- **Status colors** -- success (green), warning (amber), info (blue) for feedback states beyond error
- **Domain-specific roles** -- e.g., "revenue" vs "expense" in a finance app, "available" vs "booked" in a scheduling app
- **Semantic surface variants** -- branded section backgrounds, feature-specific highlights, tier/badge colors

### Guidelines for custom color roles

- **Follow the M3 naming pattern.** For every custom fill color, define a matching `on{X}` content color. Example: `success` + `onSuccess`, `successContainer` + `onSuccessContainer`.
- **Derive from tonal palettes.** Generate custom colors using the same tonal system (Material Theme Builder's "Custom Colors" section) so they harmonize with your primary/secondary/tertiary.
- **Provide both light and dark values.** Every extension color must work in both themes -- don't define colors for light mode only.
- **Keep extensions minimal.** Each new color is a maintenance cost. Before adding one, ask: can an existing role (secondary, tertiary) carry this meaning instead?
- **Document the semantics.** Every custom token should have a "Meaning" description just like the built-in roles above -- so designers and developers share the same understanding.

### Example extension structure

| Custom Token          | Meaning                                        | Light Value | Dark Value |
|-----------------------|------------------------------------------------|-------------|------------|
| `success`             | "This action succeeded / this state is good"   | #2E7D32     | #81C784    |
| `onSuccess`           | "Read me on the success color"                 | #FFFFFF     | #1B5E20    |
| `successContainer`    | "This area conveys a positive outcome"         | #C8E6C9     | #2E7D32    |
| `onSuccessContainer`  | "Read the success details"                     | #1B5E20     | #C8E6C9    |
| `warning`             | "Caution -- review before proceeding"          | #F57F17     | #FFD54F    |
| `onWarning`           | "Read me on the warning color"                 | #FFFFFF     | #3E2723    |

> The hex values above are examples. Always derive your actual values from tonal palettes to ensure harmony and accessibility.

---

## Quick Reference -- All 46 Tokens

```
ACCENTS (8 tokens x 3 groups = 24)
  primary . onPrimary . primaryContainer . onPrimaryContainer
  primaryFixed . primaryFixedDim . onPrimaryFixed . onPrimaryFixedVariant
  secondary (same 8-token pattern)
  tertiary  (same 8-token pattern)

ERROR (4)
  error . onError . errorContainer . onErrorContainer

SURFACE (11)
  surface . onSurface . onSurfaceVariant
  surfaceDim . surfaceBright . surfaceTint
  surfaceContainerLowest . surfaceContainerLow . surfaceContainer
  surfaceContainerHigh . surfaceContainerHighest

UTILITY (7)
  outline . outlineVariant
  shadow . scrim
  inverseSurface . onInverseSurface . inversePrimary

DEPRECATED (3) -- do not use in new designs
  background -> use surface
  onBackground -> use onSurface
  surfaceVariant -> use surfaceContainerHighest
```

---

## Designer Checklist

- [ ] Define 1 primary seed color minimum; optionally override secondary & tertiary
- [ ] Generate full light + dark palettes using Material Theme Builder
- [ ] Verify every `on{X}` / `{X}` pairing meets **4.5:1** contrast ratio (WCAG AA)
- [ ] Use `surfaceContainer*` levels for depth -- avoid arbitrary grays
- [ ] Reserve `primary` for 1-2 key actions per screen; don't dilute its meaning
- [ ] Never hardcode hex values in specs -- always reference token names
- [ ] If extending: follow the `{color}` / `on{Color}` / `{color}Container` / `on{Color}Container` pattern
- [ ] If extending: provide both light and dark values, derived from tonal palettes
- [ ] Document every custom token's semantic meaning

---

## Resources

- [Material Theme Builder](https://m3.material.io/theme-builder) -- Generate palettes from seed (including custom colors)
- [M3 Color Roles Spec](https://m3.material.io/styles/color/roles) -- Official color role definitions
- [Flutter ColorScheme API](https://api.flutter.dev/flutter/material/ColorScheme-class.html) -- All color properties
- [Material 3 Design Kit (Figma)](https://www.figma.com/community/file/1035203688168086460) -- Official Figma components
