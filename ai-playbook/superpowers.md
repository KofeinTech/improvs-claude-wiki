# Superpowers

Superpowers is a third-party Claude plugin (from `claude-plugins-official`) that adds structured workflow skills: brainstorming, planning, TDD discipline, code review. It's installed automatically by `setup-developer.sh`.

You will see Claude run superpowers skills because **`/start` invokes them automatically** for non-trivial tasks. This page is a quick primer so you know what's happening when they activate.

## When does it activate

`/start` classifies your Jira ticket and routes execution:

| Complexity | What you'll see |
|---|---|
| **Trivial** -- 1 file, cosmetic/text/config change | Nothing. Direct edit. |
| **Simple** -- 1-2 files, single layer, 1-3 AC | TDD cycle: failing test first, then minimal code, then refactor |
| **Complex** -- 3+ files OR multi-layer OR 4+ AC | Brainstorming session (one question at a time), then a written design doc, then a written task plan, then execution |

There is no yes/no prompt -- the classification is the decision. If you disagree the moment you see the classification block, just say *"this is actually simple, skip brainstorming"* and Claude will switch tracks.

## What the complex flow looks like

When `/start` decides a task is Complex, you'll see roughly this:

1. **Brainstorming** -- Claude asks you clarifying questions one at a time, presents 2-3 alternative approaches, picks one with you, then writes a design doc to `docs/superpowers/specs/`.
2. **Planning** -- Claude turns the design into a bite-sized task list (one file at a time, exact code, TDD steps) saved to `docs/superpowers/plans/`.
3. **Execution** -- Claude works through the plan task by task, with verification steps. You review between tasks.

This is more ceremony than you may be used to. It exists because complex tasks fail more often from misunderstood requirements than from bad code -- the 10-minute brainstorm prevents the 4-hour rebuild.

## Why brainstorming doesn't auto-fire on every task

By default, superpowers tries to brainstorm before *any* code-change request, even fix-this-typo. That's overkill. An Improvs rule in `global-rules.md` disarms the auto-fire, so only `/start` (with its complexity classification) decides when brainstorming runs.

If you want brainstorming for something that isn't a Jira task -- say, thinking through an approach before writing the ticket -- just ask Claude explicitly: *"Use the superpowers brainstorming skill to help me think through this."* The override only suppresses **automatic** invocation; explicit invocation always works.

## Escape hatches when superpowers is wrong

- **Wrong complexity classification.** Say *"this is actually simple, skip brainstorming"* the moment `/start` prints the Mode line. Claude switches tracks.
- **Brainstorming is dragging on.** Say *"you have enough context, present the design now."*
- **Plan is overengineered.** Say *"simplify this plan to 3 tasks."*

What not to do: don't try to bypass TDD on simple tasks. The discipline IS the value -- if you skip the failing-test step you lose the protection that the test catches what you think it catches.

## Related

- [Skills Reference](skills.md) -- the Improvs `/start`, `/review`, `/test` slash commands
- [Getting Started](getting-started.md) -- first session walkthrough
