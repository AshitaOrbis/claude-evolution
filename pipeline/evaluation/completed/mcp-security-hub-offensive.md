## Discovery: MCP Security Hub (FuzzingLabs)

**Source**: https://github.com/FuzzingLabs/mcp-security-hub
**Category**: MCP
**Stars/Validation**: 111 stars, MIT license, Active development

### Summary
Collection of MCP servers bringing offensive security tools to AI assistants: Nmap (network scanning), Ghidra (reverse engineering), Nuclei (vulnerability scanner), SQLMap (SQL injection), Hashcat (password cracking), and more. Enables AI-assisted penetration testing and security research.

### Redundancy Check

**Existing capabilities checked**:
- security-auditor: Defensive security (code review)
- /security-review: Defensive security (vulnerability detection)
- No existing offensive security tools

**Classification**: **NOVEL** - Adds offensive security capabilities for penetration testing, red team exercises, and security research.

### Potential Value

**Token impact**: Moderate - Each tool MCP adds overhead, but can be loaded on-demand with Tool Search Tool

**Capability**: Offensive security toolchain:
- **Nmap**: Network discovery, port scanning, service detection
- **Ghidra**: Binary analysis, reverse engineering
- **Nuclei**: Template-based vulnerability scanner (9000+ templates)
- **SQLMap**: Automated SQL injection testing
- **Hashcat**: GPU-accelerated password cracking
- **Additional tools**: Feroxbuster, Whatweb, etc.

**Integration effort**: Hard
- Requires installation of each tool individually
- Some tools (Ghidra, Hashcat) are resource-intensive
- Ethical/legal considerations for usage

### Use Cases

1. **Security research**: Analyze malware, reverse engineer binaries
2. **Penetration testing**: Automated vulnerability scanning with Nuclei
3. **Network auditing**: Nmap for internal network discovery
4. **Password auditing**: Hashcat for testing password policies
5. **SQL injection testing**: SQLMap for database security

### Security & Ethical Considerations

⚠️ **WARNING**: These are offensive security tools with dual-use potential.

**Risks**:
- **Unauthorized access**: Tools like SQLMap can exploit vulnerabilities
- **Legal liability**: Using on systems without permission is illegal
- **Resource consumption**: Hashcat uses GPU, can impact system
- **False security**: AI may misuse tools without understanding context

**Mitigations**:
- Restrict to authorized security professionals
- Require explicit user consent before tool execution
- Add disclaimers in tool descriptions
- Log all tool invocations for audit
- Sandbox tool execution (Docker containers)

### Comparison to Existing

| Feature | security-auditor | /security-review | MCP Security Hub |
|---------|------------------|------------------|------------------|
| Purpose | Defensive | Defensive | Offensive |
| Network scanning | N/A | N/A | ✅ Nmap |
| Binary analysis | N/A | N/A | ✅ Ghidra |
| Vulnerability scanning | Manual | Manual | ✅ Nuclei (9000+ templates) |
| SQL injection testing | N/A | N/A | ✅ SQLMap |
| Password auditing | N/A | N/A | ✅ Hashcat |

**Key differentiator**: Defensive (existing) vs Offensive (new). Completely different threat model.

### Quick Assessment Score

- **Integration complexity**: 40/100 (Each tool requires separate installation, some are complex)
- **Token efficiency impact**: 60/100 (Multiple MCPs, but can defer loading)
- **Capability expansion**: 85/100 (New offensive security capabilities)
- **Maintenance burden**: 50/100 (Depends on upstream tools, many dependencies)
- **Community validation**: 70/100 (111 stars, but niche use case)

**TOTAL**: **61/100** (Below threshold, needs research)

### Recommended Action

[x] Evaluate further - RESEARCH GATE (legal/ethical considerations)
[ ] Reject
[ ] Fast-track integration

### Research Questions

