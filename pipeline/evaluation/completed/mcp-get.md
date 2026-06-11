# Discovery: mcp-get

- **Source**: https://github.com/michaellatman/mcp-get
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Community MCP package manager for installing MCP servers from various sources. Alternative to Smithery CLI with 505 stars and MIT license.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

mcp-get is a CLI tool for managing MCP server installations. From search results:

- **GitHub stars**: 505 stars, 105 forks
- **License**: MIT
- **Purpose**: Package manager for Model Context Protocol servers
- **Community-driven**: Not affiliated with Anthropic or Smithery

Key differentiators from Smithery CLI:
- Open source community tool vs commercial registry
- Likely supports multiple registries/sources (needs verification)
- Higher GitHub engagement (505 vs unclear for Smithery CLI)

## Redundancy Check

**Status**: NOVEL (but COMPETING with smithery-cli)

Checked against registry:
- **No existing MCP package manager**: Same novel capability as Smithery CLI
- **Not filesystem/git/database MCP**: Infrastructure tool for managing MCPs
- **Complements existing stack**: Simplifies MCP installation

This discovery is **COMPETING** with smithery-cli for the same use case. Need side-by-side comparison to determine which (if either) to integrate.

## Evaluation Needs

1. **vs Smithery CLI comparison**:
   - Feature parity (install/uninstall/search/update)
   - Registry support (single vs multiple)
   - Client compatibility
   - Maintenance activity (last commit date)
   - Community validation (505 stars vs Smithery's market presence)

2. **Token impact**: Zero (CLI tool, not MCP server)

3. **Integration complexity**: Easy if it's just CLI installation

4. **Key questions**:
   - Does it work with Claude Code or only Claude Desktop?
   - Can it install from GitHub, npm, PyPI, or only custom registry?
   - Configuration format compatibility with `~/.claude.json`?
   - Active maintenance (last commit date)?
   - Security model for untrusted MCP servers?

**Decision framework**:
- If mcp-get is more feature-complete → Choose this over Smithery CLI
- If Smithery CLI has better registry → Choose Smithery
- If equivalent → Choose mcp-get (open source, community-driven, higher stars)
- If complementary (different registries) → Possibly integrate both

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator

### Redundancy Check

**Registry Match**: NO existing MCP package manager. Manual installation via `claude mcp add`.

**Classification**: **NOVEL** (but need research to compare vs Smithery CLI)

### Research Gap

**Critical unknowns**:
1. Feature comparison: mcp-get vs Smithery CLI
2. Registry coverage: Which has more MCP servers?
3. Claude Code compatibility: Does mcp-get work with `~/.claude.json` format?
4. Maintenance activity: Last commit dates for both
5. Installation sources: GitHub/npm/PyPI support

**Research needed before scoring**: Cannot evaluate without comparative data.

### Preliminary Scoring (INCOMPLETE)

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 90/100 | 20% | 18.0 | CLI tool, likely simple install |
| Token efficiency impact | 100/100 | 25% | 25.0 | Zero tokens (CLI, not MCP server) |
| Capability expansion | ❓/100 | 25% | ❓ | **BLOCKED: Need vs Smithery comparison** |
| Maintenance burden | ❓/100 | 15% | ❓ | **BLOCKED: Need maintenance data** |
| Community validation | 85/100 | 15% | 12.75 | 505 stars good, but need context |

**ESTIMATED TOTAL**: **55.75 + ❓** (INCOMPLETE)

### Decision: NEEDS RESEARCH → Move to pipeline/evaluation/completed/ with RESEARCH note

**Rationale**: Cannot score without comparison data. This is a Type B blocker (Validation/Comparison needed).

**Research questions** (from Integration Blocker Classification helper):
1. **Feature parity**: Does mcp-get match `claude mcp add` functionality?
2. **Registry comparison**: mcp-get vs Smithery vs manual GitHub
3. **Config compatibility**: Does it modify `~/.claude.json` correctly?
4. **Active maintenance**: Last commit date, issue response time
5. **Security**: How does it handle untrusted MCP servers?

**Research task format** (from research-task-template.md):

```markdown
# Research Task: mcp-get vs Smithery CLI Comparison

## Blocker Type
Type B: Validation/Comparison

## Research Questions
1. Feature comparison matrix (install/uninstall/search/update/list)
2. Registry coverage (which has more MCPs?)
3. Claude Code compatibility (modifies ~/.claude.json correctly?)
4. Maintenance metrics (last commit, open issues, response time)
5. Security model (sandboxing, untrusted servers)

## Success Criteria
- Clear winner identified OR both kept if complementary
- Scoring can proceed with confidence
- Integration path defined

## Expected Outcomes
- If mcp-get superior: Score 75-85/100, approve
- If Smithery superior: Reject mcp-get, note Smithery as future eval
- If equivalent: Choose mcp-get (open source, 505 stars)
- If complementary: Potentially keep both
```

**Action**: Create research task file, defer scoring until comparison complete.
