# Monetization Models Catalog

Reference for the pricing-architect. Each model: what it is, fits when, breaks when, natural value metric, watch-outs. Pick by how value is created, delivered, and consumed — not by fashion.

## Subscription (recurring flat or tiered)
- **What:** customer pays a recurring fee (monthly/annual) for ongoing access.
- **Fits when:** value is consumed continuously; the product is used regularly; you want predictable recurring revenue (MRR/ARR).
- **Breaks when:** usage is occasional or one-off — customers resent paying when idle and churn.
- **Value metric:** per seat, per active user, per workspace, flat per account.
- **Watch-outs:** churn is the silent killer; annual billing improves retention and cash; flat subscription can decouple price from value (weak metric).

## Usage / metered (pay-as-you-go)
- **What:** charge per unit consumed (API calls, GB, compute, messages, listings processed).
- **Fits when:** cost-to-serve scales with usage; value scales with volume; consumption is lumpy/unpredictable.
- **Breaks when:** customers need budget predictability (pure usage creates bill anxiety) or usage doesn't track value.
- **Value metric:** the consumed unit itself.
- **Watch-outs:** revenue is volatile; pair with a committed base (hybrid) for predictability; meter something the customer understands.

## Hybrid (base + usage)
- **What:** a platform/base fee plus usage-based overage. The modern SaaS default for infra/AI products.
- **Fits when:** you want predictable floor revenue *and* upside as customers grow.
- **Breaks when:** the two components confuse buyers or the base is set so high it deters landing.
- **Value metric:** seats or platform for the base, consumption for the variable part.
- **Watch-outs:** keep the bill explainable; align overage rate with marginal cost-to-serve plus margin.

## Per-transaction / take-rate
- **What:** a cut of each transaction flowing through the product (marketplace fee, payment %, commission).
- **Fits when:** you sit between two parties exchanging money/value; your value scales with GMV.
- **Breaks when:** take-rate is high enough to incentivize disintermediation (parties go around you).
- **Value metric:** % of transaction value or flat per transaction.
- **Watch-outs:** balance take-rate against disintermediation risk; add SaaS fees to stabilize revenue.

## Freemium
- **What:** a permanently free tier funneling to paid upgrades.
- **Fits when:** low marginal cost to serve free users; strong viral/word-of-mouth or bottoms-up land motion; clear upgrade trigger.
- **Breaks when:** free users cost real money to serve, or the free tier is so complete nobody upgrades.
- **Value metric:** whatever gates the upgrade (seats, usage limits, premium features).
- **Watch-outs:** free-to-paid conversion is often 2–5% — model it honestly; the upgrade trigger must bite where value is felt.

## Free trial (time-boxed)
- **What:** full or near-full access for a limited window, then pay.
- **Fits when:** value is felt quickly within the trial; serving trial users isn't ruinous.
- **Breaks when:** time-to-value exceeds the trial length.
- **Value metric:** same as the paid plan it converts into.
- **Watch-outs:** length the trial to time-to-value, not a round number; reverse-trial (start on paid features, downgrade) often converts better than freemium.

## One-time / perpetual license
- **What:** pay once, own/use indefinitely (with optional paid upgrades/maintenance).
- **Fits when:** value is delivered at a point in time; customers resist subscriptions; low ongoing cost-to-serve.
- **Breaks when:** you need recurring revenue or there are ongoing serving costs.
- **Value metric:** per license / per device / per major version.
- **Watch-outs:** revenue isn't recurring — pair with maintenance/upgrade fees or consumables.

## Seat-based / per-user
- **What:** price scales with number of users.
- **Fits when:** value grows with team adoption; collaboration is core.
- **Breaks when:** customers ration seats to control cost (suppressing adoption and value), or value isn't per-person.
- **Value metric:** per seat (active vs. provisioned matters).
- **Watch-outs:** seat-rationing caps your expansion; consider per *active* user or a usage metric instead.

## Tiered (good/better/best)
- **What:** packaging strategy layered on top of any stream — 3 tiers segmenting by WTP.
- **Fits when:** customers have distinct value needs and budgets; you want anchoring and an expansion path.
- **Value metric:** features + a quantitative limit per tier.
- **Watch-outs:** too many tiers paralyze; 3 is the workhorse; make the target tier the obvious "most popular."

## Advertising
- **What:** monetize attention; users free, advertisers pay.
- **Fits when:** large engaged audience, high session frequency, low WTP from users directly.
- **Breaks when:** audience is small or niche (ad RPMs too low) or ads degrade the core experience.
- **Value metric:** impressions / clicks / sponsorships.
- **Watch-outs:** needs scale to matter; misaligns incentives with user experience.

## Services / success attach
- **What:** attach onboarding, implementation, or managed services to a product.
- **Fits when:** the product needs setup to deliver value; enterprise buyers pay for outcomes.
- **Breaks when:** it becomes a low-margin services business masquerading as a product.
- **Value metric:** per engagement / % of contract.
- **Watch-outs:** keep services margin-aware; use them to drive product adoption, not as the main act.

## Selection cheat-sheet
- Continuous value → subscription. Lumpy/scaling value → usage or hybrid.
- Intermediating value exchange → take-rate. Point-in-time value → one-time.
- Bottoms-up viral land → freemium. Fast time-to-value → trial.
- Attention at scale, low direct WTP → advertising.
- Always: pick the **value metric** that grows with customer success first, then wrap a model around it.
