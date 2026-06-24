---
phase: 2
title: Stage Routing & Vision Memory
status: completed
priority: P1
dependencies:
  - 1
effort: 3h
---

# Phase 2: Stage Routing & Vision Memory

## Overview

Author the SKILL.md body that makes `/product` a stateful router: detect current stage, fork
new-vs-existing product, and persist/read product vision in `ck_docs/`. Covers Stages 1-2 of the
pipeline (vision intake → task breakdown). No new state store — KISS.

## Requirements

- Functional: on invoke, `/product` determines where the product is in the pipeline and routes to
  the correct next ck: skill; new and existing products both supported.
- Non-functional: stage detection is derivable (from `ck_docs/` presence + session), not a bespoke
  database; orchestrator never duplicates ck: logic, only delegates.

## Architecture

**Stage detection (source of truth = filesystem, not custom state):**

| Signal | Inferred stage |
|--------|----------------|
| No `ck_docs/` vision/lean output | Stage 1 — Vision intake |
| Vision brief exists, no `SRD.md` | Stage 2 — Task breakdown |
| `SRD.md`/`UI_SPEC.md` exist, no active `ck_plans/` plan | Stage 3 — Solution design (Phase 3) |
| Active plan exists, `status: pending`/`in-progress` | Stage 4 — Execute (Phase 3) |
| Plan `completed` | Stage 5 — Ship/record (Phase 3) |

**New vs existing fork (Stage 2):**
- New product → `/lean` (MVP cut) then `/ipa:spec` (SRD.md + UI_SPEC.md).
- Existing product → `/ck:scout` + read existing `ck_docs/` BEFORE any design; skip greenfield lean.

**Vision memory (reuses `ck_docs/`):**
- Stage 1 captures a short vision brief into `ck_docs/` (e.g. `ck_docs/product-vision.md`) when no
  IPA docs exist yet; this brief graduates into `SRD.md` once `/ipa:spec` runs. No new file *type* —
  it lives in the existing `ck_docs/` set the IPA flow already owns.
- On every invoke, `/product` reads existing `ck_docs/` first to reload product context ("talk
  mainly with the product agent about the vision").

**Argument modes:** `/product <vision text>` (start/continue), `/product resume` (reload + route to
next stage), `/product status` (report current stage + next action, no side effects).

## Related Code Files

- Modify: `plugins/product/skills/product/SKILL.md` (fill `## Stage Routing`, add `## Vision Memory`, `## Argument Modes`)
- Reference only (not modified): `~/.claude/skills/lean`, `ipa`, `ck-scout`

## Implementation Steps

1. Write `## Stage Routing` section: the detection table above as explicit decision logic the model follows on invoke (read `ck_docs/` → classify → announce detected stage to user).
2. Write the new-vs-existing fork instructions for Stage 2 with exact skill calls (`/lean`, `/ipa:spec`, `/ck:scout`).
3. Write `## Vision Memory`: when/where to capture the vision brief in `ck_docs/`, and the "read ck_docs first" reload rule. Explicitly state it graduates into `SRD.md` (no orphan file).
4. Write `## Argument Modes` (vision / resume / status) with behavior per mode.
5. Add a HARD rule: orchestrator delegates to ck: skills; it MUST NOT re-implement lean/spec/scout logic inline.
6. Add `$ARGUMENTS` capture at top of body (match `ck:ask`/`ck:cook` convention).

## Success Criteria

- [ ] Invoking `/product` with no prior docs routes to Stage 1 and captures a vision brief in `ck_docs/`.
- [ ] Invoking `/product` in a repo with existing `ck_docs/` reloads context and routes to the correct later stage.
- [ ] New-product path calls `/lean` then `/ipa:spec`; existing-product path calls `/ck:scout` first.
- [ ] `/product status` reports detected stage + next action without making changes.
- [ ] SKILL.md contains no duplicated lean/spec/scout logic — only delegation.

## Risk Assessment

- **Misclassified stage**: ambiguous `ck_docs/` state. Mitigation: `/product status` always announces detected stage and asks to confirm before destructive routing.
- **Vision brief orphaning**: brief never graduating into SRD. Mitigation: Stage 2 explicitly migrates/links it; Phase 4 e2e checks the handoff.
