---
title: "Product Agent — Thin Orchestrator over ck: Pipeline"
status: brainstorm-complete
date: 2026-06-24
mode: brainstorm (problem-first)
---

# Brainstorm: `/product` — Product Partner Orchestrator

## Problem Statement

User wants single conversational "product agent": talk vision + expected output → agent
breaks into tasks → routes design work (UI/arch/tech/deploy) to specialists → user reviews
+ approves the solution → agent orchestrates execution. Works on new AND existing products.
Long-term: portable to Codex/Cursor. Now: Claude Code only.

## Problem-First Inversion (user brought a solution)

Stated solution: "build a product agent orchestrator."
Underlying problem: **no single front door + no first-class design-approval gate** over an
orchestration stack the user *already owns ~85% of*.

Key finding: the described pipeline already exists in pieces —
`/lean` → `/ipa:spec` (GATE) → `/ipa:design` (GATE) → `/ck:plan` (validate/red-team gates)
→ `/cook` → `/ship` → `/ck:journal`, plus 15 ck: subagents, Task tools, `/ck:team`,
plans-kanban. Building a new framework = rebuilding owned machinery (YAGNI violation).

Real gaps (the only things worth building):
1. **No single entry point** — user must manually chain `/lean`, `/ipa:spec`, `/ck:plan`, `/cook`.
2. **Design-approval gate not first-class** — `/cook` batch-executes; user wants explicit
   review/approve of the consolidated solution before execution.
3. **Portability conflict** — ck: infra (Task tools, hooks, SendMessage, `/ck:*`) is
   Claude-Code-specific; will not port to Codex/Cursor as-is. Resolved by: Claude-first now,
   keep agent-stack source as clean markdown so portable adapters are cheap later.

## Decisions (locked)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Build strategy | Thin orchestrator over ck: | Reuse owned agents/skills; ship fast; no duplication |
| Portability | Claude-first, portable later | Don't pay portability cost now; keep door open via clean MD |
| Review gate | Approve design once → batch execute | Heavy review where change is cheap; reuse `/cook` as-is |
| Scope | Both modes, new-product first | Prove on greenfield where pipeline is cleanest |
| Vision memory | Reuse `ck_docs/` structure | No new file type; vision graduates into SRD/UI_SPEC |
| Command | `/product` | Obvious single entry point |

## Evaluated Approaches

**A. Thin `/product` skill orchestrating existing ck: building blocks — CHOSEN**
- Pros: smallest new surface; reuses all specialists + gates; ships in days; consistent with
  existing conventions.
- Cons: Claude-Code-specific (accepted); skill must manage stage state.

**B. Dedicated `product-orchestrator` subagent persona** — rejected
- Pros: context isolation.
- Cons: subagents can't cleanly invoke slash skills; extra layer, no benefit here (YAGNI).

**C. Portable-from-scratch (AGENTS.md + generic prompts)** — rejected (now)
- Pros: runs everywhere day one.
- Cons: throws away Task tools/hooks/SendMessage; large rebuild for aspirational requirement.

## Recommended Solution

Single persistent **Product Partner** skill `/product` = router + state machine over a
5-stage pipeline, with ONE human approval gate. Holds vision in `ck_docs/`.

```
YOU talk vision ──► /product (only command invoked)
  STAGE 1 Vision intake   → brainstormer (problem-first)        → ck_docs (vision brief)
  STAGE 2 Task breakdown  → /lean + /ipa:spec (new) | /ck:scout (existing)
  STAGE 3 Solution design → ui-ux-designer + planner(arch) + devops(deploy) → 1 consolidated
                            doc; then /ck:plan (phases, validate/red-team)
  ═══ APPROVAL GATE ═══ user reviews consolidated solution + plan ── the single stop
  STAGE 4 Execute         → /cook (or /ck:team parallel); batch; stops on blocker/gate fail
  STAGE 5 Ship + record   → /ship + /ck:journal
```

### What is NEW (the thin layer — all that gets built)
1. `agent-stack/skills/product/SKILL.md` — front-door router, 5-stage state machine, the
   single approval gate, new-vs-existing branch logic.
2. Vision-memory convention in `ck_docs/` — agent reads existing IPA docs as product memory;
   if none exist yet, captures a short vision brief that graduates into `SRD.md` via `/ipa:spec`.
3. **Install step** — agent-stack = version-controlled source of truth; symlink/copy
   `skills/product/` into `~/.claude/skills/product/` so it is live.

### What is REUSED unchanged
All ck: subagents (brainstormer, planner, ui-ux-designer, devops, fullstack-developer,
code-reviewer, tester, project-manager, git-manager, journal-writer); `/lean`, `/ipa:*`,
`/ck:plan` + validate/red-team, `/cook`, `/ck:team`, `/ship`, `/ck:journal`; Task tools;
plans-kanban; existing hooks (scout-block, cook-after-plan-reminder).

## Implementation Considerations & Risks

- **State across stages**: skill must track current stage + product target. Use session-state
  + ck_docs presence as source of truth (avoid new state store — KISS).
- **New vs existing branch**: Stage 2 forks — new → `/lean`+`/ipa:spec`; existing → `/ck:scout`
  + read existing ck_docs before any design.
- **Consolidation risk**: Stage 3 spawns multiple specialists; need ONE merged solution doc,
  not N fragments. Orchestrator owns the merge.
- **Gate enforcement**: must HARD-STOP after Stage 3 for approval before `/cook`. Mirror
  existing IPA GATE pattern.
- **Install drift**: symlink (not copy) so editing agent-stack updates the live skill; document
  install in agent-stack README.
- **Portability debt (deferred)**: keep SKILL.md logic declarative; isolate Claude-specific
  calls so a future Codex/Cursor adapter can swap the execution backend.

## Success Metrics / Validation

- One command (`/product`) takes a vision from conversation → approved plan → shipped increment
  with no manual chaining of `/lean`/`/ipa`/`/ck:plan`/`/cook`.
- Exactly one human approval stop (post-design), then autonomous execution to ship.
- Works on a new product end-to-end (primary acceptance) and resumes an existing product from
  its `ck_docs/`.
- Zero duplication of existing ck: agent/skill logic (orchestrator only routes + gates).

## Next Steps / Dependencies

1. `/ck:plan` this design → phases (skill scaffold → stage routing → gate → install → e2e test).
2. Dependency: existing ck: skills remain stable (they are).
3. Defer: portable adapter spec for Codex/Cursor (separate later brainstorm).

## Open Questions (for plan stage)

- Symlink vs copy-on-install mechanism + how user triggers install.
- Whether Stage 3 specialist fan-out uses `/ck:team` (parallel sessions) or sequential
  subagent spawns for v1 (lean toward sequential for v1 simplicity).
