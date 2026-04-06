# Skills Reference

Skills are slash commands in Claude Code that automate common workflows. Type `/skill-name` in Claude Code to run them.

Skills are deployed to your Claude Code automatically via the Improvs organization. If a skill is missing, contact your manager.

## For Developers

### Daily workflow

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/start](skills/start.md) | Read Jira ticket, create branch, evaluate complexity, make a plan | Starting any new task |
| [/finish](skills/finish.md) | Review, push, create PR, update Jira | Done coding, ready for PR |
| [/quickfix](skills/quickfix.md) | Lightweight /start for trivial tasks (typo, config) | One-liner fixes |

### Bug fixing

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/bug](skills/bug.md) | Investigate root cause, failing test first, fix | Assigned a bug ticket |
| [/hotfix](skills/hotfix.md) | Emergency fix -- branch from main, PRs to main + develop | Prod is broken right now |

### Quality

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/review](skills/review.md) | Review PR against rules, security, acceptance criteria | Before approving a PR |
| [/test](skills/test.md) | Generate tests from acceptance criteria (independent QA) | Before /finish |
| [/figma-check](skills/figma-check.md) | Verify UI matches Figma design | After building a screen |

### Project setup

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/onboard](skills/onboard.md) | Project briefing -- codebase, sprint, team | First time on a project |
| [/docker-init](skills/docker-init.md) | Generate Dockerfile + docker-compose | Setting up Docker |
| [/docs](skills/docs.md) | Generate README, API docs, architecture docs | Docs needed |

## For PMs

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/create-feature](skills/create-feature.md) | Guided Jira feature ticket with AC and scope | New feature idea or requirement |
| [/create-bug](skills/create-bug.md) | Structured Jira bug report with repro steps | Bug found, needs a ticket |
| [/client-report](skills/client-report.md) | Weekly progress report from Jira + GitHub data | End of week, before client update |
| [/onboard](skills/onboard.md) | Project briefing (PM mode -- team, client, deadlines) | First time managing a project |

## Common flows

| Scenario | Skills |
|----------|--------|
| New feature | `/start PINK-42` -> code -> `/finish` |
| Trivial fix | `/quickfix PINK-50` -> fix -> `/finish` |
| Bug fix | `/bug PINK-55` -> fix -> `/finish` |
| Production emergency | `/hotfix PINK-99` (all-in-one) |
| Review a PR | `/review 47` |
| PM creates work | `/create-feature PINK` or `/create-bug PINK` |
| New on a project | `/onboard PINK` |

## How to use

1. Open Claude Code in your project directory
2. Type the skill command: `/start PINK-42`
3. Follow the prompts -- Claude asks questions if anything is unclear

## Related

- [Best Practices](best-practices.md) -- how to work effectively with Claude Code
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user features
- [Developer Rules](../developer-rules/) -- all 11 rules
