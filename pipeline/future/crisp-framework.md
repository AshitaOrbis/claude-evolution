# Discovery: CRISP Framework for Code Prompts

- **Source**: https://aiproductivity.ai/blog/claude-code-prompt-engineering/
- **Date Found**: 2026-02-06
- **Category**: technique
- **Summary**: A structured 5-component framework (Context, Requirements, Integration, Style, Parameters) specifically designed for coding prompts. Emphasizes pattern imitation and constraint-based design.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

The CRISP Framework provides a systematic approach to structuring code generation prompts:

- **C - Context**: Relevant code, files, and project information
- **R - Requirements**: What the code should do
- **I - Integration**: How it connects with existing code
- **S - Style**: Coding conventions and patterns to follow
- **P - Parameters**: Constraints, limitations, and edge cases

### Key Techniques

1. **Pattern Imitation**: Point to existing code examples rather than describing desired patterns
2. **Constraint-Based Design**: Start with type definitions before implementation
3. **Additive Refinement**: Build on working code with incremental improvements
4. **Socratic Debugging**: Use questioning to identify root causes

### Multi-File Orchestration

Requires explicit:
- File lists with dependency ordering
- Rollback points for safety
- Coordinated system changes

## Redundancy Check

**Status**: NOVEL

Checked against registry triggers:
- "prompt engineering" → Matches general reasoning techniques but NOT code-specific frameworks
- "structured prompting" → Matches but no specific 5-component framework exists
- "code generation patterns" → No existing structured approach

**Differentiation from existing capabilities**:
- Extended Thinking: General reasoning enhancement, not code-specific structure
- Plan Mode: Broader implementation planning, not prompt structure
- CLAUDE.md: Project context, not prompt composition framework

This is a **novel technique** for structuring code generation prompts with empirical validation (first-attempt success rates, iteration counts).

## Evaluation Needs

1. Does this framework improve code generation quality measurably vs. unstructured prompts?
2. Can we create templates/examples for the 5 components?
3. Should this become a skill with prompt templates?
4. How does this integrate with existing Plan Mode workflows?
5. What's the token overhead of using the full framework vs. ad-hoc prompting?

## Potential Integration

- Create skill: `~/.claude/skills/crisp-code-prompts/SKILL.md`
- Include prompt templates for each component
- Add examples from common scenarios (API endpoints, refactoring, debugging)
- Reference from existing code generation workflows
