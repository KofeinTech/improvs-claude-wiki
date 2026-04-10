# Jira Ticket Templates

How to write Jira tickets so the Improvs workflow actually works. Read this once before you create your first ticket -- everything in `/improvs:start`, `/improvs:review`, `/improvs:finish`, and `/client-report` reads data out of these tickets, so a bad ticket breaks the whole flow.

This page is for **everyone**: PMs write tickets following these standards, developers consume them, and both can point at this doc when something is missing.

## Issue types

Improvs uses **three** issue types: Epic, Task, Bug. No Stories, no Subtasks.

| Type | Use when | Who works on it | Examples |
|---|---|---|---|
| **Epic** | A multi-day-to-week effort that groups related work. Planning container, **not a unit of work**. | Nobody -- work happens on the Tasks under it. | "Authentication system", "Profile & settings", "Onboarding flow", "Payment integration" |
| **Task** | A single unit of work -- one `/improvs:start` → `/improvs:finish` cycle. Features, refactor, infra, docs, dependency upgrades. | One developer per Task. Usually linked to an Epic, can be standalone. | "Add biometric login screen", "Migrate auth to Riverpod 2.0", "Set up CI build cache" |
| **Bug** | Something is broken that should work -- a defect. | One developer. Usually standalone; can be linked to an Epic if scope-relevant. | "Login crashes on iOS 17", "Profile image doesn't update after edit" |

### How the three types relate

```
Epic: "Authentication system"
├── Task: Login screen
├── Task: Register screen
├── Task: Password reset flow
├── Task: OAuth integration (Google)
└── Task: Session management
```

An Epic is a **planning container** -- it has a title, short description, and high-level success criteria (outcome-level AC like "user can authenticate via Google", not granular checkboxes). The detailed work lives in its child Tasks. Developers never run `/improvs:start EPIC-42` -- they run `/improvs:start TASK-43` (a child of EPIC-42).

**Why this split:** for a new project, a PM can draft 5-10 Epics in 30 minutes (the rough plan). Drafting 30 Tasks upfront is too much and many decisions can't be made yet. The PM drafts Epics first, then breaks each Epic into Tasks when the team is about to start it. This is called **progressive elaboration** -- plan broadly, detail narrowly as you approach the work.

**Why no Stories:** between "Story" and "Task" there is no functional difference in the Improvs workflow. `/improvs:start` doesn't distinguish them. Adding Story as a separate type just forces the PM to make a fuzzy "is this user-facing?" decision on every ticket with no payoff.

**Why no Subtasks:** AI does the entire Task in one `/improvs:start` session. Subtasks create artificial hierarchy that nobody updates, and they don't trigger the In Progress / In Review automation properly. If a Task is too big for one session, **split it into multiple Tasks under the same Epic**, not subtasks.

## Epic template

Epics are lightweight. No technical notes, no Figma links (those live on the child Tasks). An Epic answers "what cluster of work is this, why, and what does success look like" with high-level acceptance criteria.

Title format: a noun phrase describing the feature area (`Authentication system`, `Profile & settings`), not an action (not `Add authentication`).

```markdown
## What
[2-3 sentences describing the feature area or initiative]

## Why
[1-2 sentences: user value or business motivation]

## Acceptance Criteria
- [ ] [High-level success criterion 1 -- outcome-level, e.g. "user can log in with Google"]
- [ ] [High-level success criterion 2]
- [ ] [High-level success criterion 3]
[3-5 items. These are outcome-level success criteria, not granular checkboxes. Think "what must be true for this Epic to be considered done", not implementation details.]

## Scope
[Bullet list of what is included, high-level -- one bullet per expected Task or group of Tasks. This is not binding; it becomes the seed for Task creation when the team approaches this Epic.]

## Out of scope
[What this Epic does NOT cover, to prevent scope creep later]
```

### Example: Epic

> **Title:** Authentication system
>
> **What:** User authentication flow for the mobile app. Covers signup, login, password reset, and session management. Uses Firebase Auth on the backend.
>
> **Why:** Core requirement for the MVP -- every user action is behind auth. Without this shipped, no other feature can be tested end-to-end with real users.
>
> **Acceptance Criteria:**
> - [ ] User can create an account with email and password
> - [ ] User can log in with email and password
> - [ ] User can log in with Google
> - [ ] User can reset their password via email
> - [ ] Session persists across app restart
>
> **Scope:**
> - Login screen with email + password
> - Register screen with email verification
> - Password reset flow (email link)
> - Session management (token refresh, auto-logout on expiry)
> - OAuth integration (Google Sign-In)
>
> **Out of scope:**
> - Biometric login (post-MVP, separate Epic)
> - Social logins beyond Google (Facebook, Apple -- phase 2)
> - Account deletion (separate Task in an "Account management" Epic later)

