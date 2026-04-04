# Design System

Shared design tokens, themes, and component library structure for Improvs projects.

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

### Required color tokens

| Token | Purpose |
|-------|---------|
| primary | Main brand color, CTA buttons |
| secondary | Supporting accent color |
| background | Screen backgrounds |
| surface | Card and container backgrounds |
| error | Error states, destructive actions |
| text-primary | Main text color |
| text-secondary | Helper text, subtitles |
| text-on-primary | Text on primary-colored backgrounds |
| divider | Lines, separators |

All colors must be defined as Figma Variables. No hardcoded hex values in designs.

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

Define text styles for every use case:

| Style | Typical values |
|-------|---------------|
| Heading / H1 | 24-32px, bold |
| Heading / H2 | 20-24px, semibold |
| Heading / H3 | 18-20px, semibold |
| Body / Regular | 14-16px, regular |
| Body / Bold | 14-16px, bold |
| Caption | 12px, regular |
| Button | 14-16px, medium/semibold |

Each style defines: font family, weight, size, line height, letter spacing.

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
  colorScheme: ColorScheme.light(
    primary: Color(0xFF0066CC),
    secondary: Color(0xFF...),
    surface: Color(0xFF...),
    error: Color(0xFF...),
  ),
  textTheme: TextTheme(
    headlineLarge: TextStyle(...),   // H1
    headlineMedium: TextStyle(...),  // H2
    bodyLarge: TextStyle(...),       // Body
    bodySmall: TextStyle(...),       // Caption
  ),
);
```

Never use hardcoded colors or font sizes in widgets. Always reference `Theme.of(context)`.
