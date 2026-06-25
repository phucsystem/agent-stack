---
name: pricing-model-design
description: Framework for designing a product's monetization model — selecting revenue streams (subscription, usage, transaction, freemium, one-time, hybrid), choosing the value metric, and structuring packaging and tiers and the free-to-paid path. Used by the pricing-architect agent. Trigger when a monetization consult needs a concrete way for a product to make money, not just market data.
---

# Pricing Model Design

Goal: turn understanding + market guardrails into a concrete, profitable, *validatable* monetization model. Deliverable: `_workspace/03_pricing.md` — one recommended model + one alternative, designed to pass the economics test.

## The order of decisions (do not skip)

1. **Value metric** — what you charge *per*. Highest-leverage decision; everything else follows.
2. **Revenue stream(s)** — the model that fits how value accrues.
3. **Price level** — where you land inside the market floor/ceiling.
4. **Packaging & tiers** — how value splits across good/better/best.
5. **Free-to-paid path** — how prospects become payers.

## 1. Value metric (charge per the thing that scales with value)

A great value metric: (a) aligns price with the value the customer receives, (b) grows revenue as the customer succeeds, (c) is simple to understand and predict. Examples: per seat, per active user, per GB, per transaction, per outcome (e.g. per qualified lead), per listing. A misaligned metric (e.g. flat fee while customer value 10×'s) leaves the entire capture gap on the table. **Fix the value metric before tiers.**

## 2. Revenue stream selection

Match the model to how value is delivered and consumed. See `references/monetization-models.md` for the full catalog (subscription, usage/metered, per-transaction/take-rate, freemium, free trial, one-time/perpetual, seat-based, tiered, hybrid, marketplace, advertising, services-attach) — each with *fits when / breaks when / value metric / watch-outs*. Read it when choosing or comparing models.

Default heuristics:
- Recurring value consumed continuously → **subscription**.
- Value scales with consumption and is lumpy → **usage/metered** (or hybrid base + usage).
- You sit between two parties exchanging value → **transaction / take-rate**.
- Strong viral/land motion, low marginal cost → **freemium**; otherwise prefer a **time-boxed trial**.
- Most B2B SaaS lands on **tiered subscription with a usage or seat value metric** — but justify, don't default.

## 3. Price level

Anchor to **value-based pricing** (a fraction of quantified customer value), bounded by the market floor/ceiling from `02_market.md`, with cost-plus only as a sanity floor. If value-based price and market ceiling diverge sharply, surface the tension rather than splitting the difference.

## 4. Packaging & tiers

- **Good/better/best** with 3 tiers is the workhorse: an entry tier that lands customers, a middle tier (usually the target / most-popular anchor), and a high tier that both captures big accounts and makes the middle look reasonable.
- Split features by **willingness-to-pay differentiators**, not randomly — put what advanced/larger customers value in higher tiers.
- Leave **expansion headroom**: packaging must let customers grow into more revenue (more seats/usage/tiers). Coordinate with the growth strategist.
- Anchor high. The top price reframes the middle.

## 5. Free-to-paid path

Free tier vs. trial vs. demo. Define exactly: what's free, the **upgrade trigger** (the moment value is felt and the limit bites), and the friction-minimizing path to paid. A free tier with no natural upgrade trigger is a cost, not a funnel.

## Output template (`_workspace/03_pricing.md`)

```
# Pricing Model — <product>
## Recommended model: stream(s) + value metric + why it fits
## Pricing structure: tiers/packages, price points, what each includes
## Free-to-paid path + upgrade trigger
## Alternative model + trade-off vs. recommendation
## To validate (hand to economics): price points, expected tier mix, conversion assumptions
```

## Principles

- **Design for the economics test.** Every model goes to the unit-economics analyst; if it doesn't pencil out, redesign. Build with that verdict in mind.
- **One recommendation + one alternative**, not a menu of ten. Decision-grade.
- Stay inside market guardrails unless you can justify breaking them.
- Value metric first, always.
