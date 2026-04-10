# New Project Setup

The playbook for kickoff when a new project lands. Written for the PM. Goal: go from "project arrived with Figma + spec" to "tickets in Jira, devs can `/improvs:start`" in under one focused afternoon, without a dev handoff call.

## Why no dev handoff call

Traditionally a new project needs a call where devs explain to PM what the technical constraints are, what to break the work into, how to scope tickets. At Improvs this is **not needed in the normal case** because Claude substitutes for that dev context:

- **Technical constraints** -- Claude reads the deployed rules in `.claude/rules/` and the project's `CLAUDE.md` to know the stack, conventions, and patterns
- **Figma breakdown** -- the Figma MCP gives Claude direct access to frames, components, user flows, and design tokens. Claude can tell you what's on each screen and how they connect.
- **Scope estimation** -- `/improvs:start`'s complexity classification gives immediate feedback on whether a ticket is trivial / simple / complex. If a draft ticket is too big, `/improvs:start` will flag it before any code is written.

You need dev input only in three narrow cases (covered at the bottom of this page). For the other 95% of kickoffs, PM + Claude is enough.

## The inputs you need before starting

Gather these before opening Claude. If anything is missing, ask the client or CEO first -- don't start drafting on incomplete information.

- [ ] **Figma URL** -- either the top-level project file or a specific page ready for dev
- [ ] **Product spec** -- what the product does, who it's for, what the MVP scope is. Can be a document, a client email, or a summary paragraph.
- [ ] **Client info** -- company name, primary contact (email + role), communication channel
- [ ] **Target stack** -- Flutter / .NET / Python / etc. Usually provided by the CEO when the project is assigned.
- [ ] **Repo location** -- either existing repo URL, or "new repo to be created"
- [ ] **Project key** -- which Jira key is this project (FANT, PINK, CUE, REW, TRAD, SOL, or a new one)
- [ ] **Deadlines** (optional) -- any fixed milestones the client expects
- [ ] **Reference project** (optional) -- a similar past Improvs project you can point Claude at for patterns

## The 6 steps

The kickoff uses **progressive elaboration**: draft the high-level plan (Epics) for the whole project, but only break down the first 1-2 Epics into detailed Tasks at kickoff. The rest of the Epics get broken down later, as the team approaches each one. Drafting 30 Tasks upfront is too much and most of those decisions can't be made yet.

### Step 1: Open Claude Code in a fresh directory

```bash
mkdir ~/kickoff-<project>
cd ~/kickoff-<project>
claude
```

Fresh directory means fresh context. No cross-project leakage.

### Step 2: Ask Claude to draft the project description and Epic-level plan

**Don't ask for all the Tasks yet.** Ask for the project description and a list of 5-10 Epics, each with high-level acceptance criteria (outcome-level success criteria). This is the high-level plan for the whole project -- feature clusters, not individual work items.

Example prompt:

> ```
> New project kickoff. Please help me draft the Jira project description
> and an Epic-level plan.
>
> Client: ExampleCorp
> Contact: Jane Doe <jane@example.com>, Product Manager
>
> Figma: https://figma.com/file/abc123?node-id=42
>
> Product spec:
> "B2B onboarding app for restaurant staff. Staff scans a QR code at
> their restaurant, creates an account, and gets access to training
> videos and a quiz. MVP is: auth, profile, video list, video player,
> quiz screen, results. No backend admin panel for this phase."
>
> Stack: Flutter, Riverpod, GoRouter, Dio, standard Improvs setup.
>
> Project key will be: REST
>
> Please:
> 1. Read the Figma file and identify the main feature areas
>    (group related screens and flows into Epics)
> 2. Draft a Jira project description using the Improvs template
>    (see ticket-templates.md for the field structure)
> 3. Propose 5-10 Epics that cover the MVP scope. For each Epic
>    give: title, 2-3 sentence description, 3-5 high-level acceptance
>    criteria (outcome-level success criteria like "user can log in
>    with Google"), and a bullet list of scope.
>    Do NOT draft individual Tasks yet -- we'll break Epics down
>    one at a time as the team approaches them.
> 4. Suggest an execution order for the Epics (which one first, etc.)
> ```

Claude will:
- Read the Figma via the Figma MCP and identify feature areas and user flows
- Group related screens into Epic-level clusters (e.g. "auth", "profile", "onboarding", "video playback")
- Draft a project description following the Improvs template
- Propose 5-10 Epics with high-level acceptance criteria and rough scope bullets
- Suggest an execution order

