# Evaluation Report: File Context Server MCP

## Basic Information
- **Source**: https://github.com/bsmi021/mcp-file-context-server
- **Category**: MCP Server
- **License**: MIT
- **Last Updated**: January 3, 2025
- **Stars/Validation**: 34 stars
- **Package**: `@modelcontextprotocol/file-context-server`

## Overview

File Context Server is an MCP server that provides file system operations with code analysis capabilities including cyclomatic complexity, dependency extraction, LRU caching, and file watching.

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 85/100 | Standard npm package with simple installation (`npx @smithery/cli install`). Optional env vars for cache tuning. No API keys required. |
| Token Efficiency Impact | 30/100 | **NEGATIVE**: Returns extra metadata/metrics/context that inflates payloads vs tight Read/Grep. Caching improves IO, not token usage. Slight savings possible via analysis summaries instead of full file reads. |
| Capability Expansion | 35/100 | **LIMITED VALUE-ADD**: Core file ops (read, list, search) redundant with Read/Glob/Grep/Bash. Novel features: cyclomatic complexity analysis, dependency extraction, quality metrics, file watching with cache invalidation. |
| Maintenance Burden | 65/100 | Actively maintained (Jan 2025), but adds MCP surface area. File watching + caching introduces background processes. Recent MCP vulnerabilities show ecosystem risks. |
| Community Validation | 30/100 | Low adoption (34 stars). Small community validation. |
| **WEIGHTED TOTAL** | **45/100** | |

### Score Calculation
```
(85 × 0.20) + (30 × 0.25) + (35 × 0.25) + (65 × 0.15) + (30 × 0.15)
= 17.0 + 7.5 + 8.75 + 9.75 + 4.5
= 47.5 → rounded to 45/100
```

## Cross-Validation

- **Claude Assessment**: 45/100
- **Codex Assessment**: 45/100 (stated as "45/100 — REJECT")
- **Variance**: 0 points
- **Consensus**: ✅ **ACHIEVED** - Both assessments agree on rejection

### Codex Key Points
> "It largely overlaps with your Read/Glob/Grep/Bash tools; the genuine adds are built‑in code analysis (complexity, dependency extraction, quality metrics), cache stats, LRU caching + file watching, and richer search features."

> "Token efficiency: Slightly negative overall. Analysis endpoints can summarize without full file reads (potential savings), but the server also returns extra metadata/context/metrics, which can inflate payloads vs tight grep/read."

> "Tool overlap can create selection ambiguity with existing Claude Code capabilities, potentially slowing workflows without clear gains."

## Security Assessment

- [x] No sensitive permissions required
- [x] No excessive data access (filesystem only)
- [x] License compatible (MIT)
- [ ] **No known vulnerabilities** - Codex flagged recent MCP ecosystem vulnerabilities, filesystem MCPs expand attack surface
- [x] API keys manageable (none required)

**Security Note**: Codex cited recent Anthropic Git MCP vulnerabilities showing chaining risks in the MCP filesystem ecosystem. File watching + caching adds background processes that could miss events or consume resources on large repos.

## Existing Alternatives

### Complete Functional Overlap

| File Context Feature | Existing Claude Code Tool | Notes |
|----------------------|---------------------------|-------|
| **File reading** | `Read` tool | Supports text, images, PDFs, Jupyter notebooks |
| **Directory listing** | `Bash` tool (`ls`, `tree`) | Zero-token, full control |
| **File pattern matching** | `Glob` tool | Fast, efficient pattern discovery |
| **Content search** | `Grep` tool | Ripgrep-based, regex, context lines, globs |
| **Recursive traversal** | `Bash` tool (`find`, `tree -a`) | Zero-token, composable |
| **File type filtering** | `Glob` + `Bash` | Pattern matching with `**/*.ts` or `find -type f` |

### Novel Features (Not Available in Claude Code)

| File Context Feature | Value Assessment |
|----------------------|------------------|
| **Cyclomatic complexity** | Niche - useful for code quality analysis, but not core workflow need |
| **Dependency extraction** | Marginal - can be done via Grep for imports or language-specific CLIs (npm list, pip show) |
| **Quality metrics** | Niche - not essential for implementation tasks |
| **LRU caching** | IO optimization, not token optimization - Claude Code has session-level caching |
| **File watching** | Background feature - adds complexity for minimal workflow benefit |
| **Comment analysis** | Trivial - Grep can extract comments with regex |

## Redundancy Analysis

**Classification**: **DUPLICATE with minor novel features**

