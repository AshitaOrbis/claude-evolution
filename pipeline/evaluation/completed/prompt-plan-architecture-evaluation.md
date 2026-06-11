# Evaluation: Prompt Plan Architecture

- **Date**: 2026-02-06
- **Category**: Technique
- **Source**: https://developersvoice.com/blog/ai/claude_code_2026_end_to_end_sdlc/
- **License**: N/A (technique/methodology)

## Redundancy Check

**Classification**: DUPLICATE (with minor novel elements)

Checked against registry:
- **CLAUDE.md**: BUILT-IN -- already serves as "authoritative guidance" (component 1)
- **.claude/ folder**: Already in use -- `~/.claude/skills/`, `~/.claude/agents/`, `~/.claude/commands/`
- **MCP servers for context**: IMPLEMENTED -- multiple MCPs providing read-only context
- **Plan Mode**: BUILT-IN -- structured planning with user approval
- **@imports**: IMPLEMENTED -- progressive disclosure for detailed docs

The "three-component project brain" is exactly what we already have:
1. CLAUDE.md = their "CLAUDE.md (authoritative guidance)" -- identical
2. .claude/ folder = their ".claude/ folder (persistent context)" -- identical
3. MCP servers = their "MCP servers (read-only external context)" -- identical

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 80/100 | Easy -- mostly documentation/template work |
| Token Efficiency Impact | 50/100 | Neutral -- no change to token usage |
| Capability Expansion | 30/100 | Near-duplicate. Only truly novel element is "ADR template" formalization |
| Maintenance Burden | 70/100 | Low if adopted as templates |
| Community Validation | 20/100 | Single blog post, no repo, no stars |

**WEIGHTED TOTAL**: (80 * 0.20) + (50 * 0.25) + (30 * 0.25) + (70 * 0.15) + (20 * 0.15) = 16.0 + 12.5 + 7.5 + 10.5 + 3.0 = **49.5/100**

## Cross-Validation

- **Claude Assessment**: 49.5/100
- **Codex Assessment**: N/A (MCP unavailable)
- **Variance**: N/A

## Analysis

The discovery describes a "Project Brain" architecture that is almost exactly what we already have:

| Their Component | Our Equivalent | Status |
|----------------|----------------|--------|
| CLAUDE.md (rules) | CLAUDE.md (project instructions) | Identical |
| .claude/ folder | ~/.claude/skills/, agents/, commands/ | Identical |
| MCP servers | brave-search, exa, codex, etc. | Identical |
| "Prompt Plans" | Plan Mode + CLAUDE.md conventions | 90% overlap |
| ADR templates | Not formalized | Minor gap |

The only genuinely novel element is the formalization of Architecture Decision Records (ADRs) as a pattern within the .claude/ folder. This is a minor documentation addition, not an architectural change.

The discovery's own "Recommended" path (Option 4) correctly identifies: "Document that CLAUDE.md + @imports already achieves this." This confirms the redundancy assessment.

## Recommendation

**DECISION**: REJECT (49.5 < 50)

**Rationale**: 90%+ functional overlap with existing CLAUDE.md + .claude/ folder + MCP architecture. The "Prompt Plan" concept is a rename of Plan Mode + CLAUDE.md conventions. Only novel element (ADR templates) is too minor to justify integration as a standalone discovery.

**Salvageable**: If we ever do a documentation audit, adding an ADR template to helpers/templates/ would be a low-cost improvement.
