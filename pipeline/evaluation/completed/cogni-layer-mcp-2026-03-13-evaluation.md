# Evaluation Report: CogniLayer — Persistent Code Memory + Graph MCP

## Basic Information
- **Source**: https://github.com/LakyFx/CogniLayer
- **Category**: MCP Server
- **License**: Elastic License 2.0 (ELv2) -- NOT OSI-approved open source
- **Last Updated**: 2026-03-03 (v4.2.0)
- **Stars/Validation**: 18 stars, 3 forks
- **Created**: ~2026-02-28 (approximately 2 weeks old at evaluation time)
- **Language**: Python 3.11+
- **Tool Count**: 17-18 MCP tools

## Summary

CogniLayer is a Python MCP server providing persistent session memory, AST-based code intelligence (tree-sitter), hybrid search (FTS5 + vector similarity), and a subagent protocol for Claude Code and Codex CLI. It claims 80-200K+ token savings per session by eliminating re-explanation overhead across sessions and compressing subagent context (40K -> 500 tokens).

## Redundancy Check

**Classification**: IMPROVEMENT with significant OVERLAP

### Capability Overlap Matrix

| CogniLayer Feature | Existing Capability | Overlap % | Notes |
|---|---|---|---|
| Persistent session memory | Auto-memory (v2.1.74, CLAUDE.md) | 70% | Auto-memory is built-in, zero-cost, Markdown-based |
| Knowledge graph for facts | Official Memory MCP (Knowledge Graph) | 80% | Official = JSONL knowledge graph, zero overhead |
| Semantic text search | mgrep (Mixedbread) | 75% | mgrep = cloud-based, but proven and integrated |
| AST-based code graph | codebase-memory-mcp (DeusData) | 60% | DeusData = Go binary, MIT, 64 languages, pending eval |
| Subagent context protocol | Task tool + Agent Spawn Restrictions | 50% | Built-in context isolation, no DB side-channel |
| Session bridges | Auto-memory + CLAUDE.md hierarchy | 60% | Persistent across sessions via markdown files |
| TUI dashboard | N/A | 0% | Novel, but informational only |
| Crash recovery | N/A | 0% | Novel, but Claude Code handles session persistence natively |

**Verdict**: 5 of 8 features have 50-80% overlap with existing capabilities. The bundle is distinctive, but individual components are mostly covered.

---

## Token Efficiency Claims Analysis

Applying the `token-efficiency-claims-evaluation` playbook:

### Claim: "80-200K+ tokens saved per session"
- **Claim Type**: Absolute (numerical, wide range)
- **Credibility**: LOW
  - No benchmark data provided
  - No sample size or methodology
  - Wide range (2.5x spread) suggests hand-waving
  - v0.x-equivalent maturity (2 weeks old, despite v4.2.0 label)
  - No Claude model version specified
- **Scoring**: Per playbook rule #1 (unverified claim) -> +0 points
- **Note**: The 80-200K range would require multiple full-file reads being replaced per session. Plausible in theory for large codebases, but completely unsubstantiated.

