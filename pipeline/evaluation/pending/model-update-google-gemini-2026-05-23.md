# Gemini Model Updates from Google I/O 2026

**Date discovered**: 2026-05-23  
**Event**: Google I/O 2026 (May 20, 2026)  
**Models affected**: Gemini family

## Current State
- Primary: Gemini 3.1 Pro (`gemini-3.1-pro-preview`)
- Last verified: 2026-05-09

## New Models Detected

### Gemini Omni Flash (NEW)
- **Announced**: May 20, 2026 at Google I/O 2026
- **Family**: Omni (new family)
- **Capabilities**: 
  - First model in the Omni family
  - Agentic AI capabilities
  - Character consistency improvements for multimodal workflows
  - Video generation improvements (Omni Flash improves character consistency across scenes)
- **Likely ID**: `gemini-omni-flash` (tentative)
- **Status**: Available (announced at I/O)
- **Source**: 
  - https://blog.google/innovation-and-ai/sundar-pichai-io-2026/
  - https://cybernews.com/ai-news/google-io-2026-gemini-omni-antigravity-agentic-ai/

### Gemini 3.5 Flash (NEW)
- **Announced**: May 20, 2026 at Google I/O 2026
- **Family**: 3.x (incremental from 3.2)
- **Status**: Available (announced at I/O)
- **Likely improvements**: Likely faster/cheaper than 3.2, continuing the Flash cost-optimization trend
- **Source**: https://cybernews.com/ai-news/google-io-2026-gemini-omni-antigravity-agentic-ai/

## Comparison to State File

| Model | Old State | New | Notes |
|-------|-----------|-----|-------|
| Primary Gemini | 3.1 Pro | Still 3.1 Pro | No immediate replacement announced yet |
| Gemini 3.2 Flash | Monitor (available, 2026-05-05) | Confirmed | Already in monitor section |
| Gemini 3.5 Flash | Not tracked | MONITOR | New model announced at I/O |
| Gemini Omni Flash | Not tracked | MONITOR | New family announced at I/O |

## Recommended Action

1. **Add to monitor section** (not primary yet):
   - `gemini_35_flash`: Status preview/available, released 2026-05-20, notes "Cost-optimized variant in 3.x line"
   - `gemini_omni_flash`: Status preview/available, released 2026-05-20, notes "First Omni family model with agentic AI and improved multimodal character consistency"

2. **Evaluation gates**:
   - Gemini 3.5 Flash: Likely candidate for visual-fidelity-inspector if performance/cost ratio is better than 3.2
   - Gemini Omni Flash: Candidate for agentic workflows and multimodal video generation; wait for availability/pricing details

3. **No primary update required** until Omni/3.5 have proven track records and public availability

## Sources

- [Sundar Pichai's I/O 2026 keynote](https://blog.google/innovation-and-ai/sundar-pichai-io-2026/) — First Gemini Omni Flash announcement
- [Google I/O 2026 announcements](https://blog.google/innovation-and-ai/technology/ai/google-io-2026-all-our-announcements/) — Comprehensive feature list
- [Cybernews coverage](https://cybernews.com/ai-news/google-io-2026-gemini-omni-antigravity-agentic-ai/) — Model availability details
