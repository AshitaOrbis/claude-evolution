# Evaluation: Claude Code Startup Skills

- **Date**: 2026-03-08
- **Source**: https://github.com/rameerez/claude-code-startup-skills
- **Category**: skills/workflow
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 70 | Easy — SKILL.md files are drop-in; x-post requires Twitter API setup which adds friction |
| Token efficiency impact | 25% | 50 | Neutral — workflow skills don't affect token usage |
| Capability expansion | 25% | 25 | transcribe-video duplicates existing youtube-transcriber skill; compress-images and download-video are trivially implementable (one-liner bash); x-post is novel but irrelevant to our workflows; customer-empathy is vague prompt with no tooling |
| Maintenance burden | 15% | 70 | Minimal — prompt files; x-post may need Twitter API updates |
| Community validation | 15% | 40 | 18 stars — well below 100-star threshold |

- **Claude Score**: 49/100
- **Codex Score**: N/A (skipped — clear case)
- **Final Score**: 49/100

## Decision

**REJECTED** — 90%+ redundant with existing capabilities; x-post is the only novel skill but Twitter/X is not part of our stack; 18 stars signals minimal community validation.

## Integration Notes

No integration warranted. Reconsideration trigger: if Twitter/X posting becomes a needed workflow (e.g., evolution system posts discoveries to X).

**Redundancy notes:**
- `/startup:transcribe-video` → duplicate of `youtube-transcriber` skill
- `/startup:compress-images` → one imagemagick command, no skill needed
- `/startup:download-video` → trivial yt-dlp wrapper
- `/startup:customer-empathy` → vague thinking prompt, not a tool skill
- `/startup:x-post` → novel but not relevant to current workflows
