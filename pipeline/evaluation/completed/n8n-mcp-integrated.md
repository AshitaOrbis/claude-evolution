# Discovery: n8n-mcp (n8n Workflow Automation MCP)

**Source**: https://github.com/czlonkowski/n8n-mcp
**Category**: MCP
**Stars/Validation**: 13k stars, 2.4k forks, 65k+ YouTube views on tutorial, active development

## Summary

MCP server that gives Claude Desktop, Claude Code, Cursor, and Windsurf complete, up-to-date knowledge of all 525+ n8n nodes. Enables AI to build n8n workflows with zero errors on first try. Reduces workflow creation from 45 minutes → 3 minutes according to author's testing. Includes real-time n8n documentation, node property validation, and direct workflow generation.

## Potential Value

- **Token impact**: Negative - Loads 525+ node definitions into context (estimate: 5-10k tokens)
- **Capability**: Novel - AI-assisted workflow automation without leaving IDE
- **Integration effort**: Easy - Standard MCP installation, requires n8n instance + API key

## Key Features

1. **Real-time Documentation**: Always current with n8n's node library
2. **Zero Configuration Errors**: Validates node names and properties before generation
3. **Direct API Integration**: Creates workflows via n8n REST API
4. **Multi-IDE Support**: Works in Claude Desktop, Claude Code, Cursor, Windsurf
5. **Example Library**: Includes working examples for common patterns

## Use Cases

- **Workflow Prototyping**: Describe workflow in natural language, get JSON output
- **Integration Tasks**: "Create Slack alert when Stripe payment received"
- **Data Pipelines**: "Parse CSV, transform data, write to Airtable"
- **API Orchestration**: "Poll GitHub API hourly, post changes to Discord"

## Integration Status in Claude Code

Already compatible - MCP server can be installed via:
```bash
claude mcp add --transport stdio n8n-mcp
```

Then configure with:
```json
{
  "mcpServers": {
    "n8n": {
      "command": "npx",
      "args": ["-y", "n8n-mcp"],
      "env": {
        "N8N_URL": "https://your-n8n-instance.com",
        "N8N_API_KEY": "your-api-key"
      }
    }
  }
}
```

## Redundancy Check

### Existing Capabilities

From registry:
- ✅ **Rube MCP**: 500+ app integrations (includes n8n as one option)
- ✅ **Bash tool**: Can call n8n CLI or API directly
- ✅ **WebFetch**: Can read n8n documentation

### Is This DUPLICATE or IMPROVEMENT?

**IMPROVEMENT over Bash/WebFetch approach**:
- **Automatic**: No manual doc lookup needed
- **Validated**: Node properties are schema-validated
- **Context-aware**: All 525 nodes documented in MCP format
- **Time savings**: 45 min → 3 min per author's testing

**COMPLEMENTARY to Rube MCP**:
- Rube: Broad app coverage (500+ apps), high-level automation
- n8n-mcp: Deep n8n expertise, workflow-level control, local n8n instance

## Token Efficiency Analysis

### Token Cost Estimate

- 525 n8n nodes × ~10 tokens/node (name + brief desc) = **5,250 tokens**
- Full property schemas × ~20 tokens/node = **10,500 tokens**
- **Total MCP overhead**: ~10-15k tokens (if all loaded)

With Tool Search Tool (Claude Code 2.1.7+):
- Only loads relevant nodes on-demand
- Estimated active context: ~500-1000 tokens per query

### Comparison: n8n-mcp vs Manual Approach

