# agent-stack

Personal agent stack for coding and product development. Ships a single front-door skill,
**`/product`**, that turns a product vision into an approved plan and a shipped increment by
orchestrating an existing development pipeline — with exactly one human design-approval gate.

> Design rationale: `ck_docs/brainstorm-260624-product-agent.md`
> Implementation plan: `ck_plans/260624-product-orchestrator-skill/`

## What `/product` does

You talk vision; it routes the rest:

```
/product "build X"
  Stage 1 Vision intake    → capture vision brief
  Stage 2 Task breakdown   → /lean + /ipa:spec (new) | /ck:scout (existing)
  Stage 3 Solution design  → specialists → ONE solution-design.md → /ck:plan
  ◆ APPROVAL GATE ◆        → you review + approve  (the only stop)
  Stage 4 Execute          → /ck:cook (batch)
  Stage 5 Ship & record    → /ck:ship + /ck:journal
```

It is a thin **router + gatekeeper** — it delegates to existing skills and never duplicates them.

## Install

### Option A — Claude Code plugin (primary)

```text
/plugin marketplace add /Users/phuc/Code/04-llms/agent-stack
/plugin install product@agent-stack
```

For another machine, point the marketplace at the git remote instead of the local path:

```text
/plugin marketplace add https://github.com/phuc/agent-stack
/plugin install product@agent-stack
```

Run `/plugin` to confirm `product` is installed. Plugin skills are namespaced, so the command may
resolve as `/product:product`. If you want the clean `/product`, use Option B.

> Plugins are copied into Claude's plugin cache on install, so edits to this repo need a reinstall to
> take effect. For active development, use Option B.

### Option B — dev symlink (clean `/product`, live edits)

```bash
bash scripts/dev-symlink.sh
```

Symlinks the skill into `~/.claude/skills/product`, so `/product` works immediately and every edit
in this repo is live with no reinstall.

## Layout

```
agent-stack/
├── .claude-plugin/marketplace.json        # marketplace listing
├── plugins/product/
│   ├── .claude-plugin/plugin.json         # plugin manifest
│   └── skills/product/SKILL.md            # the /product front door
├── scripts/dev-symlink.sh                 # dev install
├── ck_docs/                               # brainstorm + product vision docs
└── ck_plans/                              # implementation plans
```

## Status

v0.1.0 — Claude Code only. Portable Codex/Cursor adapters are deferred (the source is kept as clean
markdown to make them cheap later).
