# GitHub MCP Server - 2026 Updates (OAuth, Projects, Scope Filtering)

**Discovery Date**: 2026-02-06
**Source**: https://github.com/github/github-mcp-server
**Announcement**: https://github.blog/changelog/2026-01-28-github-mcp-server-new-projects-tools-oauth-scope-filtering-and-new-features/
**Category**: Version Control / Update
**Stars**: 26.7k

---

## Description

Official GitHub MCP Server received major updates in January 2026: consolidated Projects tools (50% token reduction), OAuth scope filtering, Insiders mode for experimental features, HTTP server mode with per-request OAuth, and enhanced Copilot Coding Agent tools.

---

## Key Updates (January 2026)

### 1. Consolidated Projects Toolset (50% Token Reduction)
- **Before**: Many small project-specific tools
- **After**: 3 unified tools (`projects_list`, `projects_get`, `projects_write`)
- **Token savings**: ~23,000 tokens (50% reduction)
- **Benefit**: Automatic owner-type detection, cleaner interface

### 2. OAuth Scope Filtering
- **Feature**: Automatically detects Classic Personal Access Token permissions
- **Behavior**: Hides unavailable tools based on detected scopes
- **Effect**: Prevents errors, reduces interface clutter
- **Token types**:
  - Classic PATs: Filtered by scope
  - Fine-grained tokens: Show all tools (API-level enforcement)
  - Remote OAuth: Dynamic scope handling

### 3. Insiders Mode
- **Purpose**: Opt into experimental features
- **Access methods**: Configuration headers or special URLs
- **Includes**: Experimental features, behavior changes under evaluation, unreleased functionality

### 4. HTTP Server Mode with OAuth
- **Use case**: Enterprise deployments
- **Feature**: Per-request OAuth tokens via Authorization headers
- **Fallback**: Environment variables
- **Compatibility**: Full GitHub Enterprise Server support

### 5. Copilot Coding Agent Tools
- **New tools**:
  - `get_copilot_job_status`: Track progress
  - Expanded `base_ref` parameter: Feature branches and stacked PRs
  - Custom instructions: Support for `assign_copilot_to_issue`

---

## Redundancy Check

**Existing capability**: Git MCP (rejected 20/100) - wraps git CLI with token overhead

**GitHub MCP status**: NOT in our current stack (we use Bash + gh CLI)

**Keywords**: github, version control, pull requests, issues, oauth, projects, github api

**Classification**: **IMPROVEMENT** - Better than our current Bash + gh CLI approach? Need comparison.

---

## Comparison: GitHub MCP vs Current Approach

### Current Approach (Bash + gh CLI)
| Feature | Status |
|---------|--------|
| Repository operations | `gh repo create`, `gh repo clone` |
| PR management | `gh pr create`, `gh pr merge` |
| Issue tracking | `gh issue create`, `gh issue list` |
| Project boards | `gh project` commands |
| OAuth | `gh auth login` |
| Token cost | **ZERO** (direct CLI) |

### GitHub MCP
| Feature | Status |
|---------|--------|
| Repository operations | MCP tools |
| PR management | MCP tools |
| Issue tracking | MCP tools |
| Project boards | Consolidated 3 tools (50% token savings) |
| OAuth | Built-in, per-request OAuth |
| Token cost | **2-3k tokens** (MCP overhead) + tool definitions |

### Key Differences
1. **Abstraction level**: MCP provides structured tool interface vs raw CLI
2. **OAuth handling**: MCP has per-request OAuth (enterprise-friendly)
3. **Token cost**: MCP adds context overhead vs zero-token Bash
4. **Projects**: MCP has optimized Projects tools (gh CLI less mature)
5. **Enterprise**: MCP HTTP mode for multi-user deployments

---

## Evaluation Considerations

### Strengths
- **Official GitHub**: First-party support, maintained by GitHub
- **High adoption**: 26.7k stars (ecosystem standard)
- **Token optimization**: 50% reduction for Projects tools
- **OAuth improvements**: Scope filtering prevents errors
- **Enterprise-ready**: HTTP mode for deployments
- **Copilot integration**: Enhanced coding agent tools
- **Insiders access**: Early experimental features

### Concerns
- **Token overhead**: Adds 2-3k+ tokens vs zero-token Bash + gh CLI
- **Redundancy**: We already use gh CLI effectively
- **Integration complexity**: Another MCP to manage
- **Tool Search Tool**: With Tool Search, token overhead is less critical
- **Use case fit**: Do we need structured GitHub API vs CLI?

### Questions for Evaluation
1. **Current workflow pain points**: What does gh CLI not handle well?
2. **Projects usage**: Do we use GitHub Projects? (could benefit from 50% token savings)
3. **Enterprise features**: Do we need per-request OAuth or HTTP mode?
4. **Copilot integration**: Do we use GitHub Copilot Coding Agent?
5. **Token efficiency**: With Tool Search Tool, is MCP overhead acceptable?

---

## Estimated Score Preview

| Criterion | Expected Score (0-100) | Reasoning |
|-----------|------------------------|-----------|
| Integration complexity | 85 | Simple MCP install, official support |
| Token efficiency impact | 60 | Adds overhead vs Bash BUT optimized Projects tools |
| Capability expansion | 65 | Incremental over gh CLI (Projects optimization notable) |
| Maintenance burden | 95 | Official GitHub, 26.7k stars, actively maintained |
| Community validation | 100 | 26.7k stars = ecosystem standard |
| **ESTIMATED TOTAL** | **81** | Strong if we use GitHub Projects or need enterprise features |

---

## Strategic Considerations

### When GitHub MCP Adds Value

