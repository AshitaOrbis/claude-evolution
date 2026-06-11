## Discovery: DevSecOps MCP Server

**Source**: https://github.com/jmstar85/DevSecOps-MCP
**Category**: MCP
**Stars/Validation**: Low (~24 stars, but recent activity), Listed on Glama and mcp.so

### Summary
A comprehensive MCP server integrating multiple security scanning tools: SAST (Semgrep, Bandit), DAST (OWASP ZAP), IAST (Trivy + ZAP hybrid), and SCA (npm audit, OSV Scanner, Trivy). Provides unified interface for AI-driven vulnerability scanning with multiple output formats (JSON, HTML, PDF, SARIF). 100% open-source with no commercial dependencies.

### Redundancy Check

**Existing capabilities checked**:
- security-auditor subagent: Exists, but operates at code review level
- /security-review command: Exists, but focuses on git diff analysis
- No existing MCP for SAST/DAST/SCA automation

**Classification**: **NOVEL** - Adds automated security scanning capabilities not present in existing tools. Existing tools are reactive (review after code written), this enables proactive scanning during development.

### Potential Value

**Token impact**: Moderate - MCP adds ~2-3k token overhead, but provides actionable vulnerability data instead of manual scanning

**Capability**: Novel integration of multiple security scanners:
- SAST: Semgrep (600k+ rules), Bandit (Python-specific)
- DAST: OWASP ZAP (active vulnerability scanning)
- IAST: Trivy + ZAP hybrid (runtime + static)
- SCA: npm audit, OSV Scanner, Trivy (dependency vulnerabilities)
- SARIF output for GitHub Security tab integration
- Policy enforcement with configurable thresholds

**Integration effort**: Medium
- Requires Docker for OWASP ZAP
- Requires pip/pip3 for Python tools (Semgrep, Bandit)
- Node.js dependencies already present
- Config files for security rules and thresholds

### Comparison to Existing

| Feature | security-auditor | /security-review | DevSecOps MCP |
|---------|------------------|------------------|---------------|
| SAST | Manual prompts | Git diff only | Automated (Semgrep, Bandit) |
| DAST | N/A | N/A | OWASP ZAP integration |
| SCA | N/A | N/A | npm audit, OSV, Trivy |
| SARIF output | N/A | N/A | ✅ GitHub integration |
| Policy gates | Manual | Manual | Configurable thresholds |
| Coverage | Code review | Pending changes | Full codebase + runtime |

**Key differentiator**: Existing tools are REACTIVE (review code after written), DevSecOps MCP is PROACTIVE (scan during development).

### Quick Assessment Score

- **Integration complexity**: 60/100 (Docker + pip dependencies, but well-documented)
- **Token efficiency impact**: 70/100 (MCP overhead offset by actionable scan data)
- **Capability expansion**: 90/100 (Adds DAST, IAST, SCA - completely new capabilities)
- **Maintenance burden**: 70/100 (Depends on external tools: ZAP, Semgrep, etc.)
- **Community validation**: 50/100 (Low stars, but listed on multiple MCP directories)

**TOTAL**: **68/100** (Below threshold, needs research - validate tool stability)

### Recommended Action

[x] Evaluate further - RESEARCH GATE (50-69 range)
[ ] Reject
[ ] Fast-track integration

### Research Questions

1. **Tool stability**: How stable are the SAST/DAST/IAST integrations? Any known issues?
2. **Performance**: What's the scan time for typical projects? Token overhead in practice?
3. **False positive rate**: How noisy are Semgrep/ZAP/Trivy results? Need filtering?
4. **GitHub Security tab integration**: Does SARIF output actually work with GitHub?
5. **Alternative**: Should we use Semgrep MCP directly instead? (see next discovery)

---

## Evaluation

**Evaluator**: capability-evaluator
**Evaluation Date**: 2026-02-06

### Registry Redundancy Check

**Keywords**: security scanning, SAST, DAST, SCA, IAST, vulnerability scanning, Semgrep, OWASP ZAP, Trivy

**Registry Check**: Found existing security capabilities:
- security-auditor subagent: IMPLEMENTED (code review level)
- /security-review command: IMPLEMENTED (git diff analysis, 3-phase HIGH/MEDIUM severity)
- No existing SAST/DAST/SCA automation MCP

**Classification**: **NOVEL (with caveats)** - Adds automated security scanning not present in existing tools. Existing tools are REACTIVE (review after code written), this is PROACTIVE (scan during development).

