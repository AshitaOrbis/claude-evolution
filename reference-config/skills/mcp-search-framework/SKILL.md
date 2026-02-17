# MCP Search Tool Selection Framework

When web search is needed, choose the appropriate tool based on query type.

## Decision Tree

```
Do you need an alternative AI perspective or cross-validation?
  └─ YES → Use Codex: mcp__codex__codex (via codex-researcher subagent)
  └─ NO ↓

Is it about CODE, APIs, libraries, or programming?
  └─ YES → Use Exa: get_code_context_exa
  └─ NO ↓

Is it a LOCATION-based query ("near me", specific city, local business)?
  └─ YES → Use Brave: brave_local_search
  └─ NO ↓

Is it about current NEWS or breaking events?
  └─ YES → Use Brave: brave_news_search
  └─ NO ↓

Do you need IMAGES or VIDEOS?
  └─ IMAGES → Use Brave: brave_image_search
  └─ VIDEOS → Use Brave: brave_video_search
  └─ NO ↓

Is it a complex, exploratory, or semantic query requiring deep understanding?
  └─ YES → Use Exa: web_search_exa (neural search understands intent)
  └─ NO ↓

Is it a simple factual query with specific keywords?
  └─ YES → Use Brave: brave_web_search (fast, reliable)
  └─ NO ↓

Do you need comprehensive research from multiple sources?
  └─ YES → Use Exa: deep_researcher_start, then deep_researcher_check
  └─ NO → Default to Brave: brave_web_search
```

## Tool Capabilities Summary

| Use Case | Primary Tool | Reason |
|----------|--------------|--------|
| Alternative AI perspective | Codex: `mcp__codex__codex` | GPT-5 provides different interpretation |
| Cross-validation of findings | Codex: `mcp__codex__codex` | Second opinion from different AI |
| Multi-turn research sessions | Codex: `mcp__codex__codex-reply` | Preserves context across queries |
| Code examples, API docs, Stack Overflow | Exa: `get_code_context_exa` | AI-native code search, token-efficient |
| "How do I implement X in Y language" | Exa: `get_code_context_exa` | Finds relevant code snippets |
| Local businesses, restaurants, services | Brave: `brave_local_search` | Ratings, hours, addresses |
| Breaking news, current events | Brave: `brave_news_search` | Fresh content, news sources |
| Find images | Brave: `brave_image_search` | Direct image results |
| Find videos, tutorials | Brave: `brave_video_search` | YouTube, video metadata |
| Semantic/exploratory queries | Exa: `web_search_exa` | Neural search understands meaning |
| Simple factual lookups | Brave: `brave_web_search` | Fast, keyword-based |
| Company research, competitor analysis | Exa: `company_research` | Structured business data |
| Extract content from specific URL | Exa: `crawling` | Clean content extraction |
| Deep research reports | Exa: `deep_researcher_start/check` | Multi-source synthesis |
| LinkedIn people/company search | Exa: `linkedin_search` | Professional network data |

## Key Differences

### Brave Search (keyword-based, traditional)
- Independent search index, privacy-focused
- Best for: factual queries, news, local, multimedia
- Rate limit: 1 request/second on free tier
- Strengths: Speed, freshness, diverse result types

### Exa Search (neural/semantic, AI-native)
- Embedding-based search, understands query intent
- Best for: code, semantic queries, research, complex topics
- Strengths: Relevance over keywords, token-efficient output
- `auto` mode: combines neural + keyword for best results

### Codex Research (alternative AI, GPT-5)
- Delegates research to OpenAI's Codex (GPT-5/GPT-5-Codex)
- Best for: cross-validation, second opinions, multi-turn research
- Strengths: Different AI perspective, session persistence
- Subagent: `codex-researcher` for managed research sessions

## Examples

```
"restaurants near downtown Seattle" → Brave: brave_local_search
"latest news on AI regulation" → Brave: brave_news_search
"React useEffect cleanup pattern" → Exa: get_code_context_exa
"companies similar to Stripe" → Exa: company_research
"how do embedding models work" → Exa: web_search_exa (semantic)
"what is the capital of France" → Brave: brave_web_search (factual)
"cross-validate these findings" → Codex: codex-researcher subagent
"get a second opinion on this research" → Codex: codex-researcher subagent
```

## Rate Limits

- **Brave**: 1 request/second (free tier) - space out sequential searches
- **Exa**: Check dashboard for current limits
