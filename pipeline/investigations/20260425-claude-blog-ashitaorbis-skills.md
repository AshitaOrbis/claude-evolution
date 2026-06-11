---
date: 2026-04-25
topic: "Investigate this for ashitaorbis\n\nhttps://github.com/AgriciDaniel/claude-blog"
discord_message_id: "1497225095511543938"
status: complete
---

# claude-blog: Skills Worth Borrowing for Ashita Orbis

## Topic

"Investigate this for ashitaorbis" — https://github.com/AgriciDaniel/claude-blog

## Key Findings

- **claude-blog** is a 22-sub-skill Claude Code ecosystem for AI-assisted blog content management, explicitly targeting Astro, Next.js, and Ghost — all platforms already in the ashitaorbis stack.
- Its **dual-optimization approach** (search engines + AI citation platforms like ChatGPT, Perplexity) mirrors an existing ashitaorbis goal, but it provides a structured scoring framework: 5 categories (Content Quality, SEO, E-E-A-T, Technical, AI Citation Readiness), 100-point bands per category.
- **Significant overlap** with existing ashitaorbis pipeline: `/write-post` skill, GPT-5.4 fact-checker, style guides, and `measure_style.py` already cover core writing quality. These don't need importing.
- **High-value additions** not yet in the ashitaorbis system: keyword cannibalization detection across post sets, Google PageSpeed/Search Console integration, schema markup generation (structured data for LLM crawlers), and content calendar generation.
- The `notebooklm` sub-skill provides source-grounded research queries — a different research approach from the current Exa/Brave pipeline.
- Python 3.11+ scripts are the analysis layer; the skills themselves run in Claude Code — fully compatible environment.
- The repo has a `persona` skill for tone/voice profile management, but ashitaorbis already has STYLE-GUIDE-BLENDED/ACADEMIC which is more rigorous — no value added there.

## Details

The claude-blog project is essentially a mature Claude Code skills library for content teams, with a heavier SEO/GA4/Search Console integration focus than what ashitaorbis has. Its `blog/` orchestrator routes to specialized sub-skills, and its Python analysis scripts are meant to complement the skills (quality scoring, cannibalization detection) rather than replace Claude's judgment.

The quality scoring framework is the most interesting conceptual contribution: five discrete dimensions scored 0–100 with thresholds for minimum publish quality. This could be implemented as an enhancement to the existing `measure_style.py` or as a new `score-readiness` step in the `/write-post` pipeline, running before the fact-check gate.

Keyword cannibalization detection becomes more relevant as the post count grows (currently 38+ posts). The concept — detecting when multiple posts compete for the same search terms, diluting ranking for both — isn't currently tracked anywhere in the ashitaorbis system. At 80–100 posts this becomes a real problem. The claude-blog `cannibalization` sub-skill reads all post frontmatter/content and flags overlapping keyword coverage. This is worth implementing as a standalone audit script rather than an inline skill.

Schema markup generation (JSON-LD structured data) is underimplemented in ashitaorbis. The claude-blog `schema` skill generates Article, FAQ, HowTo, and Product schema. For ashitaorbis, Article + FAQ schema on posts would directly improve AI citation readiness — particularly for the `app.ashitaorbis.com` tier which currently lacks structured data.

The Google API integrations (PageSpeed, Search Console, GA4) require credential setup but provide the kind of feedback loop the current pipeline lacks: actual search performance data feeding back into content decisions. This is infrastructure worth setting up separately, not a skill to import directly.

## Relevance to Workspace

Ashitaorbis already has: `/write-post` → style enforcement → fact-check → glossary → deploy. The claude-blog adds SEO audit and structured data layers that fit naturally after deploy as a separate audit pass. The existing `/writing-review` and `publication-review` skills cover voice/quality; what's missing is the technical/discoverability audit.

The cannibalization detector is most relevant now, while the post catalog is still small enough to fix coverage gaps without major rewrites.

## Recommended Actions

1. **Borrow the schema markup approach**: Add JSON-LD Article schema to the Next.js tier (tier-3) post template — this is a few hours of work and directly improves AI citation readiness.
2. **Implement a cannibalization audit script**: Adapt or port the claude-blog `cannibalization` sub-skill as `scripts/audit-cannibalization.py` — run it quarterly as the post catalog grows.
3. **Add a quality scoring dimension to write-post**: Consider a 5-dimension scoring pass (particularly AI Citation Readiness) as a new gate in `/write-post`, feeding into the existing publish decision.
4. **Evaluate Google Search Console integration** as a background cron task once the blog has enough indexed content to generate useful signals (probably worth revisiting at 50+ posts).
