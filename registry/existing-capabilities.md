# Existing Capabilities Registry

> **Purpose**: Check against this BEFORE researching any discovery to catch redundancy early.
> **Last Updated**: (auto-updated by integration phase)

## How to Use This Document

### Step 1: Check for Match
Search this document for the discovery's keywords and redundancy triggers.

### Step 2: Classify the Match

| Match Type | Definition | Action |
|------------|------------|--------|
| **NOVEL** | No existing capability matches | Proceed to full evaluation |
| **DUPLICATE** | Same functionality, no advantage | SKIP immediately |
| **IMPROVEMENT** | Better than existing capability | Proceed to COMPARISON evaluation |

## Registered Capabilities

Add capabilities here as they are integrated. Format:

```
### [Capability Name]
- **Type**: MCP Server | Skill | Agent | Technique
- **Integrated**: YYYY-MM-DD
- **Redundancy triggers**: keyword1, keyword2, keyword3
- **Description**: What it does
```

### Example: Web Search
- **Type**: MCP Server
- **Integrated**: 2026-01-01
- **Redundancy triggers**: web search, internet search, google search, brave search
- **Description**: Search the web for current information via Brave Search API
