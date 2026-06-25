# Changelog

All notable changes to agent-stack are recorded here. Format follows
[Keep a Changelog](https://keepachangelog.com/); versions follow [SemVer](https://semver.org/)
(pre-1.0: `feat` → minor, `fix`/`docs`/`chore` → patch).

Releases are cut with `scripts/bump.sh` — never hand-edit version fields.

## [Unreleased]

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
