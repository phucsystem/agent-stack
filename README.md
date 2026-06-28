# agent-stack

Personal **agent stack** for coding and product development — one installable umbrella plugin that
bundles many skills, agents, and commands. Install once, update the whole stack.

Today it ships:

- **`/product`** — a front-door orchestrator that turns a product vision into an approved design and
  a shipped increment, with exactly one human design-approval gate.
- **`prototyper`** agent + **`/prototype`** skill — builds self-contained, clickable HTML prototypes
  for design review before any real code is written.
- **`/monetization-consultant`** — a 5-specialist agent team that reviews a product (new or existing)
  and produces a decision-grade plan to earn, and sustainably grow, profit.

> **Design rationale:** `ck_docs/brainstorm-260624-product-agent.md`
> **Implementation plan:** `ck_plans/260624-product-orchestrator-skill/`

---

## Output convention

Everything the stack's agents produce at runtime lives under two folders in the target product repo:

- **`agent_docs/`** — all docs: vision brief, SRD/UI spec, consolidated solution design, and
  **`agent_docs/prototypes/`** for clickable HTML mockups.
- **`agent_plans/`** — all implementation plans.

## How `/product` works

You talk vision; `/product` routes the rest through five stages with a single human stop:

```
/product "build X"
  Stage 1  Vision intake    → capture a vision brief in agent_docs/
  Stage 2  Task breakdown   → /lean + /ipa:spec  (new)  |  /ck:scout  (existing)
  Stage 3  Solution design  → specialists + prototyper → ONE agent_docs/solution-design.md → /ck:plan
  ◆ APPROVAL GATE ◆         → review design + clickable prototypes, then approve  (the only stop)
  Stage 4  Execute          → /ck:cook   (batch; stops only on blockers)
  Stage 5  Ship & record    → /ck:ship + /ck:journal
```

Stage detection is filesystem-derived (no bespoke state store): `/product` reads `agent_docs/` to
reload context and infers which stage you're in. It is a **router + gatekeeper** — it delegates to
existing skills/agents and never duplicates them.

## The prototyper

During Stage 3, when the solution has a user-facing surface, `/product` delegates to the
**`prototyper`** agent. It produces self-contained `.html` files under `agent_docs/prototypes/` (one
per screen/flow) plus a `README.md` index — openable directly in a browser, no build step. These
become first-class review material at the approval gate. You can also use it standalone via the
**`/prototype`** skill ("prototype a login + dashboard", "update that screen").

## Monetization consultant

`/monetization-consultant` answers two questions: *how should a new product make money?* and *how does
an existing one grow profit sustainably?* It runs a 5-specialist agent team as a pipeline, where each
stage feeds the next:

| Agent | Skill | Owns |
|---|---|---|
| `product-strategist` | `/product-discovery` | Segments, value-capture gap, frame NEW_PRODUCT vs GROW_EXISTING |
| `market-research-analyst` | `/market-pricing-research` | Competitor pricing, willingness-to-pay, price floor/ceiling |
| `pricing-architect` | `/pricing-model-design` | Value metric, revenue model, packaging, tiers |
| `unit-economics-analyst` | `/unit-economics` | CAC/LTV/margins/breakeven — its verdict **gates** the pricing model |
| `growth-strategist` | `/sustainable-growth` | Retention → expansion → acquisition efficiency → pricing-over-time |

Two rules are baked in: **the economics verdict gates pricing** (a model that doesn't pencil out is sent
back for redesign), and **sustainability is the bar** (profit that depends on unrealistic churn/CAC is
marked not-viable). Output lands in `monetizer-analysis/monetization-strategy.md`; follow-ups like
"redo just the pricing" run as partial re-runs. It's the *strategy* layer — pair it with a payment-
integration skill for the *implementation*.

```
/monetization-consultant "how should I make money from <product>?"   # new product
/monetization-consultant "my SaaS profit is flat — how do I grow it sustainably?"   # existing
```

## Usage

```
/product "<vision text>"   # start a new product, or continue the current one
/product resume            # reload context from agent_docs/ and route to the next stage
/product status            # report detected stage + next action (read-only)

/prototype "<screens>"     # build/refresh clickable HTML mockups under agent_docs/prototypes/
```

## Support agents

`/product` is a router — it delegates real work to this roster. It owns the orchestration and the
single approval gate; these do the specialist work.

| Agent / skill | Role | Stage |
|---|---|---|
| `brainstormer` | Probe vision, problem-first framing | 1 — Vision intake |
| `/lean` | MVP scoping (new product) | 2 — Task breakdown |
| `/ipa:spec` | SRD + UI spec (new product) | 2 — Task breakdown |
| `/ck:scout` | Codebase discovery (existing product) | 2 — Task breakdown |
| `prototyper` | Clickable HTML mockups → `agent_docs/prototypes/` | 3 — Solution design |
| `ui-ux-designer` | UI/UX design | 3 — Solution design |
| `planner` | Architecture / technical design | 3 — Solution design |
| `/ck:devops` | Deployment / infra | 3 — Solution design |
| `/ck:databases` | Data / DB design | 3 — Solution design |
| `/ck:plan` | Phased implementation plan → `agent_plans/` | 3 → gate |
| `/ck:cook` | Execute the plan | 4 — Execute |
| `/ck:ship` · `/ck:journal` | Ship + record | 5 — Ship & record |

