# Evaluation: Cloudflare Markdown for Agents

- **Date**: 2026-03-08
- **Source**: https://x.com/i/status/2021955521213800489
- **Category**: Token Efficiency / Web Content Access
- **Automated**: Yes (Twitter re-evaluation)

## Investigation

Fetched via fxtwitter API. Tweet by @Cloudflare (official account), February 12, 2026. Announces "Markdown for Agents" — Cloudflare's network now supports real-time HTML-to-Markdown conversion at the source using content negotiation headers. Confirmed via Brave search: blog.cloudflare.com/markdown-for-agents/, developers.cloudflare.com docs, and changelog dated 2026-02-12.

Cross-referenced with registry: Cloudflare Code Mode Pattern (2026-02-24, score 78.9) already exists — but that is about API representation, not about web content delivery. This is a different capability.

## Content Summary

Cloudflare's "Markdown for Agents" feature automatically converts HTML pages to Markdown when AI agents request content with `Accept: text/markdown` headers. This is a CDN-level feature that works across any Cloudflare-proxied zone. Claude Code and OpenCode already send these headers. Benefits: reduced token waste (up to 80% per page), cleaner content for LLM consumption. No integration needed on the consumer side — agents already benefit if the target sites use Cloudflare.

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 95 | Zero integration required — Claude Code already sends the right headers, Cloudflare handles conversion server-side |
| Token efficiency impact | 25% | 85 | Significant token savings when fetching web content (up to 80% reduction per page by stripping HTML cruft) |
| Capability expansion | 25% | 60 | Not a new capability per se — agents already fetch web content. This improves quality/efficiency of existing WebFetch flows |
| Maintenance burden | 15% | 95 | Zero maintenance — entirely server-side, managed by Cloudflare |
| Community validation | 15% | 95 | Official Cloudflare announcement, adopted by Claude Code and OpenCode, widely covered in tech press |

- **Final Score**: 83.5/100

## Decision

APPROVED — High-value informational integration. While no action is needed on our side (Claude Code already sends the right headers), this should be documented in the registry as a known ecosystem capability that benefits our token efficiency. The technique of content negotiation for agent-optimized responses is a pattern worth tracking. Complements existing Cloudflare Code Mode Pattern entry (API-side) with this new content-delivery-side optimization.

### Integration Recommendation

- Add registry entry under Token Efficiency documenting Cloudflare Markdown for Agents
- Add to library/techniques as a reference pattern
- No code changes needed — benefit is automatic
