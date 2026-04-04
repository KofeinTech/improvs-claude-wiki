# AI Problem Resolution Pipeline

When AI can't do something well, that friction must not be wasted. Every AI failure is an opportunity to make the whole team better.

**Rule: solve it once, skill it, share it.**

## The pipeline

```
You hit an AI limitation
    |
    v
[1] SOLVE -- finish the task (manually, research, ask for help)
    |
    v
[2] REPORT -- create Jira ticket in IMP, label "ai-gap"
    What was the task, what AI couldn't do, how you solved it, time wasted
    |
    v
[3] SKILL IT -- create a .md skill file that teaches AI to handle this next time
    Test it on a similar case
    |
    v
[4] SUBMIT -- PR to improvs-claude-wiki with the skill + catalog entry
    Assign to CEO
    |
    v
[5] CEO REVIEWS -- tests, refines, adds to private repo, deploys to all projects
    |
    v
[6] SHARED -- skill in catalog, announced to team, problem never repeats
```

## Jira ticket template (IMP project, label: "ai-gap")

**Title:** `[AI-GAP] <short description>`

**Fields:**
- What was the task
- What AI couldn't do (specific limitation)
- How you solved it (approach, libraries, patterns)
- Time impact (how long it took vs expected)
- Skill created: Yes / No (link to PR if yes)

## Rules

1. **Never just solve and forget.** If AI failed at something others might face, create an ai-gap ticket. Not optional.
2. **Create a skill if possible.** Even a simple "when doing X, use this approach" helps.
3. **Test the skill.** Verify on a similar (not identical) case before submitting.
4. **Timebox to 1 hour.** Max 1 hour on skill creation. Submit what you have, CEO refines the rest.
5. **Don't fix AI failures silently.** If you wasted 4 hours and don't report it, the next developer will waste the same 4 hours.

## Examples

| AI Gap | Skill | Time saved per dev |
|--------|-------|--------------------|
| Broken Lottie animations with complex morphing | `/animation` -- Lottie + rive patterns | 4+ hours |
| Wrong FCM setup for iOS | `/push-ios` -- complete APNs + entitlements config | 2+ hours |
| Bad Riverpod patterns for paginated lists | `/pagination` -- AsyncNotifier + infinite scroll | 2+ hours |
| Can't generate App Store Connect API integration | `/appstore-api` -- JWT auth + build submission | 3+ hours |
