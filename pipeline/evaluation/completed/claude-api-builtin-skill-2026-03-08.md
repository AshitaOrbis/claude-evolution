# Discovery: Claude Code Built-in /claude-api Skill

- **Source**: https://releasebot.io/updates/anthropic
- **Date Found**: 2026-03-08
- **Category**: skill (built-in Claude Code feature)
- **Summary**: Anthropic added a built-in `/claude-api` skill to Claude Code (version ~2.1.72+) that guides building applications with the Claude API and Anthropic SDK. This is an official, zero-maintenance alternative to the custom `claude-api` skill currently in `~/.claude/skills/claude-api/`.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## Details

From releasebot.io release notes:
> "Added the /claude-api skill for building applications with the Claude API and Anthropic SDK"

Additional features in the same release:
- New session naming support
- Numeric keypad support for option selection
- Optional `--name` argument for `/remote-control` (custom session title in claude.ai/code)
- Multi-language voice STT support (improvement to existing voice mode early preview)
- Agent/worksphere UI improvements

## Redundancy Analysis

**Classification: IMPROVEMENT** — We have a custom `claude-api` skill; this is the official Anthropic version.

| Aspect | Custom `~/.claude/skills/claude-api/` | Built-in `/claude-api` skill |
|--------|--------------------------------------|------------------------------|
| Maintenance | Manual (we maintain) | Anthropic maintains |
| Availability | This workspace only | All Claude Code instances |
| Integration cost | Already integrated | Zero (built-in) |
| Content quality | Good | Potentially better (Anthropic-sourced) |

**Evaluation question**: Should we retire our custom claude-api skill in favor of the built-in, or keep ours for project-specific customization?

## Evaluation Criteria Pre-Assessment

- Integration complexity: Easy (already built-in, no action needed)
- Token efficiency: Neutral (same as existing custom skill)
- Capability expansion: Low-Medium (already have claude-api skill coverage)
- Maintenance burden: Low (Anthropic maintains built-in)
- Community validation: High (official Anthropic feature)

**Expected score**: ~70-80 (built-in = high integration score, but we already have coverage)

## Evaluation

**Score**: 72/100
**Decision**: APPROVED
**Reason**: Official Anthropic built-in /claude-api skill (v2.1.72+). No custom claude-api skill exists in our setup (verified: ~/.claude/skills/ does not contain claude-api/), so this is a NOVEL capability, not an improvement. Zero integration cost — it's built-in and Anthropic-maintained. Provides structured guidance for building applications with the Claude API and Anthropic SDK. Useful for our Development Environment setup (Claude Max plan, claude -p CLI usage). Additional features in same release (session naming, --name for /remote-control, multi-language voice STT) should be tracked as registry updates.

| Criterion | Weight | Score |
|-----------|--------|-------|
| Integration complexity | 20% | 100 (built-in, zero effort) |
| Token efficiency impact | 25% | 50 (neutral — skill loads on demand) |
| Capability expansion | 25% | 60 (API development guidance, moderately useful) |
| Maintenance burden | 15% | 100 (Anthropic maintains) |
| Community validation | 15% | 100 (official Anthropic feature) |

**Integration action**: Update registry/existing-capabilities.md to document /claude-api as built-in skill. Also create registry entries for session naming, --name flag for /remote-control, and multi-language voice STT as version features.

**Date**: 2026-03-08
**Auto-triaged**: Yes (batch evaluation)
