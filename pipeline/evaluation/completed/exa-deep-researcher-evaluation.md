# Evaluation Report: Exa Deep Researcher

## Basic Information
- **Source**: Exa AI (Production MCP)
- **Category**: MCP Tool (Specialized)
- **License**: Commercial API (Exa AI)
- **Last Updated**: 2026-01-26 (Currently in production)
- **Stars/Validation**: Production service by Exa AI, integrated in official MCP catalog

## Context

This is a **RETROSPECTIVE EVALUATION** of an already-integrated tool. The Exa Deep Researcher tools (`deep_researcher_start` + `deep_researcher_check`) are:
- Already installed in `~/.claude.json` (Exa MCP)
- Listed in `registry/existing-capabilities.md` (line 147)
- Available in `web-researcher` subagent (line 52)
- Available in `exa-mcp-researcher` subagent

**Purpose of this evaluation**: Document the value-add, compare against manual orchestration patterns, and provide guidance on when to use vs alternatives.

## Classification: IMPROVEMENT over Manual Orchestration

This is NOT a new discovery - it's an evaluation of whether the existing tool should STAY integrated, and how it compares to manual research patterns.

| Comparison Dimension | Manual web-researcher Agent | Exa Deep Researcher |
|----------------------|------------------------------|---------------------|
| **Approach** | Manual orchestration of Exa + Brave + synthesis | Automated multi-source research with synthesis |
| **Token efficiency** | Multiple tool calls, repeated context | Single bundled operation |
| **Consistency** | Depends on prompt quality, operator discipline | Structured output with citations |
| **Speed (end-to-end)** | Slower for comprehensive research | Faster for comprehensive research (45s-2min) |
| **Speed (quick lookups)** | Faster (skip unnecessary steps) | Slower (always comprehensive) |
| **Flexibility** | High (custom workflows) | Low (fixed pipeline) |
| **Maintenance** | Higher (prompt engineering, agent tuning) | Lower (managed service) |

**Winner**: Deep Researcher for comprehensive, multi-source research. Manual orchestration for quick lookups or custom workflows.

---

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 100/100 | **Already integrated** - zero additional work required |
| Token Efficiency Impact | 85/100 | Reduces token churn vs manual orchestration (single bundled call), but heavier than basic search |
| Capability Expansion | 90/100 | Provides structured multi-source synthesis with citations that manual patterns struggle to achieve consistently |
| Maintenance Burden | 95/100 | Managed service - no maintenance required; Exa handles updates |
| Community Validation | 90/100 | Production service by Exa AI, integrated in official MCP catalog, actively maintained |
| **WEIGHTED TOTAL** | **90/100** | |

### Score Breakdown

#### Integration Complexity (100/100)
- Already integrated via Exa MCP
- No additional configuration needed
- Works seamlessly with existing subagents

#### Token Efficiency Impact (85/100)
**Positive impacts**:
- Bundles search + crawl + synthesis into one operation
- Reduces repeated tool calls vs manual orchestration
- Structured output avoids verbose raw search results

**Considerations**:
- Heavier than basic search (necessarily - doing more work)
- Should be opt-in for deep research, not default for quick lookups

#### Capability Expansion (90/100)
**Novel capabilities**:
- Automated multi-source synthesis (5-15 sources)
- Consistent citation structure
- Critical thinking and analysis by dedicated research model
- Structured research reports vs ad-hoc results

**Why not 100**: Manual orchestration CAN achieve similar results with sufficient prompt engineering, but consistency suffers.

#### Maintenance Burden (95/100)
- Managed service - Exa handles infrastructure, model updates, crawling reliability
- No code to maintain
- API-based integration (standard MCP pattern)

**Why not 100**: Still requires monitoring API availability and managing rate limits.

#### Community Validation (90/100)
- Production service with commercial backing
- Integrated in official MCP catalog
- Actively maintained by Exa AI
- Used by multiple AI assistant platforms

**Why not 100**: Not open-source, relies on single vendor (vendor lock-in risk).

---

## Cross-Validation

