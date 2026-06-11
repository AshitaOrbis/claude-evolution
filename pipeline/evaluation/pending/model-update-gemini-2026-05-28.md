# Gemini Model Update Discovery

**Date**: 2026-05-28  
**Status**: New release detected

## Summary

Google announced **Gemini 3.5 Flash** at Google I/O 2026 (May 19-20). This is a new production model now available in the Gemini API and Gemini app.

## Current State
- Primary model: Gemini 3.1 Pro
- Last verified: 2026-05-09
- Monitored variants: Gemini 3.2 Flash (available), Gemini 3.1 Flash-Lite (preview)

## New Models Detected

### Gemini 3.5 Flash (GA)
- **Status**: Generally Available
- **Released**: 2026-05-19 (at Google I/O)
- **Availability**: Gemini app, Gemini API, Google Cloud
- **Performance**: Described as "most intelligent model for sustained frontier performance on agentic and coding tasks"
- **Positioning**: Successor to Gemini 3.2 Flash
- **Source**: https://ai.google.dev/gemini-api/docs/changelog, https://mashable.com/article/google-io-2026-gemini-35-flash

### Gemini 3.5 Pro (In Testing)
- **Status**: Internal testing, expected GA June 2026
- **Class**: Heavier-weight version comparable to GPT-5.5
- **Positioning**: For complex reasoning and advanced tasks
- **Source**: https://www.cnbc.com/2026/05/19/google-ai-ultra-gemini-spark-omni.html

### Gemini Omni (New Series)
- **Status**: Announced, details unclear
- **Description**: New series combining reasoning capabilities
- **Source**: https://9to5google.com/2026/05/19/google-io-2026-news/

## Evaluation Recommendation

- **Gemini 3.5 Flash**: Evaluate for promotion to primary visual model (may improve visual-fidelity-inspector performance/cost vs 3.1 Pro)
- **Gemini 3.5 Pro**: Wait for GA in June 2026, then evaluate for heavy-reasoning tasks
- **Gemini Omni**: Monitor for further details

## Action Items

1. Update `state/contemporary-models.json` with Gemini 3.5 Flash entry
2. Evaluate whether 3.5 Flash should replace 3.1 Pro as primary visual model
3. Track 3.5 Pro release in June 2026
4. Monitor Gemini Omni announcements

## Sources

- https://ai.google.dev/gemini-api/docs/changelog
- https://mashable.com/article/google-io-2026-gemini-35-flash
- https://www.cnbc.com/2026/05/19/google-ai-ultra-gemini-spark-omni.html
- https://cloud.google.com/blog/products/ai-machine-learning/innovations-from-google-io-26-on-google-cloud
