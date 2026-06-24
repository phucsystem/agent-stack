# agent-stack

Personal **agent stack** for coding and product development — one installable umbrella plugin that
bundles many skills, agents, and commands. Install once, update the whole stack.

Today it ships:

- **`/product`** — a front-door orchestrator that turns a product vision into an approved design and
  a shipped increment, with exactly one human design-approval gate.
- **`prototyper`** agent + **`/prototype`** skill — builds self-contained, clickable HTML prototypes
  for design review before any real code is written.

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

## Usage

```
/product "<vision text>"   # start a new product, or continue the current one
/product resume            # reload context from agent_docs/ and route to the next stage
/product status            # report detected stage + next action (read-only)

/prototype "<screens>"     # build/refresh clickable HTML mockups under agent_docs/prototypes/
```

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

## Layout

```
agent-stack/
├── .claude-plugin/
│   ├── marketplace.json      # lists one plugin "agent-stack" (source ".")
│   └── plugin.json           # the umbrella plugin manifest
├── skills/
│   ├── product/SKILL.md      # the /product orchestrator
│   └── prototype/SKILL.md    # the /prototype skill
├── agents/
│   └── prototyper.md         # the prototyper agent
├── scripts/dev-symlink.sh    # dev install (links all skills + agents)
├── CLAUDE.md                 # harness pointer + change history
├── docs/journals/            # session journals
├── ck_docs/                  # this stack's own brainstorm (meta build artifact)
└── ck_plans/                 # this stack's own plan (meta build artifact)
```

> `ck_docs/`/`ck_plans/` here are the stack's *own* design docs (meta). Runtime product work uses the
> `agent_docs/`/`agent_plans/` convention above. Neither belongs in a brand/client repo's PR.

## Roadmap

- **v0.2.0 (now)** — umbrella plugin; `/product` orchestrator; `prototyper` agent + `/prototype`
  skill; `agent_docs/`/`agent_plans/` convention.
- **Next** — more skills/agents/commands added to the stack; live end-to-end dogfood.
- **v2** — parallel Stage-3 fan-out via `/ck:team`; portable adapters for Codex / Cursor (source kept
  as clean markdown to make these cheap to add).

## Status

v0.2.0 — Claude Code only. Portability deferred by design.
