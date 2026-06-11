# Discovery: Graphiti - Real-Time Knowledge Graphs with MCP

**Source**: https://github.com/getzep/graphiti
**Category**: MCP | Memory & Knowledge Management
**Stars**: 22,600+ (as of Feb 2026)
**Date Discovered**: 2026-02-06

## Summary

Graphiti is a framework for building temporally-aware knowledge graphs that AI agents can autonomously construct and query. Unlike traditional RAG approaches relying on batch processing and static summarization, Graphiti enables real-time incremental updates with explicit temporal tracking. Includes native MCP server for Claude/Cursor integration.

**Key Innovation**: Bi-temporal data model tracks both event occurrence time and ingestion time, enabling accurate point-in-time queries while maintaining historical context for changing relationships.

## Key Features

- **Real-time incremental updates**: Immediate data integration without batch recomputation
- **Bi-temporal data model**: Tracks event occurrence + ingestion times
- **Hybrid retrieval**: Semantic embeddings + BM25 + graph traversal (low-latency)
- **Custom entity definitions**: Flexible ontology via Pydantic models
- **Native MCP server**: Episode management, entity relationships, semantic search, graph maintenance
- **Scalability**: Parallel processing for large datasets
- **MIT licensed**: Open source with strong community (22.6k stars, 2.2k forks)

## Potential Value

**Token Impact**: SAVES - Graph queries are structured and efficient; avoids LLM summarization dependency

**Capability**: Novel knowledge graph layer with temporal awareness. Complements existing memory systems (Official Memory for facts, Agent Memory for state, ACE/Hindsight for learning, Graphiti for relationships and temporal context).

**Integration Effort**: EASY-MEDIUM
- Ready-made MCP server (drop-in via `claude mcp add`)
- Pydantic-based entity definitions (familiar to Python developers)
- Requires graph database (Neo4j or similar)

## Comparison to Existing Memory Capabilities

| Feature | Official Memory | Agent Memory | ACE Framework | Hindsight | Graphiti |
|---------|----------------|--------------|---------------|-----------|----------|
| **Data Model** | Flat facts | State variables | Skill patterns | Memory types | Knowledge graph |
| **Relationships** | No | No | No | No | **Yes (explicit edges)** |
| **Temporal Tracking** | No | No | No | No | **Yes (bi-temporal)** |
| **Query Type** | Semantic recall | Key-value lookup | Pattern matching | Multi-strategy search | Graph traversal + hybrid search |
| **Use Case** | "What did user say about X?" | "What is agent state?" | "What pattern works?" | "What did I learn?" | "How are X and Y related over time?" |

**Key Distinction**: Graphiti is the only solution that models *relationships between entities* with temporal context. Other memory systems store individual facts/states but don't capture connections.

## Use Cases for Claude Code Evolution System

1. **Capability Relationship Mapping**: Track dependencies between MCPs, skills, and agents (e.g., "mgrep depends on Mixedbread API, installed 2026-01-17, replaced Grep for semantic searches")

2. **Integration History**: Query "What integrations were rejected because they conflicted with Tool Search Tool?" (temporal graph traversal)

3. **Skill Evolution**: Track how skills evolve over time (e.g., "advanced-tool-use skill updated 5 times in January 2026; changes correlated with Tool Search Tool integration")

4. **Discovery Attribution**: Map discoveries to sources (e.g., "GitHub → disler → hook-lifecycle patterns → Integrated 2026-02-06")

5. **Agent Interaction Patterns**: Track which agents call which tools most frequently over time

## Complementarity Analysis

**NOT REDUNDANT** - Graphiti fills a gap in the memory stack:

- **Official Memory**: Stores facts ("API key is in .env")
- **Agent Memory**: Stores state ("last run at 2026-02-06 10:00")
- **ACE Framework**: Stores strategy ("evaluate token overhead first")
- **Hindsight**: Stores behavioral learning ("learned to check auth after 10 failures")
- **Graphiti**: Stores relationships + temporal context ("Tool Search Tool replaced defer_loading on 2026-02-06; both solve same problem but TST is automatic")

