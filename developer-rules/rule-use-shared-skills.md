# Rule: Use Shared Skills

Before writing a custom prompt, check if a shared skill already exists for your task.

## Why

Shared skills are tested, refined prompts that produce consistent results across the team. Writing your own prompt from scratch means you might miss steps, produce inconsistent output, or waste time on something that's already solved.

## Available skills

Check the skills catalog: `ai-playbook/skills-catalog.md`

Common ones:
- `/feature` -- plan and implement a feature from a Jira ticket
- `/test` -- generate tests for existing code
- `/review` -- review code for quality and issues
- `/debug` -- systematic debugging workflow
- `/start` and `/finish` -- start/stop work on a Jira ticket with time logging
- `/figma` -- read Figma designs and implement UI

## What to do

1. Check the skills catalog before starting any task
2. If a skill exists, use it
3. If no skill exists and you think one should, mention it in Telegram or create an `ai-gap` ticket
