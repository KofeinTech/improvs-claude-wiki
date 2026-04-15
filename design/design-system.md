# Design System

Shared design tokens, themes, and component library structure for Improvs projects. Built on Material 3.

## Detailed references

| Reference | Description |
|-----------|-------------|
| [Color Scheme](color-scheme.md) | All 46 M3 color roles, surface hierarchy, text-color pairings, custom extensions |
| [Text Theme](text-theme.md) | All 15 M3 text styles, semantic roles, customization constraints |

## Design token hierarchy

Tokens are organized in 3 layers:

```
Primitive tokens (raw values):
  color.blue.500: #0066CC
  color.gray.100: #F7F8FA
  spacing.4: 4
  spacing.8: 8

Semantic tokens (purpose-based, reference primitives):
  color.primary: {color.blue.500}
  color.background: {color.gray.100}
  spacing.xs: {spacing.4}
  spacing.sm: {spacing.8}

Component tokens (component-specific, reference semantic):
  button.background: {color.primary}
  button.padding: {spacing.sm}
  card.radius: 12
```

Designers define these in Figma Variables. Developers mirror them in Flutter's `ThemeData`.

## Color system

Material 3 defines **46 semantic color roles** organized into accent groups (Primary, Secondary, Tertiary), error, surface hierarchy, and utility roles.

See [Color Scheme reference](color-scheme.md) for full token list, semantic meanings, and usage rules.

Key principles:
- Define colors by **role** (what the color does), not by hex value
- Generate palettes from a seed color using `ColorScheme.fromSeed()`
- Every `on{X}` / `{X}` pairing must meet **4.5:1** contrast ratio (WCAG AA)
- Never hardcode hex values in designs or code -- always reference token names
- Use `surfaceContainer*` levels for depth instead of arbitrary grays

## Spacing scale

8pt grid. All spacing values come from this scale:

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Tight spacing between related elements |
| sm | 8px | Default gap between items |
| md | 16px | Section padding, card padding |
| lg | 24px | Section margins |
| xl | 32px | Large section separators |
| 2xl | 48px | Page-level spacing |

## Typography

Material 3 defines **15 text styles** organized into 5 semantic roles (Display, Headline, Title, Body, Label) x 3 sizes (Large, Medium, Small).

See [Text Theme reference](text-theme.md) for full token list, default values, and customization rules.

Key principles:
- Use semantic token names (e.g., "Title/Medium" not "Roboto 16 Medium")
- Keep size and weight values close to M3 defaults -- deviate only with intent
- Stay within 400-600 font weight range for most roles
- Verify readability at `bodySmall` (12px) -- minimum legible size

## Themes

Every project supports light and dark themes:

- Same token names in both themes, different values
- Use Figma variable modes to switch
- Test every screen in both modes
- Ensure text contrast: regular text 4.5:1 minimum, large text 3:1 minimum

## In Flutter

Tokens map to Flutter's `ThemeData`:

```dart
// lib/core/theme/app_theme.dart
final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF0066CC),
    // Override specific roles as needed:
    // secondary: Color(0xFF...),
    // error: Color(0xFF...),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(...),
    headlineMedium: TextStyle(...),
    titleMedium: TextStyle(...),
    bodyLarge: TextStyle(...),
    bodyMedium: TextStyle(...),
    labelLarge: TextStyle(...),
  ),
);
```

For custom color roles beyond the 46 built-in tokens, use `ThemeExtension`. See [Color Scheme reference](color-scheme.md#extending-the-color-system-themeextension).

Never use hardcoded colors or font sizes in widgets. Always reference `Theme.of(context)`.
