# /create-feature -- Create Feature Ticket

Guided creation of a Jira ticket. You describe what you need, and Claude decides whether it's an **Epic** (planning container for a multi-Task feature area) or a **Task** (single unit of work) based on the scope, then walks you through the right flow.

## Usage

```
/create-feature <JIRA_PROJECT_KEY>
```

Example: `/create-feature PINK`

Valid project keys: FANT, PINK, CUE, REW, TRAD, SOL, IMP

## Who uses this

PMs, CEO, and developers who need to create a ticket in Jira.

## How Claude decides Epic vs Task

Claude classifies automatically based on the scope signals in your description:

**Classified as Epic if:**
- You mention multiple screens, flows, or layers ("auth with login, register, password reset")
- You use words like *system*, *flow*, *area*, *integration*, *module* without a specific action verb
- The estimated acceptance criteria would exceed 7 items
- The name is a noun phrase describing a feature area ("Authentication system"), not a specific action

**Classified as Task if:**
- Scope fits a single screen, component, or behavior change
- Description implies a single action verb ("add X", "fix Y", "refactor Z")
- Fits in 3-7 acceptance criteria and a single `/improvs:start` → `/improvs:finish` session

You see the classification after Step 1 and can override it if Claude guessed wrong.

## What happens when you run it

1. **Claude asks what you need**: "Describe what you need. What should the user be able to do, or what feature area should exist?"
2. **Claude classifies** the scope as Epic or Task and shows you the decision with a short reason. You can override with "no, it's actually [the other type]".
3. **Claude asks clarifying questions** (2-4 for Task, 2-3 for Epic). For Tasks: scope, UX details, edge cases, Figma. For Epics: scope boundaries, rough breakdown, dependencies on other Epics.
4. **Claude generates the draft** using the right template (Task or Epic from [Ticket Templates](../../../processes/ticket-templates.md)).
5. **Shows you the draft for review** -- you can adjust anything.
6. **Creates in Jira** with the right Type, priority, and:
   - **For Tasks:** asks whether to link to an active Epic (if any exist in the project), then asks whether to move to To Do or leave in Backlog.
   - **For Epics:** places in Backlog and reminds you that Tasks should be drafted later, when the team is about to start the Epic (progressive elaboration).

## Example: Task

```
> /create-feature PINK

Describe what you need.
> Users should be able to share their profile via QR code

Based on the scope, this looks like a Task -- it fits a single screen,
3-4 acceptance criteria, one /improvs:start session. Proceed as Task?
> yes

Does the QR code contain a deep link or just a URL?
> Deep link

Should it work offline (cached QR) or generate on demand?
> On demand is fine

Is there a Figma design for this?
> Not yet

TASK for PINK

Title: Add QR code profile sharing
Type: Task
Priority: Medium

## What
Add a button on the profile screen that generates a QR code with a deep
link to the user profile, sharable via the system share sheet.

## Why
As a user, I want to share my profile via QR code so other users can
quickly view me without typing my username.

## Acceptance Criteria
- [ ] User can generate QR code from profile screen
- [ ] QR code contains deep link to user profile
- [ ] QR code is shareable via system share sheet
- [ ] Scanning QR opens the app to that user profile
- [ ] Works on both iOS and Android

## Technical Notes
UI changes required -- Figma design needed before implementation.

## Out of Scope
- Custom QR code styling / branding
- QR scanning inside the app (use system camera for now)

Create this Task in Jira?
> yes

Active Epics in PINK: "Profile & settings", "Onboarding flow"
Link this Task to an Epic?
> Profile & settings

Move to To Do or leave in Backlog?
> Backlog

Created PINK-72: Add QR code profile sharing
  Linked to Epic PINK-60: Profile & settings
  Placed in Backlog
```

## Example: Epic

```
> /create-feature PINK

Describe what you need.
> We need a full authentication system: login, register, password reset,
  and Google OAuth.

Based on the scope, this looks like an Epic -- it covers multiple screens
(login, register, reset, OAuth) and would span 4-5 Tasks. Proceed as Epic?
> yes

What's the biggest thing this Epic includes and what is clearly out of scope?
> Include email/password + Google. Out of scope: Facebook, Apple Sign In.

Roughly how many distinct pieces of work do you see?
> 5: login, register, password reset, email verify, Google OAuth

Does this Epic depend on another Epic being done first?
> No

EPIC for PINK

Title: Authentication system
Type: Epic
Priority: High

## What
User authentication flow for the mobile app. Covers signup, login,
password reset, and Google Sign-In.

## Why
Core requirement for the MVP -- every user action is behind auth. Without
this shipped, no other feature can be tested end-to-end.

## Acceptance Criteria
- [ ] User can create an account with email and password
- [ ] User can log in with email and password
- [ ] User can log in with Google
- [ ] User can reset their password via email
- [ ] Session persists across app restart

## Scope
- Login screen (email + password)
- Register screen with email verification
- Password reset flow (email link)
- Session management (token refresh, auto-logout)
- Google OAuth integration

## Out of scope
- Biometric login (post-MVP)
- Facebook, Apple Sign In (phase 2)
- Account deletion (separate Epic later)

Create this Epic in Jira?
> yes

Created PINK-80: Authentication system
  Placed in Backlog

Epic created. Per the Improvs Kanban flow, Tasks for this Epic should be
drafted ONLY when the team is ready to start working on it -- not now.

When you are ready to break it down, ask Claude in free chat:
  "Break down the 'Authentication system' Epic into Tasks"

See processes/new-project-setup.md for the breakdown flow.
```

## What Claude enforces

- **Epics have high-level success criteria** (outcome-level AC like "user can authenticate via Google", not granular checkboxes). If a PM provides granular Task-level AC for an Epic, Claude suggests moving them to future child Tasks and replacing them with outcome-level criteria.
- **Epics are not broken down at creation time.** You draft an Epic now, break it into Tasks later when the team approaches it. This is progressive elaboration -- details live at the right altitude for the time horizon.
- **Tasks must have 3-7 testable acceptance criteria.** If you describe something that would need more, Claude suggests creating an Epic instead.
- **Testable AC only.** "App should be fast" is not an AC. "Screen loads within 2 seconds on 4G" is.
- **Out of Scope section is always included** on both Tasks and Epics to prevent scope creep.
- **No ticket is created without your confirmation.** Claude always shows the draft first.

## Related

- [Ticket Templates](../../../processes/ticket-templates.md) -- the canonical Epic and Task templates this skill uses
- [New Project Setup](../../../processes/new-project-setup.md) -- when to create Epics (project kickoff) and when to break them down (ongoing)
- [/create-bug](create-bug.md) -- for bug reports instead of features
- [/improvs:start](../workflow/start.md) -- what developers use when they pick up a Task or Bug
