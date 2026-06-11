# Discovery: Claude Code Skills 2.0 — Built-in Evals and A/B Testing

- **Source**: https://www.geeky-gadgets.com/anthropic-skill-creator/ | https://tessl.io/blog/anthropic-brings-evals-to-skill-creator-heres-why-thats-a-big-deal/
- **Date Found**: 2026-03-06
- **Category**: technique
- **Summary**: Anthropic has released Claude Code Skills 2.0, adding a structured evaluation framework to the skill-creator system. Skills now support benchmark test sets for reliability testing as models update, and comparator agents for blind A/B testing between skill variants. Test cases can be defined locally and run inside Claude Code.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

Claude Code Skills 2.0 extends the skill-creator system with:

**Evaluation Framework**:
- Define test cases against a skill inline in Claude Code
- Run benchmark sets locally to verify skill reliability
- Track degradation as underlying models update over time
- CI/CD integration via Tessl for continuous skill eval

**A/B Testing via Comparator Agents**:
- Blind comparisons between skill variants
- Prevents cross-contamination between arms
- Structured output for comparing plan/response quality

**Skill-Creator Tooling**:
- Eval-aware skill scaffolding (prompts for test case definition)
- The skill-creator skill itself now suggests eval coverage

## Redundancy Check

**Status**: IMPROVEMENT (reclassified from NOVEL 2026-03-06)

Checked registry for: "skill eval", "A/B testing", "skill reliability", "benchmark skill", "skill comparator", "skill versioning". Our existing DSPy-based prompt optimizer already covers ~70% of this functionality (training/holdout evaluation, cross-validation, metric functions).

**Adopted improvements**:
- Assertion-based test format: lightweight JSON alternative to full Python metric functions (`assertion_metric()`)
- Model regression tracking: `optimized_with_model` field on OptimizedPrompt, `--check-model-drift` CLI flag
- Failure analyzer pass: `--analyze-failures` flag for structured programmatic analysis (zero token cost)

**Skipped**:
- Tessl CI/CD integration (paid service, not needed for local optimizer)
- Auto-regression triggers on model releases (token budget constraint — manual runs only)
- Comparator agent pattern (already have A/B testing via `run_ab_test.py`)

## Evaluation Needs

1. Does the eval framework require specific frontmatter in SKILL.md or is it out-of-band?
2. Can we retrofit evals onto existing skills (code-reviewer, mgrep-guide, etc.)?
3. Is the comparator agent pattern usable outside skill-creator context?
4. What's the token cost of running eval suites — viable in heartbeat?
5. Does this supersede or complement our existing DSPy prompt optimizer?
