# BlenderMCP - AI-Powered 3D Modeling Integration

**Discovery Date**: 2026-02-06
**Source**: https://github.com/ahujasid/blender-mcp
**Category**: Creative Tools / 3D Modeling
**Stars**: 16.9k

---

## Description

BlenderMCP connects Blender (open-source 3D creation suite) to Claude AI through the Model Context Protocol, enabling AI-assisted 3D modeling, scene creation, and manipulation using natural language.

---

## Key Features

### Core Capabilities
- **Object manipulation**: Create, modify, delete 3D objects via natural language
- **Material control**: Apply materials and colors to objects
- **Scene inspection**: Retrieve detailed scene information
- **Python execution**: Execute arbitrary Python code within Blender
- **Asset integration**: Download assets from Poly Haven
- **AI model generation**: Generate 3D models via Hyper3D Rodin API
- **Remote host support**: Connect to Blender running on different machines

### Architecture
- **Blender addon** (`addon.py`): Socket server within Blender
- **MCP Server** (`server.py`): Model Context Protocol implementation
- **Communication**: JSON-based socket communication
- **Configuration**: Claude Desktop config with uvx command

### Use Cases
- Rapid prototyping through conversational interface
- Automated scene setup and asset placement
- Material and lighting experimentation
- Educational tool for learning Blender
- Integration with AI-driven creative workflows

---

## Redundancy Check

**Keywords extracted**: 3D modeling, blender, scene creation, visual tools, creative automation, rendering

**Search against registry**: No matches found. Closest capability is Better Playwright MCP (browser automation) but that's for web, not 3D.

**Classification**: **NOVEL** - No existing 3D modeling or creative suite integration

---

## Integration Path

### Target Location
- **Type**: MCP Server
- **Location**: `~/.claude.json` mcpServers section
- **Category**: Creative Tools (new section in registry)

### Installation Steps
1. Install Blender addon: Copy addon.py to Blender addons folder
2. Install MCP server: `uvx install blender-mcp`
3. Add to `~/.claude.json`:
```json
{
  "mcpServers": {
    "blender": {
      "command": "uvx",
      "args": ["blender-mcp"]
    }
  }
}
```
4. Enable addon in Blender preferences
5. Start Blender (addon auto-starts socket server)

### Dependencies
- Blender 2.8+
- Python 3.8+
- Socket communication support
- Optional: Hyper3D Rodin API key for AI model generation

---

## Evaluation Considerations

### Strengths
- **High community validation**: 16.9k stars (very high adoption)
- **Novel capability**: First 3D modeling MCP integration
- **Active development**: 139 commits, maintained
- **Comprehensive features**: Full Blender API access
- **Creative workflow enabler**: Opens new AI-assisted 3D creation workflows

### Concerns
- **Token usage**: Full scene descriptions could be verbose
- **Learning curve**: Requires Blender knowledge for best results
- **Dependency**: Requires Blender installation (not lightweight)
- **Use case fit**: Need to assess if 3D modeling aligns with current projects

### Questions for Evaluation
1. Do we have projects that would benefit from 3D modeling integration?
2. Token overhead for typical 3D scene operations?
3. How does it compare to text-to-3D services (if we need 3D assets)?
4. Could this enable new revenue pipeline opportunities (3D game dev, product visualization)?

---

## Estimated Score Preview

| Criterion | Expected Score (0-100) | Reasoning |
|-----------|------------------------|-----------|
| Integration complexity | 70 | Requires Blender install + addon + MCP config (medium effort) |
| Token efficiency impact | 60 | Scene descriptions could be verbose; need testing |
| Capability expansion | 90 | Novel capability - opens entire 3D creation domain |
| Maintenance burden | 75 | Active project (16.9k stars), mature addon ecosystem |
| Community validation | 95 | 16.9k stars = high validation |
| **ESTIMATED TOTAL** | **78** | Strong candidate if 3D modeling use cases exist |

---

## Next Steps

1. **Evaluate use case fit**: Do we have projects needing 3D modeling?
2. **Token overhead testing**: Test typical operations to measure context usage
3. **Revenue alignment**: Could this enable game dev or product viz projects?
4. **Comparison**: Compare to alternative 3D workflows (Meshy, Luma, DALL-E 3D)

---

## Related Discoveries

- Unity MCP (game engine integration, 915 stars)
- DaVinci Resolve MCP (video editing)
- Aseprite MCP (pixel art)

**Pattern**: Creative tool MCP servers are emerging as a new category (2026 trend)

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Use Case Assessment

**Current projects**:
- **Games pipeline**: Web-based games (NOT Unity/Unreal/3D)
- **<private-project>**: Data processing (no 3D)
- **<private-project>**: SaaS web app (no 3D)
- **Revenue pipeline**: Digital products (no 3D assets)

**Conclusion**: ZERO 3D modeling use cases in active projects.

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 70/100 | Blender install + addon + MCP config |
| Token Efficiency | 60/100 | Scene descriptions potentially verbose (need testing) |
| Capability Expansion | 90/100 | Novel capability - entire 3D domain |
| Maintenance Burden | 75/100 | 16.9k stars, active development |
| Community Validation | 95/100 | 16.9k stars = very high adoption |
| **WEIGHTED TOTAL** | **78/100** | |

### Cross-Validation (Codex)
"Novel capability but no use case fit. 78/100 accurate BUT irrelevant for current stack."

### Decision: FUTURE (78/100)

**Rationale**: High score BUT zero use cases. Games pipeline focuses on web games, not 3D modeling.

**Adoption Trigger**: If we pivot to 3D game development or product visualization projects.

**Alternative**: If 3D assets needed, use text-to-3D services (Meshy, Luma) - no Blender integration overhead.
