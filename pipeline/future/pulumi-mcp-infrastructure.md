# Discovery: Pulumi MCP Server (Remote + Local)

- **Source**: https://www.pulumi.com/blog/remote-mcp-server/ + https://github.com/pulumi/mcp-server
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Official Pulumi MCP server with BOTH remote (https://mcp.ai.pulumi.com/mcp) and local options. Infrastructure-as-code automation, Pulumi Cloud integration, OAuth authentication, Pulumi Neo delegation. Alternative to Terraform MCP.
- **Potential Value**: High
- **Integration Complexity**: Easy (remote) / Medium (local)

## Description

The Pulumi MCP Server enables AI assistants to manage infrastructure through Pulumi's IaC platform with two deployment options:

**Key Features**:
- **Dual Deployment**: Remote hosted service (zero setup) OR local npm package
- **Pulumi Cloud Integration**: Access stacks, search resources, manage deployments
- **Pulumi Neo Delegation**: Autonomous infrastructure automation agent
- **OAuth Authentication**: Centralized credential management (remote) vs local tokens
- **Universal Access**: One URL works across all machines (remote)
- **Programming Language Support**: TypeScript, Python, Go, C#, Java, YAML

**Technical Details**:
- Language: TypeScript (npm package)
- License: (Check GitHub for local version)
- Remote URL: `https://mcp.ai.pulumi.com/mcp`
- Local Install: npm package
- Requires: Pulumi Cloud account + Access Token

**Remote vs Local**:

| Feature | Remote Server | Local Server |
|---------|---------------|--------------|
| Setup | Zero (single URL) | npm install |
| Updates | Automatic | Manual |
| Authentication | OAuth (browser flow) | Access Token (env var) |
| Offline | ❌ | ✅ |
| Use Case | Multi-machine, teams | Offline, local dev |

**Unique Value**:
- **Remote MCP** is industry-first hosted solution (no local installation)
- Pulumi Neo integration for autonomous infrastructure changes
- Multi-language IaC support (vs Terraform's HCL)
- Programming-first approach (vs Terraform's declarative config)

**Comparison with Terraform MCP**:
- Terraform: HCL-based, Registry focus, workspace management
- Pulumi: Multi-language, Pulumi Cloud focus, Neo agent integration
- Both: Official vendors, IaC automation, cloud deployment

## Redundancy Check

**Status**: NOVEL (compare with Terraform MCP)

Searched registry for: "pulumi", "infrastructure as code", "IaC", "cloud automation", "remote mcp", "hosted mcp server"

**Findings**:
- ✅ No existing Pulumi integration
- ⚠️ Terraform MCP in pending queue (evaluate together)
- ✅ No multi-language IaC support
- ✅ No remote/hosted MCP server pattern
- ✅ No autonomous infrastructure agent integration (Neo)

**Category**: Infrastructure & Cloud (compare with Terraform MCP)

## Evaluation Needs

1. **Terraform vs Pulumi**: Do we pick one or both? What's our IaC preference?
2. **Remote vs Local**: Is remote MCP acceptable (requires internet, OAuth)?
3. **Use Cases**: Do we USE Pulumi anywhere? <private-project> AWS deployments?
4. **Language Preference**: Do we prefer programming (Pulumi) vs declarative (Terraform)?
5. **Token Efficiency**: How verbose are Pulumi API responses?
6. **Security**: OAuth flow vs local tokens - which fits our security model?
7. **Neo Integration**: Is autonomous infrastructure agent valuable or risky?

**Quick Assessment Score** (preliminary):
- Integration complexity: 40 (remote) / 55 (local)
- Token efficiency impact: 70 (similar to Terraform)
- Capability expansion: 85 (IF we use Pulumi, alternative to Terraform)
- Maintenance burden: 90 (official Pulumi, hosted updates for remote)
- Community validation: 80 (official, industry-first remote pattern)
- **TOTAL**: ~73 (likely APPROVE IF we prefer Pulumi over Terraform)

## Notes

- **CRITICAL DECISION**: Terraform MCP vs Pulumi MCP (likely choose ONE, not both)
- Remote MCP is **industry-first** hosted pattern (zero local setup)
- Pulumi Neo = autonomous agent that MAKES infrastructure changes (not just reads)
  - Risk: Autonomous infra changes could be dangerous
  - Benefit: "Claude, deploy staging" workflows
- Multi-language support = better for TypeScript/Python teams
- OAuth authentication = better for teams, worse for isolated/offline use

**Decision Framework**:
```
Do we use Pulumi or Terraform?
├─ Pulumi → Evaluate Pulumi MCP (remote or local)
├─ Terraform → Evaluate Terraform MCP (1.2k stars)
└─ Neither → Pick based on:
    ├─ Language preference (programming vs declarative)
    ├─ Team familiarity
    ├─ Integration patterns (Neo agent vs workspace management)
    └─ Deployment model (remote vs local)
```

**Unique Advantage**: Remote MCP pattern = no local installation, works everywhere. This could be the FUTURE of MCP servers (hosted services vs local packages).

**Risk Assessment**:
- Remote requires internet (not offline-capable)
- OAuth flow = browser dependency
- Pulumi Neo autonomy = potentially dangerous if misconfigured
- Hosted service = Pulumi controls availability

**Comparison Summary**:
| Aspect | Terraform MCP | Pulumi MCP |
|--------|---------------|------------|
| Stars | 1.2k | (unknown for remote) |
| Deployment | Local only | Remote OR local |
| Language | HCL | TS/Python/Go/C#/Java/YAML |
| Auth | Env token | OAuth (remote) / token (local) |
| Agent | No | Yes (Pulumi Neo) |
| Maintenance | Self-managed | Auto-updates (remote) |

**Recommendation**: Evaluate BOTH Terraform and Pulumi MCPs, then choose based on:
1. Which IaC tool we currently use (if any)
2. Team language preference
3. Remote vs local deployment preference
4. Comfort with autonomous agents (Neo)
