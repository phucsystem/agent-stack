# Unit Economics — Formulas & Benchmarks

Reference for the unit-economics-analyst. Definitions, derivations, gotchas, and healthy ranges. Benchmarks are directional (lean SaaS-weighted) — always prefer the category benchmark the market analyst found over these defaults.

## Margins

**Gross margin** = (Revenue − COGS) ÷ Revenue.
COGS = the cost directly tied to delivering the product (hosting, payment fees, support, third-party API costs, content/licensing). For software, healthy gross margin is **70–85%+**. Low gross margin (<50%) caps everything downstream — LTV shrinks, payback lengthens.

**Contribution margin per unit** = Price − variable cost to serve that unit.
This is the per-sale profit before fixed costs. **Must be positive** — a negative contribution margin means every sale loses money and scale makes it worse.

## Customer lifetime & LTV

**Average customer lifetime** (in periods) = 1 ÷ churn rate. (5% monthly churn → 20-month average lifetime.)

**LTV (gross-margin-adjusted, preferred)** = ARPA × gross margin % ÷ churn rate.
- ARPA = average revenue per account per period.
- Always margin-adjust — LTV on raw revenue overstates the value you actually keep.
- **Churn dominates LTV.** Because lifetime = 1/churn, halving churn doubles LTV. This is why the growth strategist usually attacks retention first.

**With expansion:** if existing customers grow spend (NRR > 100%), use net revenue churn (which can be negative) — LTV rises substantially and can be large even at moderate logo churn.

## Acquisition

**CAC** = total sales + marketing spend in a period ÷ new customers acquired in that period.
Include *fully loaded* cost — ad spend, SDR/AE salaries, tools, content, commissions — not just media spend. Under-counting CAC is the most common way models lie.

**LTV:CAC ratio** = LTV ÷ CAC.
- **< 1** — you pay more to acquire than you ever earn back. Broken.
- **~1–2** — buying revenue at or near cost; unsustainable without change.
- **≥ 3** — healthy; room to invest in growth.
- **> 5** — often *under*-investing in growth (could acquire more aggressively).

**CAC payback period (months)** = CAC ÷ (monthly ARPA × gross margin %).
- **< 12 months** — healthy for SMB/self-serve.
- **12–18 months** — acceptable for enterprise with strong retention.
- **> 24 months** — needs deep pockets and very low churn to survive.

## Breakeven

**Breakeven units** = Fixed costs ÷ contribution margin per unit.
**Breakeven revenue** = Fixed costs ÷ gross margin %.
Tells you the volume/revenue needed before the business itself (not just the unit) is profitable.

## Sensitivity analysis

Vary each key driver ±20–30% and recompute the verdict:
- **Price** — directly moves contribution margin and LTV.
- **Churn** — moves LTV non-linearly (1/churn); usually the most powerful lever.
- **CAC** — moves LTV:CAC and payback directly.
- **Conversion** (free→paid, trial→paid) — moves effective CAC (more spend per paying customer if conversion drops).

The driver that flips the verdict from viable to not-viable with the smallest realistic move is the **binding constraint** — name it; it sets the growth strategist's priority.

## Benchmark quick-reference (directional)

| Metric | Healthy | Caution | Broken |
|--------|---------|---------|--------|
| Gross margin (software) | 70–85%+ | 50–70% | <50% |
| LTV:CAC | ≥ 3 | 1–3 | < 1 |
| CAC payback | < 12 mo | 12–24 mo | > 24 mo |
| Monthly logo churn (SMB) | < 3% | 3–5% | > 5% |
| Monthly churn (enterprise) | < 1% | 1–2% | > 2% |
| Net revenue retention | > 110% | 90–100% | < 90% |
| Free→paid (freemium) | 3–5%+ | 1–3% | < 1% |
| Trial→paid | 15–25%+ | 8–15% | < 8% |

## Common ways models lie (check for these)
- CAC counts only media spend, not salaries/tools/commissions.
- LTV uses revenue, not gross-margin-adjusted revenue.
- LTV assumes a churn rate the product has never actually achieved.
- Fixed costs omitted, so "profitable" means only contribution-positive.
- Conversion assumed at best-case with no sensitivity.
- "Profitable at scale" hides a negative contribution margin today.
