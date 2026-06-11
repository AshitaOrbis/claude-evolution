# Evaluation: MCP Apps - Interactive UI Extension

- **Date**: 2026-02-06
- **Source**: https://the-decoder.com/mcp-apps-the-model-context-protocols-first-official-extension-turns-ai-responses-into-interactive-interfaces/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 40 | Requires host support - unclear if Claude Code 2.1.33+ supports MCP Apps rendering |
| Token efficiency impact | 25% | 50 | Neutral - depends on implementation, may reduce need for verbose text descriptions |
| Capability expansion | 25% | 90 | Novel - enables interactive UI components in MCP responses (charts, forms, previews) |
| Maintenance burden | 15% | 80 | Official MCP extension by Core Maintainers, well-maintained standard |
| Community validation | 15% | 95 | Official extension by MCP Core Maintainers, announced late Jan 2026 |

- **Claude Score**: 63.75/100
- **Codex Score**: N/A (service unavailable during evaluation)
- **Final Score**: 63.75/100

## Decision

**FUTURE** (was NEEDS_RESEARCH, now resolved) — Terminal-based CLI cannot render interactive UI components. Moved to `pipeline/future/` pending Claude Code announcing MCP Apps support for CLI or migration to VSCode.

## Integration Notes

### Critical Research Question
**Does Claude Code 2.1.33+ support MCP Apps rendering?**

If NO → Move to `pipeline/future/` and track for when support lands
If YES → Re-evaluate with focus on which MCP servers use MCP Apps

### Potential Value (if host supported)
- Better data visualization from Exa/Brave search results
- Interactive forms for complex tool inputs
- Rich previews of API responses
- Cross-client compatibility (standard extension)

### Use Cases
- Dynamic charts in research agents
- Interactive Slack/Figma/Asana interfaces
- Rich data visualizations embedded in responses

### Technical Foundation
- Built on MCP-UI and OpenAI-Apps SDK
- Official standard by MCP Core Maintainers
- Works across multiple MCP clients without client-specific code

### Next Steps if Supported
1. Identify which existing MCP servers support MCP Apps
2. Test rendering in Claude Code
3. Evaluate impact on token efficiency and UX
4. Update registry and move to integration phase

### Future Reconsideration Triggers
- Claude Code release notes announce MCP Apps support
- Community reports of MCP Apps working in Claude Code
- Anthropic blog post on MCP Apps integration
