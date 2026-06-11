# Model Update: GPT-5.4 mini and nano

**Date discovered**: 2026-03-23
**Original detection date**: 2026-03-17 (release date)

## Summary

OpenAI released GPT-5.4 mini and nano on March 17, 2026. These are small, efficient models optimized for coding and subagents.

## Current State

- **Primary Codex model**: GPT-5.4 (gpt-5.4)
- **New models**:
  - GPT-5.4 mini (`gpt-5.4-mini`)
  - GPT-5.4 nano (`gpt-5.4-nano`)

## Details

- **Type**: New small model variants (lightweight, cost-optimized)
- **Purpose**: Optimized for coding and subagents
- **Performance**: Most capable small models yet
- **Availability**: General availability (not preview/beta)
- **Source**: https://openai.com/index/introducing-gpt-5-4-mini-and-nano/

## Recommendation

Evaluate for use in:
1. **Lightweight discovery runs** — candidate for capability-discoverer (currently Sonnet)
2. **Rapid prototyping** — candidate for model-router (currently Haiku)
3. **Cost-sensitive heartbeat phases** — candidate for model-selection framework

**Do NOT change** the primary Codex model (GPT-5.4) — that remains the standard for code review and cross-validation.

## Action Items

1. Evaluate GPT-5.4 mini/nano for lightweight agent roles
2. Update CLAUDE.md contemporary models table with new variants
3. Update model-selection.md decision tree if mini/nano become preferred choices
4. Consider integration into `helpers/playbooks/model-selection.md` reference

---

## Scoring Criteria

- **Integration complexity** (20%): Medium — requires integration testing in model-router or capability-discoverer (estimate: 70/100)
- **Token efficiency impact** (25%): High — small models reduce context/cost for suitable tasks (estimate: 90/100)
- **Capability expansion** (25%): Medium — expands available model roster but doesn't add new capability classes (estimate: 60/100)
- **Maintenance burden** (15%): Low — OpenAI-supported, lightweight models have low maintenance (estimate: 85/100)
- **Community validation** (15%): High — official OpenAI release, production-ready (estimate: 95/100)

**Estimated Score**: ~76/100 (APPROVE for integration)

