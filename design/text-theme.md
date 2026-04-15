# Material 3 -- TextTheme Guidelines

## For Designers -- Flutter Token Reference

> Every token name here maps 1:1 to a Flutter `TextTheme` property. Use these exact names in Figma styles and handoff specs.

---

## Overview

Flutter's `TextTheme` contains **15 text styles** organized into 5 semantic roles x 3 sizes (Large, Medium, Small). Each style maps directly to a `TextStyle` with font size, weight, line height, and letter spacing.

---

## Type Scale -- Default Values

Sizes are in logical pixels (sp/dp). The default font family is platform-dependent: Roboto on Android, San Francisco on iOS, and system fonts on other platforms. The values below are the M3 geometry defaults regardless of platform.

**Note on line height:** Flutter stores line height as a multiplier of fontSize (the `height` property), not as absolute pixels. The pixel values below are the intended rendered heights. When implementing in code, use the multiplier (e.g., `height: 1.12` for Display Large, not `height: 64`).

| Token              | Size  | Line Height | Height Multiplier | Weight         | Letter Spacing |
|--------------------|-------|-------------|-------------------|----------------|----------------|
| **Display Large**  | 57 px | 64 px       | 1.12              | 400 (Regular)  | -0.25 px       |
| **Display Medium** | 45 px | 52 px       | 1.16              | 400 (Regular)  | 0 px           |
| **Display Small**  | 36 px | 44 px       | 1.22              | 400 (Regular)  | 0 px           |
| **Headline Large** | 32 px | 40 px       | 1.25              | 400 (Regular)  | 0 px           |
| **Headline Medium**| 28 px | 36 px       | 1.29              | 400 (Regular)  | 0 px           |
| **Headline Small** | 24 px | 32 px       | 1.33              | 400 (Regular)  | 0 px           |
| **Title Large**    | 22 px | 28 px       | 1.27              | 400 (Regular)  | 0 px           |
| **Title Medium**   | 16 px | 24 px       | 1.50              | 500 (Medium)   | 0.15 px        |
| **Title Small**    | 14 px | 20 px       | 1.43              | 500 (Medium)   | 0.1 px         |
| **Body Large**     | 16 px | 24 px       | 1.50              | 400 (Regular)  | 0.5 px         |
| **Body Medium**    | 14 px | 20 px       | 1.43              | 400 (Regular)  | 0.25 px        |
| **Body Small**     | 12 px | 16 px       | 1.33              | 400 (Regular)  | 0.4 px         |
| **Label Large**    | 14 px | 20 px       | 1.43              | 500 (Medium)   | 0.1 px         |
| **Label Medium**   | 12 px | 16 px       | 1.33              | 500 (Medium)   | 0.5 px         |
| **Label Small**    | 11 px | 16 px       | 1.45              | 500 (Medium)   | 0.5 px         |

---

## Role Semantics -- What Each Style Communicates

### Display -- "Look at this number / word"

The largest text on screen. Display styles say: **this is the single most important piece of information -- absorb it at a glance.** They work best for short, impactful content that doesn't need to be *read* so much as *seen*.

- Hero statistics, pricing, countdowns
- Splash / landing page titles
- Best on large screens; use sparingly on mobile
- Always single-line -- if it wraps, it's too long for Display

| Token            | Semantic nuance                                                |
|------------------|----------------------------------------------------------------|
| `displayLarge`   | Maximum visual impact -- reserved for the single hero moment   |
| `displayMedium`  | Strong impact with slightly less dominance                     |
| `displaySmall`   | The entry point to display-level emphasis                      |

> **Design rule:** If Display appears on every screen, it's lost its meaning. Reserve it for moments of maximum emphasis.

### Headline -- "Here's a new section"

Headlines say: **a new topic or section starts here.** They establish the structure of your content. Smaller than Display, they're suited for screens where Display would feel oversized.

- Primary section headings on mobile
- Dialog titles
- Page-level titles when Display is too large
- Should remain single-line when possible

