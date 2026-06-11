# Integration Verification Report — April 2026 Batch
**Date**: 2026-04-11
**Items**: 11 (from pipeline/integration/)
**Integrated by**: Claude Sonnet 4.6 (interactive session)

---

## Summary

| Item | Type | Score | Registry Action | Config Action |
|------|------|-------|-----------------|---------------|
| Monitor Tool (background streaming) | technique | 92.5 | ✅ Added (table + detail) | none (built-in) |
| CLAUDE_CODE_SCRIPT_CAPS | technique | 80.0 | ✅ Added (table + detail) | none (env var) |
| /cost Per-Model & Cache Breakdown | technique | 80.0 | ✅ Added (table + detail) | none (built-in) |
| PID Namespace Subprocess Sandboxing | improvement | 80.0 | ✅ Updated CLAUDE_CODE_SUBPROCESS_ENV_SCRUB entry | none (auto on Linux) |
| Session Title via hookSpecificOutput.sessionTitle | technique | 70.5 | ✅ Added (table + detail) | none (hook noted) |
| Focus View Toggle (Ctrl+O, NO_FLICKER) | improvement | 72.5 | ✅ Updated CLAUDE_CODE_NO_FLICKER entry | none (keybind) |
| Default Effort Level Medium→High | improvement | 72.5 | ✅ Updated Effort Controls entry | N/A (Max plan unaffected) |
| Skill Invocation Names from Frontmatter | technique | 72.5 | ✅ Added (table + detail) | none (auto behavior) |
| --exclude-dynamic-system-prompt-sections | technique | 85.0 | ✅ Added (table + detail) | ✅ heartbeat-commands.md updated |
| refreshInterval Statusline | technique | 72.5 | ✅ Added (table + detail, with schema note) | ⚠️ Schema has additionalProperties:false — statusLine config not yet wired |
| Accept Edits Mode Env-Var Auto-Approval | technique | 70.0 | ✅ Added (table + detail) | none (passive) |
| keep-coding-instructions Frontmatter | skill | 76.75 | ✅ Added (table + detail) | none (pending confirmed values) |

---

## Integration Notes

### Fully integrated (registry + zero config needed)
- Monitor Tool, CLAUDE_CODE_SCRIPT_CAPS, /cost breakdown, PID namespace, Session title hook, Focus View, Default effort note, Skill invocation names, Accept edits auto-approval

### Integrated with action item
- `--exclude-dynamic-system-prompt-sections`: Registry entry added + heartbeat-commands.md updated with usage example
- `keep-coding-instructions`: Registry entry added; confirmed accepted values (boolean/enum) should be verified before applying to specific SKILL.md files
- `refreshInterval Statusline`: Registry entry added with schema caveat — `statusLine` base config needs to be wired in settings.json before refreshInterval can be tested. Schema at integration time has `additionalProperties: false` for the statusLine object.

### Pre-existing in registry (verified not duplicated)
All 11 items except `keep-coding-instructions` were already partially or fully documented in the registry from a prior session. This run confirmed all entries and added the missing `keep-coding-instructions` entry.

---

## Redundancy Check Results
All items verified against `registry/existing-capabilities.md` before integration. No duplicates introduced.

---

## Files Moved
From `pipeline/integration/` → `pipeline/verification/`:
- monitor-tool-background-script-streaming.json
- claude-code-script-caps-invocation-limit.json
- cost-command-per-model-cache-breakdown.json
- pid-namespace-subprocess-sandboxing.json
- session-title-hook-output.json
- focus-view-toggle-no-flicker.json
- default-effort-level-medium-to-high.json
- skill-invocation-names-from-frontmatter.json
- exclude-dynamic-system-prompt-sections.md
- statusline-refresh-interval.md
- accept-edits-envvar-auto-approval.md
- plugin-keep-coding-instructions-frontmatter.json
