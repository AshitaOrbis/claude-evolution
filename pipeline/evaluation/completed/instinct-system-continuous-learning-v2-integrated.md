# Discovery: Instinct System (Continuous Learning v2)

**Source**: https://github.com/affaan-m/everything-claude-code
**Date**: 2026-02-06
**Category**: Workflow / Learning System
**Stars**: Not yet tracked (recently updated Jan 2026)

## Description

Advanced continuous learning system that extracts patterns from git history and Claude sessions, scores them with confidence levels, and allows import/export for team knowledge sharing.

### Key Features
- **Confidence-scored patterns**: Tracks reliability of extracted instincts (0.0-1.0 scale)
- **Import/Export**: Share learned behaviors across team members via JSON
- **Evolve command**: Clusters similar instincts into reusable skills
- **Pattern extraction**: Analyzes git history for coding patterns
- **Checkpoint system**: State saving for long-running sessions

### Commands
- `/instinct-status` - View confidence-scored patterns
- `/instinct-import` / `/instinct-export` - Share learned behaviors
- `/evolve` - Cluster instincts into reusable skills
- `/learn` - Extract patterns from current work
- `/checkpoint` - Save session state
- `/verify` - Continuous validation

## Redundancy Check

**Keywords searched**: "continuous learning", "pattern extraction", "confidence scoring", "knowledge sharing", "team learning", "instinct system"

**Match in registry**: Partial match with:
- `Continuous Claude v3` (3.2k stars) - Context hooks/ledgers
- `context-librarian` subagent - Archives useful info from conversations

**Classification**: **IMPROVEMENT** - More sophisticated than existing approaches

### Comparison

| Feature | Existing (context-librarian) | New (Instinct System) |
|---------|------------------------------|------------------------|
| Pattern extraction | Manual trigger | Automatic from git history |
| Confidence scoring | None | 0.0-1.0 confidence levels |
| Team sharing | Via git commits | Import/export JSON |
| Clustering | None | Auto-clustering into skills |
| Integration | Subagent call | Slash commands |
| Source | Conversations | Git history + sessions |

### Why Better
1. **Quantified reliability**: Confidence scores prevent cargo-culting bad patterns
2. **Team knowledge base**: Export/import enables distributed learning
3. **Auto-skill generation**: `/evolve` creates reusable skills from patterns
4. **Git-integrated**: Learns from actual code evolution, not just prompts
5. **Lower barrier**: Slash commands vs subagent invocation

## Integration Path

1. Install from plugin marketplace OR manual copy to `~/.claude/`
2. Add commands to `~/.claude/commands/`
3. Configure hooks for automatic pattern extraction
4. Test `/instinct-status` and `/learn` on existing project
5. Evaluate confidence scoring accuracy over 1-week trial
6. If successful, document in evolution library

## Evaluation Criteria

| Criterion | Expected Score | Notes |
|-----------|----------------|-------|
| Integration complexity | 80/100 | Plugin install OR manual copy |
| Token efficiency | 70/100 | Adds context for learned patterns, but saves re-explanation |
| Capability expansion | 85/100 | Novel confidence scoring + team sharing |
| Maintenance burden | 75/100 | Requires periodic review of confidence scores |
| Community validation | 65/100 | Part of larger collection, hackathon winner |

**Estimated Total**: ~75/100 (APPROVED for integration)

## Notes

- Requires Claude Code v2.1.0+
- Node.js for cross-platform script execution
- Git for history analysis
- Complements (not replaces) context-librarian for conversation archival

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6

### Redundancy Classification

**Match**: YES - context-librarian subagent, Continuous Claude v3
**Classification**: IMPROVEMENT (confidence scoring + team sharing + auto-clustering)

### Scoring

| Criterion | Score | Weight | Weighted | Reasoning |
|-----------|-------|--------|----------|-----------|
| Integration complexity | 80/100 | 20% | 16.0 | Plugin install OR manual copy, slash commands |
| Token efficiency | 70/100 | 25% | 17.5 | Adds context but saves re-explanation |
| Capability expansion | 85/100 | 25% | 21.25 | Confidence scoring + team sharing + auto-skill generation |
| Maintenance burden | 75/100 | 15% | 11.25 | Requires periodic confidence score review |
| Community validation | 65/100 | 15% | 9.75 | Part of larger collection, hackathon winner |

**TOTAL**: **75.75/100** ✅ APPROVED

### Decision

**APPROVE** - Instinct System provides quantified reliability (confidence scores), team knowledge sharing (import/export JSON), and auto-clustering into skills. More sophisticated than context-librarian's manual archival.

**Integration Path**:
1. Install from plugin marketplace OR manual copy to `~/.claude/`
2. Add commands to `~/.claude/commands/`
3. Configure hooks for automatic pattern extraction
4. Test `/instinct-status` and `/learn` on existing project
5. Evaluate confidence scoring accuracy over 1-week trial
6. Document in evolution library if successful

**Priority**: MEDIUM - Complements existing context-librarian, adds quantification layer