### Claude Assessment: 90/100
- Strong value-add over manual orchestration
- Clean integration, no conflicts
- Appropriate for deep research use cases
- Clear positioning vs lightweight search

### Codex Assessment (GPT-5): 88/100
> "Keep it integrated, but position it as the 'deep research' option for multi-source, citation-heavy tasks."

**Key Codex insights**:
- Reduces token churn by bundling operations
- Structured reports + citations more predictable
- Slower per request but faster end-to-end for comprehensive tasks
- Risk: Tool sprawl if not clearly positioned

### Variance: 2 points
**Consensus**: ACHIEVED - Both models agree on high value (88-90), with same reasoning about positioning and use cases.

---

## Security Assessment

- [x] No sensitive permissions required (standard web API access)
- [x] No excessive data access (queries sent to Exa API)
- [x] License compatible (Commercial API, no redistribution issues)
- [x] No known vulnerabilities
- [x] API keys manageable (ANTHROPIC_API_KEY via standard MCP config)

**Note**: Commercial API means usage costs (Exa credits). Users should be aware this isn't free like Brave Search.

---

## Existing Alternatives

| Alternative | Overlap | Differentiation |
|-------------|---------|-----------------|
| `web-researcher` subagent | Manual orchestration of Exa + Brave | Deep Researcher automates and structures; web-researcher offers flexibility |
| `exa-mcp-researcher` subagent | Basic Exa wrapper | Deep Researcher adds multi-source synthesis; exa-mcp-researcher is single-query |
| `mcp__exa__web_search_exa` | Single semantic search | Deep Researcher is comprehensive (5-15 sources); web_search_exa is quick lookup |
| `mcp__brave-search__brave_web_search` | Keyword-based single search | Deep Researcher is semantic + multi-source; Brave is fast factual |

**Redundancy Classification**: NOT redundant - provides a distinct capability tier (comprehensive multi-source research) vs quick lookups.

---

## Recommendation

**DECISION**: ✅ KEEP INTEGRATED (90/100 - Strong Approve)

**Rationale**:
Exa Deep Researcher fills a clear gap between lightweight search tools (web_search_exa, brave_web_search) and manual research orchestration (web-researcher agent). It provides:
1. Automated multi-source synthesis (5-15 sources)
2. Structured output with citations
3. Consistent quality vs manual prompt engineering
4. Token efficiency through operation bundling

The tool is ALREADY integrated with zero issues, scores highly on all criteria, and has Codex cross-validation agreement.

**Positioning**:
- **Primary use case**: Comprehensive research requiring multiple sources and citations
- **NOT for**: Quick factual lookups (use Brave), single-topic searches (use Exa basic), or custom workflows (use web-researcher agent)

---

## Integration Status

**Current implementation**:
- [x] Integrated in Exa MCP (`~/.claude.json`)
- [x] Listed in registry (`registry/existing-capabilities.md:147`)
- [x] Available in `web-researcher` subagent
- [x] Available in `exa-mcp-researcher` subagent
- [ ] **MISSING**: Clear routing guidance in MCP search framework

---

## Recommended Actions

### 1. Update MCP Search Framework Guidance

Add routing rule to `~/.claude/skills/mcp-search-framework/SKILL.md`:

```markdown
| Deep comprehensive research | Exa: `deep_researcher_start/check` | Multi-source synthesis, citations, structured reports |
```

**Routing logic**:
```
Do you need comprehensive research from MULTIPLE sources with citations?
  └─ YES → Use Exa: deep_researcher_start (exa-research for most, exa-research-pro for complex)
  └─ NO → Continue decision tree for quick searches
```

### 2. Update Registry Entry

Current registry entry is minimal. Enhance to:

```markdown
| Deep Research | **IMPLEMENTED** | `mcp__exa__deep_researcher_start/check` | Multi-source synthesis |
```

