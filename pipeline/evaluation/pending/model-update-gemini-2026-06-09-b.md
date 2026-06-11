# Discovery: Gemini 3.5 Pro Release

**Date**: 2026-06-09  
**Status**: NEW major release (GA expected June 2026)  
**Source**: Google I/O 2026 announcements and TechTimes reporting

## Summary

Gemini 3.5 Pro was unveiled at Google I/O on May 19, 2026, with general availability slated for June 2026. Given today's date (June 9), this model is likely now in GA or within days of GA.

## Current vs New

| Aspect | Current | New |
|--------|---------|-----|
| **Pro model** | Gemini 3.1 Pro | Gemini 3.5 Pro |
| **Frontier positioning** | Standard Pro | Frontier reasoning tier |
| **Context window** | Not specified | 2M tokens |
| **Capabilities** | General reasoning | Deep think reasoning, long-horizon context |

## Key Details

- **Model ID**: `gemini-3.5-pro` (expected)
- **Status**: GA (general availability in June 2026, as of check date June 9)
- **Announcement date**: May 19, 2026 (Google I/O)
- **Features**: 
  - 2 million token context window
  - Deep think reasoning (frontier-class reasoning)
  - Positioned to compete with frontier AI models
  - Long-horizon coding task support
  
## Source URLs

- https://www.techtimes.com/articles/317919/20260606/google-gemini-35-pro-nears-june-launch-2-million-token-context-deep-think-reasoning.htm
- https://deepmind.google/models/gemini/ (mentions Gemini 3.5 series)

## Recommended Action

1. Evaluate Gemini 3.5 Pro as a potential upgrade path from Gemini 3.1 Pro
2. Benchmark against current 3.1 Pro on visual analysis and complex reasoning tasks
3. Assess 2M context window advantage for long-horizon code understanding
4. Consider token cost impact: likely higher than 3.1 Pro for frontier reasoning capability
5. If performance is significantly better on complex tasks, promote 3.5 Pro to primary visual analysis model

## Integration Impact

- **Updated location**: `state/contemporary-models.json` models section (upgrade from 3.1 Pro)
- **Affected components**: 
  - visual-fidelity-inspector (currently hardcoded to 3.1 Pro)
  - Any other Gemini-dependent workflows
- **Risk**: Medium — this is a frontier model and cost/performance tradeoff needs validation
- **Note**: May replace 3.1 Pro as primary or run in parallel for evaluation period
