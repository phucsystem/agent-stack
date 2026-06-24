---
phase: 1
title: Scaffold & Install
status: completed
priority: P1
dependencies: []
effort: 2h
---

# Phase 1: Scaffold & Install (Claude Code Plugin)

## Overview

Structure `agent-stack/` as a Claude Code plugin marketplace, scaffold the `product` plugin and
empty `/product` SKILL.md shell, and document install. Output: `/product` resolvable in a Claude
Code session.

## Requirements

- Functional: agent-stack installs as a Claude Code plugin; `/product` skill is discoverable.
- Non-functional: clean markdown source (portability-friendly); single source of truth; dev
  iteration without reinstall.

## Architecture

Claude Code plugin model (confirmed against `~/.claude/plugins/marketplaces/compound-engineering-plugin`):
a marketplace repo holds `.claude-plugin/marketplace.json` listing plugins; each plugin has a
manifest and `skills/` dir. Target layout:

```
agent-stack/
├── .claude-plugin/
│   └── marketplace.json        # marketplace: lists the "product" plugin, source ./plugins/product
├── plugins/
│   └── product/
│       ├── .claude-plugin/
│       │   └── plugin.json      # plugin manifest (name, version, description, author)
│       └── skills/
│           └── product/
│               └── SKILL.md     # the /product front door (body filled in Phase 2-3)
├── scripts/
│   └── dev-symlink.sh           # dev fallback: symlink skill into ~/.claude/skills/product
├── ck_docs/                     # brainstorm + (later) project vision docs
└── README.md                    # install guideline (plugin primary, symlink fallback)
```

### Invocation namespacing (decision)

Plugin skills resolve as `plugin:skill` (e.g. `compound-engineering:ce-brainstorm`). Plugin named
`product` + skill named `product` → invoked as `/product` (single-segment when names match) or
`/product:product`. To guarantee a clean `/product`, the dev-symlink fallback installs the skill at
user level (`~/.claude/skills/product/`) → always `/product`. Risk tracked below; verified in Phase 4.

## Related Code Files

- Create: `.claude-plugin/marketplace.json`
- Create: `plugins/product/.claude-plugin/plugin.json`
- Create: `plugins/product/skills/product/SKILL.md` (frontmatter + section headers only; body in later phases)
- Create: `scripts/dev-symlink.sh`
- Create: `README.md`

## Implementation Steps

1. Write `marketplace.json`: `name: "agent-stack"`, owner, metadata.version, `plugins: [{name:"product", description, source:"./plugins/product", tags}]`.
2. Write `plugin.json`: `name: "product"`, version `0.1.0`, description, author, homepage.
3. Scaffold `SKILL.md` frontmatter matching ck convention (`name: product`, `description`, `user-invocable: true`, `when_to_use`, `category`, `keywords`, `argument-hint: "[vision | resume | status]"`, `metadata.version`). Add empty section headers: `## Stages`, `## Stage Routing`, `## Approval Gate` (filled Phase 2-3).
4. Write `scripts/dev-symlink.sh`: `ln -sfn "$PWD/plugins/product/skills/product" "$HOME/.claude/skills/product"` with existence/overwrite guard + echo confirmation.
5. Write `README.md` install guideline (both paths):
   - **Plugin (primary):** `/plugin marketplace add /Users/phuc/Code/04-llms/agent-stack` → `/plugin install product@agent-stack` → restart/`/plugin` to confirm. Note git-URL form for cross-machine.
   - **Dev symlink (fallback):** `bash scripts/dev-symlink.sh` → `/product` live, edits apply without reinstall.
6. Validate JSON: `cat .claude-plugin/marketplace.json | python3 -m json.tool` and same for `plugin.json`.

## Success Criteria

- [ ] `marketplace.json` + `plugin.json` valid JSON, lint-clean.
- [ ] `/plugin marketplace add <agent-stack path>` succeeds and lists the `product` plugin.
- [ ] `/plugin install product@agent-stack` succeeds; skill appears in skill list.
- [ ] `bash scripts/dev-symlink.sh` creates `~/.claude/skills/product` symlink; `/product` resolves.
- [ ] README documents both install paths with exact commands.

## Risk Assessment

- **Namespacing** (`/product` vs `/product:product`): mitigate via dev-symlink user-level install for clean name; confirm plugin-mode invoked name in Phase 4 and document whichever the system reports.
- **Plugin caching**: installed plugins are copied to cache; edits to source may need reinstall. Mitigation: dev-symlink is the iteration path; plugin install is the distribution path. State this in README.
- **Absolute path in README**: machine-specific; also document git-URL marketplace form for portability.