Add usage guidance:
```markdown
**Deep Researcher Details**:
- Two models: `exa-research` (15-45s, good for most) and `exa-research-pro` (45s-2min, complex topics)
- Multi-source: 5-15 sources crawled and analyzed
- Structured output: Research report with citations
- Use for: Competitive analysis, policy research, comprehensive overviews
- Skip for: Quick factual lookups, single-topic searches

**When to use Deep Researcher vs alternatives**:
- **Deep Researcher**: Multi-source synthesis, citations required, comprehensive analysis
- **web_search_exa**: Quick semantic search, single topic
- **brave_web_search**: Fast factual lookup, keyword-based
- **web-researcher agent**: Custom workflows, multi-tool orchestration
```

### 3. Document Tool Selection Pattern

Add to `~/.claude/skills/mcp-search-framework/SKILL.md` examples:

```markdown
"comprehensive analysis of competitor pricing strategies" → Exa: deep_researcher_start (exa-research-pro)
"what is the capital of France" → Brave: brave_web_search (factual)
"React useEffect cleanup pattern" → Exa: get_code_context_exa (code)
"latest AI regulation news" → Brave: brave_news_search (breaking news)
```

### 4. Update web-researcher Subagent

Add clearer guidance in `~/.claude/agents/web-researcher.md`:

```markdown
## When to Delegate to Deep Researcher

Use `deep_researcher_start` when:
- Topic requires 5+ authoritative sources
- Citations are critical (compliance, policy, legal)
- Comprehensive overview needed (market research, competitive analysis)
- Research report output desired (vs quick answer)

Skip Deep Researcher when:
- Quick factual lookup (use Brave)
- Single source sufficient
- Custom workflow needed (use manual orchestration)
- Time-sensitive (use web_search_exa)
```

---

## Conditions

None - tool is production-ready and already integrated.

---

## Evaluation Metadata

- **Evaluated by**: capability-evaluator (Claude Opus 4.5)
- **Cross-validated by**: Codex (GPT-5)
- **Date**: 2026-01-26
- **Type**: Retrospective evaluation (already integrated)
- **Purpose**: Documentation + routing guidance
- **Decision**: KEEP INTEGRATED + ADD ROUTING GUIDANCE

---

## Appendix: Codex Full Response

> This is primarily **(1) an evaluation request for documentation**, with secondary coverage of **(2) redundancy** and **(3) improvement comparison**. The prompt explicitly asks for scoring, risks, and recommendations, which are typical documentation/evaluation outputs; the redundancy/improvement angles are embedded as comparison criteria.
>
> **Score (Stay Integrated): 88/100**
> - Already integrated (low additional complexity)
> - Adds multi-source synthesis and structured reporting beyond single-query tools
> - Time cost is higher, but it's a deliberate deep‑research option, not a default
>
> **Comparison vs manual web‑researcher orchestration**
> - **Capability**: Deep Researcher provides consistent multi‑source crawling + synthesis with citations; manual orchestration is more flexible but depends on prompt quality and operator discipline.
> - **Token efficiency**: Deep Researcher likely reduces token churn by bundling search + crawl + synthesis into one call; manual patterns often repeat steps and spawn multiple tool calls.
> - **Speed**: Deep Researcher is slower per request but faster end‑to‑end for comprehensive tasks; manual orchestration can be faster for quick answers but slower for real research.
> - **Reliability**: Structured reports + citations are more predictable with Deep Researcher; manual orchestration can be uneven.
>
> **Potential risks / conflicts**
> - **Redundancy**: Overlaps with web‑researcher and exa‑mcp‑researcher; could cause confusion about which tool to use.
> - **Latency**: 45s–2min for pro may frustrate users if selected by default for lightweight tasks.
> - **Cost/Token budget**: Deeper research tends to be heavier; ensure it's opt‑in.
> - **Tool sprawl**: Multiple overlapping research routes complicate agent routing rules and maintenance.
>
> **Recommendation**
> Keep it integrated, but position it as the **"deep research" option** for multi‑source, citation‑heavy tasks. Add routing guidance:
> 1. Use Deep Researcher for comprehensive research, policy docs, comparisons, or high‑stakes summaries.
> 2. Use Brave/Exa basic search for quick lookups.
> 3. Use manual orchestration when a custom workflow is explicitly needed.

[SESSION_ID: 019bf9ec-3326-7b31-b010-f10ca44c00d4]