**Verdict**: NOVEL - Different data model (graph vs flat storage) and unique temporal tracking.

## Quick Assessment Score

- **Integration complexity**: 75/100 (MCP server ready, but needs graph DB setup)
- **Token efficiency impact**: 80/100 (structured queries, no LLM summarization needed)
- **Capability expansion**: 90/100 (novel relationship + temporal layer)
- **Maintenance burden**: 65/100 (graph database management, more complex than flat storage)
- **Community validation**: 95/100 (22.6k stars, production-ready, strong ecosystem)
- **TOTAL**: 81/100

## Redundancy Check

**Checked against registry**: Official Memory, Agent Memory, ACE Framework, Instinct System, Hindsight, claude-mem (deprecated)

**Result**: NOVEL

**Reasoning**:
- No existing capability models relationships between entities
- No existing capability tracks bi-temporal data (event time + ingestion time)
- MCP server makes integration trivial
- Complements all existing memory layers rather than replacing them

## Integration Blocker Analysis

**Type**: C - Dependency (requires graph database)

**Blockers**:
1. Need Neo4j or compatible graph database (setup overhead)
2. Need to define ontology (entities + relationships for evolution system)
3. Need to decide: use for all projects or just claude-evolution?

**Mitigation**:
1. Docker container for Neo4j (low barrier)
2. Start with minimal ontology: Capability, Source, Integration, Agent, Skill, MCP
3. Pilot on claude-evolution only; expand if valuable

## Recommended Action

- [ ] Needs research
- [ ] Reject (reason: ...)
- [x] **FAST-TRACK INTEGRATION** - High score (81/100), clear value-add, ready MCP server

**Integration Plan**:
1. Set up Neo4j Docker container
2. Install Graphiti MCP via `claude mcp add`
3. Define initial ontology for evolution system (6 core entity types)
4. Populate graph with existing registry data (bootstrap)
5. Test queries: "What capabilities depend on Tool Search Tool?", "What integrations happened in January 2026?"
6. Document in `integrations/mcps/graphiti-integration.md`

**Why Fast-Track**:
- Highest score (81/100) in this discovery run
- Production-ready MCP server (zero custom code needed)
- Clear, novel capability (relationship + temporal modeling)
- Strong community validation (22.6k stars)
- Addresses documented gap (no relationship tracking in current memory stack)

---

**Filed by**: capability-discoverer
**Next step**: Assign to capability-integrator for fast-track integration

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 75/100 | MCP ready, but Neo4j Docker + ontology design required |
| Token Efficiency | 80/100 | Structured queries, no LLM summarization, operations outside context |
| Capability Expansion | 90/100 | Novel: relationship+temporal modeling, fills gap in memory stack |
| Maintenance Burden | 65/100 | Graph DB management, more complex than flat storage |
| Community Validation | 95/100 | 22.6k stars, Fortune 500 production use, MIT license |
| **WEIGHTED TOTAL** | **81/100** | |

### Cross-Validation (Codex)
"Knowledge graphs are complementary to flat memory. 81/100 is justified - temporal + relationship layer is distinct from Official Memory (facts) and Agent Memory (state)."

### Security
- [x] MIT licensed
- [x] No excessive permissions
- [x] Graph DB requires security hardening (standard practice)
- [x] MCP server isolates DB access

### Decision: APPROVE (81/100)

**Integration Path**:
1. Docker Neo4j container setup
2. Install Graphiti MCP via `claude mcp add graphiti-mcp`
3. Define evolution ontology (Capability, Source, Integration, Agent, Skill, MCP entities)
4. Bootstrap with registry data
5. Test temporal queries

**Unique Value**: Only solution modeling entity relationships with bi-temporal tracking.
