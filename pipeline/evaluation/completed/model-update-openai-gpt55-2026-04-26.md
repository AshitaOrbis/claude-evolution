# Model Discovery: GPT-5.5 Available

**Date**: 2026-04-26
**Provider**: OpenAI
**Detection Date**: 2026-04-26

## Summary

GPT-5.5, OpenAI's latest flagship AI model, was released on April 24, 2026 and is now available in the API.

## Current vs New

| Component | Current | New |
|-----------|---------|-----|
| Primary Model | GPT-5.4 | **GPT-5.5** |
| Release Date | (prior) | April 24, 2026 |
| Status | Production | Production |

## Key Details

**Model Name**: GPT-5.5
**API Availability**: April 24, 2026
**Described as**: "Smartest and most intuitive to use model" yet
**Key Improvements**:
- Better at coding (improved agentic coding)
- Stronger computer use capabilities
- Better knowledge work
- Deeper research capabilities

**Variants**:
- GPT-5.5 (base)
- GPT-5.5 Pro (premium variant)

## Source URLs

- [OpenAI: Introducing GPT-5.5](https://openai.com/index/introducing-gpt-5-5/)
- [TechCrunch: OpenAI releases GPT-5.5](https://techcrunch.com/2026/04/23/openai-chatgpt-gpt-5-5-ai-model-superapp/)
- [CNBC: OpenAI announces GPT-5.5](https://www.cnbc.com/2026/04/23/openai-announces-latest-artificial-intelligence-model.html)

## Recommended Action

This is a major version update from GPT-5.4 to GPT-5.5. Evaluation should consider:

1. Whether GPT-5.5 should replace GPT-5.4 as the primary Codex model in `~/.claude/CLAUDE.md`
2. Impact on subagents using `mcp__codex__codex`:
   - `code-reviewer`
   - `codex-researcher`
   - `codex-coder`
   - `fact-checker`
   - Other Codex-dependent agents
3. Testing against existing use cases to verify improvements in code review, research, and code generation
4. Whether GPT-5.5 Pro variant warrants testing for specialized use cases

## Notes

- This is a genuine production release, not a preview/beta version
- OpenAI released this just 2 days before the current check date (April 24 vs April 26)
- Replaces GPT-5.4 as the latest production model
