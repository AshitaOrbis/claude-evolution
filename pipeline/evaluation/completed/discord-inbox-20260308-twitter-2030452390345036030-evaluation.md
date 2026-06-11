# Evaluation: Google DeepMind "Simply" — Open Source LLM Research Codebase in JAX

- **Date**: 2026-03-08
- **Source**: https://x.com/i/status/2030452390345036030
- **Category**: Open Source AI Infrastructure / LLM Training
- **Automated**: Yes (Twitter re-evaluation)

## Investigation

Fetched via fxtwitter API. Tweet by @crazydonkey200 (Chen Liang, Google DeepMind), March 8, 2026. Reply to Karpathy's nanochat automation tweet. Announces open-sourcing "Simply" — DeepMind's infrastructure for automated research, designed for Gemini to evolve itself. Links to github.com/google-deepmind/simply.

Confirmed via Brave search: Simply is "a minimal and scalable research codebase in JAX, designed as an environment where both humans and AI agents can rapidly iterate on frontier LLM research."

## Content Summary

Google DeepMind's "Simply" is a JAX-based research codebase designed for AI agents to iterate on LLM research. It's the internal infrastructure DeepMind uses for Gemini's self-evolution. Key characteristics:
- Minimal and scalable JAX codebase
- Designed for both humans and AI agents to iterate
- Closer to SOTA LLM pre/post-training than nanochat
- Open-sourced specifically for the research community

While interesting as infrastructure, this is about LLM model training — not about Claude Code agent development, MCP integration, or workflow patterns. We don't train models.

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 15 | JAX-based ML training codebase — completely outside our stack (we use Claude Code, not train models) |
| Token efficiency impact | 25% | 0 | No relevance to token efficiency in agent workflows |
| Capability expansion | 25% | 20 | Interesting reference for AI self-improvement patterns, but not actionable in our context |
| Maintenance burden | 15% | 10 | Would require ML infrastructure we don't have |
| Community validation | 15% | 85 | Google DeepMind official release; significant research community interest |

- **Final Score**: 19.75/100

## Decision

REJECTED — Domain mismatch. Simply is an LLM training research codebase (JAX, TPU, pre/post-training) — we don't train models. While the concept of "AI agents iterating on research" is philosophically aligned with our evolution pipeline, the implementation is entirely in the ML training domain, not agent capability development. Worth noting as a reference that major labs (DeepMind) are pursuing agent-driven self-improvement at the model level.
