# Improvs Public Wiki

This repository is the company-wide knowledge base for Improvs.com. It is accessible to every member of the GitHub organization.

## Purpose

Single source of truth for all non-confidential company information: processes, standards, contacts, project docs, AI playbook, and developer rules.

## Audience

All 20 team members: developers, designers, PM, HR, CEO.

## Structure

```
setup-developer.sh  -- onboarding script (installs Claude Code + Jira/GitHub MCPs + Superpowers)

ai-playbook/        -- Claude Code guides and skills reference
  getting-started.md    -- first steps, setup script, workflow overview
  claude-code-setup.md  -- manual setup instructions, MCP configuration
  best-practices.md     -- effective prompting, plan mode, shortcuts
  skills.md             -- full catalog of /slash-commands
  skills/               -- individual skill pages (start, finish, review, write-tests, etc.)
  tips-and-tricks.md    -- plan mode, permissions, power-user features
  prompt-library.md     -- ready-to-use prompts for common tasks
  figma-to-code.md      -- generating Flutter code from Figma designs
  testing-with-ai.md    -- AI-generated tests and hook enforcement

developer-rules/    -- all 11 rules on one page (single README.md)
engineering/        -- tech stack, git workflow, coding standards, code review
processes/          -- onboarding, team workflow (Kanban), Jira workflow, PM guide, incidents
design/             -- Figma rules, design system, handoff process
```

## Rules for this repository

- All content is plain markdown files. No build tools, no SSG, no dependencies.
- Files are read directly on GitHub or cloned locally.
- Anyone in the org can propose changes via PR. Leads review and merge.
- Keep files concise and up to date. Delete outdated content rather than leaving it.
- No secrets, salaries, budgets, or client-confidential information here. That belongs in improvs-claude-private.
- Use English for all documentation to keep it accessible.

## How to contribute

1. Clone the repo or edit on GitHub
2. Create a branch with a descriptive name
3. Add or update the relevant markdown file
4. Open a PR -- leads will review and merge

## Related repositories

- **improvs-claude-private** (CEO/leads only) -- org-level Claude Code config, skills source, hooks, rules, subagents, management runbooks
- **improvs/flutter-template** -- starting point for all new Flutter projects

## How Claude Code should use this repo

When working in any Improvs project, Claude Code can reference this wiki for:
- Coding standards and conventions (engineering/)
- Git workflow and branching rules (engineering/git-workflow.md)
- Developer rules and checklists (developer-rules/)
- AI playbook, skills, and best practices (ai-playbook/)
- Skills documentation and usage (ai-playbook/skills.md)
- Design handoff process (design/)
