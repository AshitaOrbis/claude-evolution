# Fan-Out Scaling Workflow

Pattern for safely applying changes across many similar files. Tune prompts on a small sample, then deploy at scale.

## When to Use

- Migrating API patterns across 10+ endpoint files
- Updating imports/exports across many modules
- Applying security fixes across multiple handlers
- Any repetitive transformation across similar files

## Three Phases

### Phase 1: Sample Selection
- Pick 2-3 representative files covering edge cases
- Include both typical and unusual patterns

### Phase 2: Prompt Tuning
- Run Claude on sample files only
- Refine until changes are correct on all samples
- This becomes the "golden prompt"

### Phase 3: Scaled Deployment
- Apply golden prompt to full file set
- Use `batch-orchestrator` subagent to avoid context pollution
- Consider PreToolUse hooks to restrict file access scope
- Review changes in batch before committing

## Benefits

- **Token efficiency**: Iterating on 3 files vs 30 saves 90% during tuning
- **Correctness**: Edge cases caught early, not at scale
- **Safety**: Restricted permissions prevent scope creep
- **Verification**: Easier to validate 3 files thoroughly than 30 partially

## Scale Threshold

Worth using when transforming **10+ files**. Below that, direct application is fine.
