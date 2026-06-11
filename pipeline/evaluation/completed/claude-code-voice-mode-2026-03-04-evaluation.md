# Evaluation: Claude Code Voice Mode

- **Date**: 2026-03-04
- **Source**: https://9to5mac.com/2026/03/03/anthropic-adding-voice-mode-to-claude-code-in-gradual-rollout/
- **Category**: feature (Claude Code built-in)
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Claude | Codex | Rationale |
|-----------|--------|--------|-------|-----------|
| Integration complexity | 20% | 100 | 70 | Built-in `/voice` command — zero config. Codex docked for rollout gate uncertainty. |
| Token efficiency impact | 25% | 50 | 65 | Neutral. Adds input modality; Codex notes potential transcription token exemption (unconfirmed). |
| Capability expansion | 25% | 80 | 90 | Fills "Voice/Audio processing" gap in registry. Hands-free CLI workflows, accessibility improvement. |
| Maintenance burden | 15% | 100 | 50 | Claude: official Anthropic built-in, zero external deps. Codex: docked for early preview instability risk. |
| Community validation | 15% | 70 | 85 | Official eng announcement (Thariq Shihipar), covered by 9to5Mac + TechCrunch + r/ClaudeAI. No official docs yet. |

- **Claude Score**: 78/100
- **Codex Score**: 72/100
- **Final Score**: 75/100

## Decision

**APPROVED** — Novel capability filling documented gap; official Anthropic feature with zero integration cost. Early preview warrants deferral advisory per playbook.

## Integration Notes

**Status**: EARLY PREVIEW (~5% rollout as of 2026-03-04, no official changelog entry yet)
**Stability**: Behavior, plan support, and command semantics may shift during rollout
**Timeline**: Monitor for official docs/changelog entry confirming GA

**Integration type**: Registry Update + Monitoring (NOT full implementation yet)
**Target**: `registry/existing-capabilities.md` — move "Voice/Audio processing" from "Categories Not Yet Covered" to a monitored preview entry

**Actions when integrating**:
1. Add entry under new "Voice Input" section in registry
2. Document `/voice` command, availability (~5% → ramping)
3. Note re-evaluation trigger: when official docs/changelog confirm GA

**What NOT to do**:
- Do NOT add `/voice` to CLAUDE.md or skills (not generally available)
- Do NOT treat as fully integrated until GA

**Re-evaluate when**: Official Anthropic changelog or docs.anthropic.com explicitly documents `/voice` mode with stable semantics.

**Redundancy triggers**: "Claude Code voice mode", "/voice command", "voice input CLI", "hands-free coding Claude", "speech input Claude Code"
