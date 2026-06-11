# Evaluation: Deno Sandbox

- **Date**: 2026-02-06
- **Source**: https://simonwillison.net/2026/Feb/3/introducing-deno-sandbox/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 60 | API integration + vendor lock-in concern + pricing unknown |
| Token efficiency impact | 25% | 50 | Neutral - sandbox doesn't affect token usage |
| Capability expansion | 25% | 85 | Addresses security gap for untrusted LLM-generated code |
| Maintenance burden | 15% | 60 | Depends on Deno Deploy SaaS availability + API stability |
| Community validation | 15% | 80 | Deno is established (1M+ users), but sandbox is new product |

- **Claude Score**: 66.75/100
- **Codex Score**: N/A (Codex MCP unavailable)
- **Final Score**: 66.75/100

## Decision

**REJECTED** (was NEEDS_RESEARCH, now resolved) — Docker/OpenClaw provides equivalent functionality at zero cost with no vendor lock-in. Score lowered from 66.75 to 51.5 after applying research-gate-framework Type D blocker (vendor lock-in).

## Integration Notes

### Current Sandbox Capabilities
Claude Code has limited sandboxing:
- Bash tool has `dangerouslyDisableSandbox` parameter (implies default sandbox exists)
- OpenClaw/Moltbook integration uses Docker isolation
- No hosted sandbox solution currently

### Deno Sandbox Advantages
1. **Hosted**: No local infrastructure (Docker, VM) needed
2. **Language-agnostic**: Python, JS support (potentially more)
3. **Network control**: Prevents credential exfiltration
4. **LLM-optimized**: Designed for AI agent use case

### Research Questions (CRITICAL)
1. **Pricing Model**: What does Deno Sandbox cost? Per-execution? Monthly? Free tier?
2. **Rate Limits**: API throttling that could block agent workflows?
3. **Comparison**: How does this compare to:
   - Local Docker (openclaw pattern)
   - Bash tool sandbox mode
   - E2E testing (no sandbox for now)
4. **Language Support**: Beyond Python/JS, what languages work?
5. **Vendor Lock-in**: Can we migrate away if needed? Self-hosted option?
6. **Latency**: How fast is API execution compared to local?

### Use Cases
- **High value**: Running untrusted code from capability discovery (OpenClaw successor?)
- **Medium value**: Testing generated code before execution
- **Low value**: Regular development tasks (local is faster/cheaper)

### Integration Paths
1. **Replace OpenClaw Docker**: Use Deno Sandbox for Moltbook exploration
2. **Bash Tool Enhancement**: Add `sandbox: "deno"` parameter to Bash tool
3. **New Subagent**: Create `sandbox-executor` agent using Deno API
4. **MCP Server**: Wrap Deno Sandbox API as MCP tool

### Why Medium-High Score
- **Addresses gap**: Hosted sandbox fills security need
- **Novel capability**: No equivalent in current stack
- **Official product**: Deno is established, reputable
- **BUT**: Pricing unknown, vendor lock-in risk, API dependency

### Why Not Higher Score
- **Unknown costs**: Could be expensive for high-volume use
- **External dependency**: Relies on Deno Deploy uptime
- **Alternatives exist**: Docker provides similar isolation locally
- **Unclear fit**: Need to validate use cases justify SaaS dependency

### Next Steps
1. Fetch pricing information from Deno Deploy
2. Test Deno Sandbox API with sample code execution
3. Benchmark latency vs local Docker
4. Compare feature parity with OpenClaw Docker setup
5. Evaluate self-hosted alternatives (gVisor, Firecracker)
6. Create decision matrix: hosted vs local sandboxing
