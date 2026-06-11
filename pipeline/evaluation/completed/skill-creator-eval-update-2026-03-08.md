# Discovery: Anthropic skill-creator Major Update — Built-in Evals & Benchmarking

- **Source**: https://www.adwaitx.com/claude-agent-skills-skill-creator-evals/ | https://tessl.io/blog/anthropic-brings-evals-to-skill-creator-heres-why-thats-a-big-deal/
- **Date Found**: 2026-03-08
- **Category**: skill / technique
- **Summary**: Anthropic updated the official built-in `skill-creator` skill (early March 2026) to include testing, evaluation, and benchmarking capabilities. Authors can now define test cases alongside skill definitions and run benchmarks locally in Claude Code. Aims to prevent "band-aid" skills by making reliability testing part of the authoring workflow.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Key New Capabilities

1. **Integrated evals**: Write test cases as part of skill authoring (no separate eval step)
2. **Local benchmarking**: Run benchmarks against skills directly in Claude Code session
3. **Model-evolution resilience**: Skills self-check and surface breakage when models change
4. **Non-engineer friendly**: Testing flow designed to work without code knowledge

## Redundancy Analysis

**Partial overlap — classify as IMPROVEMENT:**

| Capability | Existing | New |
|-----------|---------|-----|
| Prompt optimization | DSPy optimizer (`prompt-optimizer` agent) | Built-in eval in skill-creator |
| Skill auditing | `skill-auditor` agent | Native eval layer |
| Model drift detection | `--check-model-drift` flag (DSPy) | Built-in resilience check |

**Key difference**: Our DSPy optimizer works *after* skill creation (optimize existing prompts). The Anthropic update integrates evals *during* authoring — a shift in workflow. Also, the built-in version is zero-maintenance (Anthropic maintains it).

**Not redundant with**: `skill-creator` guide (ours lacks eval integration), `skill-auditor` (runs after-the-fact, not during creation)

## Evaluation Questions

1. Does Anthropic's built-in eval replace or complement our DSPy optimizer workflow?
2. Should we update our `skill-creator` skill to reference/trigger Anthropic's built-in version?
3. Does the built-in test format differ from our DSPy assertion format?
4. Can we retire or simplify `skill-auditor` if built-in evals cover same scope?

## Evaluation

**Score**: 0/100
**Decision**: REJECTED
**Reason**: DUPLICATE — This discovery (Anthropic skill-creator evals & benchmarking update) was already evaluated on 2026-03-06 in pipeline/evaluation/completed/claude-code-skills-2-evals-abtesting-evaluation.md with a final score of 70.4/100 (APPROVED). That evaluation used Codex cross-validation and covers the same sources (tessl.io blog, Anthropic Engineering). Integration notes already documented. See also: claude-code-skills-2-evals-abtesting-integrated.md for integration status.
**Date**: 2026-03-08
**Auto-triaged**: Yes (batch evaluation)
