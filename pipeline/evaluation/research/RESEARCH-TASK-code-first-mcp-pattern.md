# Research Task: Code-First Pattern for MCP Servers

**Evaluation Score**: 85.5/100
**Source**: pipeline/evaluation/completed/code-first-mcp-pattern-evaluation.md
**Created**: 2026-02-06
**Due**: 2026-02-13 (within 7 days)
**Owner**: capability-discoverer or web-researcher

## Blocker Identified

**Type B: Validation Blocker**

Need to verify the 98% token reduction claim and understand pattern mechanics before integration. The evaluation noted this as "CRITICAL before integration" due to uncertainty about applicability to our existing MCP servers and potential conflicts with Tool Search Tool.

## Research Questions

1. **What is the Code-First Pattern and how does it work?**
   - How to investigate:
     - Fetch https://github.com/orgs/modelcontextprotocol/discussions/629
     - Find and read Anthropic's "Code execution with MCP" blog post
     - Understand how code execution replaces JSON schemas
   - Success criteria: Pattern mechanics fully understood, token reduction claim validated with evidence
   - Estimated effort: 30-45 minutes

2. **Is the pattern complementary or duplicate to Tool Search Tool?**
   - How to investigate:
     - Compare pattern mechanism against Tool Search Tool (85% reduction via dynamic loading)
     - Determine if both can coexist or if they conflict
     - Understand if reductions compound (98% × 85%) or if one supersedes the other
   - Success criteria: Clear answer on whether both can be used together
   - Estimated effort: 30 minutes

3. **How does this apply to existing MCP servers?**
   - How to investigate:
     - Check if brave-search, exa, better-playwright, gemini MCPs can benefit
     - Determine if this is for custom MCP development only or can be retrofitted
     - Identify if Claude Code already supports this pattern or if server-side changes are needed
   - Success criteria: Confirmed applicability and integration path documented
   - Estimated effort: 30-45 minutes

4. **What is the community implementation at 112 GitHub tools?**
   - How to investigate:
     - Find the community implementation mentioned in the discussion
     - Review implementation details and real-world token reduction metrics
     - Check for any caveats or limitations discovered by early adopters
   - Success criteria: Real-world validation of 98% claim, implementation examples found
   - Estimated effort: 30 minutes

## Expected Outcomes

After research, one of the following should be determinable:

- [ ] **Approve** - Move to `pipeline/integration/` with integration playbook (final score 70+)
  - Create `~/.claude/skills/code-first-mcp/SKILL.md` documenting pattern
  - Update `registry/existing-capabilities.md` with new technique
  - Update MCP-related documentation with pattern guidance

- [ ] **Reject** - Move to `archive/` (final score <50)
  - If 98% claim is invalid or pattern duplicates Tool Search Tool
  - If pattern requires unsupported client-side changes
  - If pattern only applies to custom MCP development and we don't build MCPs

- [ ] **Deprioritize** - Move to `pipeline/future/` with reconsideration trigger
  - If pattern requires Claude Code updates not yet released
  - If pattern is valid but not applicable to our current MCP usage

## Success Criteria

Research is complete when:
1. ✅ All 4 research questions answered with evidence (links, screenshots, test results)
2. ✅ Updated evaluation report created with research findings
3. ✅ Final score recalculated based on research results
4. ✅ Integration playbook drafted (if approved) or rejection rationale documented
5. ✅ Decision made (approve/reject/deprioritize) with clear justification

## Total Estimated Effort

- **Total**: 2-2.5 hours
- **Type**: B (Validation Blocker - moderate research)
- **Timeline**: Should complete within 7 days (by 2026-02-13)

## Related Documents

- Original evaluation: `pipeline/evaluation/completed/code-first-mcp-pattern-evaluation.md`
- Integration report: `integrations/technique/code-first-mcp-pattern-integration.md`
- Source discovery: https://github.com/orgs/modelcontextprotocol/discussions/629
- Helper: `helpers/playbooks/integration-blocker-classification.md`
- Helper: `helpers/templates/research-task-template.md`

## Next Actions

1. Assign to `web-researcher` subagent or `capability-discoverer` subagent
2. Execute research questions in sequence
3. Update evaluation report with findings
4. Calculate final score and make decision
5. Move to appropriate pipeline directory based on decision
