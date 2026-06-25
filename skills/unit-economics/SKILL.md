---
name: unit-economics
description: Framework for validating whether a pricing model is actually and sustainably profitable — unit economics, gross/contribution margin, CAC, LTV, LTV:CAC, payback period, breakeven, and sensitivity analysis. Used by the unit-economics-analyst agent. Trigger when a proposed monetization model needs a profit-and-loss verdict, not optimism.
---

# Unit Economics & Profitability Validation

Goal: prove whether a proposed model makes money *sustainably*, and name the binding constraint. Deliverable: `_workspace/04_economics.md` with a clear VIABLE / VIABLE-WITH-CHANGES / NOT-VIABLE verdict. Run real calculations — use a script for anything beyond trivial arithmetic so results are reproducible.

Full formula definitions and benchmark ranges: `references/formulas-and-benchmarks.md`. Read it before computing.

## The chain of questions

Profitability is a chain; a break anywhere fails the model.

1. **Is each unit profitable?** Revenue per customer − variable cost to serve = **contribution margin**. If negative, you lose money per sale — nothing downstream saves it.
2. **Does the customer earn back acquisition cost?** Compare **LTV vs. CAC**. Rule of thumb: **LTV:CAC ≥ 3** is healthy; ~1 means you're buying revenue at cost; <1 means you pay to lose customers.
3. **How fast?** **CAC payback period** — months of margin to recover CAC. <12 months is generally healthy for SMB SaaS; longer needs strong retention and capital.
4. **At what scale do you cover fixed costs?** **Breakeven volume** = fixed costs ÷ contribution margin per unit.
5. **How fragile is the answer?** **Sensitivity** — move price, churn, CAC, and conversion ±20–30% and watch the verdict. The lever that flips it fastest is the **binding constraint**.

## Core formulas (quick reference)

- **Gross margin** = (revenue − COGS) ÷ revenue
- **Contribution margin/unit** = price − variable cost to serve
- **LTV** = (ARPA × gross margin %) ÷ churn rate  *(or ARPA × gross margin × avg lifetime in periods)*
- **CAC** = total sales & marketing spend ÷ new customers acquired
- **LTV:CAC** = LTV ÷ CAC  (target ≥ 3)
- **CAC payback (months)** = CAC ÷ (monthly ARPA × gross margin %)
- **Breakeven units** = fixed costs ÷ contribution margin per unit

See the reference for derivations, the difference between gross-margin-adjusted vs. raw LTV, and why churn dominates LTV.

## Sustainability is the bar

The user wants *sustainable* profit. A model that's profitable only at unrealistically low churn, low CAC, or high conversion is **not viable** — say so. Pressure-test every favorable assumption against the market benchmarks. Sustainable means: positive contribution margin, LTV:CAC ≥ 3 at *realistic* churn, payback the business can fund, and a model that doesn't depend on a number no one has ever hit.

## Handling missing inputs

Don't stall and don't fabricate. For each missing input, model a **low / expected / high** range, label it, and make the verdict conditional on it. Surface the top 1–2 unknowns to the lead so the user can supply real numbers. State the source of every input (observed vs. assumed).

## Output template (`_workspace/04_economics.md`)

```
# Unit Economics — <product>
## Assumptions   (input | value | source: observed/assumed)
## Unit economics by tier   (price | variable cost | contribution margin)
## CAC / LTV / LTV:CAC / payback
## Breakeven volume
## Sensitivity table   (price, churn, CAC, conversion ±20–30%)
## VERDICT: VIABLE | VIABLE-WITH-CHANGES | NOT-VIABLE
##   Binding constraint: …    Required change (if any): …
```

## Principles

- **The verdict gates the pricing model.** If NOT-VIABLE, message the pricing architect the specific failing number so they redesign — don't soften the math.
- **Reproducible, not asserted.** Compute with scripts; show the inputs.
- **Name the binding constraint** — it tells the growth strategist which lever to pull (churn vs. CAC vs. price vs. conversion).
- Realistic beats optimistic. Use market benchmarks to bound assumptions.