| Token              | Semantic nuance                                              |
|--------------------|--------------------------------------------------------------|
| `headlineLarge`    | Top-level section divider -- "major new topic"               |
| `headlineMedium`   | Standard section heading                                     |
| `headlineSmall`    | Subsection heading or dialog title                           |

### Title -- "This group of content is called..."

Titles say: **here's what this component or subsection is about.** They're medium-emphasis labels that name things -- a card, a list section, a navigation destination.

- App bar titles (`titleLarge`)
- Card headers, list section dividers (`titleMedium`)
- Smaller component labels, tab labels (`titleSmall`)
- Relatively short text -- a few words, not sentences

| Token           | Semantic nuance                                               |
|-----------------|---------------------------------------------------------------|
| `titleLarge`    | "The name of this screen or major component"                  |
| `titleMedium`   | "The name of this card, section, or group"                    |
| `titleSmall`    | "The label for this tab, list header, or small component"     |

### Body -- "Read this content"

Body styles say: **this is the substance -- settle in and read.** They're the workhorse of your type system, optimized for comfortable reading at length.

| Token          | Semantic nuance                                                |
|----------------|----------------------------------------------------------------|
| `bodyLarge`    | "This paragraph is more important than the rest" -- emphasized body content, key descriptions |
| `bodyMedium`   | **"This is the default reading voice"** -- most content lives here. Flutter components use this as standard. |
| `bodySmall`    | "This is supplementary" -- captions, timestamps, metadata, secondary descriptions |

### Label -- "This is a control / annotation"

Labels say: **I belong to a UI element, not to the content.** They're small, utilitarian, and live inside or alongside interactive components.

| Token           | Semantic nuance                                               |
|-----------------|---------------------------------------------------------------|
| `labelLarge`    | "Tap me" -- button text, navigation bar labels, prominent interactive text |
| `labelMedium`   | "I describe this control" -- chip text, badge labels, menu items |
| `labelSmall`    | "Fine print" -- footnotes, overlines, annotations, the smallest legible text |

---

## Text Color Integration

Flutter's `TextTheme.apply()` method has `displayColor` and `bodyColor` parameters. Due to a legacy mapping, the split is **not** a clean role-based boundary:

| Color Property   | Applied To                                                                 |
|------------------|---------------------------------------------------------------------------|
| `displayColor`   | displayLarge, displayMedium, displaySmall, headlineLarge, headlineMedium, **bodySmall** |
| `bodyColor`      | **headlineSmall**, titleLarge, titleMedium, titleSmall, bodyLarge, bodyMedium, labelLarge, labelMedium, labelSmall |

> **In practice this quirk doesn't matter.** M3 themes set both `displayColor` and `bodyColor` to the same value (`onSurface`), so the split is invisible. Use `onSurface` for maximum contrast on surface backgrounds and `onSurfaceVariant` for de-emphasized text.

**Common text-color pairings:**

| Surface Token          | Text Color Token      | Use Case                                |
|------------------------|-----------------------|-----------------------------------------|
| `surface`              | `onSurface`           | Standard page content                   |
| `surface`              | `onSurfaceVariant`    | De-emphasized / helper text             |
| `primaryContainer`     | `onPrimaryContainer`  | Text inside a primary-toned card        |
| `secondaryContainer`   | `onSecondaryContainer`| Text inside a secondary-toned area      |
| `tertiaryContainer`    | `onTertiaryContainer` | Text inside a tertiary-toned area       |
| `errorContainer`       | `onErrorContainer`    | Error message in a tinted banner        |
| `inverseSurface`       | `onInverseSurface`    | Snackbar content                        |

---

## Customizing TextStyle Properties

Each of the 15 tokens is a full `TextStyle` -- meaning every property can be varied independently:

| Property         | What it controls                                  |
|------------------|---------------------------------------------------|
| `fontFamily`     | Typeface (e.g., Roboto, Inter, your brand font)   |
| `fontSize`       | Size in logical pixels                            |
| `fontWeight`     | Thickness (400 = Regular, 500 = Medium, 700 = Bold, etc.) |
| `height`         | Line height as a multiplier of fontSize            |
| `letterSpacing`  | Space between characters in logical pixels         |
| `wordSpacing`    | Space between words                               |
| `fontStyle`      | Normal or italic                                  |
| `decoration`     | Underline, strikethrough, overline                |
| `color`          | Text color (usually set via theme, not per-style) |

