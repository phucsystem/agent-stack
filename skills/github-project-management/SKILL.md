---
name: github-project-management
description: "Method for managing work on a GitHub Project (Projects v2) with the gh CLI: discover or create a Project board, turn a plan or feature batch into issues (tasks), add them to the board, set Status and custom fields, assign the owning agent, link PRs to issues, and query progress. Used by the delivery-manager agent. Trigger whenever work must be tracked as GitHub tickets on a Project board, progress reported from it, or a plan externalized into issues — 'create tickets', 'add to the project board', 'move to in progress', 'what's the board status'."
user-invocable: false
category: method
keywords: [github, gh, project, projects-v2, issues, tickets, board, kanban, delivery, progress, milestone]
metadata:
  author: phuc DANG
  version: "0.1.0"
---

# GitHub Project Management (method)

How to run a GitHub Project as the durable, shared record of work-in-flight. This is the *mechanics*
skill the `delivery-manager` agent uses; the *who/when* lives in the `delivery-manager` orchestrator.

The GitHub Project is the **source of truth** across sessions and agents. The in-session shared task
list mirrors it during a run, but the board is what survives.

## Preconditions (check first, fail loud)

`gh` must be installed, authenticated, and hold the **`project`** scope (Projects v2 needs it):

```bash
gh auth status                  # authenticated?
gh auth refresh -s project      # add the project scope if writes fail with a scope error
```

If a precondition fails, stop and give the user the exact command — do not silently skip board
writes. A board you didn't update is a lie the next agent will trust.

## Core model

- **Task = one GitHub issue = one Project item.** Issue carries the durable content (problem,
  acceptance criteria, link to the plan phase it traces to); the Project item carries the workflow
  fields (Status, Agent, Priority).
- **Batch features into tasks.** Group related features into a task one agent can own and a reviewer
  can verify. For a large feature, make an **epic** issue with a checklist (`- [ ] #123`) or
  sub-issues of the child tasks — never one monolithic issue, never one issue per trivial edit.
- **Agent ownership is a Project field, not a GitHub assignee.** `assignee` only accepts real GitHub
  users. Track the owning agent with a custom single-select field **"Agent"** (or an `agent:<name>`
  label). Reserve real-user assignment for humans. Never fake an agent as a GitHub account.
- **PRs move cards to Done.** A PR with `Closes #N` in its body closes the issue on merge; pair that
  with the Status field so "merged" and "Done" stay in sync.

## Status lifecycle (default)

`Backlog → Todo → In Progress → In Review → Done`. If the Project already has columns, **match them**
rather than imposing a new scheme — the board should reflect the team's reality.

## Workflow

1. **Locate or create the Project.** `gh project list --owner <org-or-user>`; create with
   `gh project create --owner <o> --title "<t>"` if none fits. Record the project number + URL.
2. **Ensure fields exist.** Confirm/seed the `Status` single-select and the `Agent`/`Priority`
   fields. Read their ids once (`gh project field-list`) — editing items needs field + option ids.
3. **Create issues from the plan/batch.** One `gh issue create` per task with a body that states
   acceptance criteria and links the plan phase. Label by area.
4. **Add issues to the Project** (`gh project item-add`) and set initial `Status=Todo`, `Agent=<the
   implementing agent>`, `Priority`.
5. **Drive the lifecycle.** As agents work, advance `Status` (Todo→In Progress→In Review→Done) and
   keep the in-session task list mirrored.
6. **Link & close.** Ensure PRs carry `Closes #N`; on merge, verify the card reaches Done.
7. **Report.** Per-status counts, blockers, next actions, board URL.

> The exact `gh` / GraphQL commands (creating items, reading field ids, editing single-select Status,
> querying progress as JSON) are in **`references/gh-projects-cheatsheet.md`** — load it when you need
> a command, not before.

## Data shape for a task issue

```
title:   <imperative, scoped>           e.g. "Add retry-with-fallback to payment gateway"
body:    Problem / Acceptance criteria (checkable) / Traces to: <plan phase or FR-id> / Notes
labels:  area:<x>, type:<feat|fix|chore>, agent:<name> (if not using the Agent field)
project: Status=Todo, Agent=<agent>, Priority=<P?>
links:   closed by PR via "Closes #<issue>"
```

## Data shape for a bug issue

```
title:   <symptom, specific>            e.g. "Checkout 500s when coupon + gift card combined"
body:    Steps to reproduce / Expected vs Actual / Severity / Surfaced in: <release/version>
labels:  type:bug, severity:<critical|high|medium|low>, release:<version> (or a release field)
project: Status=Todo, Agent=<agent>, Priority=<by severity>
```

A consistent `type:bug` label + `release:<version>` marker is what makes the quality report
computable — without them you cannot count "bugs introduced from the weekly release".

## Reporting & quality queries

The board owns the numbers; compute reports live, never from memory.

- **Project / status summary** — per-Status counts from `gh project item-list ... --format json`.
- **Done this week** — issues that reached Done / closed in the last 7 days:
  `gh issue list --repo <o>/<r> --state closed --search "closed:>=<YYYY-MM-DD>" --json number,title,labels`
- **Features completed this week** — the same, filtered to `--label type:feat` (or `label:` in the search).
- **Bugs introduced from the weekly release** — bugs filed against the latest release:
  `gh issue list --repo <o>/<r> --label type:bug --search "created:>=<release-date>"`
  (or filter by the `release:<version>` label). Report the count and the feature:bug ratio.
- **Risk signals** — tickets stalled in `In Progress` past N days, an `In Review` with no open PR, a
  rising bug-per-release trend. Surface these with the report, not buried.

> The exact commands are in `references/gh-projects-cheatsheet.md`.

## Error handling

- Scope/auth error on a write → stop, surface the `gh auth refresh -s project` fix.
- Field/option id not found → re-read `field-list` once; if still failing, leave the item in its prior
  status and report it, don't claim the move succeeded.
- Board vs reality mismatch (Done card, open PR) → trust the PR, correct the card, note the drift.
- Rate-limited → back off and report partial progress with what remains.
