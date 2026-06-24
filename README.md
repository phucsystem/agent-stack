# agent-stack

Personal agent stack for coding and product development. Ships a single front-door skill,
**`/product`**, that turns a product vision into an approved plan and a shipped increment by
orchestrating an existing development pipeline — with exactly one human design-approval gate.

> **Design rationale:** `ck_docs/brainstorm-260624-product-agent.md`
> **Implementation plan:** `ck_plans/260624-product-orchestrator-skill/`

---

## Why this exists

The development pipeline already existed in pieces (`/lean`, `/ipa:*`, `/ck:plan`, `/ck:cook`,
`/ck:ship` + specialist subagents). What was missing was **a single front door** and **one
first-class design-approval gate**. `/product` is the thin layer that supplies both — it does not
re-implement any of the underlying tools.

It is a **router + gatekeeper**, not an implementer: it delegates real work to existing skills and
never duplicates them.

## How it works

You talk vision; `/product` routes the rest through five stages with a single human stop:

```
/product "build X"
  Stage 1  Vision intake    → capture a vision brief in ck_docs/
  Stage 2  Task breakdown   → /lean + /ipa:spec  (new)  |  /ck:scout  (existing)
  Stage 3  Solution design  → specialists → ONE ck_docs/solution-design.md → /ck:plan
  ◆ APPROVAL GATE ◆         → you review + approve         (the only stop)
  Stage 4  Execute          → /ck:cook   (batch; stops only on blockers)
  Stage 5  Ship & record    → /ck:ship + /ck:journal
```

**Stage detection is filesystem-derived** — no bespoke state store. On each invocation `/product`
reads `ck_docs/` to reload product context and infers which stage you're in (vision brief present?
`SRD.md` present? active plan? plan completed?), then routes accordingly.

**Vision memory** lives in `ck_docs/`: Stage 1 writes a short `product-vision.md` that graduates
into `SRD.md` once `/ipa:spec` runs — so the product's intent persists across sessions.

## Usage

```
/product "<vision text>"   # start a new product, or continue the current one with new direction
/product resume            # reload context from ck_docs/ and route to the next stage
/product status            # report detected stage + next action (read-only, makes no changes)
```

**Example walkthrough (new product):**

1. `/product "build a tiny URL shortener"` → Stage 1 captures the vision brief, confirms with you.
2. Stage 2 runs `/lean` then `/ipa:spec` → produces `SRD.md` + `UI_SPEC.md`.
3. Stage 3 spawns design specialists (UI, architecture, deploy as needed), merges them into one
   `ck_docs/solution-design.md`, then runs `/ck:plan` for the phased plan.
4. **Approval gate:** you review the consolidated design + plan → Approve / Revise / Abort.
5. On approve, Stage 4 runs `/ck:cook` to build the whole plan in batch.
6. Stage 5 offers `/ck:ship` + `/ck:journal`.

Existing products skip the greenfield steps: Stage 2 runs `/ck:scout` and reads existing `ck_docs/`
before any design.

## Install

### Option A — Claude Code plugin (primary)

```text
/plugin marketplace add https://github.com/phucsystem/agent-stack
/plugin install product@agent-stack
```

For a local checkout, point the marketplace at the path instead:

```text
/plugin marketplace add /Users/phuc/Code/04-llms/agent-stack
/plugin install product@agent-stack
```

Run `/plugin` to confirm `product` is installed. Plugin skills are namespaced, so the command may
resolve as `/product:product`. For the clean `/product`, use Option B.

> Plugins are copied into Claude's plugin cache on install, so edits to this repo need a reinstall
> to take effect. For active development, use Option B.

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
├── docs/journals/                         # session journals
├── ck_docs/                               # brainstorm + product vision docs (local working folder)
└── ck_plans/                              # implementation plans (local working folder)
```

> `ck_docs/` and `ck_plans/` are **local working folders** — brainstorms, plans, reports. Kept here
> in this personal repo, but never include them in a brand/client repo's PR.

## Roadmap

- **v0.1.0 (now)** — Claude Code only; sequential Stage-3 specialist fan-out; plugin + dev-symlink install.
- **Next** — live end-to-end dogfood (Phase 4 of the plan, currently manual).
- **v2** — parallel Stage-3 fan-out via `/ck:team`; portable adapters for Codex / Cursor (the source
  is kept as clean markdown to make these cheap to add).

## Status

v0.1.0 — Claude Code only. Portability deferred by design.
