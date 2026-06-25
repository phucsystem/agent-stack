# agent-stack — Harness

## Harness: Product Development Stack

**Goal:** One front door (`/product`) drives a product from vision → approved design → shipped
increment; a `prototyper` agent produces clickable HTML mockups for the design review.

**Trigger:** For product-development work (new or existing product, "build X", plan a feature,
prototype a screen), use the **`/product`** orchestrator skill. Prototype-only requests → the
**`/prototype`** skill or the **`prototyper`** agent. Simple questions: answer directly.

**Output convention:** all runtime outputs go under **`agent_docs/`** (docs + `agent_docs/prototypes/`
for HTML) and **`agent_plans/`** (implementation plans). Never scatter outputs elsewhere.

## Harness: Solution Delivery

**Goal:** Own a business or technical challenge from root cause → design (with diagram) → implementation
→ verified output. The `solution-architect` is the accountable owner; it leads an agent team and signs
off on verification itself.

**Trigger:** For ambiguous, cross-cutting, or recurring problems where "what should we actually build,
and does it truly work?" matters, use the **`/solution-architect`** orchestrator skill. Also for
follow-ups: "dig deeper", "re-verify", "the fix didn't hold", "why does this keep happening". Simple
one-line edits: do them directly.

**Two peer team leads — one per engagement.** `/product` owns *what to build and why* (product framing,
scope, the human approval gate); `/solution-architect` owns *how it's built and proven* (root-cause →
design → implementation → verification). Pick the lead by where the risk lives — unclear problem/scope →
`/product` leads; hard/unproven delivery → `/solution-architect` leads — and the other contributes.
Never run both as leads of the same team.

**Hard gate:** `/solution-architect` produces a solution **design spec with a diagram** (Mermaid by
default) and gets the **human's Approve/Revise/Abort** on it before any implementation begins — the one
human stop, mirroring `/product`.

## Harness: Monetization Consultant

**Goal:** Review a product — new or existing — and produce a decision-grade plan to earn, and
sustainably grow, profit: pricing, packaging, revenue model, unit economics, and growth levers.

