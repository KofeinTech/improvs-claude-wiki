# Getting Started with Claude Code

Claude Code is an AI coding assistant that runs in your terminal. It reads your codebase, writes code, runs tests, and creates commits -- all through natural language conversation.

## Why we use it

Improvs is an AI-first company. Every task starts with AI. Manual coding is the fallback, not the default. Claude Code is our primary development tool because:

- It understands the full project context (files, dependencies, architecture)
- It follows our coding standards automatically via org-wide rules
- Quality hooks block bad code before it reaches the repo
- Shared skills standardize common workflows across all projects

## Your first session

1. Install Claude Code (see [Setup Guide](claude-code-setup.md))
2. Open your terminal in a project directory
3. Type `claude` to start a session
4. Describe what you want to build

```
cd ~/code/your-project
claude
> I need to add a logout button to the settings screen
```

Claude reads the codebase, creates a plan, and implements the code. You review every file before committing.

## The workflow

```
1. Pick a Jira ticket
2. Create a branch: PROJ-42-short-description
3. Open Claude Code in the project directory
4. Describe the task or use /start PROJ-42
5. Review Claude's plan, approve or adjust
6. Claude implements -- review every file as it works
7. Run tests: flutter test, flutter analyze
8. YOU commit (never auto-commit)
9. Create PR, log time
```

## Key principles

**AI drafts, you decide.** Claude generates code. You validate business logic, check edge cases, and take responsibility for what gets committed.

**Small tasks only.** Break work into 1-4 hour pieces. One Jira ticket = one branch = one PR. Each task gets its own Claude Code session.

**Never trust blindly.** AI generates plausible-looking code that may be wrong. Always read the diff. Check business logic, security implications, and test coverage.

## Next steps

- [Set up Claude Code](claude-code-setup.md) on your machine
- Learn [best practices](best-practices.md) for effective prompting
- Browse the [prompt library](prompt-library.md) for ready-to-use prompts
- Read the [developer rules](../developer-rules/) for commit and review standards