Only `prototyper` ships in this repo; the rest are existing skills/agents the stack composes.

## Prerequisites

This stack is a thin orchestration layer — it does **not** bundle the tools `/product` delegates to.

- **Standalone (no extra install):** `/prototype` and the `prototyper` agent. They only read/write
  HTML and work on any Claude Code install.
- **`/product` works best with the full toolchain:** [ClaudeKit](https://www.npmjs.com/package/claudekit)
  (`npm i -g claudekit` — provides the `ck` CLI and `/ck:scout|plan|cook|devops|databases|ship|journal`
  + the `planner`/`ui-ux-designer`/`brainstormer` agents) and the IPA/`/lean` skills.

If those are missing, `/product` does **not** fail — it runs in **built-in fallback mode**:
preflight detects which tools are absent, tells you, and substitutes a simpler built-in step for each
(e.g. writes the plan itself instead of calling `/ck:plan`). Install the toolchain for the richer,
gated pipeline; skip it for a lighter standalone run.

## Install

### Option A — Claude Code plugin (primary)

```text
/plugin marketplace add https://github.com/phucsystem/agent-stack
/plugin install agent-stack@agent-stack
```

For a local checkout, point the marketplace at the path instead:

```text
/plugin marketplace add /Users/phuc/Code/04-llms/agent-stack
/plugin install agent-stack@agent-stack
```

One install gives every skill/agent/command in the stack; one update refreshes them all. Plugin
skills are namespaced, so a skill may resolve as `/agent-stack:product`. For clean, un-namespaced
names, use Option B.

> Plugins are copied into Claude's plugin cache on install, so edits to this repo need a reinstall to
> take effect. For active development, use Option B.

### Option B — dev symlink (clean names, live edits)

```bash
bash scripts/dev-symlink.sh
```

Symlinks every skill into `~/.claude/skills/` and every agent into `~/.claude/agents/`, so `/product`,
`/prototype`, and the `prototyper` agent work immediately and every edit in this repo is live with no
reinstall.

### Update

Updating depends on how you installed.

**Plugin mode (Option A)** — plugins are copied into Claude's cache, so an update means refreshing the
marketplace and reinstalling. Easiest via the `/plugin` menu → *Manage plugins* → **Update**, or:

```text
/plugin marketplace update agent-stack
/plugin install agent-stack@agent-stack
```

**Dev-symlink mode (Option B)** — nothing to reinstall; the symlinks point at this repo, so a pull is
the update:

```bash
cd /Users/phuc/Code/04-llms/agent-stack && git pull
```

### Uninstall

**Plugin mode (Option A):**

```text
/plugin uninstall agent-stack@agent-stack
/plugin marketplace remove agent-stack    # optional: also drop the marketplace entry
```

**Dev-symlink mode (Option B)** — remove only the symlinks this stack created (real files and unrelated
symlinks in `~/.claude` are left untouched):

```bash
find ~/.claude/skills ~/.claude/agents -maxdepth 1 -type l -lname '*agent-stack*' -delete
```

## Layout

```
agent-stack/
├── .claude-plugin/
│   ├── marketplace.json      # lists one plugin "agent-stack" (source ".")
│   └── plugin.json           # the umbrella plugin manifest
├── skills/                   # one dir per skill (auto-discovered)
│   ├── product/ prototype/ solution-architect/        # product + delivery harnesses
│   └── monetization-consultant/ product-discovery/ market-pricing-research/
│       pricing-model-design/ unit-economics/ sustainable-growth/   # monetization harness
├── agents/                   # one .md per agent (auto-discovered)
│   ├── product.md prototyper.md solution-architect.md
│   └── product-strategist.md market-research-analyst.md pricing-architect.md
│       unit-economics-analyst.md growth-strategist.md   # monetization team
├── scripts/dev-symlink.sh    # dev install (links all skills + agents)
├── CLAUDE.md                 # harness pointer + change history
├── docs/journals/            # session journals
├── ck_docs/                  # this stack's own brainstorm (meta build artifact)
└── ck_plans/                 # this stack's own plan (meta build artifact)
```

> `ck_docs/`/`ck_plans/` here are the stack's *own* design docs (meta). Runtime product work uses the
> `agent_docs/`/`agent_plans/` convention above. Neither belongs in a brand/client repo's PR.

## Roadmap

- **v0.6.0 (now)** — umbrella plugin; `/product` orchestrator; `prototyper` agent + `/prototype`
  skill; `agent_docs/`/`agent_plans/` convention.
- **Next** — more skills/agents/commands added to the stack; live end-to-end dogfood.
- **v2** — parallel Stage-3 fan-out via `/ck:team`; portable adapters for Codex / Cursor (source kept
  as clean markdown to make these cheap to add).

## Status

v0.6.0 — Claude Code only. Portability deferred by design.
