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

For anything that touches multiple files or requires architectural decisions:

```
> /plan Add a caching layer for API responses
```

Claude explores the codebase, considers approaches, and presents a plan before writing any code. This is especially useful when you're not sure about the best approach.

## Review as Claude works

Don't wait until Claude finishes. Read files as they're created. Catch mistakes early. If Claude is going in the wrong direction, interrupt and correct:

```
> Stop. Don't use SharedPreferences for this. Use Hive instead, we already have it as a dependency.
```

## Use existing patterns

Point Claude to existing code to follow established patterns:

```
> Create a new feature module for notifications. Follow the same structure as lib/features/profile/
```

## Manage context

- Start a fresh session for each task
- Don't carry context from one task to another
- If a session gets long and Claude seems confused, start fresh
- Use `/compact` to summarize long sessions without losing context

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
