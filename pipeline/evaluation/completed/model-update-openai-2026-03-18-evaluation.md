---
name: GPT-5.4 mini and nano release
type: model-update
date: 2026-03-18
provider: OpenAI
current_models: GPT-5.4, GPT-5.3 Instant
discovered_models: GPT-5.4 mini, GPT-5.4 nano
evaluated: 2026-03-18
---

# GPT-5.4 Mini and Nano Release Discovery

## Summary

OpenAI released GPT-5.4 mini and nano on **March 17, 2026** — new capable small models complementing the standard GPT-5.4.

## Evaluation

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration complexity | 90 | Registry/docs update only — zero config changes to add to tracking |
| Token efficiency | 70 | Mini/nano variants could reduce costs on high-volume discovery pipeline runs |
| Capability expansion | 50 | Incremental — we have GPT-5.4 standard; mini/nano are cheaper alternatives, not new capabilities |
| Maintenance burden | 90 | One-time registry update; models are maintained by OpenAI |
| Community validation | 90 | Official OpenAI release (March 17, 2026) |

**Weighted Score**: (90×0.20) + (70×0.25) + (50×0.25) + (90×0.15) + (90×0.15) = 18 + 17.5 + 12.5 + 13.5 + 13.5 = **75.0/100**

## Decision

**APPROVED** (75.0)

## Integration Notes

- Add GPT-5.4 mini and GPT-5.4 nano to registry and contemporary models table in CLAUDE.md
- Evaluate mini for: capability-discoverer runs (currently Sonnet 4.6), high-volume evaluation tasks
- Evaluate nano for: routing tasks currently using Haiku
- GPT-5.4 standard remains the primary review/research model — mini/nano are cost optimization options
- Key question: What are the exact API model IDs? (e.g., `gpt-5.4-mini`, `gpt-5.4-nano`) — verify before adding to agent configs
