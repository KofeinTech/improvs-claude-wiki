# /review -- Code Review

Review the **current branch** against Improvs rules and the linked Jira ticket's acceptance criteria. Hard-blocks hardcoded secrets, dispatches the superpowers code reviewer with the AC + project rules as the spec, then verifies the diff actually covers every AC item.

## Usage

```
/review
```

No arguments. Reviews the current branch against its base.

## Who uses this

- Developers, manually before commit, to sanity-check their work
- `/finish`, automatically, for simple and complex tasks (skipped for trivial)

## What happens when you run it

1. **Determines target** -- current branch, base branch read from project's CLAUDE.md (default `develop`; if Jira ticket has `hotfix` label, base is `main`). Refuses to run on `main`/`develop` directly.
2. **Extracts the Jira key** from the branch name (must match `<KEY>-<number>-...`). Refuses if missing.
3. **Reads the Jira ticket** via Jira MCP -- title, type, priority, full acceptance criteria, description.
4. **Hard-blocks on hardcoded secrets** -- scans the diff for password literals, API key literals, AWS access keys, private key file contents, bearer tokens. **If anything matches, /review aborts immediately** with the file:line and refuses to invoke the reviewer. The fix is removing the secret, not arguing with /review.
5. **Builds a requirements spec** for the reviewer that includes:
   - Jira AC verbatim
   - Instruction to read all `.claude/rules/*.md` files in the project (global rules + stack-specific rules)
   - Hotfix mode flag if the Jira ticket has `hotfix` label (tells the reviewer to focus on correctness/safety and skip style nitpicks)
6. **Dispatches `superpowers:requesting-code-review`** via the Skill tool. This in turn dispatches a fresh `superpowers:code-reviewer` subagent with no visibility into your conversation -- the reviewer cannot be biased by the implementation discussion. If the superpowers plugin is unavailable, /review falls back to an inline review using the project's `.claude/rules/*.md` files (same output format, same severity levels).
7. **Acceptance criteria coverage post-pass** -- after the reviewer returns, /review explicitly checks each AC item against the diff and classifies it as Covered / Partial / Not addressed.
8. **Combined output** -- secret scan result, the superpowers review (Strengths / Issues by severity / Recommendations), the AC coverage table, and a combined verdict.

## What the output looks like

```
REVIEW: PINK-42 — Add biometric login for iOS
Branch: PINK-42-biometric-login
Base:   develop
Mode:   standard

--- SECRET SCAN ---
✅ No secrets detected

--- CODE REVIEW ---
Strengths:
- Clean separation of concerns (BiometricService isolated from UI)
- Real tests with actual biometric mocks (not mock-of-mock)

Issues:

  Important:
  - lib/features/biometric/service.dart:42 -- Missing fallback when device has no biometric hardware
    Why it matters: app crashes on devices without biometric support
    Fix: check biometric.canAuthenticate() before prompting

  Minor:
  - lib/features/biometric/screens/login.dart:88 -- Magic number 3 for retry attempts
    Suggest: extract to constant kBiometricMaxRetries

Recommendations:
- Consider extracting biometric error messages to ARB for i18n

Assessment: With fixes -- core implementation is solid, one important issue to address.

--- ACCEPTANCE CRITERIA COVERAGE ---
[x] AC 1: User can enable biometric login in settings
    covered: lib/features/settings/screens/biometric_settings.dart
[x] AC 2: App prompts biometric on launch if enabled
    covered: lib/main.dart, lib/features/biometric/service.dart
[ ] AC 3: Fallback to PIN if biometric fails
    NOT addressed in diff
AC coverage: 2 covered, 0 partial, 1 missing (2/3 fully covered)

--- VERDICT ---
CHANGES REQUESTED — 1 important issue + 1 AC missing
```

## What the verdict means

| Verdict | What to do |
|---------|-----------|
| APPROVED | All AC covered, no critical/important issues. Proceed to /finish. |
| CHANGES REQUESTED | Either important issues from the reviewer OR missing AC coverage. Fix and re-run. |
| BLOCKED | Hardcoded secret detected. Remove the secret, then re-run. /finish will not let the PR ship. |

## Important notes

- This is a **local review** -- nothing is posted to GitHub. You read it in your terminal.
- For hotfix tickets (Jira label `hotfix`), the reviewer focuses on correctness/safety and skips style nitpicks. This is detected automatically.
- The fresh-context subagent **cannot see your implementation conversation**, so you cannot accidentally bias it by talking about the code beforehand.
- If you disagree with a finding, fix it manually and re-run /review. Do not argue with the reviewer in the same turn -- the next /review run starts fresh.
- If superpowers is not installed or fails, /review automatically falls back to an inline review against the project's rules. The output format and verdict logic are identical -- you don't need to do anything different.

## How /review fits into /finish

`/finish` invokes `/review` automatically for simple and complex tasks, before pushing or creating a PR. If /review returns CHANGES REQUESTED or BLOCKED, /finish stops and tells you what to fix. After you fix and re-run /finish, /review runs again from scratch.

For trivial tasks, /finish skips /review entirely (no AC to compare against, no logic to review).

## Related

- [/test](test.md) -- independent test generation (also auto-invoked by /finish)
- [/start](../workflow/start.md) -- begins the task whose review this is
- [/finish](../workflow/finish.md) -- runs /review automatically
