# Discovery: Fan-Out Scaling Workflow

- **Source**: https://smartscope.blog/en/generative-ai/claude/claude-code-best-practices-advanced-2026/
- **Date Found**: 2026-02-06
- **Category**: technique
- **Summary**: Pattern for scaling operations across large codebases by tuning prompts on 2-3 representative files, then deploying to full file set with restricted permissions. Prevents token waste and incorrect changes across dozens of files.
- **Potential Value**: High
- **Integration Complexity**: Medium

## Description

The Fan-Out Scaling Workflow is a three-phase approach for applying changes across many similar files:

**Phase 1: Sample Selection (Manual)**
- Identify 2-3 representative files that cover edge cases
- Choose files that exemplify patterns to preserve/change

**Phase 2: Prompt Tuning (Iterative)**
- Run Claude on sample files only
- Refine prompt until changes are correct on all samples
- Verify edge cases are handled properly
- Final prompt becomes the "golden template"

**Phase 3: Scaled Deployment (Restricted)**
- Apply golden prompt to full file set
- Use read-only permissions on unrelated files to prevent scope creep
- May use hooks to enforce file path restrictions
- Review changes in batch before committing

**Why this matters**:
- **Token efficiency**: Iterating on 3 files vs 30 saves 90% of tokens during tuning
- **Correctness**: Catching edge cases early prevents cascading errors
- **Safety**: Restricted permissions prevent Claude from modifying adjacent code
- **Verification**: Easier to validate 3 files thoroughly than 30 partially

**Example use cases**:
- Migrating API patterns across 50 endpoint files
- Updating import statements across 40 modules
- Refactoring error handling across 30 service files
- Applying security fixes across 25 authentication handlers

## Redundancy Check

**Status**: NOVEL

Checked against registry:
- **Batch processing**: Listed via `batch-orchestrator` subagent for "programmatic tool calling"
- **Multi-file aggregation**: Listed as context management pattern
- **Subagent delegation**: For multi-step tasks

**Key distinction**:
- `batch-orchestrator` is about RESULT AGGREGATION (summarize results without polluting context)
- Fan-Out Scaling is about PROMPT REFINEMENT + SCALED APPLICATION (tune on subset, deploy to all)

The pattern addresses a different problem: how to safely apply a complex transformation across many files without wasting tokens on failed attempts or causing unintended changes.

This is complementary to batch-orchestrator, not redundant. You might use BOTH:
1. Fan-out to tune the prompt (this pattern)
2. batch-orchestrator to execute at scale without context pollution

## Evaluation Needs

1. **Workflow tooling**: Should this be a slash command, subagent, or manual workflow?
2. **Sample selection**: Can this be automated (ML clustering, AST similarity)?
3. **Golden prompt storage**: Where to save tuned prompts for reuse?
4. **Permission enforcement**: Use hooks, CLAUDE.md, or manual file selection?
5. **Metrics**: Compare token usage and error rates vs direct full-scale application
6. **Scale thresholds**: At what file count does this pattern become valuable (5? 10? 20?)

## Integration Path

If approved:
- **Skill**: `~/.claude/skills/fan-out-scaling/SKILL.md` with workflow steps
- **Command**: `/scale-operation` slash command to guide the process
- **Hook**: Optional PreToolUse hook to enforce file restrictions during Phase 3
- **Template**: Golden prompt storage in `.claude/templates/scaled-operations/`
- **Best practices**: Guidelines on sample selection and validation