### Claim: "Subagent context compression: 40K -> 500 tokens"
- **Claim Type**: Comparative (specific, structural)
- **Credibility**: MEDIUM
  - Plausible mechanism (subagents write to DB, return summary)
  - But: Task tool already provides context isolation (subagents don't pollute parent context)
  - The comparison baseline (40K context dump) is not the current behavior with properly designed subagents
- **Scoring**: +0 points (compares against a strawman baseline, not existing best practice)

---

## Scores

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 50/100 | 20% | 10.0 | NOT a simple npm/pip install. Runs `install.py` that mutates `~/.claude/settings.json`, `~/.codex/config.toml`, registers hooks, creates `~/.cognilayer/` directory. 17-18 tools = significant catalog overhead even with Tool Search. Python 3.11+ with optional heavy deps (fastembed, tree-sitter-language-pack ~20MB). Codex integration requires manual AGENTS lifecycle protocol. More invasive than any currently integrated MCP. |
| Token Efficiency Impact | 35/100 | 25% | 8.75 | Claims 80-200K savings but: (a) unverified per playbook = +0 bonus, (b) 17-18 tools add catalog overhead, (c) auto-memory (v2.1.74) provides zero-cost session persistence already, (d) subagent context isolation is built-in via Task tool. Net efficiency is likely marginal at best — may INCREASE tokens due to tool overhead and instruction templates (~510 words for AGENTS block alone). |
| Capability Expansion | 45/100 | 25% | 11.25 | Bundle is distinctive but individual capabilities are covered: auto-memory (session persistence), Official Memory MCP (knowledge graph), mgrep (semantic search), codebase-memory-mcp (AST/code graph, pending eval). Subagent-memory DB protocol is the most novel piece, but achievable with lighter conventions. TUI dashboard is informational only. The "one opinionated package" framing is a UX argument, not a capability argument. |
| Maintenance Burden | 25/100 | 15% | 3.75 | Single maintainer, 2 weeks old, no visible PR/review history. Version inflation: created 2026-02-28, tagged v3.1.0 on 2026-03-01, then v4.0.0/4.1.0/4.2.0 all on 2026-03-03. `pyproject.toml` does not declare runtime deps (imperative `install.py`). CI covers only core path — TUI, vector search, and fastembed paths are untested. Mutates user config files (settings.json, config.toml) which is a maintenance hazard. If abandoned, cleanup is non-trivial. |
| Community Validation | 20/100 | 15% | 3.0 | 18 stars, 3 forks, 1 contributor, ~2 weeks old. One Reddit post (r/ClaudeAI) with some engagement. No evidence of sustained community usage or third-party validation. Compare: codebase-memory-mcp (DeusData) also has low stars but is MIT-licensed with Go binary distribution (lower risk profile). |
| **WEIGHTED TOTAL** | | | **36.75/100** | |

---

## Cross-Validation

- **Claude Assessment**: 36.75/100
- **Codex Assessment**: 33/100
- **Variance**: 3.75 points
- **Consensus**: ACHIEVED (both assessments agree on rejection)

### Codex Key Insights (GPT-5.4)
Codex independently identified:
1. **Licensing risk**: Elastic License 2.0 is not OSI-approved, restricts managed service use
2. **Version inflation**: Project created 2026-02-28, already at v4.2.0 by 2026-03-03
3. **Invasive installation**: Mutates settings.json, config.toml, and registers hooks
4. **Capability gap vs capability bundle**: "UX gap, not a capability gap"
5. **Better path**: Compositional approach — keep existing alternatives, add lightweight subagent persistence convention if needed

Both assessments converge on the same fundamental conclusion: CogniLayer bundles existing capabilities into one package but adds licensing risk, maintenance burden, and maturity concerns without providing genuinely novel functionality.

---

## Security Assessment

- [x] No sensitive permissions required (local SQLite, no external API calls)
- [x] No excessive data access (indexes project files user already has access to)
- [ ] **FAIL**: License compatible (MIT/Apache/BSD) -- Elastic License 2.0 is NOT OSI-approved; restricts providing as managed service
- [x] No known vulnerabilities
- [x] API keys not required (fully local)

### License Concern (Detailed)

The Elastic License 2.0 (ELv2):
- Allows free use, modification, and distribution
- **Restricts**: providing the software as a managed service to third parties
- **NOT compatible** with MIT/Apache/BSD in the traditional sense
- The Reddit post claims "GPL v3" but the repository LICENSE file and pyproject.toml both specify Elastic License 2.0
- For personal Claude Code use this is technically acceptable, but for the open-source claude-evolution system (published on GitHub), integrating ELv2-licensed dependencies creates licensing complexity
- **Not a hard kill signal** for personal use, but a yellow flag for the ecosystem

---

## Existing Alternatives Comparison

### Direct Competitors (Already in Stack)

| Capability | CogniLayer | Existing Solution | Winner |
|---|---|---|---|
| Session persistence | SQLite + hooks | Auto-memory (v2.1.74, CLAUDE.md) | **Existing** — zero cost, built-in, Anthropic-maintained |
| Knowledge graph | FTS5 + vector | Official Memory MCP | **Existing** — zero overhead, native |
| Semantic search | fastembed (optional) | mgrep (Mixedbread) | **Existing** — proven, auto-indexing, 2-3s latency |
| Code structure graph | tree-sitter AST | codebase-memory-mcp (pending) | **Tie** — both offer AST parsing; DeusData is MIT, Go binary, 64 langs |
| Subagent context | DB side-channel | Task tool + isolation | **Existing** — built-in, zero overhead, no DB needed |

### Pending Evaluation: codebase-memory-mcp (DeusData)

The codebase-memory-mcp (currently in `pipeline/evaluation/pending/`) covers the AST-based code graph portion of CogniLayer with:
- MIT license (vs Elastic 2.0)
- Single Go binary (vs Python + optional deps)
- 64 language support (vs ~10 in CogniLayer)
- Benchmarked on 35 real repos including Linux kernel
- 14 tools (vs 17-18)

If the code graph capability is valuable, DeusData is a strictly better option for that specific piece.

---

## Kill Signal Assessment

| Kill Signal | Status | Notes |
|---|---|---|
| Requires root/admin access | No | |
| Accesses sensitive user data without clear need | No | |
| License incompatible | **YELLOW** | ELv2 is not OSI-approved but permits personal use |
| No documentation or examples | No | README is comprehensive |
| Abandoned (no commits in 12+ months) | No | Active (2 weeks old) |
| Known major security vulnerabilities | No | |
| Conflicts with existing critical tools | **YELLOW** | Mutates settings.json and config.toml |
| Requires API keys with unclear cost implications | No | Fully local |

No hard kill signals triggered, but two yellow flags (license + config mutation).

---

## Recommendation

**DECISION**: [x] REJECT (<70)

**Final Score**: 36.75/100

**Rationale**: CogniLayer is an ambitious bundle that combines persistent memory, code intelligence, and subagent protocols into a single MCP server. However, each individual capability is already covered (or pending evaluation in a better form) by existing tools in the stack. The 80-200K token savings claim is unverified and cannot be credited per the evaluation playbook. The Elastic License 2.0 creates licensing complexity for the open-source evolution system. Most critically, the project is only 2 weeks old with version inflation (v4.2.0 in 5 days), a single maintainer, and invasive installation that mutates Claude Code config files. The existing compositional approach (auto-memory + Official Memory MCP + mgrep + Task tool) provides equivalent capability coverage with zero maintenance burden and official/built-in support.

**What was good about it**: The concept of a unified memory-and-code-graph bundle is sound. The subagent-memory protocol (write findings to DB, return summaries) is an interesting architectural pattern. The TUI dashboard and crash recovery show thoughtful engineering. The README documentation is thorough and honest about limitations.

**Compositional alternative** (per Codex recommendation): If cross-session subagent persistence is genuinely needed, implement a lightweight convention: subagents write key findings to `CLAUDE.md` or a designated findings directory, returning only summaries. This captures 80% of CogniLayer's claimed benefit without importing licensing, maturity, or maintenance risk.

### Reconsideration Triggers

Re-evaluate CogniLayer if ANY of these occur:
1. License changes to MIT/Apache/BSD
2. Community validation reaches 500+ stars
3. Project reaches 6+ months of active maintenance with multiple contributors
4. Independent benchmark data verifying token savings claims is published
5. Auto-memory (v2.1.74) proves insufficient for cross-session persistence needs

---

## Related Evaluations

| Item | Score | Date | Relationship |
|---|---|---|---|
| mcp-memory-service (doobidoo) | 28.5/100 | 2026-02-06 | Rejected — superseded by Official Memory |
| Hindsight Agent Memory | Integrated | 2026-02-06 | Complementary behavioral learning (different layer) |
| codebase-memory-mcp (DeusData) | Pending | 2026-03-13 | Better candidate for AST/code graph capability |
| Memory MCP (official) | Built-in | N/A | Knowledge graph, zero overhead |
| Auto-memory (autoMemoryDirectory) | Built-in | v2.1.74 | Session persistence, CLAUDE.md based |
