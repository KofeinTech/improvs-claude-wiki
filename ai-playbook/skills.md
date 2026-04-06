# Skills Reference

Skills are slash commands in Claude Code that automate common workflows. Type `/skill-name` in Claude Code to run them.

Skills are deployed to your Claude Code automatically via the Improvs organization. If a skill is missing, contact your manager.

## For Developers

### Daily workflow

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/start](skills/workflow/start.md) | Read Jira ticket, evaluate complexity, create branch, route to TDD or full pipeline. For Bug tickets, also runs an investigation step before classifying. | Starting any new task -- features, bugs, refactors, everything |
| [/finish](skills/workflow/finish.md) | Auto-runs /review and /test, push, create PR, update Jira | Done coding, ready for PR |
| [/hotfix](skills/workflow/hotfix.md) | Emergency fix -- branch from main, PRs to main + develop | Production is broken right now |

### Quality

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/review](skills/quality/review.md) | Hard-block secrets, dispatch superpowers reviewer with Jira AC + project rules, verify AC coverage | Before commit (also auto-run by /finish) |
| [/test](skills/quality/test.md) | Dispatch independent test subagent that writes tests from AC, not from implementation | Before /finish (also auto-run by /finish) |
| [/figma-check](skills/quality/figma-check.md) | Verify UI matches Figma design, snap to design tokens, flag designer inconsistencies | After building a screen |

### Project setup

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/onboard](skills/setup/onboard.md) | Project briefing -- codebase, sprint, team | First time on a project |
| [/docker-init](skills/setup/docker-init.md) | Generate Dockerfile + docker-compose | Setting up Docker |
| [/docs](skills/setup/docs.md) | Generate README, API docs, architecture docs | Docs needed |

## For PMs

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/create-feature](skills/pm/create-feature.md) | Guided Jira feature ticket with AC and scope | New feature idea or requirement |
| [/create-bug](skills/pm/create-bug.md) | Structured Jira bug report with repro steps | Bug found, needs a ticket |
| [/health-check](skills/pm/health-check.md) | Audit Jira board + GitHub for stuck work, inconsistencies | Daily morning check or weekly review |
| [/client-report](skills/pm/client-report.md) | Weekly progress report from Jira + GitHub data | End of week, before client update |
| [/onboard](skills/setup/onboard.md) | Project briefing (PM mode -- team, client, deadlines) | First time managing a project |

## Common flows

| Scenario | Skills |
|----------|--------|
| New feature | `/start PINK-42` -> code -> `/finish` |
| Bug fix | `/start PINK-55` -> Claude investigates and routes to TDD -> `/finish` |
| Trivial fix (typo, color, config) | `/start PINK-50` -> Claude classifies as trivial, auto-skips ceremony -> `/finish` |
| Production emergency | `/hotfix PINK-99` (all-in-one, branches from main) |
| Review your own work before commit | `/review` |
| PM creates work | `/create-feature PINK` or `/create-bug PINK` |
| New on a project | `/onboard PINK` |
| Morning health check | `/health-check PINK` |

## How to use

1. Open Claude Code in your project directory
2. Type the skill command: `/start PINK-42`
3. Follow the prompts -- Claude asks questions if anything is unclear

## Related

- [Best Practices](best-practices.md) -- how to work effectively with Claude Code
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user features
- [Developer Rules](../developer-rules/) -- all 11 rules
