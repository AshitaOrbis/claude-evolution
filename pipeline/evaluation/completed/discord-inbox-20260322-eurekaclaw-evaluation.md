# EurekaClaw: AI Research Agent

- **Date**: 2026-03-22
- **Source**: Discord #general inbox
- **URL**: https://www.eurekaclaw.ai/
- **Category**: tool, research, agent
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1485405924762849290

## Description

EurekaClaw is an open-source, local-first AI research assistant designed to automate theoretical research workflows. It provides eight integrated functions: literature analysis (arXiv/Semantic Scholar), idea generation across papers, proof development, theorem proving with Lean4 validation, research memory with knowledge graphs, ML experiment execution (Jupyter/W&B), and automated paper writing in LaTeX. The platform supports multiple LLM providers (OpenAI, Anthropic, local Ollama) and prioritizes privacy through configurable API routing.

## User Context

Discord message noted potential relevance for research papers generally, and specifically for Psyche and Chatledger projects.

## Relevance

Could be valuable for automating literature reviews, hypothesis generation, and structured research documentation. Might apply to Psyche's psychometric research and Chatledger's data analysis workflows, particularly for paper generation and proof validation.

## Classification

Evaluated by standard pipeline.

---

## Evaluation

**Date evaluated**: 2026-03-23
**Redundancy status**: NOVEL in its niche but irrelevant to this workspace

**Reasoning**: EurekaClaw is designed for theoretical academic research workflows — arXiv/Semantic Scholar literature analysis, Lean4 theorem proving, ML experiment execution with Jupyter/W&B, and LaTeX paper writing. None of these apply to the current workspace:
- Evolution pipeline: capability discovery and integration for Claude Code (not academic papers)
- Psyche: psychological measurement analysis (not theorem proving or ML experiments)
- Chatledger: SMS/chat data analysis (not academic literature reviews)

The Psyche and Chatledger use cases mentioned in the Discord context are speculative. The tool is also complex (multiple provider integrations, Lean4 dependency, Jupyter/W&B integration), creating high setup burden for marginal relevance. Web research needs are already handled by web-researcher subagent + Exa + Brave + Codex. Not a standalone agent (no MCP integration) — requires its own environment.

**Scores**:

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 25 | Complex standalone system: Lean4, Jupyter/W&B, LaTeX, multi-provider LLM — not an MCP, requires separate setup |
| Token efficiency impact | 25% | 50 | Neutral — specialized tool for specialized use, no impact on main workflow |
| Capability expansion | 25% | 35 | Academic workflows (theorem proving, ML experiments, LaTeX papers) not applicable to this workspace |
| Maintenance burden | 15% | 35 | Complex multi-dependency system with external Lean4/Jupyter/W&B integrations |
| Community validation | 15% | 45 | Open-source but no star count in discovery; website exists but maturity unclear |

**Weighted score**: (25×0.20) + (50×0.25) + (35×0.25) + (35×0.15) + (45×0.15) = 5 + 12.5 + 8.75 + 5.25 + 6.75 = **38.25/100**

**Decision**: **REJECTED**

**Kill signal**: Academic research platform targeting theoretical workflows (Lean4, arXiv, LaTeX) with no relevance to the Claude Code capability evolution pipeline. Potential future relevance only if Psyche or Chatledger pivot to formal academic paper publication — reconsider at that point.
