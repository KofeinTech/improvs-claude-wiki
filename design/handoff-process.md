# Handoff Process

How designers hand off work to developers at Improvs.

## Overview

```
Designer finishes screen  -->  Marks "Ready for dev"  -->  Shares Figma link
         |                                                        |
Developer receives link   -->  Opens Claude Code      -->  Generates Flutter code
         |                                                        |
Developer reviews output  -->  Refines & tests        -->  Commits
```

## Designer checklist (before handoff)

Complete this checklist before marking a frame as "Ready for dev":

- [ ] Frame size is 393 x 852 px
- [ ] All frames use Auto Layout
- [ ] All layers have descriptive names (no "Frame 42" or "Rectangle 1")
- [ ] All colors use Figma Variables
- [ ] All text uses defined Text Styles
- [ ] All spacing values from the spacing scale
- [ ] Reusable elements are Components with variants
- [ ] All screen states designed (default, empty, loading, error)
- [ ] Dark mode verified (if applicable)
- [ ] Interactive states shown (hover, pressed, focused)
- [ ] Touch targets are 48x48 px minimum
- [ ] Contrast ratios pass (4.5:1 for regular text)
- [ ] Icons are SVG, outlined, single path
- [ ] Hidden and unused layers removed
- [ ] Animations/transitions annotated in comments

## How to mark ready

1. Select the frame in Figma
2. Right panel > Design tab > Section dropdown > "Ready for development"
3. Share the Figma link with the developer

## How to share

1. Click **Share** (top right) > enter developer's email > set to "Can view"
2. Developer opens the file and switches to **Dev Mode** (Shift + D)
3. Right-click the frame > **Copy link to selection** > send to developer

## Developer workflow

1. Receive the Figma link from designer (via Telegram or Jira ticket)
2. Open Claude Code in the project directory
3. Describe the task and paste the Figma link:

```
Build the settings screen from this Figma design:
[Figma URL]

Follow the feature structure in lib/features/.
Use design tokens from lib/core/theme/.
```

4. Claude reads the design via Figma MCP and generates code
5. Review the output: compare running app against Figma
6. Fix mismatches, add business logic, write tests
7. Commit and create PR

## What developers can access in Figma Dev Mode

| Property | Where to find it |
|----------|-----------------|
| Dimensions (width, height) | Inspect panel |
| Spacing (padding, gaps, margins) | Auto Layout properties |
| Colors (hex + opacity) | Figma Variables |
| Typography (font, size, weight, line-height) | Text Styles |
| Shadows (offset, blur, spread, color) | Effect Styles |
| Border radius | Variables or inspect panel |
| Assets (icons, images) | Export settings (SVG for icons, PNG for images) |

## When designs are unclear

Don't guess. Ask the designer to clarify:
- Ambiguous spacing or alignment
- Missing screen states
- Unclear animation or transition behavior
- Colors that don't match the design token set

Add clarity notes to the Jira ticket so future developers don't hit the same question.
