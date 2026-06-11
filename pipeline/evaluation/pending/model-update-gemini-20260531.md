# Gemini 3 Series Release Discovery

**Date Found:** 2026-05-31  
**Discovery Source:** Contemporary Models Check (Brave Search)

## Summary

Google released the Gemini 3 series on **May 28-29, 2026**, including:
- **Gemini 3** — New flagship model with enhanced reasoning and multimodal capabilities
- **Gemini 3 Flash** — Fast, cost-effective variant optimized for speed and cost efficiency

These models supersede or supplement the current Gemini 3.1 Pro tracked in the system.

## Current State (as of 2026-05-09)
- Primary: Gemini 3.1 Pro (`gemini-3.1-pro-preview`)
- Monitoring: Gemini 3.2 Flash (released 2026-05-05)

## New Models Detected

### Gemini 3 (Base)
- Status: Available (released May 28-29, 2026)
- Description: "Most intelligent AI model, enhancing reasoning and multimodal capabilities"
- Availability: Gemini app, AI Studio, Vertex AI
- Model ID: TBD (search results do not include API ID)
- Assessment: **Potential new primary** — if this is the flagship, may replace Gemini 3.1 Pro

### Gemini 3 Flash
- Status: Available (released May 28-29, 2026)
- Description: "Fast and cost-effective model built for speed"
- Availability: Gemini app, AI Mode in Search, Gemini API, Google AI Studio, Antigravity
- Model ID: TBD (search results do not include API ID)
- Assessment: **Cost-effective variant** — candidate for visual-fidelity-inspector or lightweight tasks

### Gemini 3.1 Flash-Lite (GA Status Update)
- Previous status: Preview (as of 2026-03-03)
- New status: Generally Available (GA)
- Notes: Released March 3, 2026 in preview; promoted to GA before May 31, 2026

## Source URLs

- https://blog.google/products-and-platforms/products/gemini/gemini-3/ (Gemini 3 announcement)
- https://blog.google/products/gemini/gemini-3-flash/ (Gemini 3 Flash announcement)
- https://ai.google.dev/gemini-api/docs/changelog (Release notes, Gemini 3.1 Flash-Lite GA status)
- https://developers.googleblog.com/gemini-3-flash-is-now-available-in-gemini-cli/ (Gemini 3 Flash CLI availability)

## Recommended Actions

1. **Research API model IDs** — Determine the exact API identifiers for Gemini 3 and Gemini 3 Flash (search results don't include these)
2. **Benchmark evaluation** — Test whether Gemini 3 should replace Gemini 3.1 Pro as primary for visual/UI work
3. **Cost analysis** — Gemini 3 Flash cost-benefit for visual-fidelity-inspector and lightweight tasks
4. **Update agents/skills** — If Gemini 3 proves suitable, update references in:
   - `~/.claude/CLAUDE.md` (Contemporary AI Models table)
   - Agent definitions using `gemini_3.1_pro`
   - Skills referencing Gemini models

## Notes

- This is a **genuine new release** (not preview/beta) — released to public APIs
- Timing: May 28-29, 2026 (this year)
- Discovery gap: State file last verified 2026-05-09; this release occurred 19-20 days later

## Follow-Up Tasks

- [ ] Confirm Gemini 3 base model API ID and availability
- [ ] Confirm Gemini 3 Flash API ID
- [ ] Evaluate Gemini 3 vs Gemini 3.1 Pro for current workflows
- [ ] Check if Gemini 3.1 Pro still exists or has been replaced
