# YouTube MCP Server (Transcript & Metadata)

**Source**: https://www.producthunt.com/products/youtube-mcp-server
**Date**: 2026 (Product Hunt listing)
**Category**: MCP Server - Video Content Analysis
**Description**: "MCP server for YouTube video transcription and metadata extraction"

## Description

MCP server providing YouTube video transcription and metadata access. Enables AI assistants to analyze YouTube content by extracting transcripts and video metadata.

**Key Capabilities** (inferred):
- Video transcript extraction
- Metadata retrieval (title, description, views, duration, etc.)
- Likely channel information
- Possibly comment analysis

## Why It Might Matter

- **Content research** - Analyze YouTube videos for research/discovery
- **Learning from videos** - Extract knowledge from video tutorials
- **Competitive analysis** - Study competitor video content
- **Documentation** - Transcribe video content to text

## Redundancy Check

**Keywords searched**: "youtube", "video transcript", "video analysis", "content extraction"

**Registry match**: NONE

**Existing capabilities that partially overlap**:
- **WebFetch** - Can fetch YouTube page HTML (but not transcripts)
- **Brave/Exa search** - Can find YouTube videos (but not analyze content)
- **No video content extraction** currently

**Classification**: **NOVEL** - No video content analysis capabilities exist

## Use Case Assessment

**Potential use cases in our workflow**:

1. **Capability Discovery**:
   - Watch MCP tutorials/announcements → extract key points
   - Analyze Claude Code demo videos → document features
   - Research competitor products from demo videos

2. **Learning/Documentation**:
   - Extract information from coding tutorials
   - Transcribe conference talks for reference
   - Document video-based product demos

3. **Content Creation** (games):
   - Research game mechanics from YouTube gameplay
   - Analyze successful game trailers
   - Extract feedback from Let's Play videos

**Frequency**: MODERATE - Occasional research, not daily workflow

## Preliminary Assessment

| Criterion | Score (0-100) | Reasoning |
|-----------|---------------|-----------|
| Integration complexity | 75 | Likely simple npm package, uses YouTube API |
| Token efficiency | 60 | Transcripts can be long (token overhead) |
| Capability expansion | 70 | Novel - enables video content analysis |
| Maintenance burden | 60 | Community-maintained (not official Google) |
| Community validation | 40 | Product Hunt listing, no GitHub stars visible |

**Estimated Score**: **NEEDS RESEARCH** (60-70 range, pending GitHub validation)

## Questions Before Evaluation

1. **GitHub repository**: Need to verify stars, maintenance, license
2. **YouTube API quotas**: Does it require YouTube API key? Quota limits?
3. **Transcript quality**: Does it use official YouTube transcripts or third-party?
4. **Token overhead**: How verbose are typical transcripts?
5. **Comparison**: Better than manually copy-pasting transcripts?

## Integration Path (If Approved)

**Type**: MCP Server
**Target**: `~/.claude.json` mcpServers section
**Requirements**: Likely YouTube API key (free tier quotas)

## Action Required

Move to **research phase**:

1. Find GitHub repository
2. Check YouTube API quota limits (10,000 units/day free)
3. Test transcript quality vs manual extraction
4. Evaluate token overhead for typical videos
5. Compare to alternative: manual transcript copy-paste

## Notes

- **YouTube API quotas** could be limiting factor (search = 100 units, video details = 1 unit)
- Transcripts available directly on YouTube (copy-paste workaround exists)
- Value depends on frequency of video research in workflow
- May be more valuable for content creators than developers
- Similar tools: yt-dlp (CLI), youtube-transcript-api (Python) - check if MCP adds value over Bash

**Status**: **PENDING RESEARCH** - Need GitHub repo and quota analysis before final decision

---

## Evaluation

**Evaluated**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Scoring Breakdown

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 70/100 | 20% | 14.0 | Likely simple npm package, YouTube API key required |
| Token Efficiency | 40/100 | 25% | 10.0 | Transcripts token-heavy; minimal vs manual copy-paste |
| Capability Expansion | 55/100 | 25% | 13.75 | Novel video analysis capability, but low frequency use |
| Maintenance Burden | 60/100 | 15% | 9.0 | Community-maintained (not official Google) |
| Community Validation | 40/100 | 15% | 6.0 | Product Hunt listing only, no visible GitHub stars |
| **TOTAL** | | | **52.75/100** | |

### Cross-Validation: Not Required
Score in 50-69 range - FUTURE status appropriate, no cross-validation needed for conditional approval.

### Redundancy Check

**Classification**: NOVEL - No video content analysis capabilities exist

**Existing overlap**:
- WebFetch: Can fetch YouTube page HTML (but NOT transcripts)
- Brave/Exa: Can find YouTube videos (but NOT analyze content)
- **youtube-transcriber subagent**: Already exists for transcript extraction!

**CRITICAL FINDING**: User instructions mention "youtube-transcriber subagent" - CHECK IF THIS ALREADY EXISTS!

### Context Check: youtube-transcriber Subagent

Per user context: "We have... YouTube transcription via youtube-transcriber subagent"

**This capability ALREADY EXISTS as a subagent!**

### Re-Classification

**STATUS**: **DUPLICATE** - youtube-transcriber subagent already provides this capability

### Updated Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 70/100 | 20% | 14.0 | Would require setup, but irrelevant (duplicate) |
| Token Efficiency | 20/100 | 25% | 5.0 | MCP overhead vs existing subagent (WORSE efficiency) |
| Capability Expansion | 10/100 | 25% | 2.5 | Duplicate of youtube-transcriber subagent |
| Maintenance Burden | 60/100 | 15% | 9.0 | Community-maintained |
| Community Validation | 40/100 | 15% | 6.0 | Low validation |
| **REVISED TOTAL** | | | **36.5/100** | |

### Final Decision

**STATUS**: REJECTED (Score: 36.5/100)

**Rejection Reasons**:
1. **100% DUPLICATE** - youtube-transcriber subagent already exists
2. **Worse implementation** - MCP overhead vs direct subagent approach
3. **Token inefficiency** - MCP adds cost over existing solution
4. **Low validation** - Product Hunt only, no GitHub visibility

**Kill Signal**: "MCP wrapper of existing subagent capability"

### Notes

- youtube-transcriber subagent = existing solution (mentioned in user context)
- MCP would add token overhead for same functionality
- Similar rejection pattern: filesystem-mcp (duplicates Read/Write/Edit), git-mcp (duplicates Bash git)
- Subagent approach is more flexible (can use yt-dlp, youtube-transcript-api, or any Python tool)
- DO NOT integrate - use existing subagent
