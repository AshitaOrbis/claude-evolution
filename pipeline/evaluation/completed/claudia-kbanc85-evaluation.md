# Evaluation: Claudia (kbanc85)

- **Date**: 2026-03-11
- **Source**: https://github.com/kbanc85/claudia
- **Category**: Personal AI Assistant / Memory System
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 43 | Multi-runtime stack: Python daemon, SQLite + sqlite-vec, Ollama, MCP wiring, Obsidian sync. Recent changelog shows repeated fixes for install/MCP reliability — high integration cost |
| Token efficiency impact | 25% | 50 | Mixed: template/skill layer increases startup context footprint, but compound memory tools reduce sequential MCP round trips |
| Capability expansion | 25% | 71 | Meaningful: persistent memory, relationship tracking, workspace generation, local semantic recall via Ollama. Strongest dimension |
| Maintenance burden | 15% | 34 | Fast-moving but single-maintainer; changelog shows repeated daemon/schema/MCP edge case fixes; 15 open issues |
| Community validation | 15% | 46 | 178 stars, 20 forks as of 2026-03-11. Launched 2026-01-23. Better than initially estimated but still early |

- **Claude Score**: 50.5/100
- **Codex Score**: 54/100
- **Final Score**: 52.25/100

## Decision

NEEDS_RESEARCH — Strong capability expansion (persistent memory, workspace templates, local embedding) but complex multi-runtime stack makes direct integration risky. Template pattern and compound memory-tool concepts worth extracting separately.

## Integration Notes

Research questions:
1. Can the SQLite + Ollama memory pattern be extracted as a lightweight technique document without adopting the full daemon stack?
2. Is the `/new-workspace` workspace template pattern applicable to our existing CLAUDE.md templating?
3. Does the compound memory tool pattern (reducing sequential MCP round trips) apply to our existing multi-agent architecture?
4. Is there overlap with existing agent memory (`memory: project` frontmatter in v2.1.33+)?

**Reconsideration trigger**: If project simplifies to remove Ollama/daemon dependency (pure MCP + SQLite), score would likely reach 70+.
