# Rule: One Branch Per Task

Every Jira ticket gets its own branch and PR. Never mix multiple tickets in one branch.

## Why

Mixed branches make reviews confusing, revert dangerous, and blame useless. If ticket A is fine but ticket B needs changes, you can't merge one without the other. Clean isolation keeps everything reviewable and revertable.

## What to do

1. Pick up one Jira ticket
2. Create a branch: `<JIRA-KEY>-<short-description>` (e.g., `PINK-42-add-auth`)
3. Work only on that ticket in that branch
4. Open a PR that references only that ticket
5. After merge, start a new branch for the next ticket