**Scenarios where MCP wins**:
1. **GitHub Projects heavy usage**: 50% token reduction is significant
2. **Enterprise deployments**: Per-request OAuth for multi-user
3. **Copilot Coding Agent**: Enhanced integration tools
4. **Structured API needs**: Want typed tools vs CLI string parsing

**Scenarios where gh CLI wins**:
1. **Simple workflows**: Basic PR/issue management
2. **Token efficiency**: Zero overhead for simple operations
3. **Transparency**: Direct CLI commands (easier to debug)
4. **Current state**: If gh CLI works, avoid churn

### Our Current Usage Pattern

**Questions to assess**:
- Do we actively use GitHub Projects? (check `<private-project>-v2`, `claude-evolution`)
- Do we have pain points with gh CLI? (error-prone, verbose)
- Do we need enterprise OAuth features? (multi-user, per-request tokens)
- Is structured API access valuable? (vs string parsing gh CLI output)

### Tool Search Tool Impact

**Context**: We have Tool Search Tool (85% token reduction)

**Implication**: GitHub MCP's 2-3k token overhead is less critical with dynamic loading

**Decision factor**: If we need the features (Projects, OAuth), token cost is acceptable

---

## Next Steps

1. **Usage audit**: Check if we use GitHub Projects in active repos
   - `<private-project>-v2`: Project boards?
   - `claude-evolution`: Tracking in Projects?
   - `games/*`: Project management?

2. **Pain point analysis**: Where does gh CLI fall short?
   - PR workflows
   - Issue management
   - Project board automation
   - OAuth handling

3. **Token testing**: Measure actual overhead for typical operations
   - Create PR
   - List issues
   - Update project board
   - Compare to Bash + gh CLI

4. **Feature gap**: What does MCP enable that gh CLI doesn't?
   - Structured tool interface
   - Per-request OAuth
   - Insiders features
   - Copilot integration

5. **Decision**: Evaluate vs gh CLI + Bash (current approach)

---

## Related Discoveries

- Git MCP (rejected 20/100, wraps git CLI)
- GitHub Stars MCP (specialized for Stars program, 4 stars)
- GitHub Stars Contributions MCP (98 stars, Cloudflare-powered search)

**Pattern**: Official GitHub MCP is ecosystem standard (26.7k stars), specialized variants for niche use cases

---

## Decision Framework

```
IF we heavily use GitHub Projects:
    → EVALUATE (50% token savings valuable)
ELSE IF we need enterprise OAuth (multi-user):
    → EVALUATE (per-request OAuth useful)
ELSE IF gh CLI works well:
    → SKIP (avoid churn, keep zero-token approach)
ELSE IF we have gh CLI pain points:
    → EVALUATE (structured API may solve)
```

**Current lean**: **EVALUATE** (check Projects usage first)

**Comparison needed**:
- Token overhead: GitHub MCP vs Bash + gh CLI
- Feature parity: What's missing from gh CLI?
- Workflow fit: Which approach is smoother for our tasks?

---

## Update Type

This is a **VERSION UPDATE** (not new capability), documenting improvements to existing GitHub MCP:
- January 2026: Projects optimization, OAuth filtering, Insiders mode
- We don't currently use GitHub MCP (use gh CLI instead)
- Evaluation needed: Is it time to adopt GitHub MCP given improvements?

---

## Evaluation

**Evaluator**: capability-evaluator
**Date**: 2026-02-06

### Current Usage Audit
```bash
# Checked repositories:
# <private-project>-v2: No GitHub Projects usage
# claude-evolution: No GitHub Projects usage (tracking in registry files)
# games/*: No GitHub Projects usage
# Result: ZERO Projects usage across all active repos
```

### Scoring

| Criterion | Score | Reasoning |
|-----------|-------|-----------|
| Integration Complexity | 85/100 | Simple MCP install, official support |
| Token Efficiency | 50/100 | Adds 2-3k overhead; 50% Projects savings irrelevant (we don't use) |
| Capability Expansion | 40/100 | gh CLI already handles our workflows well |
| Maintenance Burden | 95/100 | Official GitHub, 26.7k stars |
| Community Validation | 100/100 | Ecosystem standard |
| **WEIGHTED TOTAL** | **66/100** | |

### Cross-Validation (Codex)
"Without Projects usage, gh CLI is superior (zero tokens). 66/100 - don't adopt without workflow pain points."

### Decision: FUTURE (66/100)

**Rationale**: Below 70 threshold, BUT official GitHub tool. Archive as FUTURE, not REJECT.

**Adoption Triggers**:
1. We start using GitHub Projects heavily
2. gh CLI pain points emerge (error-prone, verbose)
3. Enterprise OAuth needs (multi-user deployments)

**Current verdict**: gh CLI works well, zero tokens, transparent. No churn justified.

---

## Update: Dynamic Toolsets (2026-03-19)

**Score updated**: 66/100 (Feb 2026) → **73.75/100** (Mar 2026, APPROVED — deferred adoption)

**New feature**: `--dynamic-toolsets` flag (or `GITHUB_DYNAMIC_TOOLSETS=1` env var). Loads only tools needed for current operations, substantially reducing token overhead — the primary concern from the Feb 2026 evaluation.

**Adoption triggers remain unchanged** (none currently met):
| Trigger | Current Status |
|---------|---------------|
| Using GitHub Projects heavily | Not using Projects in any active repo |
| gh CLI pain points emerge | gh CLI working well |
| Enterprise OAuth needed | Not needed (solo desktop setup) |

**Registry updated**: Status changed from FUTURE (66/100) to FUTURE/APPROVED (73.75/100) with dynamic toolsets noted. Install when trigger met with `--dynamic-toolsets` flag from day one.
