# gh Projects v2 cheatsheet

Concrete `gh` commands for the `github-project-management` skill. Load when you need a command.
Projects v2 writes require the `project` token scope (`gh auth refresh -s project`).

## Discover / create the board

```bash
gh project list --owner <org-or-user>                      # find existing Projects (note the number)
gh project create --owner <org-or-user> --title "Delivery" # create one; prints the new number + URL
gh project view <number> --owner <o> --format json         # board metadata
```

## Read the field schema (ids are required to edit items)

```bash
gh project field-list <number> --owner <o> --format json
```

Capture: the `Status` field id + its option ids (Todo / In Progress / In Review / Done), and the
`Agent` / `Priority` field ids + option ids. You cannot set a single-select field without both the
field id and the chosen option id.

## Create an issue (a task) and add it to the board

```bash
# 1) create the issue (body holds acceptance criteria + plan trace)
gh issue create --repo <o>/<repo> \
  --title "Add retry-with-fallback to payment gateway" \
  --body "$(printf 'Problem: ...\n\nAcceptance:\n- [ ] ...\n\nTraces to: plan phase 2 / FR-07')" \
  --label "area:payments,type:feat"

# 2) add it to the Project (use the issue URL printed above)
gh project item-add <number> --owner <o> --url https://github.com/<o>/<repo>/issues/<n>
```

## Set Status / Agent / Priority on a Project item

Item ids are Project-scoped (not the issue number):

```bash
gh project item-list <number> --owner <o> --format json     # find the item id for the issue

gh project item-edit \
  --project-id <PROJECT_NODE_ID> \
  --id <ITEM_ID> \
  --field-id <STATUS_FIELD_ID> \
  --single-select-option-id <OPTION_ID_FOR_TODO>
```

Repeat per field (Status, Agent, Priority). `--project-id` is the Project's node id (from
`project view --format json`), not the human number.

## Epics & sub-tasks

- Checklist in an epic issue body: `- [ ] #123` lines — GitHub renders progress and links.
- Or use native sub-issues where enabled. Keep one agent-ownable task per child issue.

## Link a PR to a ticket (earns the card to Done)

Put `Closes #<n>` (or `Fixes #<n>`) in the PR body — merging the PR closes the issue. Pair with a
Status move to `Done` so board and repo agree.

## Query progress (for reports)

```bash
gh project item-list <number> --owner <o> --format json \
  | jq -r '.items[] | [.content.title, .status, .agent] | @tsv'
```

Aggregate per Status for the counts; list anything `In Review` with no open PR, or `In Progress`
older than N days, as blockers.

## File a bug ticket

```bash
gh issue create --repo <o>/<repo> \
  --title "Checkout 500s when coupon + gift card combined" \
  --body "$(printf 'Repro:\n1. ...\n\nExpected: ...\nActual: ...\n\nSeverity: high\nSurfaced in: v0.5.0')" \
  --label "type:bug,severity:high,release:v0.5.0"
# then item-add to the Project and set Status=Todo + Agent (see above)
```

## Weekly + quality metrics

```bash
# Features completed this week (Done in last 7 days)
gh issue list --repo <o>/<repo> --state closed --label type:feat \
  --search "closed:>=$(date -v-7d +%F 2>/dev/null || date -d '7 days ago' +%F)" \
  --json number,title --jq 'length'

# Bugs introduced from the weekly release (filed since the release, or by release label)
gh issue list --repo <o>/<repo> --label type:bug \
  --search "created:>=<release-date>" --json number,title --jq 'length'
# or: --label "release:v0.5.0"

# Open bugs by severity (risk view)
gh issue list --repo <o>/<repo> --state open --label type:bug \
  --json number,title,labels --jq '[.[] | {n:.number, t:.title}] | length'
```

Report the **feature count vs bug count** and the ratio; a rising bug-per-release alongside rising
features is the quality-erosion signal to flag.

## Assignment caveat

`gh issue edit <n> --add-assignee <login>` only accepts real GitHub users. For AI-agent ownership,
set the `Agent` Project field (or an `agent:<name>` label) instead — do not invent a GitHub account
for an agent.
