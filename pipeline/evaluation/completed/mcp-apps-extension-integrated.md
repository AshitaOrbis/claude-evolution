## Discovery: MCP Apps Extension

**Source**: https://blog.modelcontextprotocol.io/posts/2026-01-26-mcp-apps/
**Category**: MCP Extension
**Stars/Validation**: Official Anthropic (MCP Core Maintainers), Claude/ChatGPT/VSCode support, Production-ready

### Summary
MCP Apps is the first official MCP extension, announced January 26, 2026. It allows tools to return interactive UI components (dashboards, forms, visualizations, workflows) that render directly in conversations via sandboxed iframes with bidirectional JSON-RPC communication.

### Potential Value
- **Token impact**: Neutral to positive - replaces text descriptions with interactive UIs
- **Capability**: Novel - enables visual data exploration, configuration wizards, document review, monitoring
- **Integration effort**: Medium - requires MCP server updates to add UI resources

### Technical Details

**Architecture**:
- Tools include `_meta.ui.resourceUri` field pointing to UI resources
- Server-side resources served via `ui://` scheme containing bundled HTML/JavaScript
- Host fetches resources, renders in sandboxed iframes
- Bidirectional JSON-RPC over `postMessage`

**Developer API** (`@modelcontextprotocol/ext-apps`):
- `App` class for receiving tool results
- Calling server tools from UI
- Updating model context with user interactions
- Framework-agnostic `postMessage` communication

**Security Model**:
- Iframe sandboxing with restricted permissions
- Pre-declared templates reviewable before rendering
- Auditable JSON-RPC messaging
- Optional user consent for tool calls from UI

**Client Support**:
- Claude (web and desktop) ✅
- ChatGPT ✅
- VSCode Insiders ✅
- Goose ✅

**Example Use Cases**:
- Interactive dashboards with filtering/drill-down
- Configuration wizards with dependent fields
- Inline PDF viewing with highlighted sections
- Real-time monitoring with live-updating metrics

### Quick Assessment Score

- **Integration complexity**: 60/100 (requires MCP server updates, new UI templates)
- **Token efficiency impact**: 70/100 (replaces verbose text with visual UIs, but adds iframe overhead)
- **Capability expansion**: 90/100 (completely novel - enables rich UIs in conversations)
- **Maintenance burden**: 70/100 (official extension, but requires maintaining UI templates)
- **Community validation**: 100/100 (official Anthropic, supported by major clients)

**TOTAL**: **78/100** (Weighted average)

### Recommended Action
[X] Evaluate further
[ ] Reject (reason: ...)
[ ] Fast-track integration

### Integration Considerations

**When to Use**:
- Evolution dashboard (current pipeline status, discovery metrics)
- MCP server configuration wizards (complex OAuth setups)
- Live monitoring of discovery/evaluation runs
- Interactive registry browsing

**When NOT to Use**:
- Simple text-based interactions (keep using regular tools)
- Non-visual workflows (no benefit over text)
- Environments without UI rendering (headless scripts)

**Research Needed**:
1. How to create UI templates for MCP servers
2. Example implementation for dashboard use case
3. Security implications of iframe rendering
4. Performance impact on token efficiency

**Blockers**:
- None identified (production-ready, Claude Code support confirmed)

### Notes
- This is the **first official MCP extension** (beta period ended, production-ready)
- Built on amazing work of MCP-UI and OpenAI Apps SDK
- Claude Code v2.1.33+ likely already supports this (client support confirmed)
- Example servers available: 3D visualization, maps, PDFs, dashboards, music notation

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: capability-evaluator

### Redundancy Check

**Registry Match**: NO existing UI rendering capability. All current tools are text/code-based.

**Classification**: **NOVEL** - First official MCP extension enabling interactive UIs in conversations.

### Use Case Analysis

**High-value scenarios**:
1. **Evolution dashboard**: Pipeline status, discovery metrics, evaluation scores (live updates)
2. **MCP configuration wizards**: OAuth setup, complex server config
3. **Interactive registry browser**: Search/filter capabilities, dependency graphs
4. **Live monitoring**: Discovery/evaluation runs with progress bars
5. **Data visualization**: Query results from DuckDB, GitHub API data

**Medium-value scenarios**:
- The statement parser: Interactive transaction table with filters
- The finance app: Scenario comparison with sliders

**Low-value scenarios**:
- Simple text workflows (no benefit over text)
- Headless automation (Discord bots, cron jobs)

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 60/100 | 20% | 12.0 | Requires MCP server updates + UI template creation |
| Token efficiency impact | 75/100 | 25% | 18.75 | Replaces verbose text with interactive UIs, offset by iframe overhead |
| Capability expansion | 90/100 | 25% | 22.5 | Completely novel - rich UIs in conversations |
| Maintenance burden | 80/100 | 15% | 12.0 | Official extension, but requires UI template maintenance |
| Community validation | 100/100 | 15% | 15.0 | Official Anthropic, Claude/ChatGPT/VSCode support |

**TOTAL**: **80.25/100** ✅ **APPROVED**

### Decision: APPROVE → Move to pipeline/integration/

**Rationale**: Strong score (80.25). Official Anthropic extension, production-ready, high value for evolution pipeline (dashboard), MCP config (wizards), and data visualization.

**Integration Path**:
1. **Phase 1 - Learn**: Study example servers (3D viz, maps, PDFs, dashboards)
2. **Phase 2 - Prototype**: Create evolution dashboard UI resource
   - Pipeline status (discovery/evaluation/integration counts)
   - Recent discoveries table with scores
   - Live progress updates during runs
3. **Phase 3 - Deploy**: Update evolution-orchestrator to return dashboard UI
4. **Phase 4 - Expand**: Add MCP config wizard, interactive registry browser
5. **Phase 5 - Document**: Create skill guide in `~/.claude/skills/mcp-apps-extension/SKILL.md`

**Conditions**:
- Test in Claude Code (verify v2.1.33+ support confirmed)
- Security audit: Review iframe sandboxing, JSON-RPC surface area
- Performance test: Measure token overhead vs text-based alternative
- Start simple: Dashboard first, wizards later

**Initial Focus**: Evolution pipeline dashboard (highest immediate value).
