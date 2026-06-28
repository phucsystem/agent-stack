# agent-stack — Harness

## Harness: Product Development Stack

**Goal:** One front door (`/product`) drives a product from vision → approved design → built →
**team-led end-to-end verification** → shipped increment; a `prototyper` agent produces clickable HTML
mockups for the design review. The approved prototypes become the project's **baseline** (single
source of truth): every later feature is designed against it and the built increment is accepted only
if it matches that baseline.

**Trigger:** For product-development work (new or existing product, "build X", plan a feature,
prototype a screen), use the **`/product`** orchestrator skill. Prototype-only requests → the
**`/prototype`** skill or the **`prototyper`** agent. Simple questions: answer directly.

**Output convention:** all runtime outputs go under **`agent_docs/`** (docs + `agent_docs/prototypes/`
for HTML) and **`agent_plans/`** (implementation plans). Never scatter outputs elsewhere.

## Harness: Solution Delivery

**Goal:** Own a business or technical challenge end-to-end. Two engagement types: **DELIVER** (root cause →
design with diagram → test-first implementation → verified output) and **ASSESS** (judge an existing or
proposed solution against the business requirements, the risk it introduces, and what it breaks → an
evidence-backed verdict + remediation). The `solution-architect` is the accountable owner; it leads an
agent team and signs off itself.

**Trigger:** For ambiguous, cross-cutting, or recurring problems where "what should we actually build,
and does it truly work?" matters, use the **`/solution-architect`** orchestrator skill. Also for
assessment: "assess this solution", "does this meet the requirements", "review this for risk", "will this
break anything", "is this safe to ship", "audit the solution". And for follow-ups: "dig deeper",
"re-verify", "re-assess", "the fix didn't hold", "why does this keep happening". Simple one-line edits: do
them directly.

**Two peer team leads — one per engagement.** `/product` owns *what to build and why* (product framing,
scope, the human approval gate); `/solution-architect` owns *how it's built and proven* (root-cause →
design → implementation → verification). Pick the lead by where the risk lives — unclear problem/scope →
`/product` leads; hard/unproven delivery → `/solution-architect` leads — and the other contributes.
Never run both as leads of the same team. **Baton-pass ≠ co-leading:** the canonical product flow is a
*sequential* hand-off — PM finalizes spec+prototype → hands to SA for the technical design + risk (SA's
Gate 2) → **PM+SA joint review** of the combined deliverable → **one** human report. One lead holds the
baton at a time; the joint review replaces a second human gate. The `delivery-manager` then tickets the
chain on GitHub **before any implementation** (every feature/bug a ticket for dev + QA), and SA keeps
the system-architecture/code docs current **on every merge request**.

**Hard gate:** DELIVER produces a solution **design spec with a diagram** (Mermaid by default) and gets
the **human's Approve/Revise/Abort** before any implementation begins. ASSESS produces a **verdict**
(FULFILLS / FULFILLS-WITH-RISKS / DOES-NOT-FULFILL) and gets the **human's Accept/Remediate/Re-assess** —
*Remediate* flips into a DELIVER engagement at the design gate (never silent edits). One human stop per
engagement, mirroring `/product`.

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

## Harness: Delivery / GitHub Project Management

**Goal:** Own the GitHub Project board end-to-end: turn an approved plan or feature batch into tracked
issues (tasks), assign each to the implementing agent, drive every ticket across the status lifecycle,
file bug tickets, and report — project/weekly summaries, risk callouts, and a quality report (features
shipped vs bugs introduced per weekly release).

**Trigger:** For GitHub ticket/board work, use the **`/delivery-manager`** orchestrator skill: "init
GitHub project management", "create tickets for this plan", "manage the tickets / progress", "who owns
the tasks", "move this to in review", "weekly project summary", "any risks", "create a bug ticket",
"quality report", "how many features this week / bugs from the release", and follow-ups ("re-batch",
"update/sync the board"). The `delivery-manager` agent owns the board; the `github-project-management`
skill holds the `gh`/Projects-v2 mechanics. Quick one-off `gh` lookups: do them directly.

**Role boundary:** peer to the two leads — `/product` (what/why) and `/solution-architect` (how/proven)
produce the plan; `/delivery-manager` externalizes it onto GitHub and tracks it. One lead owns the
engagement; the delivery-manager owns the ticket lifecycle and reporting. Hand-off is optional and
graceful: if `gh` / a Project isn't available, the leads run on the in-session task list only.

**Structure:** single umbrella plugin (`.claude-plugin/`), auto-discovered `skills/`, `agents/`,
`commands/`. Install/update the whole stack at once. Dev: `bash scripts/dev-symlink.sh`.

> Note: the repo's own `ck_docs/` and `ck_plans/` hold the *meta* build artifacts of this stack
> (its brainstorm + plan), distinct from the `agent_docs/`/`agent_plans/` runtime convention above.

**Versioning:** SemVer (pre-1.0: `feat` → minor, `fix`/`docs`/`chore` → patch). Version lives in
`plugin.json`, `marketplace.json`, and README — **never hand-edit these**.

Releases are **bump-in-PR**: you bump the version manually in each PR *before* merge by running
`scripts/bump.sh <major|minor|patch>` on the branch — it syncs the version fields, rolls `CHANGELOG.md`,
and commits `chore(release): vX.Y.Z` (it does **not** tag or push). `.github/workflows/version-check.yml`
**fails any PR** whose `plugin.json` version isn't strictly above `main` (or whose `marketplace.json` /
`CHANGELOG.md` are out of sync) — **skip** with `skip-bump` in the PR title, body, or a `skip-bump` label.
On merge, `.github/workflows/tag-on-merge.yml` reads the merged version and pushes the `v*` tag, which
triggers `release.yml` to publish the GitHub Release. Record user-facing changes under `## [Unreleased]`
in `CHANGELOG.md` as you work; `bump.sh` promotes them into the new version section.

