# Discovery: Miro MCP Server

**Date**: 2026-02-08
**Source**: Miro announcement (Feb 6, 2026), confirmed by Exa deep research
**Category**: MCP Server - Visual Collaboration
**URL**: https://solutionsreview.com/artificial-intelligence-news-for-the-week-of-february-6-updates-from-openai-cerebras-systems-opsera-more

## Summary

Miro launched an MCP server that converts collaborative visual canvases into first-class context for AI coding tools (Claude Code, GitHub Copilot, Gemini CLI). Enables bidirectional integration: feed architecture diagrams to agents for context-aware generation, push code-driven diagrams back to Miro.

## Key Features

1. **Visual Context Injection**: Feed Miro boards (architecture diagrams, design specs) into coding agents
2. **Bidirectional Sync**: Push generated diagrams/documentation back to Miro from code
3. **Multi-Tool Support**: Works with Claude Code, GitHub Copilot, Gemini CLI
4. **Architecture Alignment**: Maintains consistency between planning and implementation

## Potential Value

- **Novel**: First major visual collaboration tool with native MCP integration
- **Official**: Built in collaboration with Anthropic
- **High Adoption**: Miro has millions of users in enterprise teams
- **Workflow Enhancement**: Solves "architecture drift" problem (docs vs. code divergence)

## Integration Path

### Option 1: MCP Server Installation
```bash
# Add to ~/.claude.json
{
  "mcpServers": {
    "miro": {
      "command": "npx",
      "args": ["-y", "@miro/mcp-server"],
      "env": {
        "MIRO_API_TOKEN": "..."
      }
    }
  }
}
```

### Option 2: Skills/Workflows
- Create "architecture-first development" skill
- Document diagram → code → diagram workflow
- Integration with plan mode (visual planning)

### Option 3: Cross-Modal Patterns
- Extract learnings about visual + textual reasoning
- Apply to other diagram tools (Lucidchart, draw.io, Excalidraw)

## Questions for Evaluation

1. Is the MCP server publicly available? (Announcement mentions launch, need confirmation)
2. What authentication is required? (Miro API token, OAuth?)
3. Does it work with free Miro accounts or enterprise only?
4. Can we export Miro boards without MCP? (Fallback for non-MCP users)

## Estimated Score (Pre-Evaluation)

**75/100**
- Integration complexity: Easy (18/20) - Standard MCP installation, requires API token
- Token efficiency: Positive (18/25) - Visual context more compact than text descriptions
- Capability expansion: High (20/25) - Novel cross-modal reasoning, architecture alignment
- Maintenance: Low (13/15) - External MCP, Miro maintains
- Community validation: High (13/15) - Official collab with Anthropic, Miro brand

## Redundancy Check

**NOVEL** - No existing visual collaboration MCP in registry. Closest match: Excalidraw tool (not MCP), diagram generation libraries (not ingestion).

**Comparison to existing:**
- Excalidraw: Diagram generation only, not ingestion
- Lucidchart: No MCP integration
- Playwright: Browser automation, not diagram-native

## Use Cases

1. **Architecture-First Development**: Design in Miro, implement with Claude Code, sync diagrams
2. **Documentation Generation**: Generate Miro boards from codebase structure
3. **Design-Code Loop**: Iterate between visual design and implementation with alignment
4. **Team Collaboration**: Shared visual context across team members and AI agents

## Next Steps

1. Verify MCP server availability and installation process
2. Test with free Miro account (or request trial)
3. Document visual context injection patterns
4. Create evaluation report with scoring
5. If approved, add to registry and create architecture-first skill
