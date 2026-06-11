# Evaluation: Founder Skills

- **Date**: 2026-03-08
- **Source**: https://github.com/ognjengt/founder-skills
- **Category**: other
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 50 | GitHub repo — if relevant skills format, moderate integration effort |
| Token efficiency impact | 25% | 50 | Unknown content; neutral assumption |
| Capability expansion | 25% | 40 | Name suggests entrepreneurship/founder focus, unclear relevance to Claude Code workflows; might be business-domain skills unrelated to this system |
| Maintenance burden | 15% | 70 | Skills files typically low maintenance if applicable |
| Community validation | 15% | 30 | Unknown repo, no star count in discovery, small/private contributor (ognjengt) |

- **Claude Score**: 47.5/100
- **Codex Score**: N/A (skipped — discovery file contains only a URL, no content to cross-validate)
- **Final Score**: 47.5/100

## Decision

REJECTED — Score 47.5/100 falls below the 50-point threshold. Discovery file contains only a URL with no description. "Founder skills" strongly implies business/entrepreneurship domain knowledge rather than Claude Code technical capabilities. The GitHub account (ognjengt) is an individual contributor with no established presence in the Claude Code ecosystem. Insufficient signal to justify a research investment.

## Integration Notes

Reconsideration triggers: If the repo is confirmed to contain Claude Code `~/.claude/skills/` format files with novel technical workflows, re-evaluate. The existing skills ecosystem audit (`docs/awesome-claude-skills-audit.md`) covers major community collections; a small personal repo is unlikely to be additive.
