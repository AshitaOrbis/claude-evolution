# Discovery: Gemini 3.2 Flash Release

**Date**: 2026-05-09
**Source**: buildfastwithai.com, Gemini API changelog
**Model**: Gemini 3.2 Flash

## Current Status

- **Current production model**: Gemini 3.1 Pro
- **New model**: Gemini 3.2 Flash
- **Release date**: May 5, 2026
- **Status**: Stable, available in iOS app and Google AI Studio

## Details

Google quietly released Gemini 3.2 Flash on May 5, 2026 with no press release or keynote announcement. The model appears in the official iOS Gemini app and Google AI Studio.

**Key characteristics**:
- **Cost**: $0.25 per million input tokens (significantly cheaper than Gemini 3.1 Pro)
- **Speed**: Reportedly faster than Gemini 3.1 Pro
- **Use case**: Lightweight, cost-optimized alternative while maintaining strong performance

## Sources

- [buildfastwithai: Gemini 3.2 Flash Release](https://www.buildfastwithai.com/blogs/gemini-3-2-flash-release-2026)
- [Google Gemini API Changelog](https://ai.google.dev/gemini-api/docs/changelog)

## Recommended Action

1. Add Gemini 3.2 Flash to `state/contemporary-models.json` monitor section
2. Evaluate for potential replacement of Gemini 3.1 Pro in cost-sensitive workflows (e.g., visual-fidelity-inspector, lightweight UI analysis)
3. Compare performance/speed against Gemini 3.1 Pro on key visual analysis tasks
4. If performance is comparable, consider promoting to primary for cost savings

## Integration Notes

- Model ID: `gemini-3-2-flash` (likely)
- Status: Stable (GA)
- Cost advantage: ~70% cheaper per token than Gemini 3.1 Pro (estimated)
- Performance: Comparable or better than Gemini 3.1 Pro per early reports
