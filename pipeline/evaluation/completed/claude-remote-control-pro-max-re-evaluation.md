# Evaluation: Claude Code Remote Control - Pro/Max Re-evaluation

- **Date**: 2026-02-25
- **Source**: https://www.techradar.com/pro/anthropic-reveals-remote-control-a-mobile-version-of-claude-code-to-keep-you-productive-on-the-move
- **Category**: technique
- **Automated**: Yes (daily heartbeat)
- **Previous evaluation**: `pipeline/evaluation/completed/claude-remote-control-subcommand-evaluation.md` (45.25/100, REJECTED 2026-02-24)

## Re-evaluation Context

Previous rejection reason: Enterprise-only gating ("Contact your administrator").
Reconsideration trigger met: Pro/Max expansion confirmed (the trigger explicitly noted "Monitor: Track if Anthropic extends remote-control to Pro/Max plans").

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 80 | Account confirmed as qualifying (2026-02-28). `claude remote-control --help` returns full help text. Feature is available and functional. |
| Token efficiency impact | 25% | 50 | Neutral — session management, not token optimization. |
| Capability expansion | 25% | 65 | Removes the enterprise gate. Adds polished mobile UI and browser-based access. Existing Tailscale+SSH+Termux solution already functional, reducing incremental value. |
| Maintenance burden | 15% | 100 | Official Anthropic feature — zero additional maintenance. |
| Community validation | 15% | 90 | Official Anthropic release, now expanded to Pro/Max (research preview). |

- **Claude Score**: 73.25/100
- **Codex Score**: N/A (skipped — key factor was account qualification, now verified)
- **Final Score**: 73.25/100

## Decision

APPROVED (2026-02-28) — Account qualifies. `claude remote-control --help` returns full help text with usage details. Feature is functional as a research preview.

## Integration Notes

**Verified (2026-02-28)**:
- `claude remote-control --help` returns help text (not "not enabled")
- Supports `--permission-mode` flag (acceptEdits, bypassPermissions, default, dontAsk, plan)
- Research preview status — may have rough edges

**Integration**: Document as alternative to Tailscale SSH for mobile access. UX improvement over `ssh ashita@<tailnet-ip>` via Termux, but not a capability unlock (SSH already fully functional).

**Usage**: Run `claude remote-control` in a project directory, then connect from claude.ai/code on phone/browser.
