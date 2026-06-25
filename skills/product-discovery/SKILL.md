---
name: product-discovery
description: Framework for monetization intake — understand a product, its customer segments (payer vs. user), value proposition, the value-created-vs-captured gap, and current monetization state, then frame the engagement as new-product or grow-existing. Used by the product-strategist agent at the start of any monetization consult. Trigger when you need to understand a product before pricing or growing it.
---

# Product Discovery for Monetization

Goal: produce a sharp, shared understanding the rest of the monetization team can build on. The deliverable is `_workspace/01_discovery.md` — decision-grade, not a glossy report.

## Why this comes first

You cannot price or grow what you don't understand. Two errors are fatal downstream: (1) pricing a product whose value is thin or undifferentiated, and (2) targeting a segment that won't or can't pay. Discovery catches both before the team spends effort on them.

## 1. The core job (jobs-to-be-done)

State the one primary job the product gets done for the user, in their terms. "People hire this product to ___." A crisp job statement reveals what the value — and therefore the price — is anchored to. If you can't state it in one sentence, the product's positioning is unclear and that's finding #1.

## 2. Segments — separate payer from user

Map who **uses** the product vs. who **pays** for it (often different: end-user vs. manager vs. procurement). For each candidate segment capture:
- The acuteness of the pain (nice-to-have vs. must-have)
- Whether they have budget / buying authority
- How many of them exist (rough size)

Rank segments by **willingness-to-pay potential** = pain acuteness × budget. The top segment becomes the team's focus; flag it for the market analyst to validate.

## 3. Value proposition + the capture gap

Articulate the measurable outcome the product delivers (time saved, revenue gained, risk reduced, cost avoided). Then name the **value-created-vs-captured gap**: how much value the product creates vs. how much money it currently captures. That gap *is* the monetization opportunity. A large gap = pricing upside; a small or negative gap = a product problem pricing can't fix.

Be honest: if the value is weak, undifferentiated, or unprovable, say so. That's the most important thing you can tell the team.

## 4. Current state

- **Existing product:** how it makes money today (model, price points, what converts, where revenue leaks — churn, discounting, unmonetized usage). This is a teardown.
- **New product:** no monetization yet — describe the opportunity and the nearest analogous models instead.

## 5. Engagement framing (required output)

State explicitly, one line:
- **NEW_PRODUCT** — design a profitable monetization model from scratch, or
- **GROW_EXISTING** — grow sustainable profit on a model that already earns.

This single decision re-weights the entire team's work, so make it unambiguous.

## Output template (`_workspace/01_discovery.md`)

```
# Discovery — <product>
## Core job
## Segments (payer vs user, ranked by WTP potential)
## Value proposition & capture gap
## Current monetization state   [existing]  |  Opportunity framing  [new]
## Engagement type: NEW_PRODUCT | GROW_EXISTING
## Open questions for the team   (WTP anchors to validate, cost/economics unknowns)
```

## Principles

- **Scout before asking.** Read the repo/site/deck/docs the user provided. Ask only for what can't be discovered.
- **Value created ≠ value captured.** Keep them separate; the gap between them is the whole point.
- **A weak value prop is a finding, not something to paper over.** Surface it early.
- Label assumptions. If you must assume, mark it PROVISIONAL and list what would confirm it.
