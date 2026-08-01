# Domain-Expertise Planning Layer for Agent Sessions

**Source**: https://www.anthropic.com/research/claude-code-expertise
**Date**: 2026-06-26 (integrated 2026-07-19)
**Type**: technique (planning refinement)
**Score**: 85/100 (approved 2026-06-28)

## The Finding

Anthropic's Claude Code usage study found a consistent division of labor: **humans
supply most planning decisions, agents supply most execution decisions** — and users
with domain expertise extract more useful agent work *per instruction*, because their
instructions carry the constraints the agent would otherwise have to guess (and guess
wrong, expensively).

The actionable inversion: if expertise-in-the-instruction is what makes delegation
efficient, then make that expertise an explicit, required artifact rather than an
accident of who is typing.

## The Pattern — Three Things Before Delegating Execution

Before an agent session (or subagent dispatch) begins implementation, the plan states:

1. **Domain constraints** — the non-obvious rules of this codebase/domain that an
   outsider would violate: invariants, ordering requirements, "this looks refactorable
   but isn't," performance envelopes, compliance rules. Written down, not assumed.
2. **Decision ownership** — which decisions the agent may make alone (naming, internal
   structure, test scaffolding) and which are reserved (schema changes, public API
   shape, dependency additions, anything irreversible). Reserved decisions surface as
   questions, not actions.
3. **Evidence of completion** — what observable proof will count as done: passing named
   tests, a command's output, a diff property. Declared before execution so "done" is a
   check, not a claim.

## Relationship to Existing Practice

This slots into patterns already in use here: plan-mode conventions (thoroughness before
execution), the subagent-return-with-provenance rule, and the completion-evidence
discipline in the verification pipeline. What it adds is the explicit *decision
ownership* split — the piece most often left implicit, and the cause of most
"agent did something technically valid but organizationally wrong" failures.

## When It Pays Most

- Dispatching subagents into codebases they have not read end-to-end.
- Cross-domain work (an agent strong in code executing in a domain with external rules —
  finance, privacy, publishing).
- Long autonomous runs, where a wrong guessed constraint compounds for hours.

**Tags**: `planning`, `domain-constraints`, `decision-ownership`,
`completion-evidence`, `delegation`, `subagents`, `anthropic-research`
