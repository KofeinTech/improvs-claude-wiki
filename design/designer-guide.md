# Designer Guide

How designers work within the Improvs AI-first workflow.

## Your role in the pipeline

```
Client request -> You design in Figma -> Developer builds with Claude Code -> You verify
```

Designers don't use Claude Code directly. Your output (Figma files) is consumed by Claude Code via the Figma MCP server. The quality of your Figma file directly affects the quality of generated code.

## What makes a good Figma file for AI

Claude Code reads your Figma files to generate Flutter code. The better your file is structured, the better the code comes out.

| Good | Bad |
|------|-----|
| Auto-layout on every frame | Absolute positioning |
| Semantic names: `SubmitButton` | Default names: `Frame 42` |
| Design tokens for colors/spacing | Hardcoded hex values |
| Component variants for states | Duplicate frames per state |
| All screen states designed | Only happy path |

See [Figma Structure](figma-structure.md) for the full rules and [Design System](design-system.md) for tokens.

## Handoff to developers

1. Complete the [handoff checklist](handoff-process.md) for your frame
2. Mark the frame as "Ready for development" in Figma
3. Share the Figma link in the Jira ticket or Telegram
4. Developer uses Claude Code to read your design and generate code
5. Developer may run `/figma-check` to verify their implementation matches your design

## When developers ask questions

Developers will ask about:
- Ambiguous spacing or alignment
- Missing screen states (error, empty, loading)
- Animation or transition behavior
- Colors that don't match the token set

Answer in the Jira ticket comment (not just Telegram) so the context is preserved.

## Verifying implementations

After a developer builds a screen, you may be asked to verify it matches the design. Compare:
- Spacing and alignment
- Colors and typography
- Component states (hover, pressed, disabled)
- Responsiveness on different screen sizes

Flag issues in the PR or Jira ticket.

## Tools

| Tool | What for |
|------|----------|
| Figma | Design, prototyping, handoff |
| Jira | Track design tasks, see sprint context |
| Telegram | Quick communication with devs |

## Related

- [Figma Structure](figma-structure.md) -- naming, auto-layout, and file organization rules
- [Design System](design-system.md) -- colors, typography, spacing tokens
- [Handoff Process](handoff-process.md) -- checklist for handing off to developers
- [Figma to Code](../ai-playbook/figma-to-code.md) -- how developers use your Figma files
