# Evaluation Report: Codebase Memory MCP (DeusData)

## Basic Information
- **Source**: https://github.com/DeusData/codebase-memory-mcp
- **Category**: MCP Server
- **License**: MIT
- **Created**: 2026-02-24
- **Last Updated**: 2026-03-12 (v0.4.10, 23 releases in 16 days)
- **Stars/Validation**: ~612-647 (growing rapidly)
- **Forks**: 67
- **Contributors**: 5 (single maintainer dominates)
- **Open Issues**: 21

## Overview

MCP server that indexes a local codebase into a persistent SQLite-backed knowledge graph using tree-sitter AST parsing across 64 languages. Provides 14 MCP tools for structural queries: call graph tracing, dead code detection, architecture analysis, change impact mapping, community detection (Louvain), and a Cypher-like query language. Single Go binary, no Docker, no API keys.

**Key claim**: 99% fewer tokens than grep for structural code queries (~3,400 tokens vs ~412,000 tokens for 5 structural questions across 64 repositories).

## Redundancy Classification

**Result**: ORTHOGONAL (Layer 3) -- confirmed by comparison playbook

| Aspect | Grep | mgrep | Codebase Memory MCP |
|--------|------|-------|---------------------|
| Approach | Exact string matching (ripgrep) | Semantic embeddings (Mixedbread) | AST parsing (tree-sitter) |
| Query type | Literal/regex patterns | Natural language ("how is auth done?") | Structural ("what calls function X?") |
| Output | Matching lines + context | Ranked files + relevance scores | Call graphs, type hierarchies, architecture |
| Infrastructure | Built-in (zero cost) | Cloud-based (free tier) | Local SQLite + Go binary |
| Persistence | None (stateless) | Cloud-synced index | Local persistent graph |
| Novel capability | No | Semantic understanding | Structural understanding |

**Verdict**: This tool does NOT compete with Grep or mgrep. It solves fundamentally different questions:
- Grep: "Where does string X appear?"
- mgrep: "Where is the auth logic?"
- Codebase Memory: "What is the call graph from endpoint Y? What functions are dead code?"

No existing capability in the registry provides AST-based structural graph querying.

## Token Efficiency Claim Analysis

Per the token-efficiency-claims-evaluation playbook:

