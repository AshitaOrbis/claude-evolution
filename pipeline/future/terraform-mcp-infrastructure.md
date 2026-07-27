# Discovery: Terraform MCP Server

- **Source**: https://github.com/hashicorp/terraform-mcp-server
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Official HashiCorp Terraform MCP server providing real-time Terraform Registry access, HCP Terraform/Enterprise integration, workspace management, and IaC automation through AI. Dual transport (stdio/HTTP), 1.2k stars, MPL-2.0 license.
- **Potential Value**: High
- **Integration Complexity**: Medium

## Description

The Terraform MCP Server enables AI assistants to work with Infrastructure as Code through direct integration with Terraform ecosystem:

**Key Features**:
- **Registry Integration**: Direct access to Terraform Registry APIs for providers, modules, and policies (real-time, not training data)
- **HCP Terraform & Enterprise**: Full workspace management, organization/project listing, private registry access
- **Workspace Operations**: Create, update, delete workspaces with variables, tags, and run management
- **Dual Transport**: Stdio and StreamableHTTP protocols for flexible deployment
- **Security Model**: Local-first design, configurable CORS, rate limiting, TFE_TOKEN authentication

**Technical Details**:
- Language: Go (likely, given HashiCorp stack)
- License: MPL-2.0
- Stars: 1.2k (official HashiCorp project)
- Version: 0.4.0+ (active development, 312 commits)
- Requires: Docker (optional), TFE_TOKEN for HCP Terraform

**Unique Value**:
- Real-time provider documentation (avoids stale training data)
- AI-generated Terraform configs with accurate syntax
- Workspace automation without manual CLI operations
- Private registry support for enterprise deployments

**Use Cases**:
- "Generate AWS EC2 Terraform config for t3.micro instance"
- "Show me available AWS provider resources"
- "Create HCP Terraform workspace for production deployment"
- "What modules exist for Kubernetes ingress?"

## Redundancy Check

**Status**: NOVEL

Searched registry for: "terraform", "infrastructure as code", "IaC", "cloud automation", "workspace management", "hashicorp"

**Findings**:
- ✅ No existing Terraform integration
- ✅ Bash can run `terraform` CLI but NOT with Registry API intelligence
- ✅ No HCP Terraform workspace management
- ✅ No real-time provider documentation access
- ✅ AWS/GCP/Azure mentioned in registry but NOT as IaC tools

**Category**: Infrastructure & Cloud (gap in current capabilities)

## Evaluation Needs

1. **Token Efficiency**: How much overhead for typical queries? Registry API responses?
2. **Use Cases**: Valuable for the finance app AWS infra? The statement parser deployment automation?
3. **HCP vs OSS**: Do we need HCP Terraform or just Registry access?
4. **Security**: How are TFE_TOKEN credentials managed? Local-only recommendation?
5. **Skill Integration**: Should this pair with a Terraform skill for Claude?
6. **Alternative**: Could we achieve same via Bash + `terraform` CLI + `curl` to Registry?

**Quick Assessment Score** (preliminary):
- Integration complexity: 60 (Docker + TFE_TOKEN, but straightforward)
- Token efficiency impact: 70 (Registry API responses, documentation extraction)
- Capability expansion: 90 (enables IaC automation, fills major gap)
- Maintenance burden: 85 (official HashiCorp, well-maintained)
- Community validation: 85 (1.2k stars, official, active)
- **TOTAL**: ~78 (likely APPROVE)

## Notes

- Official HashiCorp = guaranteed protocol compliance, long-term support
- Addresses "Claude can code but not deploy" gap
- Could enable end-to-end workflows: "Build app → Generate Terraform → Deploy"
- Security model emphasizes local-only use (aligns with our approach)
- MPL-2.0 license is permissive (compatible with our stack)
- Recent activity: v0.4.0 released Jan 22, 2026 (policy sets feature)
