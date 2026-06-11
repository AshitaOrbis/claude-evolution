# Evaluation: Karpathy on DeepWiki MCP for Library Extraction

- **Date**: 2026-03-08
- **Source**: https://x.com/i/status/2021633574089416993
- **Category**: AI Development Tools / MCP Integration
- **Automated**: Yes (Twitter re-evaluation)

## Investigation

Fetched via fxtwitter API. Tweet by @karpathy (Andrej Karpathy), February 11, 2026. Discusses DeepWiki's MCP integration with GitHub CLI to extract FP8 training functionality from torchao library, reimplemented as self-contained 150-line module for nanochat. Engagement: 7,271 likes, 778 retweets, 1M+ views. Mentions "libraries are over, LLMs are the new compiler" concept.

## Content Summary

Karpathy demonstrates using DeepWiki (deepwiki.com) as an MCP-integrated tool to understand library internals and extract self-contained implementations. The workflow: point DeepWiki at a library repo, query its MCP interface to understand internals, then rewrite a minimal version. He got a 3% speedup by extracting FP8 training from torchao into 150 lines for nanochat.

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 60 | DeepWiki is a third-party service; MCP integration exists but adds external dependency |
| Token efficiency impact | 25% | 55 | Neutral to slightly positive — replaces reading library docs but requires DeepWiki queries |
| Capability expansion | 25% | 65 | Novel concept of library-to-module extraction via AI, but more of a workflow pattern than tool |
| Maintenance burden | 15% | 50 | External service dependency, API changes could break workflow |
| Community validation | 15% | 90 | Karpathy endorsement with massive engagement (7K likes, 1M views) |

- **Final Score**: 63.0/100

## Decision

NEEDS_RESEARCH — Interesting workflow pattern (AI-assisted library extraction via DeepWiki MCP) with strong community signal from Karpathy, but unclear whether the DeepWiki MCP integration provides value beyond existing code understanding tools (Exa get_code_context, Codex). Would need hands-on evaluation of DeepWiki MCP quality and token cost to determine if it beats current approaches. The "libraries are over" philosophy is thought-provoking but the practical tool integration needs vetting.