- **Claim type**: Comparative (vs grep)
- **Credibility**: Medium-High for structural queries specifically
- **Benchmark source**: Self-published, 64 repositories, 5 structural questions each
- **Plausibility**: A graph query returning a call chain is 2-3 lines. Achieving the same via grep+read loops requires reading dozens of files. The 120x figure (3,400 vs 412,000) is plausible for structural queries, but misleading as a general "99% savings" claim.
- **Caveat**: Does NOT include indexing cost, tool schema overhead (14 tools with verbose descriptions), or errors from incorrect AST parsing.
- **Scoring**: +0 points (unverified self-published benchmark; capability scores independently)

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 75/100 | Pre-built binaries exist for all platforms. Auto-detects Claude Code. However: (1) installer is invasive -- writes 4 skill files to `~/.claude/skills/`, edits PATH, and mutates editor configs, requiring manual cleanup or override; (2) building from source requires Go 1.26 + CGO + C compiler; (3) 14 tools with verbose descriptions add context overhead even with Tool Search Tool active. Not as simple as "single binary install" implies. |
| Token Efficiency Impact | 70/100 | For structural queries (call graphs, dead code, architecture), the token savings over manual grep+read loops are genuinely significant -- likely 10-50x, not 99% as claimed. But this only applies to structural questions (~20% of typical code exploration). For string searches, imports, config lookups -- the majority of searches -- existing Grep is faster and cheaper. Net impact: moderate savings for a subset of queries. |
| Capability Expansion | 85/100 | Genuinely novel. No existing tool provides: persistent AST knowledge graph, call graph tracing, dead code detection, architecture community detection, change impact analysis, or Cypher-like structural queries. This is a real capability gap in the current stack. Deducted from 100 because: (1) some "novel" features (search_code, get_code_snippet) overlap with existing Grep/Read; (2) architecture analysis quality depends on AST parser accuracy per language. |
| Maintenance Burden | 30/100 | This is the critical weakness. (1) Repo is 16 days old with 23 releases -- extreme churn, API surface not stable; (2) Known issues: OOM on large monorepos (10k+ files), SQLite lock/hang behavior, high CPU during indexing, parser-quality bugs affecting dead-code/architecture accuracy (GitHub issues #45, #52, #58); (3) Tool/documentation drift already present -- installed skill references `list_directory` tool that doesn't exist in current registration; (4) Bus factor = 1 (single maintainer dominates); (5) Background polling for auto-sync adds process management overhead; (6) v0.4.x maturity -- breaking changes expected. |
| Community Validation | 60/100 | ~612 stars in 16 days is impressive growth velocity, indicating genuine interest. Multiple Reddit posts (r/ClaudeAI, r/LocalLLaMA) with positive reception. LinkedIn post from creator. However: (1) stars != production stability; (2) 16 days is insufficient for community validation of reliability; (3) only 5 contributors; (4) 21 open issues with operational problems suggest early-adopter enthusiasm, not battle-tested validation. |

### Weighted Score Calculation

```
Total = (IC x 0.20) + (TE x 0.25) + (CE x 0.25) + (MB x 0.15) + (CV x 0.15)
      = (75 x 0.20) + (70 x 0.25) + (85 x 0.25) + (30 x 0.15) + (60 x 0.15)
      = 15.0 + 17.5 + 21.25 + 4.5 + 9.0
      = 67.25/100
```

| **WEIGHTED TOTAL** | **67.25/100** | Below 70 threshold |

## Cross-Validation

- **Claude Assessment**: 67.25/100
- **Codex Assessment**: 65/100
- **Variance**: 2.25 points
- **Consensus**: ACHIEVED -- both assessments converge on "promising but premature"

### Codex Key Findings (Not in My Initial Analysis)

Codex surfaced several important details:
1. **Invasive installer**: `install` command writes 4 Claude skills under `~/.claude/skills/`, edits PATH, and writes Codex/editor configs. This is NOT a clean MCP-only install.
2. **Tool/doc drift**: Installed skill references `list_directory` tool that no longer exists in the MCP registration. The benchmark also scores `list_directory`. This suggests rapid iteration without documentation maintenance.
3. **Specific GitHub issues**: OOM (#58), SQLite lock/hang (#52), high CPU (#45) -- these are operational problems, not feature requests.
4. **Bus factor**: Single maintainer (DeusData) dominates all contributions.

I agree with all of these findings. They reinforce the maintenance burden score of 30/100.

## Security Assessment

- [x] No sensitive permissions required (reads local files only)
- [x] No excessive data access (codebase files, standard for code tools)
- [x] License compatible (MIT)
- [ ] **No known vulnerabilities** -- SQLite-backed, but lock/hang behavior (#52) could affect Claude Code session stability
- [x] API keys manageable (none required)

**Concern**: The installer's behavior of writing files to `~/.claude/skills/` without explicit user consent is an anti-pattern. These skill files could conflict with or override existing skill configurations.

## Existing Alternatives

| Need | Current Solution | Codebase Memory Adds |
|------|------------------|---------------------|
| Text search | Grep (ripgrep, instant) | Nothing -- Grep is better for this |
| Semantic search | mgrep (embeddings, natural language) | Nothing -- mgrep is better for this |
| Call graph tracing | Manual grep+read chain (slow, token-heavy) | Persistent graph query (fast, token-efficient) |
| Dead code detection | Language-specific linters via Bash | Cross-language dead code heuristics |
| Architecture overview | Manual file exploration | Automated community detection, entry points |
| Change impact analysis | `git diff` + manual tracing | Graph-based blast radius with risk classification |

**Conclusion**: The novel capabilities (rows 3-6) are genuinely not covered by existing tools. The question is whether the maturity risk justifies integration now.

## Kill Signals

- [ ] Requires root/admin access -- No
- [ ] Accesses sensitive data without need -- No
- [ ] Incompatible license -- No (MIT)
- [ ] No documentation or examples -- No (extensive README, benchmarks, docs site)
- [ ] Abandoned (12+ months) -- No (hyperactive, opposite problem)
- [ ] Known major security vulnerabilities -- No (but stability issues exist)
- [ ] Conflicts with existing critical tools -- No (orthogonal capability)
- [ ] Requires API keys with unclear costs -- No (fully local)

No kill signals triggered.

## Recommendation

**DECISION**: NEEDS_RESEARCH (50-69 range, score 67.25)

**Rationale**:

The capability is genuinely novel and addresses a real gap in the current stack (structural code understanding). The 67.25 score is tantalizingly close to the 70 threshold, but the maintenance burden (30/100) is the anchor dragging it down -- and for good reason:

1. **16 days old**: This repo went from 0 to v0.4.10 in 16 days with 23 releases. That velocity signals both excitement and instability. API surface, tool names, and behavior are actively changing.

2. **Known operational issues**: OOM on monorepos, SQLite hangs, high CPU, parser bugs. These are not edge cases -- they're core reliability problems that would directly impact Claude Code sessions.

3. **Invasive installer**: Writing skill files and PATH modifications goes beyond what an MCP server should do. This would need to be installed manually (just the MCP server config) with the skill-writing behavior disabled or reversed.

4. **Documentation drift**: Tool references in installed skills don't match actual tool registration. This means the tool is iterating faster than its own documentation -- a reliability red flag.

**What's good about this tool**: The core idea is sound. AST-based structural queries are fundamentally different from text search and genuinely useful for understanding large codebases. The single Go binary approach is elegant. 64 language support via tree-sitter is impressive. The token efficiency for structural queries is likely real (10-50x, not 99%).

**What needs to happen for approval**:

Per the v0.x-beta-integration-pilot-mode playbook, this is a candidate for re-evaluation:

### Research Questions

1. **Stability**: Does v0.5.x or v1.0 address OOM, SQLite lock, and CPU issues?
2. **API stability**: Has the tool registration stabilized (no more removed tools)?
3. **Manual install**: Can it be installed as MCP-only without the invasive skill/PATH writing?
4. **Real-world test**: How does it perform on the actual workspace (~59 projects, mixed languages)?
5. **Tool subset**: Can it be configured to expose fewer than 14 tools (reduce context overhead)?

### Re-evaluation Triggers

| Trigger | Timeline |
|---------|----------|
| v0.5.0+ release with stability fixes | Monitor GitHub releases |
| Stars reach 1,000+ (broader validation) | ~2-4 weeks at current growth rate |
| 30-day maturity window | Re-evaluate on 2026-03-27 |
| First-party benchmark replication | If someone independently verifies the 120x claim |

### Pilot Mode (If Impatient)

If you want to try it before the re-evaluation window:
1. Install the binary manually (do NOT use the `install` command that writes skills)
2. Add only the MCP server config to `~/.claude.json`
3. Test on 1-2 medium repos (not the full workspace)
4. Document: indexing time, query accuracy, token delta vs grep for same structural questions
5. File results in `pipeline/evaluation/completed/codebase-memory-mcp-pilot-results.md`

## Integration Path (Deferred)

If approved after re-evaluation:

1. Install pre-built Go binary to `~/.local/bin/codebase-memory-mcp`
2. Add MCP server config to `~/.claude.json` (stdio transport)
3. Do NOT run `codebase-memory-mcp install` (skip invasive skill writing)
4. Create custom skill at `~/.claude/skills/codebase-memory/SKILL.md` (our own, not theirs)
5. Add to registry with redundancy triggers: "call graph", "dead code", "AST analysis", "code structure", "knowledge graph codebase"
6. Set defer_loading: true initially (14 tools is heavy; let Tool Search Tool handle discovery)
7. Document in CLAUDE.md decision tree: Grep (exact) -> mgrep (semantic) -> Codebase Memory (structural)

## Conditions (If Approved Later)

- Must be installed manually (no `install` command)
- Must use defer_loading to avoid 14-tool context bloat
- Must pass pilot test on >=2 real workspace repos without OOM/hang
- Must have stable tool registration (no tool name changes for >=2 releases)

---

## Evaluation Metadata

- **Evaluated By**: capability-evaluator (Claude Opus 4.6)
- **Date**: 2026-03-13
- **Cross-Validator**: Codex (GPT-5.4)
- **Cross-Validation Session**: 019ce8de-a232-7541-a8f7-0d3bf2641622
- **Framework Version**: 1.0 (5 criteria, weighted scoring)
- **Redundancy Playbook Applied**: mcp-capability-comparison-for-redundancy.md (Layer 3: Orthogonal)
- **Token Efficiency Playbook Applied**: token-efficiency-claims-evaluation.md (Comparative claim, +0 unverified)

## References

1. Repository: https://github.com/DeusData/codebase-memory-mcp
2. Documentation site: https://deusdata.github.io/codebase-memory-mcp/
3. Reddit (r/ClaudeAI): https://www.reddit.com/r/ClaudeAI/comments/1rp6pkr/
4. Reddit (r/LocalLLaMA): https://www.reddit.com/r/LocalLLaMA/comments/1rjt4hh/
5. Existing Capabilities Registry: `registry/existing-capabilities.md`
6. FileContext MCP (prior rejection, 45/100): `pipeline/evaluation/completed/filecontext-mcp-evaluation.md`
7. mgrep evaluation: `pipeline/evaluation/completed/mgrep-evaluation.md`
8. Pilot mode playbook: `helpers/playbooks/v0x-beta-integration-pilot-mode.md`
9. Redundancy comparison playbook: `helpers/playbooks/mcp-capability-comparison-for-redundancy.md`
10. Token efficiency claims playbook: `helpers/playbooks/token-efficiency-claims-evaluation.md`
