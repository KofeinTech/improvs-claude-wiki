# Skills Reference

Skills are slash commands that automate common workflows. Improvs skills are split across two surfaces:

- **Claude Code CLI** (developers) -- delivered via the `improvs` plugin. Invoked as `/improvs:<skill>`. Auto-installed on every dev's machine via org managed settings.
- **claude.ai web** (PMs, CEO) -- delivered via Organization Skills in the admin console. Invoked as `/create-feature`, `/create-bug`, etc.

## For Developers (Claude Code CLI)

All developer skills are namespaced under the `improvs` plugin. Type `/improvs:` to see them.

### Daily workflow

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/improvs:start](skills/workflow/start.md) | Read Jira ticket, evaluate complexity, create branch, route to TDD or full pipeline. Handles bugs (investigation), hotfixes (branches from main), and features. | Starting any task -- features, bugs, hotfixes, everything |
| [/improvs:finish](skills/workflow/finish.md) | Auto-runs /review and /test, push, create PR, update Jira. For hotfixes: dual PRs to main + develop. | Done coding, ready for PR |

### Quality

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/improvs:review](skills/quality/review.md) | Hard-block secrets, dispatch superpowers reviewer with Jira AC + project rules, verify AC coverage | Before commit (also auto-run by /finish) |
| [/improvs:test](skills/quality/test.md) | Dispatch independent test subagent that writes tests from AC, not from implementation | Before /finish (also auto-run by /finish) |
| [/improvs:figma-export](skills/quality/figma-export.md) | Export Figma design to local JSON + SVG assets in `design/` folder via REST API | Before building a UI screen |
| [/improvs:figma-check](skills/quality/figma-check.md) | Verify UI matches Figma design (from local `design/` export), snap to design tokens, flag designer inconsistencies | After building a screen |

### Project setup

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/improvs:onboard](skills/setup/onboard.md) | Project briefing -- codebase, sprint, team | First time on a project |
| [/improvs:docker-init](skills/setup/docker-init.md) | Generate Dockerfile + docker-compose | Setting up Docker |
| [/improvs:docs](skills/setup/docs.md) | Generate README, API docs, architecture docs | Docs needed |

## For PMs (claude.ai web)

These skills are available in the claude.ai web interface, not in Claude Code CLI.

| Skill | What it does | When to use |
|-------|-------------|-------------|
| [/create-feature](skills/pm/create-feature.md) | Guided Jira feature ticket with AC and scope | New feature idea or requirement |
| [/create-bug](skills/pm/create-bug.md) | Structured Jira bug report with repro steps | Bug found, needs a ticket |
| [/health-check](skills/pm/health-check.md) | Audit Jira board + GitHub for stuck work, inconsistencies | Daily morning check or weekly review |
| [/client-report](skills/pm/client-report.md) | Weekly progress report from Jira + GitHub data | End of week, before client update |
| [/improvs:onboard](skills/setup/onboard.md) | Project briefing (PM mode -- team, client, deadlines) | First time managing a project |

## Common flows

| Scenario | Skills |
|----------|--------|
| New UI screen | `/improvs:figma-export <URL>` -> `/improvs:start PINK-42` -> code -> `/improvs:figma-check` -> `/improvs:finish` |
| New feature | `/improvs:start PINK-42` -> code -> `/improvs:finish` |
| Bug fix | `/improvs:start PINK-55` -> Claude investigates and routes to TDD -> `/improvs:finish` |
| Trivial fix (typo, color, config) | `/improvs:start PINK-50` -> Claude classifies as trivial, auto-skips ceremony -> `/improvs:finish` |
| Production emergency | `/improvs:start PINK-99` -> auto-detects Critical priority, branches from main -> `/improvs:finish` creates dual PRs |
| Review your own work before commit | `/improvs:review` |
| PM creates work | `/create-feature PINK` or `/create-bug PINK` (on claude.ai web) |
| New on a project | `/improvs:onboard PINK` |
| Morning health check | `/health-check PINK` (on claude.ai web) |

## How skills are deployed

**CLI skills** are packaged as a plugin in the public repo [KofeinTech/claude-plugins](https://github.com/KofeinTech/claude-plugins). Org managed settings auto-register the marketplace and enable the plugin for every developer. Updates happen automatically when the plugin repo is updated.

**Web skills** are uploaded as ZIPs to the claude.ai admin console (Organization Settings > Skills). Only admins can update them.

## How to use

1. Open Claude Code in your project directory
2. Type the skill command: `/improvs:start PINK-42`
3. Follow the prompts -- Claude asks questions if anything is unclear

## Troubleshooting

If skills are missing, see the [setup troubleshooting](claude-code-setup.md#troubleshooting) section.

## Related

- [Best Practices](best-practices.md) -- how to work effectively with Claude Code
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user features
- [Developer Rules](../developer-rules/) -- all 11 rules
