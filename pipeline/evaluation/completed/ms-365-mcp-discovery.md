# MS-365 MCP Server - Microsoft 365 Integration

**Discovery Date**: 2026-02-06
**Source**: https://github.com/Softeria/ms-365-mcp-server
**Category**: Productivity / Enterprise Integration
**Stars**: 446

---

## Description

MCP server enabling AI assistants to interact with Microsoft 365 and Office services via the Graph API. Provides programmatic access to Outlook, Calendar, OneDrive, Excel, OneNote, To Do, Teams, SharePoint, and more.

---

## Key Features

### Personal Account Capabilities
- **Email**: Outlook message operations (read, send, search, organize)
- **Calendar**: Event handling and scheduling
- **OneDrive**: File operations and document management
- **Excel**: Spreadsheet manipulation
- **OneNote**: Notebook access
- **Tasks**: To Do and Planner integration
- **Contacts**: Contact management
- **Profile**: User profile access
- **Search**: Unified search across M365

### Work/School Account Features (--org-mode)
- **Teams**: Chat messaging and collaboration
- **SharePoint**: Site access and content management
- **Shared mailboxes**: Shared inbox operations
- **User directory**: Organization user management

### Technical Highlights
- **Authentication**: Device code flow (default), OAuth authorization code flow, bring-your-own-token
- **Cloud support**: Global (login.microsoftonline.com) and China 21Vianet
- **Output formats**: JSON (standard), TOON (experimental, claims 30-60% token reduction vs JSON)
- **Comprehensive**: Microsoft Graph API coverage

---

## Redundancy Check

**Keywords extracted**: microsoft 365, office, outlook, onedrive, teams, sharepoint, graph api, email automation, calendar, enterprise integration

**Search against registry**: No matches found. We have:
- Rube MCP (500+ apps including Gmail, Slack) but NOT Microsoft 365
- No existing email/calendar/document MCP

**Classification**: **NOVEL** - No existing Microsoft 365 integration

---

## Integration Path

### Target Location
- **Type**: MCP Server
- **Location**: `~/.claude.json` mcpServers section
- **Category**: Productivity / Enterprise Integration (new section in registry)

### Installation Steps
1. Install: `npm install -g @softeria/ms-365-mcp-server`
2. Authenticate: Run server, follow device code flow prompts
3. Add to `~/.claude.json`:
```json
{
  "mcpServers": {
    "ms365": {
      "command": "ms-365-mcp-server",
      "args": ["--output-format", "json"]
    }
  }
}
```
4. For work accounts: Add `--org-mode` flag
5. Restart Claude Code to load MCP

### Dependencies
- Node.js 18+
- Microsoft account (personal or work/school)
- Internet connection for Graph API
- Optional: Azure AD app registration for custom OAuth

---

## Evaluation Considerations

### Strengths
- **Comprehensive M365 coverage**: Email, calendar, files, tasks, Teams, SharePoint
- **Official API**: Uses Microsoft Graph API (stable, documented)
- **Dual account support**: Personal and work/school accounts
- **Token optimization**: TOON format claims 30-60% reduction (experimental)
- **Active development**: 222 commits, 446 stars, 147 forks
- **Strategic value**: Enterprise integration unlocks business automation

### Concerns
- **Use case fit**: Do we have workflows requiring M365 automation?
- **Token overhead**: Graph API responses can be verbose (mitigated by TOON format?)
- **Authentication complexity**: Device code flow requires manual steps
- **Rube overlap**: Rube MCP already covers 500+ apps - does M365 overlap?
- **Maintenance**: Microsoft Graph API changes require updates

### Questions for Evaluation
1. **Immediate need**: Do we actively use M365 for business operations?
2. **Rube comparison**: Does Rube MCP already cover M365? (Need to check)
3. **Token efficiency**: How much overhead for typical operations? (Test TOON format)
4. **Revenue fit**: Could M365 integration enable revenue pipeline automation?
5. **Alternative**: Could we use Rube MCP instead? (Unified vs specialized)

---

## Estimated Score Preview

