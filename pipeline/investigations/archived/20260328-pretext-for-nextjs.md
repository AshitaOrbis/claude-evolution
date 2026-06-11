---
date: 2026-03-28
topic: "Pretext TypeScript text layout library for Next.js"
discord_message_id: "1487505132676714679"
status: complete
---

# Pretext: TypeScript Text Measurement Library for Next.js

## Topic

> "Seems like a cool frontend option perhaps could be incorporated in the next.js page?" — github.com/chenglou/pretext

## Key Findings

- **Pretext** is a pure TypeScript/JavaScript library for multiline text measurement and layout, designed to calculate text dimensions without triggering expensive DOM reflows
- Core capabilities: **height measurement** (calculate paragraph height at any width without DOM) and **manual line layout** (access individual line widths and cursor positions)
- Primary use cases: text virtualization, overflow detection, custom Canvas/SVG/WebGL rendering with precise text
- Created by **Cheng Lou** (former React team, creator of ReasonML/ReScript and `react-motion`) — high credibility signal for quality and long-term thinking
- Integrates with Next.js via `npm install @chenglou/pretext`; works in Server Components via canvas measurement
- **Highly specialized**: This solves a specific performance problem (text measurement without DOM) rather than a general frontend need; most Next.js apps don't need it

## Details

Pretext solves the "expensive text measurement" problem: when you need to know how tall a block of text will be at a given width (for virtualization, dynamic layouts, or overflow detection), the standard DOM approach forces a reflow. Pretext avoids this entirely.

**When to use Pretext**:
- Long scrollable text lists (virtualization requires knowing item heights upfront)
- Canvas/WebGL text rendering (no DOM available)
- "Read more" overflow truncation without double-render hacks
- Responsive text layouts where precise height calculations are needed before paint

**When NOT to use**:
- Standard Next.js content pages (CSS handles layout fine)
- Small-to-medium text volumes (performance benefit doesn't justify added complexity)
- Server-side rendering of static text

For **Ashita Orbis** (the primary Next.js project): The blog/forum layout is mostly standard typography. Pretext would only be relevant if implementing a virtualized comment thread, a code editor-style component, or a dense data table. Not currently needed, but worth knowing exists.

## Relevance to Workspace

- `applications/ashitaorbis/`: Low current relevance — standard blog layout doesn't require precise text measurement
- Future interactive features: If a "terminal-style" or "dense data" component is built, Pretext would be the right tool
- Library quality: Cheng Lou's work is production-grade; this is a well-maintained option when the specific need arises

## Recommended Actions

1. **No immediate action** — bookmark for future use when a text-virtualization or precise layout need arises
2. Add to `library/techniques/` as a reference: "for Next.js text virtualization/measurement, use `@chenglou/pretext`"
3. Evaluate for Ashita Orbis if implementing a feature that requires overflow detection or virtualized text lists
