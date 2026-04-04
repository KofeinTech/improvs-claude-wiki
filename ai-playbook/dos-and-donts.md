# Dos and Don'ts

Quick reference for working with Claude Code at Improvs.

## Do

| Do | Why |
|----|-----|
| Review every line before committing | AI can introduce subtle bugs, security issues, or unnecessary complexity |
| Break tasks into 1-4 hour pieces | Small tasks produce better AI output and easier-to-review PRs |
| Create a plan before implementing | Prevents wasted work, catches architecture mistakes early |
| Start a fresh session for each task | Prevents context confusion between unrelated tasks |
| Point Claude to existing code as reference | "Follow the pattern in lib/features/profile/" produces consistent code |
| Run `flutter test` and `flutter analyze` before PRs | Hooks enforce this, but run manually too -- don't waste CI time |
| Report AI failures as ai-gap tickets | Your struggle today prevents someone else's struggle tomorrow |
| Use shared skills before writing custom prompts | Check the skills catalog -- someone may have solved this already |
| Log time on every Jira ticket | Essential for estimation accuracy and client billing |
| Commit only yourself, never auto-commit | You are responsible for every line in your commits |

## Don't

| Don't | Why |
|-------|-----|
| Auto-commit or let Claude commit for you | You are accountable for what enters the codebase |
| Use Claude for tasks you don't understand | You can't review what you can't comprehend |
| Carry context between tasks | Stale context causes Claude to make wrong assumptions |
| Paste secrets or API keys into prompts | Prompts may be logged; use environment variables |
| Trust AI-generated tests blindly | Tests can look correct but test the wrong thing -- always read them |
| Force push (ever) | Hooks block this. Rewrite history = lost work |
| Mix multiple Jira tickets in one branch | One ticket = one branch = one PR. Keep changes isolated |
| Skip the plan step for complex tasks | "Just implement it" leads to rework |
| Ignore flutter analyze warnings | Zero warnings is the standard, hooks enforce it |
| Work without a Jira ticket | If it's not in Jira, it doesn't exist |

## When in doubt

- **Not sure about the approach?** Use plan mode: `/plan`
- **AI can't do it?** Solve manually, then file an ai-gap ticket
- **Need help?** Ask in the project Telegram chat, then document the answer in Jira or wiki
