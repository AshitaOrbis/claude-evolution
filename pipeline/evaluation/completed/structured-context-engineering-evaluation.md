# Evaluation: Structured Context Engineering for File-Native Agentic Systems

- **Date**: 2026-02-10
- **Source**: https://arxiv.org/abs/2602.05447
- **Category**: technique
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 85 | Documentation updates only—add evidence-based recommendations to existing context management skills. No code changes, dependencies, or architecture modifications required. |
| Token efficiency impact | 25% | 70 | Validates that compact formats DON'T help (counterintuitive). Domain-partitioning could improve navigation. File-based retrieval shows +2.7% accuracy for frontier models. Prevents future optimization mistakes. |
| Capability expansion | 25% | 60 | Validates existing practices rather than adding new capabilities. Provides empirical backing for intuitive decisions. Domain-partitioning strategy is somewhat novel. Primarily defensive value. |
| Maintenance burden | 15% | 95 | Documentation only—no code to maintain. Evidence-based guidance reduces future debates and experimentation. |
| Community validation | 15% | 85 | ArXiv research paper with empirical study. Shared by Simon Willison (high credibility). Peer-reviewed venue with measurable results. |

- **Claude Score**: 76.5/100
- **Codex Score**: N/A (connection unavailable)
- **Final Score**: 76.5/100

## Decision

**APPROVED** — Empirical validation of existing practices with actionable domain-partitioning insight

## Integration Notes

**Type**: Documentation enhancement (technique)

**Target locations**:
1. `~/.claude/skills/advanced-tool-use/SKILL.md` — Add section on evidence-based file organization
2. `~/.claude/CLAUDE.md` — Update context management recommendations with research backing
3. `registry/existing-capabilities.md` — Document as empirical validation of format-agnostic approach

**Key insights to integrate**:
- Format selection (YAML/Markdown/JSON) should prioritize team familiarity over performance—validated as statistically neutral (p=0.484)
- Compact formats consume MORE tokens at scale due to search inefficiencies—contradicts common assumption
- Domain-partitioned organization outperforms size-based splitting for large codebases
- File-based retrieval benefits frontier models (+2.7% accuracy) but not open-source models (-7.7%)
- Model-aware architecture decisions > universal best practices

**Concerns**: None. Low-risk documentation enhancement that prevents future misoptimizations.

**References**:
- Full paper: https://arxiv.org/abs/2602.05447
- Discovery source: Simon Willison