1. **Legal review**: Can we distribute offensive security tools in Claude Code context?
2. **User authorization**: How do we ensure tools only used on authorized systems?
3. **Audit logging**: Can we track tool invocations for compliance?
4. **Sandboxing**: Should tools run in isolated containers?
5. **Alternative approach**: Should we document Bash-based tool usage instead of MCP integration?
6. **Target audience**: Is this valuable for our user base, or too niche?
7. **Liability**: What's our liability if users misuse these tools?

### Notes

This is a **specialized security research toolchain**, not a general-purpose security improvement. Requires careful consideration of:
- Legal implications
- Ethical guidelines
- User authorization
- Audit requirements

May be more appropriate to document in a SKILL file ("Using offensive security tools with Claude Code") rather than direct MCP integration.

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6 (capability-evaluator)

### Redundancy Analysis

**Registry check**: No existing offensive security tools. security-auditor and /security-review are DEFENSIVE (find vulnerabilities in our code). MCP Security Hub is OFFENSIVE (exploit vulnerabilities in target systems). **Classification: NOVEL**

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 40/100 | 20% | 8.0 | Each tool requires separate installation (Nmap, Ghidra, Nuclei, SQLMap, Hashcat), complex dependencies |
| Token Efficiency Impact | 60/100 | 25% | 15.0 | Multiple MCPs add overhead, but Tool Search Tool mitigates; deferred loading possible |
| Capability Expansion | 70/100 | 25% | 17.5 | Novel offensive security capabilities, but VERY NICHE use case for coding assistant |
| Maintenance Burden | 50/100 | 15% | 7.5 | Depends on upstream tools (Nmap, Ghidra, etc.), many dependencies to manage |
| Community Validation | 70/100 | 15% | 10.5 | 111 stars, active development, but niche security research audience |
| **TOTAL** | | | **58.5/100** | **FUTURE** |

### Cross-Validation (Codex)

Used codex-researcher to cross-validate:

**Codex assessment**: 52/100 - "Offensive security tools are high-value for security professionals but pose legal/ethical risks for general coding assistant. Installation complexity and narrow use case are concerns. Recommend deferring until clear user demand emerges."

**Variance**: 6.5 points (acceptable, both agree on FUTURE status)

### Decision: **FUTURE** (Score: 58.5/100)

**Rationale**: Below the 70+ approval threshold due to:
1. **Legal/ethical risks**: Tools like SQLMap and Hashcat can be misused for unauthorized access
2. **Narrow use case**: Security research is not a primary Claude Code workflow
3. **Installation complexity**: Each tool requires separate setup, some are resource-intensive (Ghidra, Hashcat)
4. **Unclear demand**: No user research showing coding sessions need offensive security tools

This is a valuable capability for security professionals, but needs:
- Legal review of distribution risks
- User authorization mechanisms (audit logging, consent workflows)
- Demand validation (how many Claude Code users need pentesting tools?)
- Alternative evaluation (Bash-based tool usage vs MCP integration)

### Adoption Triggers

Reconsider for integration if:
1. **User demand emerges**: Multiple requests for pentesting tool integration
2. **Legal clearance**: Confirmed we can distribute offensive security tools
3. **Authorization framework**: Audit logging and consent mechanisms implemented
4. **Sandboxing solution**: Docker-based isolation for tool execution
5. **Target audience shift**: Claude Code expands to security researcher market

### Alternative Approach (Recommended)

Instead of MCP integration, create **skill file**: `~/.claude/skills/offensive-security-tools/SKILL.md`
- Document how to use Nmap, Nuclei, SQLMap via Bash tool
- Include legal disclaimers and authorization requirements
- Provide example workflows without adding MCP overhead
- Reference FuzzingLabs repo for users who want MCP integration

This approach:
- Avoids token overhead of MCPs
- Provides guidance without legal risk of bundling
- Allows advanced users to self-integrate if needed
- Documents best practices for authorized security testing

### Notes

Offensive security tools are a double-edged sword: highly valuable for authorized security professionals, but pose legal/ethical risks in a general-purpose coding assistant. The skill file approach provides value without the integration burden.
