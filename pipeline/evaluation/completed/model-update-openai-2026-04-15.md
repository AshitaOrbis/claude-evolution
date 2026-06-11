# Model Update Discovery: GPT-5.4-Cyber

**Date**: 2026-04-15
**Detected**: April 14, 2026 release
**Source**: OpenAI official announcement, Reuters, NYT

## Current State

- Main model: `gpt-5.4`
- Monitor list: GPT-5.4 Thinking, GPT-5.4 Mini, GPT-5.4 Nano

## New Model Detected

**GPT-5.4-Cyber** (`gpt-5.4-cyber`)
- **Released**: April 14, 2026
- **Availability**: Limited basis to vetted security vendors, organizations, and researchers
- **Purpose**: Cybersecurity-focused variant with more permissive design to find security holes in software
- **Status**: Not yet generally available; requires approval for access

## Source URLs

- Reuters: https://www.reuters.com/technology/openai-unveils-gpt-54-cyber-week-after-rivals-announcement-ai-model-2026-04-14/
- NYT: https://www.nytimes.com/2026/04/14/technology/openai-cybersecurity-gpt54-cyber.html

## Recommended Action

1. Add GPT-5.4-Cyber to the monitor list in `state/contemporary-models.json` with status `available-limited`
2. Document availability restrictions (vetted organizations only)
3. No immediate integration needed — this is a specialized variant for security testing, not a general-purpose model replacement
4. Re-evaluate when general availability is announced

## Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Integration complexity | 90 | Trivial — update models state file |
| Token efficiency impact | 50 | Neutral — specialized security variant, different use case |
| Capability expansion | 10 | Near-zero — limited access (vetted orgs only), security-specific focus not applicable to our workflow |
| Maintenance burden | 80 | Low — monitor for GA announcement |
| Community validation | 80 | Official OpenAI + Reuters/NYT coverage |

**Total**: (90×0.20) + (50×0.25) + (10×0.25) + (80×0.15) + (80×0.15) = 18 + 12.5 + 2.5 + 12 + 12 = **57.0**

**Decision**: NEEDS_RESEARCH

**Reasoning**: This is a monitoring/state-file update item, not a capability integration. Limited access (vetted organizations only) makes capability_expansion effectively zero for our system. Score of 57.0 = NEEDS_RESEARCH — research question is "when will GA be announced?" Action: update `state/contemporary-models.json` to add GPT-5.4-Cyber as `available-limited` entry. No further evaluation needed until GA.

**Research questions**:
1. Is there a public access request process for GPT-5.4-Cyber?
2. What is the OpenAI roadmap for general availability?
3. When GA is announced, re-evaluate with capability_expansion = 60+ (security audit use cases)

**Evaluated**: 2026-04-15