When the team is ready to start this Epic, the PM breaks each scope bullet into one or more Tasks (see the Task template below) and links them to the Epic in Jira.

## Task template

Title format: action verb first (`Add ...`, `Migrate ...`, `Refactor ...`), not `Feature: ...` or `Task: ...`.

```markdown
## What
[1-2 sentences: what is being changed or added]

## Why
[1-2 sentences: motivation -- user value, tech debt, performance, dev experience, etc.]

## Acceptance Criteria
- [ ] [Specific testable criterion 1]
- [ ] [Specific testable criterion 2]
- [ ] [Specific testable criterion 3]

## Technical Notes
[Optional: Figma link, relevant API endpoint URL, platform-specific constraints]
[Do not prescribe architecture, package choices, or list files affected -- the developer decides during /start]

## Out of Scope
- [Explicitly list what this ticket does NOT include, to prevent scope creep]
```

For user-facing work, you can frame the **What** section as a user story (`As a user I want to X so that Y`) -- it's a useful thinking aid but not required. The system doesn't care about the format, only that the field has clear context.

### Example: user-facing task

> **Title:** Add QR code profile sharing
>
> **What:** Add a button on the profile screen that generates a QR code containing a deep link to the user's profile. Sharable via the system share sheet.
>
> **Why:** As a user, I want to share my profile via QR code so other users can quickly view me without typing my username. Users frequently exchange profiles in person at events; manual username entry is error-prone and slow.
>
> **Acceptance Criteria:**
> - [ ] User can generate a QR code from the profile screen
> - [ ] QR code contains a deep link to the user's profile
> - [ ] QR code is shareable via the system share sheet
> - [ ] Scanning the QR opens the app to that user's profile
> - [ ] Works on iOS and Android
>
> **Technical Notes:** UI changes required -- Figma design needed before implementation. Deep link routing already set up.
>
> **Out of Scope:**
> - Custom QR code styling/branding
> - QR scanning inside the app (use system camera for now)

### Example: internal task

> **Title:** Migrate auth module to Riverpod 2.0
>
> **What:** Replace the legacy `ChangeNotifier`-based auth provider in `lib/features/auth/` with Riverpod 2.0 `AsyncNotifier`.
>
> **Why:** The auth module is the only place still using ChangeNotifier. Bringing it inline with the rest of the codebase removes the inconsistency and lets us delete the legacy adapter in `lib/core/legacy/`.
>
> **Acceptance Criteria:**
> - [ ] `lib/features/auth/` uses `@riverpod` code generation
> - [ ] All existing auth tests still pass
> - [ ] `lib/core/legacy/auth_adapter.dart` is deleted
> - [ ] No new analyzer warnings introduced
>
> **Technical Notes:** Auth state is consumed by multiple widgets -- developer will identify affected files during `/improvs:start`.
>
> **Out of Scope:**
> - Other modules using legacy ChangeNotifier (separate tickets)

### Example: screen implementation

Use this pattern for UI-first projects (mobile MVPs, onboarding flows, prototypes) where the natural unit of work is one screen from Figma. One Task = one Figma frame.

> **Title:** Implement Settings screen
>
> **What:** Build the Settings screen from the Figma frame in `lib/features/settings/screens/settings_screen.dart`. Wire up the existing Riverpod providers from `lib/features/settings/providers/`.
>
> **Why:** One of the four bottom-tab destinations defined in the new app shell. Currently a stub.
>
> **Acceptance Criteria:**
> - [ ] Layout matches the Figma frame within tolerance (verified by `/improvs:figma-check`)
> - [ ] All toggles wired to the relevant Riverpod providers
> - [ ] Loading state implemented (skeleton or spinner)
> - [ ] Empty state implemented
> - [ ] Error state implemented
> - [ ] Navigation in (from app shell tab) and out (back / deep links) works
> - [ ] Dark mode renders correctly
>
> **Technical Notes:** Figma URL: <link to frame>. One of the four bottom-tab destinations. Platform constraint: must support both light and dark mode.
>
> **Out of Scope:**
> - Account deletion flow (separate Task -- needs API)
> - Notification preferences (separate Task -- needs new endpoint)

## Bug template

Title format: symptom + context (`Login crashes on iOS 17`, not `Login bug`).

