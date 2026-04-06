# Best Practices for Claude Code

How to get the most out of AI-assisted development.

## Start with a plan

Before writing code, ask Claude to plan:

```
> I need to add push notifications. Create a plan first.
```

Review the plan. Adjust it. Only then approve implementation. This prevents wasted work and catches architectural mistakes early.

## Keep tasks small

One task = one Claude Code session. Break features into 1-4 hour chunks. Large tasks exhaust the context window and produce harder-to-review code.

**Bad:** "Implement the entire authentication system"
**Good:** "Add the login API endpoint with JWT token generation"

## Be specific in your prompts

The more context you provide, the better the output.

**Vague:** "Fix the bug"
**Specific:** "The user list doesn't refresh after deleting a user. The delete API call succeeds but the Riverpod provider isn't invalidated. Fix the state management in user_list_provider.dart"

## Use plan mode for complex tasks

For anything that touches multiple files or requires architectural decisions, press `Shift+Tab` to switch to plan mode. Claude explores the codebase, considers approaches, and presents a plan before writing any code. Press `Shift+Tab` again to switch back to code mode when you're ready to implement.

## Interrupt early, correct often

Don't wait until Claude finishes if it's going the wrong direction. Interrupt and correct:

- **Press `Escape`** to stop Claude mid-response
- **Type your correction** and Claude adjusts immediately
- Cheaper to interrupt and redirect than to let it finish and undo

```
> Stop. Don't use SharedPreferences for this. Use Hive instead, we already have it as a dependency.
```

Read files as they're created. Catch mistakes early.

## Use existing patterns

Point Claude to existing code to follow established patterns:

```
> Create a new feature module for notifications. Follow the same structure as lib/features/profile/
```

## Manage context

- Start a fresh session for each task -- don't carry context between tasks
- If a session gets long and Claude seems confused, use `/compact` to summarize without losing context
- Use `/clear` to wipe the conversation and start fresh within the same session
- Point Claude to files instead of pasting code: "read lib/features/auth/auth_provider.dart"

## Useful keyboard shortcuts

| Shortcut | What it does |
|----------|-------------|
| `Escape` | Stop Claude mid-response |
| `Shift+Tab` | Toggle plan mode (think before code) |
| `Shift+Enter` | Accept and allow similar actions for the rest of the session |
| `!` + command | Run a shell command directly (e.g., `! flutter pub get`) |

## When AI gets stuck

If Claude can't solve something after 2-3 attempts:

1. Solve it yourself or with a colleague
2. Create an ai-gap Jira ticket (see [AI Gap Pipeline](../processes/ai-gap-pipeline.md))
3. Consider creating a skill so the next developer doesn't hit the same wall

## Don't do these

- Don't let Claude auto-commit -- always review the diff yourself
- Don't skip reading generated tests -- they may test the wrong thing
- Don't use Claude for tasks you don't understand -- you can't review what you don't understand
- Don't paste secrets or API keys into prompts

## Related

- [Getting Started](getting-started.md) -- first steps with Claude Code
- [Tips and Tricks](tips-and-tricks.md) -- plan mode, permissions, context management
- [Developer Rules](../developer-rules/) -- all 11 rules on one page
