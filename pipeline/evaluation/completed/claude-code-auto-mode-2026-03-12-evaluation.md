# Evaluation: Claude Code Auto Mode (Research Preview)

**Source**: https://awesomeagents.ai/news/claude-code-auto-mode-research-preview/
**Type**: technique
**Discovered**: 2026-03-12
**Evaluated**: 2026-03-15

---

## What It Is

Anthropic's research preview of "Auto Mode" for Claude Code, shipping around v2.1.76. Instead of prompting developers to approve every file write or shell command, Claude evaluates each operation's scope and risk, then classifies it:
- **Low-risk** (auto-approve): File reads, writes within known directories, standard shell commands
- **High-risk** (surface to developer): Network access, deletions, commands outside expected scope

Enabled via `Shift+Tab` cycling or `"defaultMode": "auto"` in `settings.json`. Includes prompt injection safeguards and admin-level restriction controls (IT teams can lock the setting).

---

## Redundancy Check

| Existing Capability | Match? |
|---------------------|--------|
| `allowedTools` / `blockedTools` | PARTIAL — static allowlist, no risk classification |
| `ask: ["Bash(rm *)"]` content-level | PARTIAL — pattern matching, not scope-aware |
| CLAUDE_CODE_SIMPLE | PARTIAL — restricts tool set entirely, different goal |
| PreToolUse hooks | PARTIAL — can approximate via scripting, but requires custom logic |
| Agent spawn restrictions (frontmatter) | NOT RELATED — controls subagent hierarchy, not operation approval |
| Context-Aware Permission Guard (2026-03-14, NEEDS_RESEARCH) | PARTIAL — community declarative rules vs Anthropic-native risk classification |

**Verdict**: NOVEL. First Anthropic-native autonomous permission mode. Risk-based classification is architecturally distinct from pattern-based allowlists. PreToolUse hooks can approximate it imperatively but require per-rule scripting; Auto Mode provides a single universal toggle with built-in risk evaluation.

---

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 90 | Drop-in: `"defaultMode": "auto"` in settings.json or Shift+Tab toggle. Zero code changes |
| Token efficiency impact | 25% | 60 | Removes permission confirmation prompts from autonomous runs; minor token savings but significant workflow efficiency for long iterative-improve / heartbeat runs |
| Capability expansion | 25% | 90 | Genuinely novel: first native risk-classified autonomous permission mode. High impact on all autonomous workflows |
| Maintenance burden | 15% | 75 | Anthropic-maintained (low burden on our end); research preview risk means settings field could change |
| Community validation | 15% | 90 | Official Anthropic research preview + GitHub Issue #33587 confirms v2.1.76 shipment |

**Total**: (90×0.20) + (60×0.25) + (90×0.25) + (75×0.15) + (90×0.15)
= 18 + 15 + 22.5 + 11.25 + 13.5 = **80.25/100**

---

## Decision

**APPROVED** (80.25/100) — Moved to `pipeline/integration/`

---

## Integration Path

**Target**: `~/.claude/CLAUDE.md` and `registry/existing-capabilities.md`

**Settings change**:
```json
// ~/.claude/settings.json
{
  "defaultMode": "auto"
}
```

**Workflow impact**:
- Iterative-improve skill: long autonomous loops no longer interrupted by permission prompts
- Heartbeat cron jobs: autonomous discovery runs without interruptions
- One-time opt-in; compatible with existing PreToolUse hooks (hooks still fire, but approval is automatic for classified low-risk ops)

**Security note**: Research preview includes prompt injection safeguards. For production use, verify that injection protection is active via Anthropic docs before enabling in sensitive environments. IT admin controls allow locking `defaultMode` to "normal" org-wide.

**Research preview caveat**: Settings field (`defaultMode`) may change in stable release. Re-evaluate when Auto Mode exits preview.

---

## Redundancy Triggers (Add to Registry)

"auto mode", "defaultMode auto", "autonomous permissions", "permission automation", "auto-approve operations", "permission fatigue", "autonomous approval mode", "claude code auto mode"
