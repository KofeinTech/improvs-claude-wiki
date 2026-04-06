# Developer Rules

Non-negotiable rules for every developer at Improvs. Read once, follow always.

**AI drafts. You decide. You commit.**

## 1. Commit only yourself

Never let Claude auto-commit. Read every line of the diff. If you don't understand a line, don't commit it. You are responsible for everything in your commits.

## 2. Small tasks

Break work into pieces that take 1-4 hours each. One Jira ticket = one branch = one PR. Large PRs get rubber-stamped; small PRs get real reviews.

## 3. Plan before code

Use `/start` to read the Jira ticket, create a plan, and get confirmation before implementing. For complex tasks, use plan mode (`Shift+Tab`). 15 minutes of planning saves hours of rework.

## 4. One branch per task

Branch naming: `<JIRA-KEY>-<short-description>` (e.g., `PINK-42-add-auth`). Never mix multiple tickets in one branch. Hooks enforce this.

## 5. Fresh context per task

Start a new Claude Code session for each Jira ticket. Old context from a previous task causes Claude to mix up requirements. Use `/clear` if needed.

## 6. Review AI critically

Claude writes confident code that may be wrong. Check: business logic, edge cases (empty/null/concurrent), error handling, security, unnecessary complexity. If you don't understand it, ask Claude to explain or rewrite it simpler.

## 7. Test before PR

Hooks run `flutter analyze` + `flutter test` (or equivalent) before every commit. If you commit outside Claude Code, run them manually. See [Testing with AI](../ai-playbook/testing-with-ai.md).

## 8. Use shared skills

Before writing a custom prompt, check if a skill exists: type `/` in Claude Code. See the full [Skills Reference](../ai-playbook/skills.md).

## 9. Document surprises

If you discover something non-obvious (workaround, API quirk, deployment gotcha), write it in the project's `CLAUDE.md` or the wiki. Knowledge in your head helps nobody.

## 10. Report AI gaps

When AI fails and costs you >30 minutes of manual work: create a Jira ticket with label `ai-gap`, then create a Claude Code skill so the next developer doesn't hit the same wall. See [AI Gap Pipeline](../processes/ai-gap-pipeline.md).

## 11. Communication

Decisions go in Jira ticket comments. Process/architecture goes in the wiki. Telegram is for quick questions only. If someone asks "where was that decided?" the answer should be a Jira link, not "scroll up in Telegram."

## Related

- [Best Practices](../ai-playbook/best-practices.md) -- detailed how-to for working with Claude Code
- [Skills Reference](../ai-playbook/skills.md) -- all /slash-commands
- [Git Workflow](../engineering/git-workflow.md) -- branching, commits, PRs
- [Definition of Done](../processes/definition-of-done.md) -- checklist for completing a task
