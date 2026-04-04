# Rule: Commit Only Yourself

Never let Claude auto-commit. Always read every line of the diff before committing.

## Why

You are responsible for everything you commit. AI can introduce subtle bugs, security issues, or unnecessary changes that look correct at first glance. A reviewer trusts that you verified the code -- if you didn't, defects slip through.

## What to do

1. Let Claude generate the code
2. Review every changed line in the diff
3. Understand what each change does and why
4. Only then run `git commit`

## Red flags to watch for

- Code you don't understand
- Changes to files you didn't ask to be changed
- Unnecessary refactoring mixed with your feature
- Hardcoded values, missing error handling, or security shortcuts
- Dependencies added without clear reason
