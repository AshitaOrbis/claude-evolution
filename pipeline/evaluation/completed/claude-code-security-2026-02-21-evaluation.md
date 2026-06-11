# Evaluation: Claude Code Security (Anthropic Official)

- **Date**: 2026-02-21
- **Source**: https://fortune.com/2026/02/20/exclusive-anthropic-rolls-out-ai-tool-that-can-hunt-software-bugs-on-its-own-including-the-most-dangerous-ones-humans-miss/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 0 | Impossible — Enterprise/Team plan only; no local CLI, MCP, or API endpoint available |
| Token efficiency impact | 25% | 50 | Neutral — cannot affect our token usage; not integratable into local workflow |
| Capability expansion | 25% | 20 | Technique awareness only; cross-component data flow analysis is novel but inaccessible; existing semgrep + security-auditor + /security-review covers local workflow |
| Maintenance burden | 15% | 100 | Zero — nothing to install, configure, or maintain |
| Community validation | 15% | 100 | Official Anthropic product with enterprise launch; sent CrowdStrike/Cloudflare stocks down 8%+ |

- **Claude Score**: 47.5/100
- **Codex Score**: N/A (Codex unavailable)
- **Final Score**: 47.5/100

## Decision

REJECTED — Cannot be integrated (Enterprise-tier only, no local API); existing security stack (semgrep MCP + security-auditor + /security-review) covers local development workflow adequately.

## Integration Notes

Not integrable in current form. Rejected, not abandoned — watch for these triggers:

1. If Anthropic releases a local CLI or API endpoint for Claude Code Security
2. If published techniques for cross-component data flow analysis become available (enable improvements to security-auditor subagent)
3. If workspace moves to Enterprise tier

**Technique of interest**: Full-codebase cross-component data flow tracing as a single unit of analysis (vs. current git diff scope or heuristic review). Future sessions could apply this framing manually when running security reviews on critical paths.
