# AutoNovel: AI-Powered Novel Generation

- **Date**: 2026-03-19
- **Source**: Discord #general inbox
- **URL**: https://github.com/NousResearch/autonovel
- **Category**: tool, creative-writing, ai-agent
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1484291011889856670

## Description

AutoNovel is a framework for autonomous novel generation from Nous Research. The user specifically noted potential applications for both the translation project and the amnesiac-story project, with mention of creating a new experimental folder for stories based on this framework.

## Relevance

Direct relevance to creative writing projects in workspace. Could provide scaffolding or patterns for story generation workflows, particularly applicable to the amnesiac-story experiment currently under development and potential expansion of the webnovel-translation pipeline.

## Classification

To be evaluated by the standard pipeline.

---

## Evaluation

**Evaluated**: 2026-03-20
**Decision**: NEEDS_RESEARCH (54.25/100)

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 60 | Run as external tool or extract patterns; relatively straightforward GitHub repo |
| Token efficiency impact | 25% | 45 | Adds another framework; may duplicate existing story agent work without token savings |
| Capability expansion | 25% | 55 | Could provide new generation patterns for amnesiac-story/translation pipeline, but we already have story-writer/curator/editor agents |
| Maintenance burden | 15% | 60 | Nous Research backing; likely active development |
| Community validation | 15% | 55 | Nous Research is credible; star count unverified |

**Weighted Score**: (60×0.20) + (45×0.25) + (55×0.25) + (60×0.15) + (55×0.15) = 12 + 11.25 + 13.75 + 9 + 8.25 = **54.25/100**

**Research Questions**:
1. What is the GitHub star count for NousResearch/autonovel?
2. Does AutoNovel work with any LLM (including Claude) or is it OpenAI/provider-locked?
3. How does AutoNovel's generation architecture differ from our existing story-writer → story-curator → story-editor pipeline?
4. What would a concrete "new experimental folder for stories based on this framework" actually look like?
5. Does it produce better narrative quality, or is it primarily about automation/scale of generation?

**Re-evaluation trigger**: When star count is confirmed (target: 200+ for confidence), or when a concrete use case is identified for amnesiac-story/translation that AutoNovel uniquely solves.
