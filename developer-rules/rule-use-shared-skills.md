# Rule: Use Shared Skills

Before writing a custom prompt, check if a shared skill already exists for your task.

## Why

Shared skills are tested, refined prompts that produce consistent results across the team. Writing your own prompt from scratch means you might miss steps, produce inconsistent output, or waste time on something that's already solved.

## Available skills

Skills are being built out. Currently available:
- `/client-report` -- generate branded weekly client progress report

Planned (coming soon):
- `/feature` -- plan and implement a feature from a Jira ticket
- `/test` -- generate tests for existing code
- `/review` -- review code for quality and issues
- `/start` and `/finish` -- start/stop work on a Jira ticket with time logging
- `/figma` -- read Figma designs and implement UI

Check the [Prompt Library](../ai-playbook/prompt-library.md) for ready-to-use prompts that cover similar use cases until skills are available.

## What to do

1. Check if a shared skill exists before writing a custom prompt
2. If a skill exists, use it
3. If no skill exists, check the [Prompt Library](../ai-playbook/prompt-library.md) for a ready-made prompt
4. If you solve something new and reusable, create an `ai-gap` ticket so it can become a skill
