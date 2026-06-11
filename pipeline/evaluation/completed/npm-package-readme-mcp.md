# Discovery: npm Package README MCP Server

- **Source**: https://mcpservers.org/servers/elchika-inc/npm-package-readme-mcp-server
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: MCP server for fetching npm package documentation (README, metadata, search) during development. Helps AI assistants understand library APIs without leaving context.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## Description

An MCP server that enables AI assistants to fetch comprehensive npm package information directly from npm registry.

**Key Features**:
- **Package README Retrieval**: Fetch formatted README with usage examples
- **Package Metadata**: Dependencies, versions, statistics, maintainers
- **Package Search**: Search npm registry with advanced filtering
- **Smart Caching**: Optimize API usage and response times
- **GitHub Integration**: Enhanced README fetching via GitHub API
- **Error Handling**: Retry logic and fallback strategies

**Tools**:
- `get_package_readme`: Retrieve README and usage examples
- `get_package_info`: Comprehensive package metadata
- `search_packages`: Search npm registry with filters

**Configuration**:
```json
{
  "mcpServers": {
    "npm-package-readme": {
      "command": "npx",
      "args": ["npm-package-readme-mcp-server"],
      "env": {
        "GITHUB_TOKEN": "optional_for_higher_rate_limits"
      }
    }
  }
}
```

## Redundancy Check

**Status**: IMPROVEMENT over existing

Checked against registry:
- **Exa get_code_context_exa**: Searches code snippets on web, not npm-specific
- **WebSearch/WebFetch**: Can fetch npm pages but not structured API access
- **No npm-specific MCP**: We don't have direct npm registry integration

**Comparison**:

| Capability | Existing (Exa) | npm-package-readme-mcp |
|------------|----------------|------------------------|
| Fetch package README | Via web scraping | Via npm API (structured) |
| Package metadata | Not available | Yes (deps, versions, stats) |
| Search packages | Generic web search | npm-specific search API |
| Usage examples | Code snippets from web | README-embedded examples |
| Caching | None | Smart caching |
| Token efficiency | Moderate | High (structured data) |

**Verdict**: IMPROVEMENT over web scraping approach, but NARROW use case.

## Evaluation Needs

1. **vs Exa get_code_context_exa**:
   - Exa searches CODE across GitHub, Stack Overflow, docs
   - npm-package-readme fetches DOCS from npm registry
   - Complementary or redundant?

2. **vs WebFetch + npm URLs**:
   - Can WebFetch `https://www.npmjs.com/package/<name>` + prompt "extract README"?
   - Is structured API access worth dedicated MCP overhead?

3. **Token impact**:
   - README content can be LARGE (multi-page docs)
   - Caching helps but initial fetch still costly
   - How does it compare to Exa token usage?

4. **Use case frequency**:
   - How often do we need npm package docs MID-CONVERSATION?
   - vs just opening npmjs.com in browser?
   - Real-world scenario: "How do I use framer-motion?" → Exa code snippets vs npm README?

5. **Key questions**:
   - Does caching persist across sessions?
   - GITHUB_TOKEN requirement reasonable?
   - How does it handle packages with massive READMEs (>50KB)?
   - Does it extract relevant sections or dump entire README?

**Scoring considerations**:
- **Integration complexity**: Easy (20/20)
- **Token efficiency**: Uncertain - could be negative if READMEs are large (??/25)
- **Capability expansion**: Incremental over Exa + WebFetch (15/25)
- **Maintenance burden**: Low - npx tool (13/15)
- **Community validation**: Medium - multiple implementations exist (10/15)

**LIKELY SCORE: 58-70** (borderline)

**Decision factors**:
- If we frequently need package metadata (deps, versions) → Approve
- If READMEs are concise and cached well → Approve
- If Exa code snippets are sufficient → Reject

Needs **comparative benchmark**: Exa vs npm-package-readme-mcp for "explain how to use package X" query.

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6 (capability-evaluator)

### Redundancy Analysis

**Registry check**: Exa `get_code_context_exa` searches code snippets across web. WebFetch can fetch npm URLs. **Classification: IMPROVEMENT** - Structured npm API access vs web scraping.

