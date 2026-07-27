# Evaluation: AWS Agent Plugins for AWS (deploy-on-aws)

- **Date**: 2026-02-22
- **Source**: https://github.com/awslabs/agent-plugins
- **Blog**: https://aws.amazon.com/blogs/developer/introducing-agent-plugins-for-aws/
- **Category**: plugin (Claude Code plugin, not MCP)
- **Automated**: No (manual evaluation)

## Key Facts (from Codex research)

- **Repo**: `awslabs/agent-plugins` (not "agent-plugins-for-aws" as originally discovered)
- **Stars**: 97 (new repo, Feb 17 2026 launch)
- **License**: Apache-2.0
- **Type**: Claude Code plugin bundling Agent Skills + AWS MCP servers (Knowledge, Pricing, IaC)
- **Install**: `/plugin marketplace add awslabs/agent-plugins` then `/plugin install deploy-on-aws@agent-plugins-for-aws`
- **Credentials**: Uses local AWS CLI credentials (`~/.aws/credentials` or env vars), least-privilege recommended
- **Workflow**: 5-step (Analyze → Recommend → Estimate costs → Generate IaC → Deploy with confirmation)
- **IaC**: CDK and CloudFormation templates
- **Safety**: Explicit human confirmation before any deployment

## Scores

| Criterion | Weight | Claude Score | Codex Score | Rationale |
|-----------|--------|-------------|-------------|-----------|
| Integration complexity | 20% | 80 | 100 | Plugin install is easy, but requires AWS CLI configured with credentials. Not zero-config. |
| Token efficiency impact | 25% | 60 | 100 | Plugin bundles skills + references MCP servers — adds context overhead. Structured workflow reduces back-and-forth vs manual prompting, but net token impact is neutral-to-slightly-positive. Codex's 100 is overly generous. |
| Capability expansion | 25% | 85 | 80 | Novel end-to-end deploy workflow with cost estimation. Fills a real gap — no existing AWS deployment capability in registry. Bash `aws` CLI can deploy but lacks structured analysis/recommendation/costing. |
| Maintenance burden | 15% | 80 | 70 | Official AWS Labs = strong maintenance signal. Plugin updates automatic via marketplace. AWS service evolution may require occasional updates. |
| Community validation | 15% | 70 | 100 | Official AWS Labs is strong signal, but 97 stars is low (<100). Star count will grow but today it's modest. Codex incorrectly scored 100 (threshold is 1k+ for 100). |

- **Claude Score**: (80×0.20) + (60×0.25) + (85×0.25) + (80×0.15) + (70×0.15) = 16 + 15 + 21.25 + 12 + 10.5 = **74.75/100**
- **Codex Score**: (100×0.20) + (100×0.25) + (80×0.25) + (70×0.15) + (100×0.15) = 20 + 25 + 20 + 10.5 + 15 = **90.5/100**
- **Final Score**: Average = **(74.75 + 90.5) / 2 = 82.6/100**

## Score Reconciliation

Codex scored significantly higher (90.5 vs 74.75). Key disagreements:
- **Token efficiency**: Codex gave 100, Claude gave 60. Plugin adds context overhead from bundled skills/MCP references. Not a "major savings" tool — it's a capability tool. Splitting difference: 60 is more realistic.
- **Community validation**: Codex gave 100, Claude gave 70. Official AWS Labs is strong, but 97 stars doesn't meet the 1k+ threshold for 100. Claude's scoring is framework-compliant.
- **Integration complexity**: Codex gave 100, Claude gave 80. Requires AWS CLI configured with appropriate credentials — not zero-config for a new user.

## Decision

**APPROVED** (82.6/100) — Novel AWS deployment capability with official backing and structured safety workflow.

## Integration Notes

- **Type**: Claude Code plugin (NOT an MCP server)
- **Where**: Install via Claude Code plugin marketplace
- **Registry update**: Add to "DevOps & Infrastructure" section
- **Concerns**:
  - AWS credential security — enforce least-privilege
  - Review generated IaC before deployment
  - Plugin ID disambiguation: use README's `@agent-plugins-for-aws` identifier
- **Adoption trigger**: When doing AWS deployments (the finance app infrastructure)
- **Status recommendation**: FUTURE — similar to Terraform/Grafana MCPs. Approved but adopt when actively deploying AWS infrastructure.

## Redundancy Triggers

"aws agent plugins", "deploy-on-aws", "aws deployment plugin", "aws cdk plugin", "cloudformation plugin", "aws iac generation", "agent-plugins-for-aws"
