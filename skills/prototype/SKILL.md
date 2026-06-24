---
name: prototype
description: "Build self-contained interactive HTML prototypes (clickable mockups) under agent_docs/prototypes/. Use whenever someone wants a prototype, mockup, wireframe, clickable demo, UI preview, or 'show me what it looks like' before building the real thing — and for follow-ups like 'update the prototype', 'redo that screen', 'add a screen', 'make it interactive'. One self-contained .html file per screen/flow."
user-invocable: true
when_to_use: "Invoke to turn a UI idea, spec, or screen list into reviewable clickable HTML mockups before real implementation."
category: design
keywords: [prototype, mockup, wireframe, html, clickable, demo, ui-preview]
metadata:
  author: phuc DANG
  version: "0.1.0"
---

# Prototype — Self-Contained HTML Mockups

Turn a UI idea or spec into **clickable HTML prototypes** the user can open and review *before* any
real code is written. Prototypes are throwaway, fast, and exploratory — their job is to make a
design decision concrete, not to become production code.

## Why prototypes (the intent)

A picture the user can click resolves design debates that prose cannot. The value is *fast feedback*
on layout, flow, and interaction — so optimize for "good enough to react to," produced quickly, over
pixel-perfection. The real build happens later from the approved prototype.

## Output Convention

- Write every prototype to **`agent_docs/prototypes/`** in the product repo.
- **One self-contained `.html` file per screen or flow** — name by screen: `login.html`,
  `dashboard.html`, `checkout-step-1.html`. Each file must open directly in a browser with **no
  build step and no network** (inline all CSS/JS; embed images as data URIs or use simple CSS/SVG
  placeholders).
- Maintain **`agent_docs/prototypes/README.md`** as an index: one line per screen (file → what it
  shows), plus how the screens link together.
- Cross-link screens with plain `<a href="other-screen.html">` so the set is clickable end-to-end.

## How to build

1. **Read the source of truth first.** If `agent_docs/SRD.md` / `UI_SPEC.md` or design tokens exist,
   follow them — colors, type, spacing, component patterns. Do not invent a look that contradicts the
   spec.
2. **Use real-ish content,** not lorem ipsum, so the user can judge the design honestly.
3. **Make it interactive where it clarifies the flow:** working links between screens, tab/accordion
   toggles, hover/active states, simple form behavior. Keep JS minimal and inline.
4. **Responsive by default:** relative units, flexbox/grid, `max-width:100%` media; no horizontal
   scroll on mobile.
5. **Match, don't gold-plate.** This is a mockup. Spend effort on layout/flow/hierarchy, not on
   animation polish or edge cases.

For genuine visual-design quality (typographic scale, color systems, avoiding generic AI-slop
layouts), lean on the existing design skills rather than reinventing them: `frontend-design` /
`ui-ux-pro-max`. This skill owns the **prototype convention** (where files go, self-contained, fast,
reviewable); those skills own **how to make UI look good**.

## Iteration

On a follow-up ("update the prototype", "change the dashboard", "add a settings screen"):

1. Read the existing files under `agent_docs/prototypes/` first.
2. Edit in place / add the new screen; keep the README index in sync.
3. Report exactly which files changed so the reviewer knows what to re-open.

## Done means

- Files open standalone in a browser, no console errors, screens link together.
- README index lists every screen.
- The look follows the spec/tokens when they exist.
- The user can click through the core flow and react to it.
