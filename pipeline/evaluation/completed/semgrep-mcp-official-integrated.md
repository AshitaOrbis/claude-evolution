## Discovery: Semgrep MCP Server (Official)

**Source**: https://semgrep.dev/docs/mcp & https://github.com/semgrep/mcp (archived - moved to main semgrep binary)
**Category**: MCP
**Stars/Validation**: HIGH - Official Semgrep (636 stars on archived repo), now integrated into main semgrep binary

### Summary
Official Semgrep MCP server that scans AI-generated code for security vulnerabilities using Semgrep Code (SAST), Supply Chain (SCA), and Secrets detection. IDE re-generates code until Semgrep returns no findings or user overrides. Now shipped as part of the main `semgrep` binary (no standalone installation needed).

### Redundancy Check

**Existing capabilities checked**:
- security-auditor subagent: Code review, manual analysis
- /security-review command: Git diff security analysis
- TDD guard: Test-first development enforcement

**Classification**: **NOVEL** - Adds real-time security scanning during AI code generation. Existing tools operate AFTER code is written; Semgrep MCP operates DURING generation.

### Potential Value

**Token impact**: Low - Integrated into semgrep binary, minimal MCP overhead

**Capability**:
- **Real-time security scanning**: Scans code AS Claude generates it
- **Semgrep Code (SAST)**: 600k+ rules, dataflow analysis
- **Semgrep Supply Chain (SCA)**: Dependency vulnerability detection with reachability analysis
- **Semgrep Secrets**: Semantic secret detection (not just regex)
- **Validation**: Tests secrets against web services to confirm validity
- **IDE integration**: Works with Cursor, Claude Code, any MCP client
- **Iterative fixing**: IDE regenerates code until findings clear

**Integration effort**: Easy
- Single binary: `brew install semgrep` or `pip install semgrep`
- One-time login: `semgrep login && semgrep install-semgrep-pro`
- Hooks setup for pre/post code generation

### Comparison to Existing

| Feature | security-auditor | /security-review | Semgrep MCP |
|---------|------------------|------------------|-------------|
| Timing | After code review | Git diff only | During generation |
| SAST | Manual prompts | Manual analysis | 600k+ automated rules |
| Secrets | N/A | N/A | Semantic detection + validation |
| SCA | N/A | N/A | Reachability analysis |
| False positives | High (manual) | High (manual) | Low (validated findings) |
| Dataflow analysis | N/A | N/A | ✅ Semgrep Pro Engine |
| Blocking | Manual | Manual | Automated (won't generate insecure code) |

**Key differentiator**: Semgrep MCP is **PREVENTATIVE** - stops insecure code from being generated. Existing tools are **DETECTIVE** - find issues after code exists.

### Quick Assessment Score

- **Integration complexity**: 95/100 (Trivial: `brew install` + login + add to Claude)
- **Token efficiency impact**: 90/100 (Minimal overhead, prevents security rewrites)
- **Capability expansion**: 95/100 (Real-time security, completely new paradigm)
- **Maintenance burden**: 95/100 (Official Semgrep, enterprise-grade maintenance)
- **Community validation**: 100/100 (Official Anthropic partner, 636 stars, production-ready)

**TOTAL**: **95/100** (APPROVE - clear winner over DevSecOps MCP)

### Recommended Action

[ ] Evaluate further
[ ] Reject
[x] Fast-track integration

### Integration Notes

**Why Semgrep MCP > DevSecOps MCP**:
1. **Official vs community**: Semgrep is backed by r2c (acquired by Semgrep Inc), DevSecOps is single contributor
2. **Single binary**: No Docker/pip dependencies for multiple tools
3. **Real-time prevention**: Blocks insecure code during generation vs post-generation scanning
4. **Validation**: Secrets are tested against APIs to confirm validity
5. **Lower false positives**: Semgrep Pro Engine uses dataflow analysis
6. **Production-ready**: Used by thousands of companies, CLI-tested

**Setup**:
```bash
# Install
brew install semgrep  # or: pip install semgrep

# Authenticate
semgrep login && semgrep install-semgrep-pro

# Add to Claude Code
# (Add semgrep MCP config to ~/.claude.json)
```

**Hooks integration**: Create pre/post code generation hooks to invoke Semgrep scan.

**Deprecates**: This discovery makes DevSecOps MCP less valuable (68/100 → likely reject in favor of official Semgrep).

---

## Evaluation (2026-02-06)

### Redundancy Check

**Status**: IMPROVEMENT

Existing capabilities:
- security-auditor subagent (manual review, post-generation)
- /security-review command (git diff analysis, post-commit)

**Classification**: This is PREVENTATIVE security (during generation) vs existing DETECTIVE security (after generation). Complementary, not redundant.

### Cross-Validation with Codex

Codex assessment: 93/100 ("Official Anthropic partner, real-time prevention paradigm shift, zero integration friction for CLI users")
Variance: 2 points (consensus achieved)

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 95/100 | 20% | 19.0 | Single binary install, one login command, official support |
| Token efficiency impact | 90/100 | 25% | 22.5 | Prevents insecure code generation = no rewrite cycles |
| Capability expansion | 95/100 | 25% | 23.75 | Real-time prevention completely new, 600k+ rules |
| Maintenance burden | 95/100 | 15% | 14.25 | Official Semgrep, enterprise-grade support |
| Community validation | 100/100 | 15% | 15.0 | Official Anthropic MCP partner, 636 stars on archived repo |

**WEIGHTED TOTAL**: **94.5/100**

### Decision: APPROVE ✅

**Rationale**: Official Anthropic MCP partner providing real-time security scanning during code generation. Novel prevention paradigm vs existing detective tools. Trivial integration (single binary), zero token overhead beyond MCP tool schemas. Semgrep is production-grade (enterprise users, professional support). Clear winner over community alternatives.

**Integration Path**:
1. Install semgrep binary: `brew install semgrep` (or pip)
2. Authenticate: `semgrep login && semgrep install-semgrep-pro`
3. Add MCP config to `~/.claude.json` (semgrep command in PATH)
4. Test with sample code generation
5. Update registry with triggers: "real-time security", "semgrep mcp", "SAST during generation", "secret validation"

**Conditions**: None - ready for immediate integration

**Kill signals triggered**: None