```markdown
## Summary
[One sentence describing what's broken]

## Steps to Reproduce
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens, including any error messages]

## Environment
- Platform: [iOS / Android / Web / All]
- OS Version: [e.g., iOS 17.2, Android 14]
- App Version: [e.g., 2.3.1]
- Device: [if relevant -- e.g., iPhone 15, Pixel 7]

## Frequency
[Every time / Sometimes (~X% of attempts) / Once / Unknown]

## Severity
[Critical / High / Medium / Low -- see severity guide below]

## Additional Context
[Screenshots, logs, related tickets, any workarounds]
```

### Severity guide

| Severity | When to use | Examples |
|---|---|---|
| **Critical** | App crash, data loss, security vulnerability, blocks core user flow for everyone | App crashes on launch, login fails for all users, payments stuck |
| **High** | Feature broken with no acceptable workaround, affects many users | Cannot upload photos, sync fails on slow connections |
| **Medium** | Partial breakage with workaround available, affects some users | UI misaligned on small screens, button label wrong |
| **Low** | Cosmetic, typo, edge case | Wrong icon color, typo in settings |

### Filled example

> **Title:** App crashes on notification tap (Android 14)
>
> **Summary:** App crashes immediately when the user taps a push notification on Android 14 devices.
>
> **Steps to Reproduce:**
> 1. Receive a push notification (any type)
> 2. Tap the notification on the lock screen or notification shade
> 3. App crashes instead of opening
>
> **Expected Behavior:** App opens to the relevant screen referenced in the notification payload.
>
> **Actual Behavior:** App crashes immediately. Logcat shows `NullPointerException` at `push_handler.dart:38`.
>
> **Environment:**
> - Platform: Android
> - OS Version: Android 14
> - App Version: 2.3.1
> - Device: Pixel 7, Pixel 8
>
> **Frequency:** Every time (100% reproduction)
>
> **Severity:** Critical -- crash on common user flow

## What the system does with your ticket

This is the most important table on the page. It shows which field is read by which skill and what breaks if you leave it blank or fill it badly:

| Field | Read by | What happens if missing or bad |
|---|---|---|
| **Type** (Epic / Task / Bug) | `/improvs:start`, `/client-report` | **Epic:** no skill reads it for work -- it's a planning container, `/improvs:start` won't run on it. **Task:** standard workflow. **Bug:** `/improvs:start` runs an investigation step before classifying complexity. |
| **Epic link** (on Task / Bug) | `/client-report` | Used to show client progress per Epic ("auth: 3/5 done"). Tasks without an Epic link still work; they just show as standalone in reports. |
| **Title** | `/improvs:start`, `/improvs:finish`, `/client-report` | Used in branch name, PR title, client reports. Vague titles produce vague PRs. |
| **What / Why / Description** | `/improvs:start`, `/improvs:onboard` | Without context, Claude can't orient itself and may misclassify complexity or pick the wrong approach. |
| **Acceptance Criteria** | `/improvs:start`, `/improvs:review`, `/improvs:finish`, `/client-report` | **Task/Bug:** `/improvs:start` refuses to start without AC. `/improvs:review` cannot verify coverage. `/improvs:finish` cannot build the PR checklist. AC is the most load-bearing field on Task/Bug tickets. **Epic:** high-level success criteria (outcome-level). Read by `/client-report` for progress tracking. |
| **Priority** | PM, `/health-check` | Used for sorting and escalation. Critical bugs trigger the hotfix flow within `/improvs:start` (branches from main, dual PRs). |
| **Figma link** (UI Tasks only) | `/improvs:start`, `/improvs:figma-check` | If `/improvs:start` sees UI keywords without a Figma link, it asks the developer to provide one before proceeding. |
| **Steps to Reproduce** (Bug only) | `/improvs:start` | The Bug investigation step needs reproduction info to find the root cause. Without it, Claude has to ask the dev. |
| **Environment** (Bug only) | `/improvs:start` | Without OS / app version, the bug investigation may look at the wrong code path. |
| **Assignee** | `/improvs:start`, PM | Just for tracking on Task/Bug -- not load-bearing on automation, but PM needs it for board hygiene. Epics do not need an assignee. |

## Definition of Ready

Different ticket types have different readiness criteria.

### For a Task or Bug (pulled from "To Do" by a developer via `/improvs:start`)

A Task/Bug is ready to be moved from Backlog to To Do when **every box is checked**:

- [ ] **Type** is set (Task or Bug)
- [ ] **Epic link** set if this Task/Bug belongs to an Epic (optional but recommended)
- [ ] **Title** is in action format -- starts with a verb (`Add`, `Migrate`, `Fix`, `Refactor`, ...)
- [ ] **What / Why** has 2-3 sentences explaining the change and motivation
- [ ] **Acceptance Criteria** has 3-7 testable items
- [ ] **Priority** is set
- [ ] If UI changes are involved → **Figma link** is attached
- [ ] If type is Bug → **Steps to Reproduce + Expected/Actual + Environment** are filled
- [ ] **Assignee** is set (when the ticket is moved into the To Do column)

