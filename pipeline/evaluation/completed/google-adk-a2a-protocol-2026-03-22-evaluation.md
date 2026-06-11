# Google Agent Development Kit (ADK) + A2A Protocol — Cross-Framework Agent Interop

- **Source**: https://github.com/google/adk-python
- **Secondary sources**: https://developers.google.com/agent-development-kit
- **Type**: technique
- **Discovered**: 2026-03-22
- **Keywords**: google-ADK, A2A-protocol, agent-to-agent, cross-framework-agents, agent-interop, agent-communication-protocol

## Description

Google's Agent Development Kit (ADK) is a hierarchical agent framework with native A2A (Agent-to-Agent) protocol support. The A2A protocol enables cross-framework agent communication — Claude Code agents could interoperate with non-Claude agents (GPT agents, Gemini agents, open-source agents) via standardized A2A message passing.

Key differentiator over current multi-model approach: current Codex/Gemini MCPs work via model API calls (one model calling another's API); A2A works at the agent-behavior level (agents communicating as peers, not as callee APIs).

Community validation: 18k GitHub stars, official Google product.

## Redundancy Check

**Status**: NOVEL — Registry has Agent Teams (experimental, Claude-only), Task tool orchestration (Claude subagents), Codex/Gemini MCP (model API calls). None address cross-framework agent communication via A2A protocol standard.

**Hallucination risk**: LOW — Google ADK (google/adk-python) is a real publicly available project. A2A protocol is real.

---

## Evaluation

**Evaluated**: 2026-03-22
**Decision**: NEEDS_RESEARCH (64.75/100)

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 65 | A2A protocol monitoring requires no installation. ADK framework itself would be high complexity. Scoring the protocol-as-monitor path. |
| Token efficiency impact | 25% | 50 | No direct token efficiency impact currently. Future A2A integration could enable more efficient cross-framework coordination. Neutral for now. |
| Capability expansion | 25% | 55 | Cross-framework agent interoperability is genuinely novel. Currently no action possible for Claude Code, but knowing the protocol is valuable for when Claude Code adds A2A support (likely). |
| Maintenance burden | 15% | 80 | Monitoring a protocol standard is low burden. No code to maintain. |
| Community validation | 15% | 90 | Official Google product (18k GitHub stars). High credibility. A2A protocol gaining industry adoption. |

**Weighted Score**: (65×0.20) + (50×0.25) + (55×0.25) + (80×0.15) + (90×0.15)
= 13 + 12.5 + 13.75 + 12 + 13.5 = **64.75/100**

**Decision Rationale**: Strong community validation (Google, 18k stars) and genuine novelty (A2A is not covered in registry), but currently no actionable integration path for Claude Code. The ADK framework itself would score much lower (high integration complexity). Evaluating A2A protocol as a "monitor and track" item — if Claude Code adds A2A support, this becomes immediately actionable. Score sits just below 70 because capability expansion is limited to future potential, not current capability.

**Research Questions**:
1. Is there a working example of Claude Code + A2A integration anywhere in the community?
2. What's the current A2A specification version and broader industry adoption rate (beyond Google)?
3. Has Anthropic made any public statements about A2A protocol support in Claude Code?
4. Are any existing MCP servers implementing A2A as a transport layer?
5. What would an A2A-enabled Claude Code agent actually look like in practice — peer routing, task delegation, or response aggregation?

**Re-evaluation trigger**: When Claude Code announces A2A protocol support, or when a working Claude Code + A2A integration example is published. At that point, integration complexity drops significantly and the score likely crosses 70.
