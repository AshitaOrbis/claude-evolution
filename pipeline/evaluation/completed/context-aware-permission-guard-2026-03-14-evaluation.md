# Evaluation: Context-Aware Permission Guard for Claude Code

**Source**: https://news.ycombinator.com/item?id=47343927
**Type**: technique
**Discovered**: 2026-03-14
**Evaluated**: 2026-03-14

---

## What It Is

A community-built Claude Code extension that replaces binary allow/deny permission logic with context-aware permission rules:
- Permission decisions based on active working directory
- File-type-aware rules (allow writes to `src/` but not `config/`)
- Operation context (allow reads, block writes during certain phases)
- Historical operation awareness (block follow-up operations after trigger events)

The native system (`ask: ["Bash(rm *)"]` content-level permissions) matches tool call patterns, not execution context. This would add declarative context-aware rules.

---

## Redundancy Check

| Existing Capability | Match? |
|---------------------|--------|
| `allowedTools`/`blockedTools` | PARTIAL — binary, no context |
| `ask: ["Bash(rm *)"]` content-level | PARTIAL — pattern on call content, not working context |
| CLAUDE_CODE_SIMPLE | PARTIAL — session-wide restriction, not context-aware |
| Agent spawn restrictions (frontmatter) | PARTIAL — agent-level, not context-level |
| PreToolUse hooks | PARTIAL — can implement context logic imperatively |

**Verdict**: NOVEL as a declarative context-aware permission layer. PreToolUse hooks can approximate it but require custom scripting per rule. A declarative interface would be significantly more maintainable.

**Key question**: If this IS just a PreToolUse hook wrapper, it could be a technique document rather than a separate tool.

---

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 55 | Unknown implementation — could be hook script, binary, or settings extension |
| Token efficiency impact | 25% | 50 | Neutral for token usage; prevents unintended operations but no token savings |
| Capability expansion | 25% | 75 | Genuine new expressiveness — declarative context-aware rules fill a real gap |
| Maintenance burden | 15% | 60 | Community project, unknown maintenance cadence; no stars/repo info yet |
| Community validation | 15% | 50 | Single HN post; no GitHub stars, no repo link in discovery file |

- **Total Score**: (55×0.20) + (50×0.25) + (75×0.25) + (60×0.15) + (50×0.15)
- = 11 + 12.5 + 18.75 + 9 + 7.5 = **58.75/100**

## Decision

**NEEDS_RESEARCH** (58.75/100) — Capability gap is real; implementation details required before scoring can improve

---

## Research Questions (Priority Order)

1. **BLOCKING**: What is the GitHub repo URL? (Check the HN post: `https://news.ycombinator.com/item?id=47343927`)
2. Is this a hook script, a standalone binary, or something else?
3. How does it integrate? Via `settings.json` hooks, a separate config file, or process injection?
4. What is the rule DSL (declarative permission language)?
5. If it's a hook wrapper — is the declarative interface substantially easier than writing raw PreToolUse scripts?

---

## Integration Path (If Research Confirms Value)

If this is a well-designed PreToolUse hook wrapper with good DSL:
- Score would increase: integration complexity 55 → 70, community 50 → 65
- Revised total: ~65-68 → potential APPROVE

If it's purely a pattern/technique (not a standalone tool):
- Document as technique in `library/techniques/` rather than MCP/skill integration
- May score lower on integration complexity (no drop-in) but still valuable as documentation

---

## Redundancy Triggers

"context-aware permissions", "permission guard claude", "dynamic tool permissions", "directory-aware permissions", "conditional tool access", "context permission rules", "claude code permission scaling", "declarative permissions", "working directory permissions"