### Step 3: Review the Epics, make product calls

**This is your job, not Claude's.** Claude did the mechanical work -- reading Figma, grouping screens, drafting text. You make the judgment calls:

- Are the Epic boundaries right? Should two be merged, or one split?
- Which Epics are MVP and which are post-launch?
- Are there Epics missing that Figma doesn't show? (backend setup, CI/CD, analytics, crash reporting, environment config are all common additions)
- Is the execution order right for what the client expects first?

Edit the Epic drafts until you're happy. Push back on Claude: *"merge 'profile' and 'settings' -- they're the same Epic"*, *"skip the admin panel Epic, not in MVP"*, *"add an Epic for 'Infrastructure & CI' that isn't in Figma"*.

You should end up with **5-10 clean Epic drafts**, not 30 Task drafts.

### Step 4: Set up the Jira project and create the Epics

1. **Create the project in Jira** (https://improvs.atlassian.net) with the chosen project key. Use Kanban board type (see [Team Workflow](team-workflow.md)).
2. **Paste the project description** from Claude's draft into the Jira project settings → Details → Description field. This is read by `/improvs:onboard`, `/client-report`, and the `pm` subagent, so format matters.
3. **Create each Epic** in Jira with `Type: Epic`. Copy the title, description, acceptance criteria, scope bullets, and out-of-scope from Claude's drafts. Set priority on each Epic based on your execution order.

At this point, the project has a description and 5-10 Epics (each with high-level AC) in Backlog. **There are no Tasks yet.** That's intentional.

### Step 5: Break down the first 1-2 Epics into Tasks

Ask Claude to break down the highest-priority Epic (or the first two, if they're small) into concrete Tasks. Example prompt:

> ```
> Let's break down the "Authentication system" Epic into Tasks.
>
> Figma frames for this area:
> - Login screen: [frame URL]
> - Register screen: [frame URL]
> - Password reset: [frame URL]
> - Email verification: [frame URL]
>
> Stack: Flutter + Firebase Auth.
>
> Please draft one Task per screen following the Task template from
> ticket-templates.md. Include Figma URLs in the Technical Notes.
> Include a separate Task for Firebase Auth setup (not a screen but
> needed before the login screen can work).
> ```

Claude drafts 4-6 Tasks for that Epic. You review, adjust, and create them in Jira linked to the Epic:

- **Fast path:** paste each Task directly into Jira, set Type = Task, set Epic link to the parent Epic, set priority.
- **Validated path:** run `/create-feature REST` for each Task and feed Claude the draft. Slower but catches anything that doesn't meet the Definition of Ready.

**Move the first batch of Tasks from Backlog to To Do** -- typically 3-5 Tasks, enough to keep the team busy for a few days. Set an assignee on each.

### Step 6: Hand off to developers

There is no handoff meeting. Once Tasks are in To Do, any developer can pull `/improvs:start <KEY>` and begin working. The Task contains:

- Title, Type, Priority, Epic link
- What / Why
- Acceptance Criteria
- Figma URL (for UI Tasks)
- Environment / repro steps (for Bug tickets)

Everything a developer needs. `/improvs:start` reads the Task, classifies complexity, sets up the branch, and routes to the appropriate workflow. No call required.

If a developer hits something that's genuinely unclear (ambiguous AC, missing context), they ping you in Telegram. You answer async or update the Task. That's the extent of PM-dev communication for a normal project.

## Ongoing: breaking down each new Epic

After kickoff, the project runs on the normal Kanban flow. But every time the team is about to finish one Epic and pick up the next, there's a small planning moment: the PM breaks the next Epic down into Tasks.

This happens **once per Epic**, not on a fixed schedule. When you notice the active Epic has only a few Tasks left in To Do / In Progress, trigger the breakdown for the next Epic:

1. Open Claude in the project directory
2. Say *"break down the '<Epic name>' Epic into Tasks"*
3. Claude reads the Epic scope, reads any relevant Figma frames, drafts Tasks
4. You review, adjust, create in Jira linked to the Epic, move to To Do as needed

Each breakdown is 20-30 minutes of focused work. Much cheaper than drafting 30 Tasks at kickoff.

**Signs the current Epic is nearly done and it's time to break down the next one:**
- Fewer than 2 Tasks left in To Do for the active Epic
- Developers starting to ask "what's next?" in Telegram
- Client communication shifting to the next feature area

Err on the side of breaking down a little early rather than late -- an empty To Do column is a bottleneck.

## Project description template

Paste this into Claude as the reference for Step 2, or use it directly when setting up the Jira project. This template is read by `/improvs:onboard`, `/client-report`, and the `pm` subagent as the single source of truth for operational project info.

```markdown
## Client
- Company: [Client company name]
- Contact: [Name, email, role]
- Communication: [Telegram / email / Slack -- how the team talks to the client]

## Repos
- [repo-name] ([Flutter/React/.NET/etc]) -- [purpose: mobile app / backend API / admin panel / etc]

## Links
- Staging: [URL]
- Production: [URL]
- API docs: [Swagger / Postman URL]
- Figma: [project Figma URL]
- CI/CD: [GitHub Actions URL]

## Infrastructure
- Hosting: [Azure / AWS / GCP / other]
- Logs: [where and how to access]
- Monitoring: [dashboard URL]
- Database: [type + where hosted]

## Access
- Secrets: GitHub Actions secrets (ask [name] for access)
- VPN: [required? how to connect]

## Team
- PM: [name]
- Tech Lead: [name]
- Developers: [names]

## Deadlines
- [Milestone]: [date] -- [what's expected]

## Wiki
KofeinTech/wiki/[PROJECT_KEY]/ -- architecture, setup guides, API contracts, decisions

## Notes
- [Any project-specific quirks, decisions, constraints]
```

Deep technical knowledge (architecture diagrams, setup guides, API contracts) does **not** belong in this description. It belongs in the `KofeinTech/wiki/<PROJECT_KEY>/` folder. This description is for operational info only.

## When you DO need dev input

Claude replaces most of what a dev call would give you, but not all of it. These are the three cases where you should ping a developer (in Telegram, async -- not a scheduled call):

1. **Technical constraints that aren't in the code or Figma.** Example: "the client banned us from using Firebase" or "we can't touch the legacy auth module until phase 2". Claude doesn't know anything that isn't written down. If you're aware of such constraints, put them in the project description's **Notes** section so they're durable.
2. **Backend scope that Figma doesn't show.** If the project involves significant backend work (new API, new schema, migrations), Figma won't tell Claude what the backend scope is. Ask a backend dev for a rough list of Tasks: "what does the auth backend need?" Async Telegram message, 15 minutes.
3. **Unusual patterns you're not sure about.** If you draft a ticket and you're not sure it's a reasonable unit of work, ask the assigned dev to eyeball it. "Does this make sense as one Task or should I split it?" Quick async review.

All three are **async, short, and specific**. Not a meeting.

## Common pitfalls

- **Not enough product context.** If the client sent you a 2-line email ("make us a restaurant app") and you start drafting, Claude and you are both guessing. Push back on the client or CEO for a real spec before starting.
- **Drafting Tasks before Figma is ready.** If Figma frames are labelled "WIP" or "Draft", Claude will read them and produce drafts based on unfinished designs. Wait for "Ready for dev" frames.
- **Drafting all Tasks at kickoff instead of starting with Epics.** The whole reason the flow is Epic-first is to avoid this. 30 Task drafts at kickoff is too much context for Claude, too much review for you, and most of the decisions aren't knowable yet. **Stick to 5-10 Epics + Tasks for only the first 1-2 Epics.**
- **Epic that is really a single Task.** If a feature area is small enough to fit in one `/improvs:start` session, it is a Task, not an Epic. Creating an Epic for it adds overhead with no benefit.
- **Letting the To Do column go empty.** Break down the next Epic before the current one is finished. An empty To Do column blocks developers from pulling work.
- **Skipping Step 3 (the Epic review).** Claude's Epic drafts are good but not production-ready. They need your judgment about MVP scope, execution order, and missing non-UI Epics (infra, CI, analytics). Never paste Claude's Epic drafts straight into Jira without reading them.
- **Technical spec in the project description.** The description is operational (client, repos, links, team, deadlines). Architecture decisions go in `KofeinTech/wiki/<PROJECT_KEY>/`, not in Jira.

## Related

- [Ticket Templates](ticket-templates.md) -- how to write individual tickets (Task and Bug templates, Definition of Ready)
- [Team Workflow](team-workflow.md) -- how work flows through the board once the project is live
- [PM Guide](pm-guide.md) -- day-to-day PM routine (continuous grooming, monitoring, client reports)
- [Jira Workflow](jira-workflow.md) -- board columns, branch naming, JQL filters
- [`/create-feature` skill](../ai-playbook/skills/pm/create-feature.md) -- interactive Task creation
- [`/create-bug` skill](../ai-playbook/skills/pm/create-bug.md) -- interactive Bug creation