If any box is unchecked, the Task/Bug stays in **Backlog**. The PM is responsible for moving tickets between Backlog and To Do based on this checklist.

### For an Epic (created by PM during planning)

Epics have a much lighter readiness check. An Epic is ready to exist in the board when:

- [ ] **Title** is a noun phrase describing the feature area
- [ ] **What** has 2-3 sentences describing the feature area
- [ ] **Why** has 1-2 sentences of motivation
- [ ] **Acceptance Criteria** has 3-5 high-level success criteria (outcome-level, e.g. "user can log in with Google")
- [ ] **Scope** is a high-level bullet list (not binding, becomes seeds for Tasks later)
- [ ] **Out of scope** is filled to prevent creep

Epics don't move through the board like Tasks. They stay as containers until the PM decides to break one down into Tasks. When an Epic has zero child Tasks not yet in Done, and no more are planned, mark the Epic as Done too.

## Sizing rule

Use `/improvs:start`'s built-in complexity classification as a sanity check on ticket size:

| `/improvs:start` classifies as | Means | Action |
|---|---|---|
| **Trivial** (1 file, cosmetic, 1 AC) | Cosmetic / config / text change | Fine. Consider whether it deserves its own ticket -- small fixes can sometimes be batched. |
| **Simple** (1-2 files, single layer, 1-3 AC) | The ideal ticket size | Most tickets should be this. |
| **Complex** (3+ files, 4+ AC, multi-layer) | Real complexity | Fine if genuinely complex. If you can split it into 2-3 simpler Tasks, do that. |

**Hard limit:** if a Task has more than 7 acceptance criteria or touches 5+ files, it's too big. **Split it into multiple Tasks**, never subtasks.

## Common red flags

| Red flag | Why it's bad | How to fix |
|---|---|---|
| `Title: Improve the settings page` | Vague -- what specifically? | Replace with concrete action: `Add dark mode toggle to settings` |
| Empty AC on a Task or Bug | `/improvs:start` refuses to begin | Add 3-7 testable criteria before moving to To Do |
| `AC: app should be fast` | Not testable | Make it measurable: `Page loads within 2 seconds on 4G` |
| 10+ AC items on one Task | Task is too big | Split into 2-3 separate Tasks under the same Epic |
| Bug with no repro steps | `/improvs:start` can't investigate | Add step-by-step repro, or label `needs-repro` |
| Bug + change-request mixed in one ticket | Claude can't classify | Create two tickets -- one Bug, one Task |
| UI Task with no Figma link | `/improvs:start` will ask the dev | Attach Figma link before moving to To Do |
| `Type: Task` for a defect | Bug investigation step won't fire | Change type to Bug |
| Epic with granular Task-level AC | Epic AC should be outcome-level, not implementation detail | Make AC outcome-level: "user can log in", not "button has correct padding" or "loading spinner appears within 200ms" |
| Task without an Epic link | Not wrong per se, but the ticket doesn't show up in Epic progress reports | Link to the right Epic (or leave standalone if it truly doesn't belong to any) |
| Epic that is really a single Task | Creating an Epic adds overhead for no benefit | If the whole thing fits in one `/improvs:start` session, it's a Task, not an Epic |

## Tools to help you

- **`/create-feature <PROJECT_KEY>`** -- Claude walks you through creating a Task interactively. Asks 2-4 clarifying questions, generates the ticket in the format above, asks for confirmation before creating in Jira. Use this instead of writing Tasks from scratch. (Despite the name, it creates Tasks -- "feature" is the colloquial word, the Jira type is Task.)
- **`/create-bug <PROJECT_KEY>`** -- Same flow for Bug tickets. Auto-suggests severity based on description.
- **Epics** -- create directly in Jira or ask Claude to draft them during project kickoff (see [New Project Setup](new-project-setup.md)). Epics are lightweight enough that a dedicated skill isn't needed.
- **PM backlog grooming** -- continuous at the Task level, periodic at the Epic level (when approaching a new feature area). See [PM Guide](pm-guide.md).

## Related

- [Jira Workflow](jira-workflow.md) -- board structure, statuses, branch naming, JQL filters
- [Definition of Done](definition-of-done.md) -- the checklist for completing a ticket (this page is the start of the lifecycle, that one is the end)
- [PM Guide](pm-guide.md) -- backlog grooming and daily routine for the PM
- [`/create-feature` skill](../ai-playbook/skills/pm/create-feature.md)
- [`/create-bug` skill](../ai-playbook/skills/pm/create-bug.md)