| Approach | Tokens | Time | Errors |
|----------|--------|------|--------|
| Manual Bash + WebFetch | ~500 tokens (minimal) | 45 min (author's data) | 6 errors avg |
| n8n-mcp + Tool Search | ~500-1000 tokens (filtered) | 3 min (author's data) | 0 errors |
| n8n-mcp (no Tool Search) | ~10-15k tokens (all nodes) | 3 min | 0 errors |

**Verdict**: With Tool Search Tool, n8n-mcp is token-efficient AND time-efficient.

## Quick Assessment Score

- **Integration complexity**: 90/100 (standard MCP install, requires n8n setup)
- **Token efficiency impact**: 70/100 (10-15k without Tool Search, <1k with Tool Search)
- **Capability expansion**: 80/100 (novel AI-assisted workflow automation)
- **Maintenance burden**: 85/100 (community-maintained, active development, n8n API stable)
- **Community validation**: 95/100 (13k stars, 65k YouTube views, community tutorials)
- **TOTAL**: **84/100**

## Recommended Action

[X] Evaluate further - High score but needs validation:
  - **Prerequisite**: Requires n8n instance (self-hosted or cloud)
  - **Use case validation**: Is workflow automation a core Claude Code use case?
  - **Alternative**: Rube MCP already provides broad automation coverage
  - **Token overhead**: Acceptable with Tool Search Tool, but still significant

## Research Questions

1. **Adoption**: How many Claude Code users run n8n instances?
2. **Overlap**: Does Rube MCP (500+ apps) make n8n-mcp redundant?
3. **Workflow Frequency**: How often do users need to create automation workflows?
4. **Deployment**: Self-hosted n8n vs n8n cloud - which is more common?

## Integration Blocker Classification

**Type A: Verification Required**
- Verify: Does Tool Search Tool work effectively with 525-node catalog?
- Verify: Rube MCP vs n8n-mcp feature overlap (both support n8n)
- Verify: User demand for workflow automation in coding workflows

## Pros

✅ Solves real problem: Workflow creation errors
✅ Massive time savings: 45 min → 3 min
✅ High community validation: 13k stars, tutorials
✅ Active development: Recent commits
✅ Multi-IDE support: Works beyond Claude Code
✅ Tool Search compatible: Token overhead manageable

## Cons

❌ Requires n8n instance: Not zero-setup
❌ Token overhead: 10-15k tokens (mitigated by Tool Search)
❌ Niche use case: Not all users need workflow automation
❌ Overlap: Rube MCP may provide sufficient n8n support
❌ Maintenance: Dependent on n8n API stability

## Decision Factors

**Approve if:**
- User research shows demand for workflow automation in coding sessions
- Rube MCP's n8n support is insufficient (lacks node documentation)
- Tool Search Tool effectively filters 525-node catalog

**Reject if:**
- Rube MCP adequately covers n8n use cases
- User demand for workflow automation is low
- Token overhead unacceptable even with Tool Search

## Notes

- Author's dramatic time savings (45 min → 3 min) suggest real pain point
- High community engagement (13k stars, tutorials) validates utility
- n8n is popular in automation/data engineering workflows
- Could enable "code + automate" workflows (write code → deploy via n8n)
- Example use case: "Write Lambda function, create n8n workflow to trigger it on Stripe events"

---

**Evaluation Date**: 2026-02-06
**Evaluator**: capability-discoverer
**Discovery Loop**: #15

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6 (capability-evaluator)

### Redundancy Analysis

**Registry check**: Rube MCP provides 500+ app integrations including n8n. **Classification: IMPROVEMENT** - n8n-mcp provides deep n8n expertise vs Rube's broad coverage.

**Key distinction**:
- **Rube MCP**: Broad (500+ apps), high-level automation, SaaS
- **n8n-mcp**: Deep n8n expertise, 525-node catalog, requires n8n instance

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 80/100 | 20% | 16.0 | Standard MCP install, but REQUIRES n8n instance + API key (self-hosted or cloud) |
| Token Efficiency Impact | 65/100 | 25% | 16.25 | 10-15k tokens without Tool Search, ~500-1k with Tool Search; dramatic time savings (45min → 3min) offset token cost |
| Capability Expansion | 70/100 | 25% | 17.5 | Deep n8n expertise is novel, but NARROW use case (workflow automation); overlaps with Rube MCP |
| Maintenance Burden | 85/100 | 15% | 12.75 | Community-maintained, active development, n8n API is stable |
| Community Validation | 95/100 | 15% | 14.25 | 13k stars, 65k YouTube views, extensive tutorials, proven utility |
| **TOTAL** | | | **76.75/100** | **APPROVE** |

### Cross-Validation (Codex)

Used codex-researcher to cross-validate:

**Codex assessment**: 73/100 - "Strong community validation and dramatic time savings justify integration, but prerequisite of n8n instance limits audience. Token overhead is concern, but Tool Search Tool mitigates effectively. Rube MCP overlap exists but n8n-mcp provides deeper expertise."

**Variance**: 3.75 points (excellent consensus)

### Decision: **APPROVE** (Score: 76.75/100)

**Rationale**: Above 70+ threshold due to:
1. **Dramatic time savings**: 45 min → 3 min per author's testing (15x improvement)
2. **High community validation**: 13k stars, tutorials, proven utility
3. **Deep expertise**: 525-node catalog with schema validation vs Rube's generic integration
4. **Token efficiency**: Acceptable with Tool Search Tool (~500-1k tokens vs 10-15k without)

### Conditions

1. **Document prerequisite**: Requires n8n instance (self-hosted or cloud)
2. **Rube MCP comparison**: Document when to use Rube (broad automation) vs n8n-mcp (workflow engineering)
3. **Use case validation**: Best for users who actively work with n8n workflows
4. **Tool Search requirement**: Only install if Claude Code 2.1.7+ (Tool Search Tool required)

### Integration Path

1. **Verify n8n instance available**: Check if user has n8n setup
2. **Install MCP**: `claude mcp add --transport stdio n8n-mcp`
3. **Configure**:
   ```json
   {
     "mcpServers": {
       "n8n": {
         "command": "npx",
         "args": ["-y", "n8n-mcp"],
         "env": {
           "N8N_URL": "https://your-n8n-instance.com",
           "N8N_API_KEY": "your-api-key"
         }
       }
     }
   }
   ```
4. **Create skill file**: `~/.claude/skills/n8n-workflow-automation/SKILL.md`
   - When to use n8n-mcp vs Rube MCP
   - Common workflow patterns (Slack alerts, data pipelines, API orchestration)
   - Best practices for node selection and validation
   - Example workflows from library
5. **Defer loading**: Add `"defer_loading": true` if not using n8n regularly (optional)
6. **Update registry**: Add to existing-capabilities.md under "Workflow Automation" section

### Comparison: n8n-mcp vs Rube MCP

| Feature | Rube MCP | n8n-mcp |
|---------|----------|---------|
| Coverage | 500+ apps | n8n only (525 nodes) |
| Depth | Generic integration | Deep n8n expertise |
| Setup | SaaS, OAuth 2.1 | Requires n8n instance |
| Token cost | Lower (per-app tools) | Higher (525-node catalog) |
| Use case | Broad automation | Workflow engineering |
| Validation | API translation | Schema validation |

**Recommendation**: Use BOTH
- Rube MCP for quick integrations ("post to Slack when X happens")
- n8n-mcp for complex workflows ("build multi-step data pipeline")

### Notes

The 45 min → 3 min time savings is compelling evidence of value. While Rube MCP provides n8n integration, n8n-mcp's deep expertise (525 nodes with schema validation) justifies the additional tool for users who actively work with n8n workflows. The prerequisite of an n8n instance limits the audience, but for those users, the value is substantial.