**Key distinction**:
- **Exa get_code_context_exa**: Searches CODE across GitHub, Stack Overflow, docs (broad, code-focused)
- **WebFetch + npm URLs**: Can fetch npm pages but requires parsing
- **npm-package-readme-mcp**: Structured API access to npm registry (narrow, metadata-focused)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 100/100 | 20% | 20.0 | Simple npx command, optional GITHUB_TOKEN |
| Token Efficiency Impact | 45/100 | 25% | 11.25 | **CRITICAL CONCERN**: READMEs can be massive (>50KB), no excerpt/filtering shown; caching helps repeated queries but NOT first fetch |
| Capability Expansion | 55/100 | 25% | 13.75 | Incremental over Exa (structured metadata) but narrow use case; Exa provides CODE snippets which are more valuable |
| Maintenance Burden | 85/100 | 15% | 12.75 | npx tool, minimal dependencies, npm API is stable |
| Community Validation | 60/100 | 15% | 9.0 | Multiple implementations exist (mcpservers.org listing), but no star count provided |
| **TOTAL** | | | **66.75/100** | **FUTURE** |

### Cross-Validation (Codex)

Used codex-researcher to cross-validate:

**Codex assessment**: 62/100 - "Structured npm API access is cleaner than web scraping, but token overhead from large READMEs is significant concern. Exa provides more valuable code snippets than README documentation. Package metadata (deps, versions) is useful but niche. Borderline - needs evidence of token efficiency in practice."

**Variance**: 4.75 points (acceptable, both agree on borderline status)

### Decision: **FUTURE** (Score: 66.75/100)

**Rationale**: Below 70+ threshold due to:
1. **Token efficiency risk**: READMEs can be 50KB+ (e.g., React, Next.js, Prisma), no evidence of excerpt/filtering
2. **Narrow improvement over Exa**: Exa provides CODE snippets (more valuable) vs README docs (less actionable)
3. **Niche use case**: How often do we need package metadata (deps, versions) mid-conversation vs just code examples?
4. **Caching only helps repeated queries**: First fetch still has full token overhead

### Concerns Requiring Research

1. **Token efficiency**: Does it extract relevant sections or dump entire README?
2. **Caching persistence**: Does caching persist across Claude Code sessions?
3. **Comparison with Exa**: Benchmark "explain how to use framer-motion" with both tools
4. **Use case frequency**: How often do users need npm docs vs code snippets?
5. **Metadata value**: Is package metadata (deps, versions, stats) valuable mid-session?

### Adoption Triggers

Reconsider for integration if:
1. **Evidence of token efficiency**: Demonstration that READMEs are excerpted, not dumped in full
2. **Exa comparison shows gaps**: Benchmark proves npm-package-readme provides value Exa doesn't
3. **Use case validation**: User research shows frequent need for package metadata
4. **Enhanced filtering**: Tool adds "extract relevant sections" or "summarize README" capability

### Alternative Approach (Current)

**Current stack is sufficient**:

For "explain how to use package X" queries:
1. **Exa get_code_context_exa**: Returns actual CODE snippets (GitHub, Stack Overflow) - more actionable than README
2. **WebFetch + npm URL**: Can fetch npm page if README specifically needed
3. **Bash tool**: `npm view <package>` for metadata (deps, versions, stats) - zero token cost

**Example workflow**:
```
User: "How do I use framer-motion?"

Option A (Exa): Returns code snippets from GitHub, Stack Overflow
Option B (npm-readme-mcp): Returns full README (token-heavy)
Option C (WebFetch): Fetch npm page, extract README (similar to MCP)
Option D (Bash): npm view framer-motion (metadata only, zero tokens)

Verdict: Option A (Exa) provides most value
```

### Notes

This MCP solves a problem we already solve better with Exa. The structured API access is nice, but Exa's code snippet focus is more valuable than README documentation. Package metadata is useful but can be retrieved via Bash (`npm view`) at zero token cost.

**Recommendation**: Keep in FUTURE until evidence emerges that:
- Token efficiency is better than expected (excerpting works)
- Exa has gaps that npm-package-readme fills
- Users frequently need package metadata mid-session

If these are demonstrated, re-evaluate for integration. Otherwise, current stack (Exa + WebFetch + Bash) is sufficient.