| Criterion | Expected Score (0-100) | Reasoning |
|-----------|------------------------|-----------|
| Integration complexity | 75 | npm install + auth flow (straightforward) |
| Token efficiency impact | 65 | TOON format claims 30-60% reduction; needs validation |
| Capability expansion | 80 | Novel M365 access BUT check Rube overlap first |
| Maintenance burden | 75 | Active project, Microsoft Graph is stable |
| Community validation | 70 | 446 stars = moderate validation |
| **ESTIMATED TOTAL** | **73** | Strong IF we use M365 AND Rube doesn't cover it |

---

## Strategic Considerations

### Rube MCP Overlap Analysis

**CRITICAL QUESTION**: Does Rube MCP (500+ apps) already include Microsoft 365?

**Rube capabilities** (from registry):
- Gmail, Slack, GitHub, Notion (listed)
- "500+ apps" - likely includes M365

**Decision framework**:
```
IF Rube MCP includes M365:
    → SKIP (use Rube - unified integration)
ELSE IF M365 critical but not in Rube:
    → EVALUATE (specialized integration may be better)
```

### Use Case Assessment

**Questions to answer**:
1. Do we use M365 for:
   - Email campaigns? (<private-project> customer comms?)
   - Document collaboration? (<private-project> documentation?)
   - Task management? (Evolution pipeline tracking?)
   - Calendar scheduling? (Client meetings?)

2. Could M365 automation enable:
   - Automated email responses?
   - Document generation pipelines?
   - Meeting scheduling for sales?
   - Project tracking integration?

### Token Efficiency Deep Dive

**TOON format** (experimental):
- Claims 30-60% token reduction vs JSON
- Status: Experimental (stability unknown)
- Comparison needed: TOON vs JSON for typical operations

**Baseline**: Graph API responses are verbose (rich metadata)

---

## Next Steps

1. **Rube overlap check**: Does Rube MCP cover M365? (BLOCKER)
   - If YES → SKIP this MCP, use Rube
   - If NO → Continue evaluation

2. **Use case validation**: Do we actively use M365 in workflows?
   - Review current business operations
   - Identify automation opportunities

3. **Token testing**: Test TOON format vs JSON
   - Measure actual token reduction
   - Assess stability and compatibility

4. **Comparison matrix**: MS-365 MCP vs Rube MCP vs manual workflows
   - Feature parity
   - Token efficiency
   - Integration complexity

5. **Revenue alignment**: Could M365 automation accelerate revenue pipeline?

---

## Related Discoveries

- Rube MCP (500+ apps, existing integration)
- WorkIQ Copilot (Microsoft 365 Copilot data, mentioned in search results)
- Notion MCP (if standalone exists)

**Pattern**: Productivity suite MCP integrations are emerging (Notion, Slack, M365)

---

## Decision Framework

```
IF Rube MCP includes M365:
    → SKIP (avoid redundancy, use unified Rube)
ELSE IF we actively use M365 + automation opportunities exist:
    → EVALUATE (likely 73+)
ELSE IF we don't use M365:
    → SKIP (no immediate value)
ELSE IF future M365 adoption planned:
    → FUTURE (valuable but premature)
```

**BLOCKER**: Must check Rube MCP capabilities first

---

## Evaluation

**Date**: 2026-02-06
**Context**: We have Rube MCP (500+ apps). Need to assess overlap and actual M365 usage.

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 75/100 | 20% | 15.0 | npm install + OAuth (straightforward) |
| Token Efficiency | 65/100 | 25% | 16.25 | TOON format claims savings but experimental |
| Capability Expansion | 40/100 | 25% | 10.0 | **CRITICAL**: Don't use M365 heavily per context |
| Maintenance Burden | 75/100 | 15% | 11.25 | Active project, Graph API stable |
| Community Validation | 70/100 | 15% | 10.5 | 446 stars = moderate |
| **TOTAL** | | | **63.0** | **FUTURE** |

### Decision: FUTURE

**Reason**: Limited M365 usage in current workflows. Rube MCP may already cover some M365 apps. Valuable IF we adopt M365 for business operations.

**Adoption trigger**: If M365 becomes central to <private-project> or revenue pipeline (email campaigns, document automation).
