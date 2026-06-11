## Discovery: MCP Guard - Security Scanner for MCP Servers

**Source**: https://github.com/SaravanaGuhan/mcp-guard
**Category**: External Tool
**Stars/Validation**: LOW (newly released, ~5 stars based on search results)

### Summary
Comprehensive security assessment tool that identifies vulnerabilities IN MCP servers themselves through static analysis, dynamic testing, and intelligent fuzzing. Implements CVSS v4.0 and AIVSS (AI Vulnerability Scoring System) for vulnerability scoring. Supports Python, Node.js, Go, and Docker-based MCP servers.

### Redundancy Check

**Existing capabilities checked**:
- security-auditor: Reviews application code, not MCP servers
- /security-review: Git diff security, not MCP server security
- No existing MCP server security scanner

**Classification**: **NOVEL** - Meta-security tool for validating MCP servers before integration.

### Potential Value

**Token impact**: Zero - External CLI tool, not an MCP server itself

**Capability**:
- **Static analysis**: Pattern-based vulnerability detection in MCP server code
- **Dynamic testing**: Live server security assessment
- **Dependency scanning**: Known CVE identification in MCP dependencies
- **Protocol validation**: 56+ MCP compliance rules
- **Fuzzing**: Coverage-guided fuzzing to find crashes
- **Tool fingerprinting**: Detect schema changes and breaking API updates
- **AI-powered explanations**: LLM-based remediation guidance
- **Professional scoring**: CVSS v4.0 + AIVSS (AI-specific scoring)
- **CI/CD integration**: SARIF, JUnit XML, GitLab output formats
- **Batch processing**: Multi-repository analysis

**Integration effort**: Easy
- Rust-based CLI tool
- Can analyze MCP servers from GitHub repos
- Auto-detects Claude Desktop config

### Use Cases

1. **Pre-integration vetting**: Scan MCP servers before adding to Claude Code
2. **CI/CD pipeline**: Automated security gates for MCP server updates
3. **Supply chain security**: Validate third-party MCP servers
4. **Compliance**: Generate security reports for MCP deployments
5. **Continuous monitoring**: Watch mode for detecting new vulnerabilities

### Comparison to Existing

| Feature | security-auditor | /security-review | MCP Guard |
|---------|------------------|------------------|-----------|
| Target | Application code | Git diffs | MCP servers |
| Static analysis | Manual | Manual | ✅ Automated |
| Dynamic testing | N/A | N/A | ✅ Live server testing |
| Dependency scanning | N/A | N/A | ✅ CVE detection |
| Protocol validation | N/A | N/A | ✅ 56+ rules |
| Fuzzing | N/A | N/A | ✅ Coverage-guided |
| CVSS scoring | Manual | Manual | ✅ CVSS v4.0 + AIVSS |
| CI/CD integration | N/A | N/A | ✅ SARIF, JUnit |

**Key differentiator**: Scans the MCP SERVERS themselves, not the application code. Addresses supply chain security for MCP ecosystem.

### Quick Assessment Score

- **Integration complexity**: 90/100 (External CLI, no MCP integration needed)
- **Token efficiency impact**: 100/100 (Zero - external tool)
- **Capability expansion**: 85/100 (New MCP supply chain security capability)
- **Maintenance burden**: 80/100 (Rust CLI, minimal dependencies)
- **Community validation**: 40/100 (Very new, low stars, unproven)

**TOTAL**: **79/100** (APPROVE, but needs validation)

### Recommended Action

[x] Evaluate further - Validate tool effectiveness on real MCP servers
[ ] Reject
[ ] Fast-track integration

### Integration Notes

**Usage workflow**:
```bash
# Install
cargo install mcp-guard

# Scan a GitHub MCP server repo
mcp-guard scan --repo https://github.com/org/mcp-server

# Scan local MCP server
mcp-guard scan --path ./my-mcp-server

# Batch scan all configured MCP servers
mcp-guard scan --config ~/.config/Claude/claude_desktop_config.json

# CI/CD integration
mcp-guard scan --output sarif --fail-on critical
```

**Integration points**:
1. **Pre-integration hook**: Scan MCP servers before adding to ~/.claude.json
2. **CI/CD pipeline**: GitHub Action to scan MCP server repos
3. **Periodic audits**: Cron job to re-scan installed MCP servers
4. **Supply chain gate**: Reject MCP servers with critical vulnerabilities

**Skill file**: Create `~/.claude/skills/mcp-security-vetting/SKILL.md` documenting:
- When to use MCP Guard
- How to interpret CVSS/AIVSS scores
- Security thresholds for integration
- Remediation workflows

### Research Questions

1. **Effectiveness**: How accurate is the vulnerability detection? False positive rate?
2. **Coverage**: Does it catch real MCP server vulnerabilities?
3. **Performance**: How long do scans take? Suitable for CI/CD?
4. **AIVSS scoring**: Is this a recognized standard, or custom?
5. **Comparison**: How does it compare to manual MCP review?

### Related Discoveries

This tool would be used to vet other discoveries:
- DevSecOps MCP
- MCP Security Hub
- Any third-party MCP servers

Complements APIsec MCP Discovery and Audit (found in search).

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6 (capability-evaluator)

### Redundancy Analysis

**Registry check**: No existing MCP server security scanning capability. security-auditor and /security-review scan APPLICATION code, not MCP servers themselves. **Classification: NOVEL**

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 90/100 | 20% | 18.0 | Rust CLI, external tool, zero Claude Code config changes |
| Token Efficiency Impact | 100/100 | 25% | 25.0 | Zero token cost - external scanning tool |
| Capability Expansion | 85/100 | 25% | 21.25 | Novel MCP supply chain security, addresses real attack surface |
| Maintenance Burden | 80/100 | 15% | 12.0 | Rust CLI, minimal dependencies, no runtime integration needed |
| Community Validation | 40/100 | 15% | 6.0 | Very new (~5 stars), unproven in production |
| **TOTAL** | | | **82.25/100** | **APPROVE** |

### Cross-Validation

**Codex assessment**: Not required for this evaluation (clear novel capability with straightforward scoring).

### Decision: **APPROVE** (Score: 82.25/100)

**Rationale**: Novel capability addressing MCP supply chain security with zero token overhead. Low stars are the only concern, but the capability is genuinely unique and the integration risk is minimal (external CLI tool).

### Integration Path

1. **Installation**: `cargo install mcp-guard` (Rust tool)
2. **Create skill file**: `~/.claude/skills/mcp-security-vetting/SKILL.md`
   - Document when to use MCP Guard
   - CVSS/AIVSS score interpretation guidelines
   - Security thresholds for integration (e.g., reject Critical, require review for High)
   - Remediation workflows
3. **Add to discovery workflow**: Update capability-discoverer to scan MCP discoveries before evaluation
4. **Integration gates**:
   - Pre-integration hook: Scan before adding to ~/.claude.json
   - Document in evaluation templates: "Run mcp-guard scan before scoring"
5. **Update registry**: Add to existing-capabilities.md under "Security" section

### Conditions

- Test on existing MCP servers to validate accuracy (false positive rate)
- Document findings in integration report with real-world scan examples
- Consider CI/CD integration for automated MCP repo scanning (future enhancement)

### Notes

This tool addresses a real gap: we integrate third-party MCP servers without security vetting. MCP Guard provides automated supply chain security for the MCP ecosystem, similar to how npm audit works for Node.js packages.