### Customization Constraints -- Stay Close to the Base

You **can** vary any of these properties per token, but the M3 defaults are carefully calibrated for readability, rhythm, and component compatibility. Straying too far introduces risk:

**Safe to change freely:**
- **Font family** -- swap in your brand typeface globally. This is the most common and lowest-risk customization.
- **Letter spacing** -- minor adjustments (+/-0.5px) to match your typeface's natural spacing.

**Change with care -- stay similar to the base values:**
- **Font weight** -- you can increase emphasis (e.g., making `titleMedium` semibold instead of medium), but avoid making body text bold or labels light. The base uses only Regular (400) and Medium (500) -- staying within 400-600 is safest.
- **Font size** -- small adjustments (+/-1-2px) are usually fine, but larger changes affect component sizing, touch targets, and layout. If you increase `bodyMedium` from 14 to 16, every component that uses it will grow.
- **Line height** -- must stay proportional to size. The base ratio is roughly 1.2-1.5x. Compressing line height hurts readability; expanding it wastes space.

**Avoid unless you have a strong reason:**
- **Font style** (italic) -- the base uses no italics at all. Adding italics to a role changes its voice significantly.
- **Decoration** (underline, strikethrough) -- these are situational; baking them into a theme role is almost never right.

### The Principle

> **The best custom type scales feel like they *could* be M3 defaults -- just with your brand's typeface.** Sizes, weights, and spacing should stay in the neighborhood of the base values. If a custom style would look out of place next to the other 14 defaults, it's probably too far from the system.

### Recommended approach

1. Start from the M3 defaults in the table above
2. Replace the default font with your brand font
3. Adjust letter spacing to compensate for your font's natural metrics (some fonts run tighter or looser)
4. If your font has different optical weights, remap: e.g., if your font's "Medium" looks as heavy as Roboto's "Bold," use a lighter weight
5. Keep the 15-token structure intact -- don't add or remove roles
6. Test at minimum (0.85x) and maximum (2.0x) system font scale settings
7. Verify that components (buttons, chips, app bars, dialogs) still look correct with your customized styles

---

## Quick Reference -- All 15 Tokens

```
DISPLAY   "Look at this"     57 . 45 . 36    Regular
HEADLINE  "New section"      32 . 28 . 24    Regular
TITLE     "This is called"   22 . 16 . 14    Regular / Medium
BODY      "Read this"        16 . 14 . 12    Regular
LABEL     "Tap / note this"  14 . 12 . 11    Medium
```

---

## Designer Checklist

- [ ] Choose a primary font family; optionally a secondary for Display styles
- [ ] Maintain the 5-role x 3-size structure (15 styles total)
- [ ] Spec every style with: family, size, weight, line height, letter spacing
- [ ] Keep size and weight values close to the M3 defaults -- deviate only with intent
- [ ] Verify readability at `bodySmall` (12px) -- this is your minimum legible size
- [ ] Ensure button text (`labelLarge`) meets touch target guidelines (48dp tap area)
- [ ] Test with dynamic type / accessibility scaling enabled
- [ ] Use semantic token names in Figma (e.g., "Title/Medium" not "Roboto 16 Medium")
- [ ] If customizing weights: stay within 400-600 range for most roles
- [ ] If customizing sizes: verify component layout doesn't break at new sizes

---

## Resources

- [M3 Typography Spec](https://m3.material.io/styles/typography/type-scale-tokens) -- Official type scale tokens
- [Flutter TextTheme API](https://api.flutter.dev/flutter/material/TextTheme-class.html) -- All 15 text style properties
- [Material 3 Design Kit (Figma)](https://www.figma.com/community/file/1035203688168086460) -- Official Figma components
- [Google Fonts](https://fonts.google.com/) -- Free brand-compatible typefaces
