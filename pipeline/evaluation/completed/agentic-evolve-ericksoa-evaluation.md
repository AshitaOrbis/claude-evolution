# Evaluation: agentic-evolve (Evolutionary Algorithm Framework)

- **Date**: 2026-02-06
- **Source**: https://github.com/ericksoa/agentic-evolve
- **Category**: NOVEL
- **Automated**: Yes (daily heartbeat)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 70 | Requires Python 3.10+, Claude Agent SDK, virtual environment, project structure setup |
| Token efficiency impact | 25% | 60 | Multiple specialized agents per generation (token-heavy), though runs as external process |
| Capability expansion | 25% | 85 | Genuinely novel - evolutionary algorithm optimization not covered by existing capabilities |
| Maintenance burden | 15% | 60 | External dependency with 8 specialized agents, requires SDK updates |
| Community validation | 15% | 50 | Very low adoption (23 stars, 2 forks), early-stage project |

- **Claude Score**: 66.75/100
- **Codex Score**: N/A (Codex MCP unavailable)
- **Final Score**: 66.75/100

## Decision

**NEEDS_RESEARCH** — Novel capability but below approval threshold (70). Low community validation and limited use case overlap with our capability discovery mission.

## Research Questions

1. **Use case alignment**: When would we need evolutionary algorithm optimization?
   - Potential: Optimizing subagent prompts for token efficiency
   - Potential: Evolving heartbeat automation scripts for reliability
   - Gap: Not aligned with core capability discovery mission

2. **Community maturity**: Why only 23 stars after public release?
   - Project announced with claims of 14,000x improvements
   - Low adoption suggests limited real-world utility or documentation issues
   - Monitor for growth before reconsidering

3. **Integration effort vs value**: Is the setup complexity justified?
   - Requires separate virtual environment
   - Needs Claude Agent SDK (additional dependency)
   - Complex multi-agent orchestration
   - Value proposition unclear for our use cases

4. **Alternative approaches**: Can we achieve similar outcomes simpler?
   - Manual prompt optimization with Codex feedback
   - A/B testing different approaches
   - DSPy for prompt optimization (lighter weight)

## Integration Notes

**IF approved after research**:
- Create isolated Python environment in `~/venvs/agentic-evolve`
- Install as optional tool, not core capability
- Document specific use cases where evolution is warranted
- Test on subagent prompt optimization before broader use

**Important Distinction**:
- **agentic-evolve**: Optimizes algorithms/code through genetic programming
- **claude-evolution** (our system): Discovers and integrates new tools/capabilities
- These are orthogonal missions with similar naming (coincidental)

## Future Reconsideration Triggers

Monitor for:
- Star count growth to 200+ (indicates broader adoption)
- Integration with official Claude Code features
- Simplified installation (fewer dependencies)
- Clear use cases aligned with capability discovery
- Prompt optimization as core feature (DSPy integration)

## Recommendation

**HOLD** - File as `pipeline/evaluation/completed/` with NEEDS_RESEARCH status. Keep in pending until:
1. Community validation improves (200+ stars)
2. Clear use case emerges (prompt optimization needs)
3. Integration complexity decreases

Not rejected because capability is genuinely novel, but not approved because value proposition unclear and adoption too low.
