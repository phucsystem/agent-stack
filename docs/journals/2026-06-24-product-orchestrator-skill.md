# Product Orchestrator Skill: Avoiding the Rewrite Trap

**Date**: 2026-06-24 14:30
**Severity**: Medium
**Component**: agent-stack/plugins/product, .claude-plugin/
**Status**: Committed (feat/product-orchestrator-skill, f661355), not pushed

## What Happened

Started the session wanting to build a unified "product agent" front door for the ck ecosystem. Initial instinct: write a new framework to unify design, planning, execution, and shipping. Quickly realized we already own 85% of that pipeline across ~15 subagents and 7+ skills. Real problem wasn't missing orchestration—it was missing a *single entry point* and a *first-class design approval gate*.

Pivoted to a thin orchestrator pattern: delegate to existing skills, add nothing redundant, keep it portable (markdown source, Claude-first, deferred Codex/Cursor). Mid-session, user asked to package as a Claude Code plugin, so restructured agent-stack as a marketplace.

Delivered: `.claude-plugin/marketplace.json`, `plugins/product/` with full SKILL.md, validated plugin and skill JSON, dev-symlink install, README with both paths.

## The Brutal Truth

Almost wasted a week building a new router when we already had one. The temptation to "improve" the ecosystem by centralizing all subagent logic was strong and completely backwards. We have good, modular skills that work. The value wasn't more machinery—it was a clean entry point.

The risk that kept me honest: if /product duplicates logic from /plan or /cook, we own *two systems* shipping the same behavior. Bugs in one don't sync to the other. Maintenance becomes a nightmare. That fear killed every idea to "improve" the existing skills.

The plugin marketplace pivot felt chaotic mid-session but was actually correct: if we're building for portability, the plugin model forces cleaner boundaries and makes the marketplace real, not aspirational.

## Technical Details

**Skill routing verified against live registry:**
- `/lean` → SRD + GATE 1
- `/ipa:spec` → UI_SPEC + GATE 2
- `/ipa:design` → prototypes + GATE 3
- `/ipa:detail`, `/ipa:validate` → design docs
- `/ck:scout`, `/ck:devops`, `/ck:databases`, `/ck:plan` → research & planning
- `/cook` → implementation
- `/ship` → release
- `/journal` → post-mortem

All verified by name against installed skills in `.claude/skills/`. Zero invocation typos, zero assumptions about skill names.

**Plugin manifests validated:**
```json
// marketplace.json: valid JSON, plugin ref stable
// plugins/product/.claude-plugin/plugin.json: name, version, entrypoint clean
// skills/product/SKILL.md: 5-stage router, delegation pattern explicit
```

**Router logic:**
Vision → Task Breakdown (new-product fork vs. existing-product fork) → Design (sequential specialist fan-out) → **Single HARD-STOP approval** → Batch execute `/cook` → Ship + journal. Approval gate is load-bearing: every design decision gets one human checkpoint before code starts.

**Known wrinkle:** Plugin-mode install may resolve /product as `/product:product` (vendor-namespaced). Dev-symlink install (via `scripts/dev-symlink.sh`) guarantees clean `/product` and is documented as primary for dev.

## What We Tried

1. **Full orchestrator rewrite** (rejected early): Parse every skill, unify error handling, centralize approval logic. Cost: ~3× new code, duplicate state machines, unknown maintenance burden. Benefit: imaginary.

2. **Async task queue**: Considered batch-execute design specs, approval, and code in one shot. Rejected: approval gate needs human time; forcing it async hides the blocking point.

3. **Vision memory in-skill**: Wanted /product to maintain design session state. Rejected: ck_docs/ already does this; replicating state = debugging nightmare.

4. **Monolithic plugin vs. marketplace**: Initially thought one big product plugin. User pivot to marketplace was right: forces modular design, makes registry real, opens path for peer orchestrators.

## Root Cause Analysis

**Why almost built the wrong thing:** Orchestration looks like a coordination problem, so it triggers the "write a coordinator" instinct. But this ecosystem already *has* coordination: task-based routing, skill delegation, approval gates. The real problem was naming and discoverability. That's a UX problem, not an architecture problem.

**Why plugin marketplace won out:** Makes the entry point distributable without changes to Claude Code. Also forces us to articulate what "plugin" means: a skill + manifests + dev tooling. Clarifying that contract up front beats discovering it in v2 after Codex adapters break.

**Why the approval gate is non-negotiable:** Any "execute on approval" system without a human-readable, *stoppable* checkpoint is shipping faster-to-bug. Putting it front and center in the router (Stage 4) makes it impossible to bypass. It's the only part of this that should be opinionated.

## Lessons Learned

1. **Check what you own before building.** The first question should be "what exists?" not "what should exist?" This team already solved orchestration, planning, execution, and shipping. We just needed a door.

2. **Delegation patterns are load-bearing.** The /product skill's entire value is that it knows which skill to call and when. If that routing is wrong, everything downstream fails silently. Verify every invocation name against the live registry.

3. **Portability constraints clarify design.** "Make it work in Codex later" is vague. "Use markdown sources + manifests" is concrete. The plugin model gave us that constraint for free.

4. **Approval gates don't scale horizontally.** Don't try to make approval async or hidden. It's a human-time bottleneck; make it visible, make it stoppable, make it early.

5. **Wrinkles in plugin namespacing are acceptable.** `/product:product` is ugly but not wrong. Dev-symlink is the real path for clean UX; plugin fallback is fine. Document both, don't try to hide the machinery.

## Next Steps

- **Phase 4 (deferred):** End-to-end dogfood. Run `/product new-feature` on a real feature request, capture failures, iterate the router.
- **v2 (deferred):** Parallel /ck:team fan-out in Stage 3 (design phase). Currently sequential; allow cross-team specialist parallelism if available.
- **Portability (v2+):** Codex/Cursor adapters. Plugin manifests are environment-agnostic; entry point adapters come later.
- **Marketplace:** Audit any peer orchestrators added; ensure delegation patterns stay clean.

**Owner:** Product Orchestrator skill maintenance tied to /ck:plan, /cook, /ship churn.  
**Timeline:** Phase 4 (manual dogfood) before merge; no timeline constraint on v2.

---

**Status:** Committed (feat/product-orchestrator-skill, f661355)  
**Summary:** Avoided rewriting 85% of the pipeline by recognizing the problem was a missing entry point, not missing orchestration. Delivered thin delegator + plugin marketplace + verified skill routing. Load-bearing: approval gate is non-negotiable; all delegations verified against live registry.
