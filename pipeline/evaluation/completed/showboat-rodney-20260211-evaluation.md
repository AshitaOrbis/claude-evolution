# Evaluation: Showboat and Rodney

- **Date**: 2026-02-11
- **Source**: https://simonwillison.net/2026/Feb/10/showboat-and-rodney/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | Hard - requires fly.io account, deployment pipeline, Playwright + ffmpeg setup, wrapping in skill/subagent pattern |
| Token efficiency impact | 25% | 50 | Neutral - doesn't reduce tokens (agents still describe work), adds deployment config overhead, but videos may replace lengthy text descriptions in specific demo scenarios |
| Capability expansion | 25% | 70 | Incremental - novel "show your work" layer but doesn't enable fundamentally new development types; use cases niche (MVP demos, portfolio generation) |
| Maintenance burden | 15% | 70 | Occasional updates needed - external dependencies (fly.io API, Playwright, ffmpeg), but Simon Willison has good maintenance track record (Datasette) |
| Community validation | 15% | 40 | Brand new (Feb 10, 2026), no GitHub stars yet, no public repo visible; high authority source (Simon Willison) but unproven in wild |

- **Claude Score**: 56.5/100
- **Codex Score**: N/A (Codex unavailable)
- **Final Score**: 56.5/100

## Decision

**NEEDS_RESEARCH** — Promising concept from respected source but requires investigation into practical integration value vs complexity trade-off.

## Integration Notes

### Research Questions

1. **GitHub availability**: Are Showboat and Rodney available as open-source repos yet, or still private tools? Blog post doesn't link to installation instructions.

2. **fly.io dependency**: Can Showboat be adapted to other deployment targets (Vercel, Netlify, Railway) or is it fly.io-specific? fly.io account requirement adds barrier.

3. **Rodney vs existing stack**: We already have better-playwright MCP for browser automation. Does Rodney provide value beyond what we can do with Playwright + ffmpeg directly?

4. **Use case validation**: Do our actual workflows (evolution pipeline, revenue pipeline, games pipeline) benefit from automated video demos, or is this solving a problem we don't have?

5. **Token efficiency reality check**: Would videos actually replace text descriptions, or would agents need to describe videos anyway? Need to test assumption that videos reduce context usage.

6. **Integration pattern**: If valuable, should this be a skill (wrap existing tools), subagent (orchestrate deployment + recording), or MCP (if repos become available)?

### Reconsideration Triggers

- Public GitHub repos released with clear installation docs
- Community adoption visible (500+ stars, success stories)
- Evidence that video demos materially improve stakeholder communication vs screenshots
- Integration with existing better-playwright stack becomes trivial
- fly.io integration becomes unnecessary (alternative deployment targets available)

### Comparison to Existing

**Better Playwright MCP**: Already provides browser automation and screenshots. Rodney adds video recording on top of Playwright, but we can achieve this with `playwright codegen --output video.mp4` or similar ffmpeg piping.

**browser-tester subagent**: Uses better-playwright for E2E testing and screenshots. Could be extended to record videos if needed.

**Gap analysis**: The novel part is **automated temporary deployment** (Showboat), not browser video recording (achievable with existing stack). Focus research on Showboat's deployment automation value proposition.
