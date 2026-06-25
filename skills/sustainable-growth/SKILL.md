---
name: sustainable-growth
description: Framework for growing a product's profit sustainably over time — retention/churn reduction, expansion revenue (upsell/cross-sell/NRR), acquisition efficiency, and pricing optimization — sequenced by leverage and anchored to the binding profit constraint. Used by the growth-strategist agent. Trigger when a monetization consult needs a durable, compounding profit-growth plan rather than one-time gains.
---

# Sustainable Profit Growth

Goal: design how profit **compounds durably**, not how to spike revenue once. Deliverable: `_workspace/05_growth.md` — levers prioritized by leverage and durability, sequenced into a phased roadmap, anchored to the economics analyst's binding constraint.

## The core insight: sequence beats menu

Anyone can list growth tactics. The value is **sequencing by leverage**. The default order, and why:

1. **Stop the leak — retention / churn.** Keeping revenue you already won is the cheapest profit growth there is, and because LTV = 1/churn, reducing churn compounds everything else. Acquiring into a leaky bucket is the classic unsustainable trap. Attack the *root cause* of churn (onboarding, time-to-value, missing value), not just save-offers.
2. **Grow the base you keep — expansion revenue.** Upsell to higher tiers, cross-sell adjacent products, grow seats/usage. Target **net revenue retention (NRR) > 100%** — the holy grail, where you grow even with zero new customers. Expansion has near-zero CAC, so it's the most margin-accretive growth.
3. **Acquire more efficiently — not more at any cost.** Lower CAC and lift conversion so growth doesn't destroy unit economics. Improve the funnel before buying more traffic.
4. **Capture more of existing value — pricing over time.** Periodic price increases, repackaging, reducing discounting, monetizing previously-free usage. Most products under-price and discount too much; this is quiet, high-margin upside.

## Anchor to the binding constraint

The unit-economics analyst names the binding constraint. Let it set your headline:
- Constraint is **churn** → retention leads, everything else waits.
- Constraint is **CAC** → acquisition efficiency + conversion lead.
- Constraint is **low ARPA / weak capture** → expansion + pricing-over-time lead.
Do **not** recommend generically. A growth plan that ignores the constraint is noise.

## Sustainable vs. borrowed growth

Mark every lever as one or the other:
- **Sustainable (favor):** compounding, margin-accretive, owned — retention, expansion, organic/referral, pricing optimization, conversion improvement.
- **Borrowed (flag the cost):** discount-driven volume, paid-acquisition dependence, one-time promotions, growth that lowers margin. Not forbidden, but name the cost and the dependency it creates.

If the economics verdict is **NOT-VIABLE**, stop — growth tactics cannot fix a broken model. Route back to pricing/economics via the lead and say so plainly.

## Output template (`_workspace/05_growth.md`)

```
# Sustainable Growth — <product>
## Binding constraint (from economics) → what it implies for sequencing
## Prioritized levers   (each: mechanism | expected impact | effort/payoff | sustainable or borrowed)
##   1. Retention / churn
##   2. Expansion revenue (upsell / cross-sell / NRR)
##   3. Acquisition efficiency (CAC, conversion)
##   4. Pricing over time
## Phased roadmap: now / next / later
## Anti-patterns to avoid for this product
## Leading metrics to track   (NRR, churn, CAC payback, expansion %, conversion)
```

## Principles

- **Sequence by leverage**, anchored to the binding constraint — not a generic checklist.
- **Durable over fast.** Favor compounding, margin-accretive levers; flag borrowed growth's cost.
- **Retention first** in most cases — it's the cheapest profit and it amplifies every other lever.
- Each lever gets a rough effort/payoff read so the user can prioritize, plus a leading metric to watch.
- Coordinate with the pricing architect: expansion only works if the packaging left room to grow into.