Choose the bump level yourself (`feat`→minor, breaking→major, else patch). **Setup:** `tag-on-merge.yml`
requires a `RELEASE_TOKEN` repo secret (a PAT) — a tag pushed with the default `GITHUB_TOKEN` would not
trigger `release.yml`.

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
| 2026-06-26 | Add ASSESS engagement type to solution-architect (3-gate track: establish-bar → map+assess across requirement-fulfillment/risk/broken-issues lenses → verdict + Accept/Remediate/Re-assess human stop) | agents/solution-architect, skills/solution-architect | user: solution architect also assesses an existing solution — fulfills business requirements, introduces no risk or broken issues |
| 2026-06-26 | Bake TDD + reviewable-slice discipline into DELIVER Gate 2/3 (split big changes into independently testable slices, gating test first) | agents/solution-architect, skills/solution-architect | user: split big tasks into reviewable/testable pieces; always TDD |
| 2026-06-28 | Strengthen DELIVER Gate 4: after the team implements, the architect runs a 3-layer verification (tests & review → live end-to-end behavioral run → boundary checks) — "tests green" ≠ "works as expected" | agents/solution-architect, skills/solution-architect | user: after leading the team to implement, verify it works as expected |
| 2026-06-28 | `/product`: approved prototypes become the project's **prototype baseline** (source of truth); later features must align to it and surface any deviation as a knowing baseline change; prototyper conforms new screens to the baseline | skills/product, agents/product, agents/prototyper | user: align the prototype chain to the approved prototype baseline; every feature gated by approval |
| 2026-06-28 | `/product`: add **Stage 5 — Verify** (product leads the team end-to-end before ship; accept the increment against the prototype baseline + success criteria with full confidence; ship only on all-PASS) — Ship becomes Stage 6 | skills/product, agents/product | user: product leads team end-to-end verification — no unexpected behavior, accepted behavior 100% confident |
| 2026-06-28 | Both leads: changes to existing behavior require a pre-implementation **impact analysis** (impacted fields/components/consumers + regression risk + guarding tests) reviewed at the design/approval gate before any code | agents/solution-architect, skills/solution-architect, agents/product, skills/product | user: before implementing a change to existing behavior, do impact analysis + regression risk |
| 2026-06-28 | solution-architect: **documentation is a deliverable** — any software-system / DB / API-contract / integration / deployment change must be captured in project docs (delegate `docs-manager`/`/docs`) before the engagement is done; added to Gate 4 exit + checklist + roster | agents/solution-architect, skills/solution-architect | user: docs are part of the architect's deliverables; maintain knowledge across the project |
| 2026-06-28 | Releases switch from merge-driven auto-bump to **bump-in-PR**: `bump.sh` bumps+commits on the branch (no tag/push); `version-check.yml` fails un-bumped PRs (`skip-bump` opts out); `tag-on-merge.yml` tags the merged version → `release.yml` | .github/workflows (bump.yml→version-check.yml + tag-on-merge.yml), scripts/bump.sh | user: bump version manually for every PR before merge |
| 2026-06-29 | Add **Delivery / GitHub PM harness**: `delivery-manager` agent owns a GitHub Project board (plan/feature batch → issues, assign agents, drive lifecycle); `/delivery-manager` orchestrator + `github-project-management` method skill (gh/Projects-v2); wired as optional hand-off from `/product` Stage 4 and `/solution-architect` Gate 3 | agents/delivery-manager, skills/delivery-manager, skills/github-project-management, skills/product, skills/solution-architect | user: init GitHub project management — someone to own tickets, batch features into tasks, manage progress across agents |
| 2026-06-29 | Extend delivery-manager with **reporting + bug tickets + quality report**: project/weekly summary with risk callouts, on-demand bug-ticket creation, and a quality report (features shipped this week vs bugs introduced per weekly release) | agents/delivery-manager, skills/delivery-manager, skills/github-project-management | user: weekly summary + risks, create bug tickets, quality report of features done vs bugs per release |
| 2026-06-29 | `/product` flow rewired to **baton-pass + joint review + single human gate**: PM finalizes spec+prototype → hands to `solution-architect` for technical design + risk (Gate 2) → PM+SA joint review (PM product-acceptance, SA technical veto, dissent surfaced) → one human report | skills/product, agents/product, agents/solution-architect, CLAUDE.md | user: PM finalizes spec+prototype, SA reviews + designs + anticipates risk, both jointly review before reporting to me |
| 2026-06-29 | **Ticket-first hard gate**: after approval and before any implementation, delivery-manager creates GitHub tickets for the chain (every feature/bug a ticket for dev + QA) in both `/product` (Stage 4) and `/solution-architect` (Gate 3) | skills/product, skills/solution-architect, agents/delivery-manager, agents/product | user: every chain linked to a GitHub ticket, created before implementation; everything written down |
| 2026-06-29 | solution-architect accountable for **docs currency per merge request** — system-architecture/code docs land in the same MR as the code, never "docs later" | agents/solution-architect, skills/solution-architect | user: SA keeps all system architecture/code docs up to date for each merge request |