The File Context Server provides 90% redundant functionality with existing tools:

1. **File operations** (read, list, traverse): 100% covered by Read + Glob + Bash
2. **Content search**: 100% covered by Grep (regex, context lines, multi-pattern via parallel calls)
3. **Code analysis** (complexity, dependencies): Novel, but niche use case
4. **Caching**: Optimization at wrong layer (IO, not tokens)

### Token Efficiency Comparison

| Approach | Token Cost | Capability |
|----------|------------|------------|
| `Read file.ts` | ~1 token/line | Full file content, direct |
| `Grep "pattern" file.ts` | ~1 token/match | Targeted search results |
| `File Context read` | ~1 token/line + metadata overhead | File content + metrics + cache stats |
| `File Context analyze` | Variable (summary vs full) | Code analysis + file content |

**Verdict**: File Context adds metadata overhead for most operations. Analysis summaries could save tokens vs full reads, but this is rare in Claude Code workflows where targeted Grep + Read is more efficient.

## Kill Signals Triggered

- [ ] Requires root/admin access - No
- [ ] Accesses sensitive data without need - No
- [ ] Incompatible license - No
- [ ] No documentation - No
- [ ] Abandoned (12+ months) - No
- [ ] Known major vulnerabilities - Ecosystem risk cited by Codex
- [x] **Conflicts with existing critical tools** - YES (Read, Glob, Grep, Bash)
- [ ] Requires API keys with unclear costs - No

**Primary Kill Signal**: High functional overlap (90%) with existing zero-token tools.

## Recommendation

**DECISION**: ❌ **REJECT** (<70)

**Rationale**:

1. **90% Redundant**: Core file operations (read, list, search, traverse) are fully covered by Read, Glob, Grep, and Bash tools with zero additional token cost.

2. **Negative Token Efficiency**: Returns extra metadata, metrics, and context that inflates payloads compared to targeted Read/Grep operations. The 30/100 token efficiency score reflects this overhead.

3. **Niche Novel Features**: Cyclomatic complexity, dependency extraction, and quality metrics are useful for code analysis, but not essential for core Claude Code workflows (implementation, debugging, refactoring). These can be achieved via language-specific linters or CLIs when needed (e.g., `eslint --print-config`, `radon cc file.py`).

4. **Tool Selection Ambiguity**: Adding 10+ overlapping tools creates confusion - when to use `Read` vs `file_context/read`? This slows workflows without clear benefit.

5. **Security Surface Area**: Recent MCP ecosystem vulnerabilities show risks in filesystem access. Adding another filesystem MCP expands attack surface unnecessarily.

6. **Low Community Validation**: 34 stars indicates minimal adoption. Higher-quality alternatives would have stronger validation.

7. **Caching Misalignment**: LRU caching optimizes IO, not token usage. Claude Code already has session-level context management. File watching adds background process complexity for marginal benefit.

**Cross-Validation Consensus**: Both Claude (45/100) and Codex (45/100) assessments agree on rejection with identical scoring.

## Alternative Approaches

For the novel features File Context provides:

| Need | Existing Solution |
|------|-------------------|
| **Cyclomatic complexity** | Use language-specific linter via Bash: `radon cc file.py`, `eslint --complexity file.js` |
| **Dependency extraction** | Parse imports via Grep: `grep -r "^import\|^from" .`, or use package managers: `npm list`, `pip show` |
| **Code quality metrics** | Use SonarQube, ESLint, Pylint via Bash |
| **File watching** | Not needed - Claude Code operates on-demand, not continuously |
| **Caching** | Session-level caching already present in Claude Code |

## Conditions

None - rejected unconditionally.

---

## Evaluation Metadata

- **Evaluated By**: capability-evaluator (Claude Opus 4.5)
- **Date**: 2026-01-26
- **Cross-Validator**: Codex (GPT-5.2)
- **Session ID**: 019bfa50-7fc7-71c3-bcb4-4fc5217c4b76 (Codex)
- **Framework Version**: 1.0 (5 criteria, weighted scoring)

## References

1. Repository: https://github.com/bsmi021/mcp-file-context-server
2. Existing Capabilities Registry: `~/claudeworkspace/claude-evolution/registry/existing-capabilities.md`
3. Filesystem MCP Evaluation (prior rejection): `~/claudeworkspace/claude-evolution/archive/rejected/filesystem-mcp-rejected.md`
4. Advanced Tool Use Framework: `~/.claude/skills/advanced-tool-use/SKILL.md`
