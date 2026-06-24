---
phase: 3
title: Design Consolidation & Approval Gate
status: completed
priority: P1
dependencies:
  - 2
effort: 3h
---

# Phase 3: Design Consolidation & Approval Gate

## Overview

Author the heart of `/product`: Stage 3 (spawn design specialists sequentially → merge into ONE
consolidated solution doc → `/ck:plan`), the single HARD-STOP approval gate, then Stage 4 (batch
execute via `/cook`) and Stage 5 (`/ship` + `/ck:journal`). This is the connective tissue that
turns owned ck: pieces into one reviewable flow.

## Requirements

- Functional: design needs (UI / architecture / tech / deploy) routed to the right specialist;
  outputs merged into a single doc the user reviews; one approval unlocks autonomous execution.
- Non-functional: exactly ONE human stop; specialists run sequentially (v1); execution reuses
  `/cook` unchanged.

## Architecture

**Stage 3 — sequential specialist fan-out (v1 decision):**
Orchestrator inspects the task list (from Stage 2 SRD/spec) and, per design need, spawns the owned
subagent sequentially:

| Design need | Specialist |
|-------------|-----------|
| UI/UX | `ui-ux-designer` agent (or `/ipa:design`) |
| Architecture / technical design | `planner` agent |
| Deployment / infra | `devops` skill |
| Data/DB | `planner` + `databases` skill |

Orchestrator OWNS the merge: collects specialist outputs into ONE
`ck_docs/solution-design.md` (consolidated solution), then runs `/ck:plan` to produce the phased
plan. `/ck:plan`'s own validate/red-team gates remain available.

> v1 = sequential (KISS, simpler context handling). `/ck:team` parallel fan-out deferred to v2;
> noted as a flagged upgrade in SKILL.md, not built now.

**APPROVAL GATE (the single stop):**
Mirror the IPA GATE pattern. After the consolidated solution + plan exist, `/product` HARD-STOPS and
presents: consolidated solution summary + plan phase outline + open questions. Uses
`AskUserQuestion`: Approve → proceed to Stage 4 · Revise → loop back into Stage 3 · Abort → stop.
No execution before explicit approval.

**Stage 4 — batch execute:** on approval → `/cook <plan-path>` (or `/cook <plan-path> --parallel`
when user opts in). Runs all phases; stops only on blocker or a ck: gate failure. No per-task gate
(per locked decision).

**Stage 5 — ship + record:** on execution complete → offer `/ship` then `/ck:journal`.

## Related Code Files

- Modify: `plugins/product/skills/product/SKILL.md` (fill `## Stage 3 — Solution Design`, `## Approval Gate`, `## Stage 4 — Execute`, `## Stage 5 — Ship & Record`)
- Create: documents the `ck_docs/solution-design.md` consolidation convention (written at runtime, not now)

## Implementation Steps

1. Write `## Stage 3 — Solution Design`: design-need → specialist mapping table as routing logic; sequential spawn instructions; explicit "orchestrator merges into single `ck_docs/solution-design.md`" rule.
2. Add the `/ck:plan` handoff after consolidation (pass solution-design.md as context).
3. Write `## Approval Gate`: HARD-STOP rule + `AskUserQuestion` with Approve/Revise/Abort; forbid any `/cook` call before approval. Mirror IPA GATE language.
4. Write `## Stage 4 — Execute`: `/cook` delegation, `--parallel` opt-in, stop-on-blocker behavior.
5. Write `## Stage 5 — Ship & Record`: `/ship` + `/ck:journal` offer.
6. Add `## v2 (Deferred)` note: `/ck:team` parallel fan-out — explicitly out of scope for v1.
7. Re-read full SKILL.md (Phases 1-3) for whole-file consistency: stage names, file paths, and skill calls must match across sections.

## Success Criteria

- [ ] SKILL.md routes each design need to the correct specialist and merges outputs into one `ck_docs/solution-design.md`.
- [ ] Approval gate HARD-STOPS before execution; `/cook` is unreachable without explicit Approve.
- [ ] Approve → `/cook`; Revise → back to Stage 3; Abort → clean stop.
- [ ] Stage 4 executes the full plan in batch (no per-task stops); Stage 5 offers ship + journal.
- [ ] No ck: logic duplicated; all heavy lifting delegated.

## Risk Assessment

- **Fragmented design output** (N specialist docs, no synthesis): mitigation — consolidation into a single doc is an explicit, testable step; Phase 4 verifies one doc exists.
- **Gate bypass**: model proceeds to `/cook` without approval. Mitigation — phrase gate as a HARD-GATE with an explicit "MUST NOT call /cook before Approve" rule; verify in Phase 4.
- **Sequential latency**: many design needs = slow. Accepted for v1; `/ck:team` upgrade path documented.
