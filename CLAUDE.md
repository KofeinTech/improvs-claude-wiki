# Improvs Public Wiki

This repository is the company-wide knowledge base for Improvs.com. It is accessible to every member of the GitHub organization.

## Purpose

Single source of truth for all non-confidential company information: processes, standards, contacts, project docs, AI playbook, and developer rules.

## Audience

All 20 team members: developers, designers, PM, HR, CEO.

## Structure

```
company/          -- org chart, contacts, communication guidelines
engineering/      -- tech stack, git workflow, coding standards, CI/CD
ai-playbook/      -- Claude Code setup, skills catalog, best practices, prompts
projects/         -- overview and knowledge base per project
design/           -- Figma rules, design system, handoff process
processes/        -- onboarding, sprint workflow, definition of done
developer-rules/  -- commit rules, small tasks, plan before code, etc.
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

## How Claude Code should use this repo

When working in any Improvs project, Claude Code can reference this wiki for:
- Coding standards and conventions (engineering/)
- Git workflow and branching rules (engineering/git-workflow.md)
- Developer rules and checklists (developer-rules/)
- Project-specific context (projects/)
- Available shared skills (ai-playbook/skills-catalog.md)
