# ECC Tools (Everything Claude Code) — Evaluation

- **Date Evaluated**: 2026-03-16
- **Original Discovery**: discord-inbox-20260315-ecc-tools.md
- **Source**: https://ecc.tools / https://github.com/affaan-m/everything-claude-code
- **Decision**: NEEDS_RESEARCH

## What It Is

"Everything Claude Code" (ECC) by Affaan Mustafa — the most popular Claude Code configuration resource publicly, with **73k+ stars and 6k+ forks**. Ships 65+ skills, 16 agents, 40+ commands for Claude Code, Codex, Cursor, and OpenCode. ecc.tools is the commercial SaaS wrapper. Key features:

- **GitHub App** (listed on GitHub Marketplace): Scans repos to auto-extract team patterns and generate PRs with reusable CLAUDE.md defaults
- **AgentShield**: Security scanner with 102 rules for auditing agent configs, CLAUDE.md, settings.json, MCP servers, hook injection, and permissions — powered by Opus 4.6 in a red-team/blue-team/auditor pipeline
- Pricing: Free for public repos → $19/seat Pro → Enterprise

## Redundancy Check

PARTIAL OVERLAP:
- 65+ skills/16 agents: Overlap with our existing capability system. Bulk adoption would conflict.
- AgentShield (102-rule security scanner): Our `security-auditor` agent exists but may be less comprehensive. **COMPARISON evaluation needed.**
- GitHub App pattern (auto-extracting team conventions from commit history): **NOVEL** — not in registry.

## Scoring

| Criterion | Score | Weight | Weighted |
|-----------|-------|--------|---------|
| Integration complexity | 30 | 20% | 6.0 |
| Token efficiency impact | 50 | 25% | 12.5 |
| Capability expansion | 60 | 25% | 15.0 |
| Maintenance burden | 50 | 15% | 7.5 |
| Community validation | 90 | 15% | 13.5 |
| **Total** | | | **54.5** |

## Scoring Rationale

- **Integration complexity (30)**: Wholesale adoption is not feasible — conflicts with existing system. Cherry-picking specific patterns (AgentShield rules, GitHub App concept) requires significant adaptation work.
- **Token efficiency (50)**: Neutral — adding more agents/skills could increase context overhead.
- **Capability expansion (60)**: Incremental overall, but two specific sub-capabilities are genuinely novel: (a) AgentShield's 102-rule security scanning may significantly exceed our current security-auditor's coverage, and (b) the GitHub App pattern for auto-extracting project conventions has no current equivalent.
- **Maintenance burden (50)**: External dependency on a third-party repo (Affaan's). If ECC changes, our integrated patterns may drift. Medium maintenance.
- **Community validation (90)**: 73k stars, highly active, most-starred Claude Code resource. Affaan is a recognized authority in the space.

## Decision

**NEEDS_RESEARCH (54.5)** — Too broad to evaluate as a single item. Two specific sub-capabilities need dedicated evaluation passes:

### Research Questions

1. **AgentShield vs security-auditor**: Does AgentShield's 102-rule scanner cover significantly more attack surface than our existing `security-auditor` agent? Could we adopt the ruleset without adopting the full ECC system? What's the overlap?

2. **GitHub App pattern**: The auto-extraction of team conventions from commit history/PR patterns into CLAUDE.md format is novel. Is this implementable as a standalone Claude Code skill without the full GitHub App? What specific patterns does it extract?

3. **Skill/agent cherry-picking**: Are there specific ECC skills addressing gaps in our current registry that warrant direct adoption?

See research flag: `discord-inbox-20260315-ecc-tools-research-flag.txt`
