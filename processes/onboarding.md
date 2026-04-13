# Onboarding

Checklist for new team members at Improvs. CEO drives onboarding. HR creates accounts.

## Day 1: Accounts and access

- [ ] Google Workspace account created (@improvs.com email)
- [ ] Added to GitHub organization `improvs` with correct team (`mobile`, `backend`, `qa`, `design`)
- [ ] Added to Jira Cloud (improvs.atlassian.net) with access to assigned project(s)
- [ ] Claude Code license provisioned (Premium for devs/QA, Standard for PM/HR)
- [ ] Added to Figma team (if designer or needs design access)
- [ ] Added to relevant Telegram groups (project chat, general)

## Day 1: Tools setup

- [ ] Run the [setup script](../setup-developer.sh) -- installs Claude Code, logs you into the org, sets up Jira/GitHub MCPs, installs superpowers plugin, and verifies all connections
- [ ] Install Docker Desktop / OrbStack (backend projects only -- Python and .NET run in containers)
- [ ] Clone assigned project repo(s)
- [ ] Read the project's `CLAUDE.md` -- it lists the actual run/test/build commands for that stack
- [ ] Open `claude` in the project dir and type `/mcp` to verify Jira / GitHub / Figma are connected

## Day 2: Read the wiki

- [ ] Read [Getting Started with Claude Code](../ai-playbook/getting-started.md)
- [ ] Read [Developer Rules](../developer-rules/) (single page, all 11 rules)
- [ ] Read [Git Workflow](../engineering/git-workflow.md)
- [ ] Read coding standards for your stack ([Flutter](../engineering/coding-standards/flutter-dart.md), [C#](../engineering/coding-standards/backend-csharp.md), or [Python](../engineering/coding-standards/backend-python.md))

## Day 3-4: First task (paired)

- [ ] CEO assigns a small Jira ticket (bug fix or minor feature, 1-2 hours)
- [ ] Work through it using the full workflow: branch, Claude Code, plan, implement, test, PR
- [ ] CEO reviews the PR and gives feedback on process compliance
- [ ] Discuss: what was confusing? What needs clarification?

## Day 5: Independent work

- [ ] Pick next Jira ticket independently
- [ ] Complete the full workflow without pairing
- [ ] CEO available for questions but not driving

## For designers

Replace the tools/code steps with:
- [ ] Read [Figma Structure](../design/figma-structure.md) rules
- [ ] Read [Design System](../design/design-system.md)
- [ ] Read [Handoff Process](../design/handoff-process.md)
- [ ] Review an existing project's Figma file as reference
- [ ] First task: create or update one screen following all rules

## Onboarding owner

CEO is responsible for onboarding. HR handles account creation. PM ensures the new person has Jira tickets ready for Day 3.
