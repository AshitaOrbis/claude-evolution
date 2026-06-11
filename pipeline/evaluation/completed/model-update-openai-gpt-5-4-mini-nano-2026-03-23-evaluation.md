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

---

## Evaluation

**Date evaluated**: 2026-03-23
**Redundancy status**: IMPROVEMENT — extends existing Multi-Model Orchestration capability

**Note**: The registry already documents GPT-5.4 mini/nano as ACTIVE (Score: 75/100) from a prior evaluation. This pending file was created to trigger the outstanding action items (CLAUDE.md update, model-selection.md update) which have not yet been completed.

**Reasoning**: GPT-5.4 mini and nano expand the available model roster at the cost-optimized end. The mini variant is suitable for capability-discoverer runs (currently using Sonnet) and evaluation tasks where Haiku-level reasoning is sufficient. The nano variant is suitable for lightweight routing and classification tasks. These models don't add new capability classes but reduce cost significantly for bulk/automated tasks. Official OpenAI GA release with high community validation. The registry entry exists but action items remain pending.

**Scores**:

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 70 | Config testing + CLAUDE.md table update + model-selection.md update — moderate effort |
| Token efficiency impact | 25% | 90 | Small models = major cost reduction for lightweight/bulk tasks (discovery, routing, classification) |
| Capability expansion | 25% | 60 | Expands model roster at cost-efficient end; doesn't add new capability class |
| Maintenance burden | 15% | 85 | OpenAI-supported GA release; model IDs stable |
| Community validation | 15% | 95 | Official OpenAI GA release (March 17, 2026) |

**Weighted score**: (70×0.20) + (90×0.25) + (60×0.25) + (85×0.15) + (95×0.15) = 14 + 22.5 + 15 + 12.75 + 14.25 = **78.5/100**

**Decision**: **APPROVED**

**Action items**:
1. Update `~/.claude/CLAUDE.md` Contemporary AI Models table: add `gpt-5.4-mini` and `gpt-5.4-nano` rows
2. Update `helpers/playbooks/model-selection.md`: add mini/nano to decision tree for cost-sensitive paths
3. Verify model IDs work via Codex MCP (`~/.claude-mcp-servers/codex-simple/server.js`)
4. Do NOT replace primary GPT-5.4 model for code review/cross-validation
