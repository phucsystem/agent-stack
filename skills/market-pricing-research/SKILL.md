---
name: market-pricing-research
description: Method for researching competitor pricing, market willingness-to-pay, comparable business models, and category benchmarks, then turning findings into defensible pricing guardrails (floor/ceiling). Used by the market-research-analyst agent. Trigger when monetization work needs external market evidence instead of guesswork about what customers will pay.
---

# Market & Pricing Research

Goal: replace the team's assumptions about "what people will pay" with cited evidence, and hand the pricing architect a defensible **floor and ceiling**. Deliverable: `_workspace/02_market.md`.

## 1. Map the competitive pricing landscape

For each direct competitor and close substitute, capture: model (subscription / usage / transaction / one-time / freemium), price points, tier structure, what's bundled at each tier, and the free-tier shape. Use the product's own pricing pages, archived pricing, and review sites. **Cite a URL for every observed price.**

Build a table. Three-plus comparables turn anecdotes into a pattern.

## 2. Estimate willingness-to-pay (WTP)

You rarely get WTP directly, so triangulate from proxies:
- **Surviving competitor prices** — prices that persist in market are prices someone pays.
- **Adjacent spend** — what the target segment already pays for tools solving a related job sets their price expectation. Their budget anchor is *everything they buy*, not just rivals.
- **Voice-of-customer** — reviews/forums complaining "too expensive" or "worth every penny" bracket the acceptable range.
- **Value-based ceiling** — a fraction (commonly 10–25%) of the quantified value the product delivers to the customer.

Produce a WTP **range** per target segment with the evidence behind each bound. Distinguish **observed** (found it) from **inferred** (reasoned it) explicitly.

## 3. Find business-model comparables (including analogues)

Pick 3–5 products whose monetization the team can learn from. Include analogues from *other* industries that solve a similar job for a similar buyer — they often reveal a better model than direct rivals. For each, extract the lesson: *why* their model fits their market (value metric, tier logic, free-to-paid path).

For novel products with no direct comparables, lean entirely on analogues and label the inference.

## 4. Category benchmarks

Gather typical ranges so the team can sanity-check its own numbers: gross margins, free-to-paid conversion, trial conversion, CAC norms, churn norms for the category. These feed the unit-economics analyst.

## 5. Set the guardrails

Synthesize into a **defensible price floor and ceiling** for the pricing architect:
- **Floor** — below this, you're leaving obvious money on the table or signaling low value.
- **Ceiling** — above this, you exit the segment's WTP without exceptional differentiation.

## Output template (`_workspace/02_market.md`)

```
# Market & Pricing Research — <product>
## Competitor / comparable pricing table   (name | model | price points | included | source)
## Willingness-to-pay by segment            (range + evidence; observed vs inferred)
## Business-model comparables               (3–5, each with the lesson)
## Category benchmarks                       (margin, conversion, CAC, churn)
## Pricing guardrails: floor = … / ceiling = …
```

## Principles

- **Cite or label.** Every number is sourced (URL) or marked as an estimate. Never present inferred as observed.
- **Triangulate.** One data point is noise; a cluster plus an adjacent anchor is signal.
- **Honest gaps.** "No reliable data for X" beats a fabricated benchmark — flag thin markets for the team.
- Retry a failed search once with different terms before declaring a finding unavailable.