### Scoring

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 55/100 | Requires Docker (ZAP), pip (Semgrep, Bandit), config files. Well-documented but not trivial. Low stars (24) = limited community testing. |
| Token Efficiency Impact | 65/100 | MCP adds ~2-3k overhead, but provides actionable scan results. Net positive IF scans are targeted (not full codebase every query). Risk of verbose output bloat. |
| Capability Expansion | 85/100 | Adds DAST (ZAP), IAST (Trivy+ZAP), SCA (npm/OSV/Trivy), SARIF output. Novel capabilities vs existing reactive tools. SAST (Semgrep) is incremental (security-auditor covers this reactively). |
| Maintenance Burden | 60/100 | Depends on 4 external tools (ZAP, Semgrep, Bandit, Trivy). Each tool evolves independently. Docker dependency adds complexity. Low community validation (24 stars). |
| Community Validation | 40/100 | Low stars (24), limited production use, listed on MCP directories but not widely adopted. Repository is active (recent commits) but early stage. |
| **WEIGHTED TOTAL** | **63.5/100** | FUTURE (50-69 range) |

**Calculation**: (55×0.20) + (65×0.25) + (85×0.25) + (60×0.15) + (40×0.15) = 63.5

### Cross-Validation (Codex)

**Codex Assessment**: 58/100
- Agreement: "Novel capabilities (DAST, SCA) are valuable"
- Concern: "Low community validation is a red flag - 24 stars suggests limited testing"
- Concern: "Four external tool dependencies = high maintenance risk"
- Question: "Why not use Semgrep MCP directly + Trivy CLI? Less dependency hell"
- Variance: 5.5 points (within acceptable range)

### Decision: FUTURE (50-69 range)

**Rationale**: Interesting capabilities (DAST, IAST, SCA) but significant concerns:
1. **Low community validation**: 24 stars = limited production testing, higher risk of bugs
2. **High dependency complexity**: Docker + 4 external tools = fragile integration
3. **Maintenance burden**: Each tool (ZAP, Semgrep, Trivy, Bandit) evolves independently
4. **Alternative exists**: Could use Semgrep MCP (official, 1.2k stars) + Trivy CLI directly
5. **Proactive value unclear**: How often do we need DAST/IAST vs reactive security-auditor?

### Research Gate Assessment

**Completeness**: 6/10 - Well-documented, but low stars suggest limited production validation
**Viability**: 7/10 - Technical viability high (tools are proven), but integration stability unknown
**Effort-to-Value**: 5/10 - High integration effort (Docker, 4 tools), speculative value (DAST/IAST usage unclear)

**Total**: 18/30 - DEFER

### Recommended Action

**MOVE TO FUTURE** - Revisit when:
1. **Community validation increases** (100+ stars, production adoption examples)
2. **Clear use case emerges** (need DAST/IAST for specific project)
3. **Alternative assessment complete** (evaluate Semgrep MCP + Trivy CLI as lighter alternative)
4. **Stability validation** (test in isolated project first, validate false positive rate)

### Alternative Approach (Lower Complexity)

Instead of comprehensive MCP with 4 tools, consider:

1. **Semgrep MCP** (official, 1.2k stars) for SAST
2. **Trivy CLI via Bash** for SCA (zero token overhead)
3. **security-auditor subagent** for code review (reactive, but already works)
4. **DAST/IAST on-demand** (manual ZAP runs when needed, not in conversation context)

This avoids MCP complexity while covering 80% of use cases.

### Integration Blocker Classification

**Type B: Validation Required**
- Need stability testing (low community validation is a risk)
- Need false positive rate assessment (Semgrep/ZAP can be noisy)
- Need performance benchmarking (scan time, token overhead)
- Need alternative comparison (Semgrep MCP + Trivy CLI vs comprehensive MCP)

### Pros

✅ Adds DAST (OWASP ZAP) - not available elsewhere
✅ Adds IAST (Trivy + ZAP hybrid) - novel capability
✅ Adds SCA (npm audit, OSV, Trivy) - proactive dependency scanning
✅ SARIF output for GitHub Security tab integration
✅ 100% open-source (no commercial dependencies)
✅ Policy enforcement with configurable thresholds

### Cons

❌ Low community validation (24 stars = limited production testing)
❌ High dependency complexity (Docker + 4 external tools)
❌ Maintenance burden (4 tools evolve independently)
❌ Alternative may be simpler (Semgrep MCP + Trivy CLI)
❌ Proactive value unclear (when do we actually need DAST/IAST?)
❌ Risk of false positive noise (Semgrep/ZAP can be verbose)

### Registry Update (If Promoted Later)

Would add to "Code Quality" section:

```markdown
| Capability | Status | Implementation |
|------------|--------|----------------|
| SAST/DAST/SCA Automation | **IMPLEMENTED** | DevSecOps MCP (Semgrep, ZAP, Trivy, Bandit) |
```

But NOT adding now - needs validation first.
