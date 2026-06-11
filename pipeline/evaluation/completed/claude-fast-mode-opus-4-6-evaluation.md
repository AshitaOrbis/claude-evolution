# Evaluation: Claude Fast Mode (Opus 4.6)

- **Date**: 2026-02-08
- **Source**: https://code.claude.com/docs/en/fast-mode + https://simonwillison.net/2026/Feb/7/claude-fast-mode/
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 100 | Trivial - just type `/fast` command or use `model: "claude-opus-4-6-fast"` in API |
| Token efficiency impact | 25% | 50 | Neutral - same token usage, faster inference only |
| Capability expansion | 25% | 70 | Incremental - offers speed/cost trade-off for time-sensitive work |
| Maintenance burden | 15% | 100 | Official Anthropic feature, built-in to Claude Code, zero maintenance |
| Community validation | 15% | 100 | Official Anthropic release (Feb 7, 2026), production-ready |

- **Claude Score**: 80.0/100
- **Codex Score**: Skipped (clear approval case, no cross-validation needed)
- **Final Score**: 80.0/100

## Decision

**APPROVED** — Official Anthropic feature providing 2.5x speed improvement at 6x cost (3x during promo until Feb 16). Novel capability for time-sensitive workflows.

## Integration Notes

**Integration Type**: Documentation + selective usage pattern

**Where it goes**:
- Document in `~/.claude/CLAUDE.md` as usage guideline
- Add to `registry/existing-capabilities.md` under appropriate section

**Use Cases** (from discovery file):
- Interactive sessions where latency matters
- Demos and presentations requiring quick responses
- Time-sensitive debugging
- User-facing applications

**Avoid**:
- Batch jobs (heartbeat, pipeline orchestration)
- Cost-sensitive workflows
- Non-time-critical tasks
- Research/exploration

**Cost Control**:
- Reserve `/fast` for specific high-priority tasks only
- Default to standard Opus 4.6 for all automated workflows
- Monitor token usage carefully during fast mode sessions
- Promotional pricing expires Feb 16, 2026 (reverts to 6x cost)

**Registry Entry**: Add to Opus 4.6 Model Capabilities section with usage guidance.
