# Getting Started with Claude Code

Claude Code is an AI coding assistant that runs in your terminal. It reads your codebase, writes code, runs tests, and creates commits -- all through natural language conversation.

## Step 0: Set up your machine

Before anything else, run the setup script. It installs Claude Code, connects Jira, GitHub, and Figma, and logs you into the Improvs organization.

```bash
# Download and run the setup script
curl -sO https://raw.githubusercontent.com/KofeinTech/improvs-claude-wiki/main/setup-developer.sh
chmod +x setup-developer.sh
./setup-developer.sh
```

The script guides you through each step interactively -- it opens browser windows for login/token creation and waits for you at each step.

If you prefer to set up manually, see the [Setup Guide](claude-code-setup.md) for step-by-step instructions.

## Why we use it

Improvs is an AI-first company. Every task starts with AI. Manual coding is the fallback, not the default. Claude Code is our primary development tool because:

- It understands the full project context (files, dependencies, architecture)
- It follows our coding standards automatically via org-wide rules
- Quality hooks block bad code before it reaches the repo
- Shared skills standardize common workflows across all projects

## Your first session

1. Open your terminal in a project directory
2. Type `claude` to start a session
3. Describe what you want to build

```
cd ~/code/your-project
claude
> I need to add a logout button to the settings screen
```

Claude reads the codebase, creates a plan, and implements the code. You review every file before committing.

## The workflow

```
1. Open Claude Code in the project directory
2. /start PROJ-42          -- reads Jira ticket, creates branch, makes a plan
3. Review the plan, approve or adjust
4. Claude implements -- review every file as it works
5. YOU commit (never auto-commit)
6. /finish                 -- pushes, creates PR, updates Jira
```

All the manual steps (branch naming, running tests, creating PRs, updating Jira) are handled by the `/start` and `/finish` skills. You focus on reviewing the code.

## Key principles

**AI drafts, you decide.** Claude generates code. You validate business logic, check edge cases, and take responsibility for what gets committed.

**Small tasks only.** Break work into 1-4 hour pieces. One Jira ticket = one branch = one PR. Each task gets its own Claude Code session.

**Never trust blindly.** AI generates plausible-looking code that may be wrong. Always read the diff. Check business logic, security implications, and test coverage.

## Next steps

- Learn [best practices](best-practices.md) for effective prompting
- Browse the [prompt library](prompt-library.md) for ready-to-use prompts
- Check the [skills reference](skills.md) for all available /slash-commands
- Read the [developer rules](../developer-rules/) for commit and review standards

## Related

- [Setup Guide](claude-code-setup.md) -- detailed manual setup and MCP configuration
- [Best Practices](best-practices.md) -- how to prompt effectively
- [Skills Reference](skills.md) -- all available /slash-commands
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, power-user tips
