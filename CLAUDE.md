# agent-stack — Harness

## Harness: Product Development Stack

**Goal:** One front door (`/product`) drives a product from vision → approved design → shipped
increment; a `prototyper` agent produces clickable HTML mockups for the design review.

**Trigger:** For product-development work (new or existing product, "build X", plan a feature,
prototype a screen), use the **`/product`** orchestrator skill. Prototype-only requests → the
**`/prototype`** skill or the **`prototyper`** agent. Simple questions: answer directly.

**Output convention:** all runtime outputs go under **`agent_docs/`** (docs + `agent_docs/prototypes/`
for HTML) and **`agent_plans/`** (implementation plans). Never scatter outputs elsewhere.

**Structure:** single umbrella plugin (`.claude-plugin/`), auto-discovered `skills/`, `agents/`,
`commands/`. Install/update the whole stack at once. Dev: `bash scripts/dev-symlink.sh`.

> Note: the repo's own `ck_docs/` and `ck_plans/` hold the *meta* build artifacts of this stack
> (its brainstorm + plan), distinct from the `agent_docs/`/`agent_plans/` runtime convention above.

**Change history:**

| Date | Change | Target | Reason |
|------|--------|--------|--------|
| 2026-06-24 | Initial harness: `/product` orchestrator over the ck: pipeline | skills/product | - |
| 2026-06-25 | Add `prototyper` agent + `prototype` skill; wire into `/product` Stage 3 | agents/prototyper, skills/prototype, skills/product | user: prototype HTML under prototypes folder, collab with product |
| 2026-06-25 | Restructure to single umbrella plugin (was plugin `product`) | .claude-plugin, skills/, agents/ | user: agent-stack is one installable stack of many skills/agents/commands |
| 2026-06-25 | Adopt `agent_docs/` + `agent_plans/` output convention | skills/product, skills/prototype, agents/prototyper | user: all agent outputs under agent_docs/agent_plans |
| 2026-06-25 | Add `product` agent persona (orchestrator stays the skill) | agents/product, skills/product | user: build a product agent; persona "who" + skill "how" (a pure agent can't drive the slash pipeline/gate) |
| 2026-06-25 | Dependency preflight + graceful-degradation fallbacks; README Prerequisites | skills/product, skills/prototype, README | user: handle installs without the ClaudeKit/IPA toolchain (A+B — declare/detect + degrade) |
