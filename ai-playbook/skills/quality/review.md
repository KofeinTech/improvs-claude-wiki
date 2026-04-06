# /review -- PR Review

Review a pull request against project rules, security guidelines, and Jira acceptance criteria. Outputs a structured review in your terminal.

## Usage

```
/review <PR_NUMBER>
```

Example: `/review 47`

## Who uses this

Any developer reviewing a colleague's pull request.

## What happens when you run it

1. **Reads the PR diff** from GitHub -- all changed files, commits, branch name
2. **Reads the Jira ticket** linked to the branch (extracts key from branch name)
3. **Checks code against rules**:
   - Stack rules (Riverpod patterns, Freezed models, CQRS, etc.)
   - Security rules (no hardcoded secrets, no injection vulnerabilities)
   - Global rules (branch naming, commit format)
   - General quality (tests, dead code, TODOs, unnecessary files)
4. **Compares against Jira acceptance criteria** -- checks each AC item is addressed
5. **Outputs a structured review** with severity levels and a verdict

## What the output looks like

```
REVIEW: PR #47 -- feat(biometric): add Face ID login
Jira: PINK-42 -- Add biometric login for iOS
Branch: PINK-42-biometric-login
Files changed: 9

--- CRITICAL (must fix before merge) ---
- lib/features/biometric/service.dart:23 -- API key hardcoded
  Rule: security-rules.md

--- WARNINGS (should fix) ---
- No test for biometric failure fallback (AC item #3)

--- SUGGESTIONS (nice to have) ---
- Consider extracting biometric config to environment

--- ACCEPTANCE CRITERIA ---
- [x] User can enable biometric login in settings
- [x] App prompts biometric on launch if enabled
- [ ] Fallback to PIN if biometric fails -- NOT addressed

--- VERDICT ---
CHANGES REQUESTED
1 critical issue (hardcoded API key), 1 AC item missing
Critical: 1 | Warnings: 1 | Suggestions: 1
AC coverage: 2/3
```

## Important notes

- This is a **local review only** -- nothing is posted to GitHub. You read it in your terminal and decide what to do.
- If the PR has no Jira ticket linked, Claude skips the AC comparison and notes it.
- If the PR is a hotfix, Claude applies a lighter review (focus on correctness and security, skip style).
- Claude never approves a PR with hardcoded secrets, regardless of everything else.

## What to do with the review

| Verdict | Your action |
|---------|-------------|
| APPROVE | Merge the PR on GitHub |
| CHANGES REQUESTED | Tell the author to fix the critical issues, then re-run `/review` |
| NEEDS DISCUSSION | Bring up the design questions with the team |

## Related

- [/bug](../bugs/bug.md) -- fix a bug before it becomes a PR
- [/hotfix](../bugs/hotfix.md) -- hotfix PRs get lighter reviews automatically