**Trigger:** For monetization work ("how do I make money from X", "monetize", pricing/packaging
strategy, "is this profitable", "grow revenue/profit sustainably", "business/revenue model"), use the
**`/monetization-consultant`** orchestrator skill. Follow-ups ("re-run the analysis", "redo just the
pricing") route as partial re-runs. Quick one-off pricing/economics questions: answer directly.

**Team (5 specialists, agent-team mode):** `product-strategist` (discovery + frame NEW_PRODUCT vs
GROW_EXISTING) → `market-research-analyst` (WTP, competitor pricing, guardrails) → `pricing-architect`
(value metric, model, packaging) → `unit-economics-analyst` (CAC/LTV/margins/breakeven; **its verdict
gates the pricing model**) → `growth-strategist` (retention → expansion → acquisition efficiency →
pricing-over-time, anchored to the binding constraint). Output: `monetizer-analysis/monetization-strategy.md`.

**Structure:** single umbrella plugin (`.claude-plugin/`), auto-discovered `skills/`, `agents/`,
`commands/`. Install/update the whole stack at once. Dev: `bash scripts/dev-symlink.sh`.

> Note: the repo's own `ck_docs/` and `ck_plans/` hold the *meta* build artifacts of this stack
> (its brainstorm + plan), distinct from the `agent_docs/`/`agent_plans/` runtime convention above.

**Versioning:** SemVer (pre-1.0: `feat` → minor, `fix`/`docs`/`chore` → patch). Version lives in
`plugin.json`, `marketplace.json`, and README — **never hand-edit these**.

Releases are **merge-driven**: merging a PR into `main` runs `.github/workflows/bump.yml`, which derives
the level from the PR title (`feat`→minor, `type!:`/`BREAKING CHANGE`→major, else patch) and runs
`scripts/bump.sh` (syncs version fields, rolls `CHANGELOG.md`, commits `chore(release): vX.Y.Z`, tags,
pushes). The pushed `v*` tag then triggers `release.yml` to publish the GitHub Release. **Skip a release**
by putting `skip-bump` in the PR title, body, or a `skip-bump` label. Record user-facing changes under
`## [Unreleased]` in `CHANGELOG.md` as you work; the bump promotes them.

`scripts/bump.sh <major|minor|patch>` remains the manual escape hatch (run locally) and is the single
source of truth the CI reuses. **Setup:** `bump.yml` requires a `RELEASE_TOKEN` repo secret (a PAT) —
the default `GITHUB_TOKEN` can neither push to protected `main` nor trigger `release.yml` on the tag.

**Change history:**

| Date | Change | Target | Reason |
|------|--------|--------|--------|
| 2026-06-24 | Initial harness: `/product` orchestrator over the ck: pipeline | skills/product | - |
| 2026-06-25 | Add `prototyper` agent + `prototype` skill; wire into `/product` Stage 3 | agents/prototyper, skills/prototype, skills/product | user: prototype HTML under prototypes folder, collab with product |
| 2026-06-25 | Restructure to single umbrella plugin (was plugin `product`) | .claude-plugin, skills/, agents/ | user: agent-stack is one installable stack of many skills/agents/commands |
| 2026-06-25 | Adopt `agent_docs/` + `agent_plans/` output convention | skills/product, skills/prototype, agents/prototyper | user: all agent outputs under agent_docs/agent_plans |
| 2026-06-25 | Add `product` agent persona (orchestrator stays the skill) | agents/product, skills/product | user: build a product agent; persona "who" + skill "how" (a pure agent can't drive the slash pipeline/gate) |
| 2026-06-25 | Dependency preflight + graceful-degradation fallbacks; README Prerequisites | skills/product, skills/prototype, README | user: handle installs without the ClaudeKit/IPA toolchain (A+B — declare/detect + degrade) |
| 2026-06-25 | Version management: bump script + CHANGELOG + tag-triggered release workflow | scripts/bump.sh, CHANGELOG.md, .github/workflows/release.yml | user: proper version management on GitHub main |
| 2026-06-25 | Add `solution-architect` agent + `/solution-architect` orchestrator (root-cause → design → build → verify, owns verification) | agents/solution-architect, skills/solution-architect | user: solution architect that digs to root cause, coordinates other agents, owns verification |
| 2026-06-25 | Make `product` + `solution-architect` peer team leads | agents/product, agents/solution-architect, skills/solution-architect | user: product manager and solution architect are both team leads that manage/spin up teams |
| 2026-06-25 | Gate 2 requires a design spec with diagram before implementation | agents/solution-architect, skills/solution-architect | user: solution architect must provide design specs with diagram before implementation |
| 2026-06-25 | Add human Approve/Revise/Abort gate on the design spec before Gate 3 | agents/solution-architect, skills/solution-architect | user: yes (mirror /product's one human stop) |
| 2026-06-25 | Merge-driven releases: `bump.yml` bumps on PR merge (level from PR title), `skip-bump` opts out; needs `RELEASE_TOKEN` PAT | .github/workflows/bump.yml | user: trigger release by merging a PR, skip when PR says skip-bump |
| 2026-06-25 | Add monetization-consultant harness: 5-agent team + `/monetization-consultant` orchestrator + 5 specialist skills (economics gates pricing; sustainability is the bar) | agents/{product-strategist,market-research-analyst,pricing-architect,unit-economics-analyst,growth-strategist}, skills/{monetization-consultant,product-discovery,market-pricing-research,pricing-model-design,unit-economics,sustainable-growth} | user: monetizer consultant — review a product and grow profit sustainably |
| 2026-06-25 | Add plugin update + uninstall guide (plugin and dev-symlink modes) | README | user: add guideline to update and uninstall plugin |
