# Rule: Report AI Gaps

When AI fails at a task or produces bad results that require significant manual work, you must report it and create a skill so it never happens again.

## Why

If you spend 4 hours fixing what AI couldn't do, and you don't report it, the next developer will waste the same 4 hours. Multiplied across 14 developers and 6 projects, silent AI failures cost the company weeks of wasted time.

## What to do

1. Finish your task (however needed)
2. Create a Jira ticket in IMP with label `ai-gap`
3. Create a Claude Code skill that teaches AI to handle this type of task
4. Test the skill on a similar case
5. Submit a PR with the skill, assign to CEO
6. Max 1 hour on skill creation -- submit what you have, CEO refines

## When this applies

- AI generated broken or wrong code that took more than 30 minutes to fix
- AI couldn't understand a task type at all (e.g., complex animations, specific API integrations)
- AI kept making the same mistake despite corrections
- You found a pattern or library that AI doesn't know about but should

## When this does NOT apply

- AI made a minor mistake you fixed in 5 minutes (normal)
- The task was genuinely novel with no repeatable pattern
- You didn't try AI first (always try AI first)

## See also

Full pipeline details: processes/ai-gap-pipeline.md
