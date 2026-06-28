# Changelog

All notable changes to agent-stack are recorded here. Format follows
[Keep a Changelog](https://keepachangelog.com/); versions follow [SemVer](https://semver.org/)
(pre-1.0: `feat` → minor, `fix`/`docs`/`chore` → patch).

Releases are merge-driven (`bump.yml` on PR merge; `scripts/bump.sh` is the manual escape hatch) —
never hand-edit version fields.

## [Unreleased]

### Added
- **Monetization-consultant harness** — `/monetization-consultant` orchestrator that reviews a product
  (new or existing) and produces a decision-grade plan to earn and sustainably grow profit. Runs a
  5-specialist agent team: `product-strategist`, `market-research-analyst`, `pricing-architect`,
  `unit-economics-analyst`, `growth-strategist`, plus their skills (`product-discovery`,
  `market-pricing-research`, `pricing-model-design`, `unit-economics`, `sustainable-growth`). The
  economics verdict gates the pricing model and *sustainable* profit is the bar, not just profitability.
- README **Update** and **Uninstall** guide for both plugin and dev-symlink install modes.
- **Solution-architect ASSESS engagement** — the `solution-architect` now also assesses an *existing or
  proposed* solution, not just delivers new ones. A 3-gate Assessment Track (establish the requirement
  baseline + risk appetite → map & assess across three lenses: requirement-fulfillment, risk introduced,
  broken issues/regressions → verdict FULFILLS / FULFILLS-WITH-RISKS / DOES-NOT-FULFILL + remediation).
  The verdict is the one human stop (Accept / Remediate / Re-assess); *Remediate* flips into a DELIVER
  engagement at the design gate rather than editing silently.

### Changed
- **Solution-architect now treats documentation as a deliverable.** Any change to the software system,
  database schema, API contract, integration, or deployment must be captured in the project's docs
  (delegating to `docs-manager` / `/docs`) before the engagement closes — added to Gate 4's exit
  criteria, the behavioral checklist, and the team roster. Knowledge that lives only in the diff is lost.
- **Both leads now require a pre-implementation impact analysis for changes to existing behavior.**
  Before any code, `solution-architect` (Gate 2) and `/product` (Stage 3) enumerate the impacted
  fields/components/endpoints/consumers, state the regression risk, and name the regression tests that
  already cover it plus the new ones to write first — reviewed at the design/approval gate.
- **`/product` now treats the approved prototypes as the project's baseline (single source of truth).**
  On approval, the prototypes + `solution-design.md` become the baseline of record; every later feature
  must be designed/prototyped to align with it, and any deviation is surfaced as a knowing baseline
  change rather than a silent drift. The `prototyper` conforms new screens to the existing baseline.
- **`/product` adds Stage 5 — Verify: the product leads the team in end-to-end verification before
  ship.** After the build, the product confirms the accepted behavior works fully and with confidence
  (no unexpected behavior) and that the increment matches the approved prototype baseline — mapping
  every success criterion and prototype flow to PASS/FAIL in `agent_docs/verification.md`. Ship (now
  Stage 6) only proceeds on an all-PASS verdict.
- **Solution-architect DELIVER Gate 4 now requires end-to-end verification after the team implements** —
  once the team reports the build done, the architect runs three layers before signing off: tests &
  review → a live end-to-end behavioral run of the integrated solution → boundary checks. "Tests green"
  is no longer accepted as "works as expected"; the verdict must include a live run.
- **Solution-architect DELIVER track now enforces TDD + reviewable slices** — big changes are split into
  small, independently reviewable and testable slices, each driven test-first (gating test → red → green
  → refactor).
- Releases are now **bump-in-PR**: run `scripts/bump.sh <level>` on the PR branch before merge (it
  bumps the version fields, rolls the changelog, and commits — no tag/push). `version-check.yml` fails
  any PR that didn't bump `plugin.json` above `main` (or left `marketplace.json`/`CHANGELOG.md` out of
  sync); `skip-bump` in the PR title/body/label opts out. On merge, `tag-on-merge.yml` pushes the `v*`
  tag, triggering `release.yml`. Requires a `RELEASE_TOKEN` PAT secret. (Replaces the prior
  merge-driven auto-bump `bump.yml`.)

## [0.4.0] - 2026-06-25

### Added
- `solution-architect` agent (`agents/solution-architect.md`) — owns a challenge end-to-end:
  root-cause → design → implementation → verification, and signs off on verification itself.
- `/solution-architect` orchestrator skill (`skills/solution-architect/`) — agent-team execution
  across four gates (Understand → Design → Implement → Verify).

### Changed
- `product` and `solution-architect` are now **peer team leads** — one leads per engagement
  (product owns what/why, solution-architect owns how/proven); never both lead the same team.
- `/solution-architect` Gate 2 requires a **solution design spec with a diagram** (Mermaid by
  default) before any implementation begins.
- `/solution-architect` adds a **human approval gate** (Approve/Revise/Abort) on the design spec
  before implementation — the one human stop, mirroring `/product`.

## [0.3.0] - 2026-06-25

### Added
- `product` agent persona (`agents/product.md`) — the "who"; the `/product` skill remains the "how".
- Dependency **preflight** in `/product` — detects which delegated skills/agents are present.
- README **Prerequisites** section (standalone vs full-toolchain).
- `.gitignore` for local working + runtime folders (`ck_docs/`, `ck_plans/`, `agent_docs/`, `agent_plans/`, `docs/journals/`).
- Support-agents roster table in README.

### Changed
- `/product` Prime Directive → **delegate when available, degrade gracefully**: every delegated step
  has a built-in fallback when the tool is absent.
- `/prototype` now works standalone without `frontend-design` / `ui-ux-pro-max`.

## [0.2.0] - 2026-06-24

### Changed
- Restructured into a single umbrella plugin `agent-stack` (was a single `product` plugin); skills
  auto-discovered from `skills/`, agents from `agents/`.
- Adopted `agent_docs/` + `agent_plans/` output convention.

### Added
- `prototyper` agent + `/prototype` skill for self-contained clickable HTML prototypes.
- `dev-symlink.sh` links all skills + agents; `CLAUDE.md` harness pointer.

## [0.1.0] - 2026-06-24

### Added
- `/product` orchestrator skill (vision → approved design → shipped increment, single approval gate),
  packaged as a Claude Code plugin.
