---
title: /product Orchestrator Skill
description: >-
  Thin /product front-door skill that orchestrates the existing ck: pipeline
  with one design-approval gate, packaged as a Claude Code plugin.
status: in-progress
priority: P2
branch: main
tags:
  - agent-stack
  - orchestration
  - skill
  - plugin
blockedBy: []
blocks: []
created: '2026-06-24T13:18:15.341Z'
createdBy: 'ck:plan'
source: skill
---

# /product Orchestrator Skill

## Overview

Build `/product` — a single conversational front door over the existing ck: pipeline. User talks
vision → skill routes through 5 stages (vision intake → task breakdown → solution design →
**single approval gate** → batch execute → ship), composing owned ck: agents/skills with **zero
duplication**. Source of truth lives in `agent-stack/`, packaged as a **Claude Code plugin**
(marketplace + plugin manifest) for install, with a dev symlink fallback for fast iteration.

**Locked decisions** (from brainstorm `ck_docs/brainstorm-260624-product-agent.md`):
thin orchestrator over ck: · Claude-first (portable later) · approve-design-then-batch-execute ·
both modes, new-product first · vision memory reuses `ck_docs/` · command `/product`.

**Resolved open questions:** install primary = Claude Code plugin (marketplace add + plugin
install); dev fallback = symlink. Stage-3 specialist fan-out = **sequential** for v1 (`/ck:team`
parallel deferred).

## Acceptance Criteria

- [ ] `/product` invokable after plugin install; one command drives vision → approved plan → shipped increment with no manual chaining of `/lean`/`/ipa`/`/ck:plan`/`/cook`.
- [ ] Exactly ONE human approval stop (post-design), then autonomous execution.
- [ ] New-product path works end-to-end; existing-product path resumes from `ck_docs/`.
- [ ] Zero duplication of ck: agent/skill logic — orchestrator only routes + gates.
- [ ] agent-stack installs as a Claude Code plugin via documented commands.

## Phases

| Phase | Name | Status |
|-------|------|--------|
| 1 | [Scaffold & Install](./phase-01-scaffold-install.md) | Completed |
| 2 | [Stage Routing & Vision Memory](./phase-02-stage-routing-vision-memory.md) | Completed |
| 3 | [Design Consolidation & Approval Gate](./phase-03-design-consolidation-approval-gate.md) | Completed |
| 4 | [End-to-End Validation](./phase-04-end-to-end-validation.md) | In Progress |

## Dependencies

- **External (stable):** existing ck: skills/agents — `/lean`, `/ipa:*`, `/ck:plan`, `/cook`, `/ck:scout`, `/ship`, `/ck:journal`, and subagents (brainstormer, planner, ui-ux-designer, devops, etc.). Treated as a stable contract; not modified.
- **Tooling:** `ck` CLI v4.5.0 (present); Claude Code plugin system (`/plugin`).
- **Sequential:** Phase 1 → 2 → 3 → 4 (each builds on prior).
- **No cross-plan blockers** (agent-stack repo is greenfield).
