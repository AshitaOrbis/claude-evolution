# Model Update: OpenAI GPT-5.5

**Detection Date**: 2026-04-25  
**Discovery Source**: Brave Web Search  
**Model Category**: External AI Model

## Current Status

| Model | Version | Status |
|-------|---------|--------|
| **Previous** | GPT-5.4 | Archived |
| **Current** | GPT-5.5 | Released April 23-24, 2026 |

## Details

OpenAI released **GPT-5.5** on April 23-24, 2026. This is a new flagship model succeeding GPT-5.4.

**Key capabilities:**
- Improved coding and agentic workflows
- Enhanced computer use capabilities
- Stronger knowledge work and research capabilities
- More intuitive interface

**Variants available:**
- GPT-5.5 (base)
- GPT-5.5 Pro (enhanced variant)

**Status:** Generally available in ChatGPT and via OpenAI API (as of April 24, 2026)

**Release notes:** https://openai.com/index/introducing-gpt-5-5/

## Sources

1. TechCrunch: "OpenAI releases GPT-5.5, bringing company one step closer to an AI 'super app'"
   - https://techcrunch.com/2026/04/23/openai-chatgpt-gpt-5-5-ai-model-superapp/

2. CNBC: "OpenAI announces GPT-5.5, its latest artificial intelligence model"
   - https://www.cnbc.com/2026/04/23/openai-announces-latest-artificial-intelligence-model.html

3. OpenAI Official: "Introducing GPT-5.5"
   - https://openai.com/index/introducing-gpt-5-5/

4. Releasebot: OpenAI Release Notes
   - https://releasebot.io/updates/openai

## Recommended Action

**EVALUATE** for adoption in the following contexts:

1. **Codex integration**: Consider whether GPT-5.5 should replace GPT-5.4 as the default for `codex-researcher` and `codex-coder` agents. Stronger coding capabilities suggest potential improvement for code review workflows.

2. **Agent references**: Update references in:
   - `~/.claude/CLAUDE.md` (Contemporary AI Models table)
   - Agent frontmatter documentation (codex-coder, codex-researcher)
   - `registry/existing-capabilities.md` (model tracking section)

3. **Backward compatibility**: GPT-5.4 may be retired by OpenAI at an unspecified future date. Plan for deprecation.

## Notes

- This is a **genuine new model release**, not a variant or preview (unlike Gemini 3.1 Flash variants)
- **Cost/performance tradeoff**: Research needed on token pricing and latency compared to GPT-5.4
- **Prompt compatibility**: Check whether existing prompts optimized for GPT-5.4 benefit from retargeting to GPT-5.5
- Not a critical blocker (GPT-5.4 remains functional), but represents best-practice alignment
