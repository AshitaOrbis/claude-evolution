---
date: 2026-05-16
topic: "This is probably useful for the ashitaorbis site: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide"
discord_message_id: "1505214348111511693"
status: complete
---

# Google AI Optimization Guide: Implications for Ashita Orbis

## Topic
Google published an official guide on optimizing content for AI-powered search features (AI Overviews, AI Mode). The user flagged it as potentially useful for the Ashita Orbis blog/site.

## Key Findings
- **Standard SEO still governs AI Overviews** — "our generative AI features are rooted in our core Search ranking and quality systems"
- **Distinctive, first-person expertise beats commodity content** — unique perspectives and original insights are exactly what Google's AI rewards
- **No special AI markup needed** — llms.txt files, "chunking," and writing-for-AI are explicitly called out as unnecessary/counterproductive
- **Semantic HTML and crawlability remain critical** — JavaScript frameworks need SSR/SSG to be properly indexed
- **Ashita Orbis's current approach is well-aligned** — the psychometric depth, philosophical framing, and first-person analysis are precisely the non-commodity content that AI Overviews favor
- **One gap: verify technical crawlability** — since the blog uses a JS-heavy stack, ensure Googlebot can index content without JS rendering issues

## Details

Google's guide is notable for what it debunks. Several "AEO/GEO optimization" tactics that have proliferated in 2025-2026 are explicitly dismissed:

- **llms.txt**: Google says this provides no advantage and isn't part of their systems. This saves effort — no need to add or maintain one for ashitaorbis.
- **Content chunking**: Breaking content into AI-friendly fragments is unnecessary.
- **Structured data for AI**: Helpful for rich snippets (recipes, events, etc.) but not required for AI Overviews inclusion.

The positive guidance aligns strongly with Ashita Orbis's existing editorial direction. Google explicitly rewards "unique perspectives" over generic information aggregation — the blog's psychometric analysis, philosophical frameworks, and personal cognitive history are inherently differentiated content. The guide says to "develop material with unique perspectives and original expertise rather than recycling existing information." That describes the Ashita Orbis voice precisely.

The most actionable technical concern is JavaScript SEO. The blog appears to use a modern JS framework (likely Astro or Next.js based on the workspace structure). Google's guide flags "JavaScript SEO best practices if your site uses frameworks" as a requirement. Astro's static generation (if used) handles this automatically by rendering to HTML at build time. If the blog uses any client-side-only rendering for key content (post bodies, structured metadata), that content could be invisible to Googlebot's initial crawl pass before JS rendering.

For product/local visibility features (Google Merchant Center, Business Profiles), these don't apply to Ashita Orbis as a personal/editorial blog.

## Relevance to Workspace

The Ashita Orbis site (`applications/ashitaorbis/`) is a 3-tier blog described in the workspace as "PRIMARY." Google's AI search optimization is directly relevant to organic discovery — AI Overviews increasingly appear above traditional blue-link results, particularly for questions that match Ashita Orbis's topic territory (psychometrics, AI philosophy, cognition, Catholic/Thomist frameworks).

The guidance reinforces the editorial strategy already in place rather than requiring strategic changes. The main value is confirming that no additional AI-specific SEO work is needed and that the distinctive-voice approach is the correct one.

## Recommended Actions

1. **Verify JS rendering** — run `fetch` in Google Search Console on 2-3 key blog posts to confirm Googlebot sees the full HTML content, not just the JS shell
2. **No llms.txt needed** — explicitly avoid adding one; Google says it provides no benefit
3. **Continue distinctiveness emphasis** — the guide validates the current editorial direction; no strategy change needed
4. **Check image/video support** — Google's guide mentions "support text with relevant images and videos when appropriate" as a positive signal; consider whether key posts could benefit from embedded visual content
5. **Monitor AI Overviews citations** — set up Google Search Console AI appearance tracking to see if any posts are being cited in AI Overviews
