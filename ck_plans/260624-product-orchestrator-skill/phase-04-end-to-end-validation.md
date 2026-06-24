---
phase: 4
title: End-to-End Validation
status: in-progress
priority: P2
dependencies:
  - 3
effort: 2h
---

# Phase 4: End-to-End Validation

## Overview

Dogfood `/product` on a throwaway new product to prove the single-command flow and single gate
work, confirm plugin-vs-symlink invocation, then verify the existing-product resume path. This is
the acceptance phase.

## Requirements

- Functional: full pipeline runs from one command with exactly one human stop; both modes work.
- Non-functional: no ck: duplication regressions; install paths reproducible.

## Architecture

Two validation tracks against a scratch repo (e.g. `/private/tmp/.../product-e2e/`):

1. **New-product track:** `/product "build a tiny URL shortener"` → confirm Stage 1 vision brief →
   Stage 2 `/lean` + `/ipa:spec` → Stage 3 specialists + consolidated `solution-design.md` +
   `/ck:plan` → **approval gate stops** → Approve → `/cook` runs → ship/journal offered.
2. **Existing-product track:** re-invoke `/product` in the same repo after docs exist → confirm it
   reloads `ck_docs/`, reports correct later stage via `/product status`, and routes onward.

## Related Code Files

- Create (scratch, disposable): e2e test product under scratchpad/tmp
- Modify (if defects found): `plugins/product/skills/product/SKILL.md`
- Modify (if defects found): `README.md`, `marketplace.json`, `plugin.json`

## Implementation Steps

1. Fresh install check: `/plugin marketplace add` + `/plugin install product@agent-stack`; record the exact invoked command name (`/product` vs `/product:product`). If namespaced, document it in README and/or rely on dev-symlink for clean `/product`.
2. Run new-product track end-to-end; at each stage confirm the right ck: skill was delegated to (not re-implemented).
3. Assert the approval gate HARD-STOPS — attempt to confirm `/cook` is NOT called pre-approval.
4. Approve and confirm batch execution proceeds with no per-task stops.
5. Run existing-product track; confirm `ck_docs/` reload + correct stage detection via `/product status`.
6. Capture defects → fix in SKILL.md → re-run affected track.
7. Update `agent-stack/README.md` with a verified quick-start (install → first `/product` run).

## Success Criteria

- [ ] New-product run completes vision → approved plan → execution with exactly ONE human stop.
- [ ] Existing-product run reloads context and routes to the correct stage.
- [ ] Plugin install path verified; actual invocation name documented.
- [ ] Approval gate confirmed un-bypassable.
- [ ] No ck: skill logic was duplicated (spot-check delegations).
- [ ] README quick-start reproduces a working install.

## Risk Assessment

- **E2E pollutes real repos**: mitigation — run in a disposable scratch dir only.
- **Long run / token cost**: mitigation — use a deliberately tiny product (URL shortener) to keep the pipeline short.
- **Hidden coupling to ck: internals**: if a ck: skill changed, document the assumed contract in README so future breakage is diagnosable.
