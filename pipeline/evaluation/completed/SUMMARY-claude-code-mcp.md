# claude-code-mcp Evaluation Summary

**Date**: 2026-01-26
**Evaluator**: capability-evaluator (Opus) + codex-researcher (GPT-5)
**Decision**: ❌ **REJECT** (23.5/100)

## One-Line Summary

MCP wrapper of Claude Code CLI designed for external clients; using from within Claude Code creates recursive loop with zero value-add.

## Scoring

| Claude | Codex | Average | Threshold | Result |
|--------|-------|---------|-----------|--------|
| 23.5 | 18 | 20.75 | 70 | **REJECT** |

## Key Kill Signals

1. **Recursive redundancy**: Claude Code → MCP → Claude Code CLI spawn
2. **Zero capability expansion**: Task tool already provides agent-in-agent natively
3. **Token efficiency negative**: MCP overhead + CLI context duplication
4. **Security risk**: Requires `--dangerously-skip-permissions` in nested context

## Correct Use Case (Not Applicable Here)

This tool is EXCELLENT for its intended purpose:
- External AI models (Cursor, Windsurf, ChatGPT)
- Need to delegate to Claude Code's file/git/code capabilities
- MCP client → claude-code-mcp server → Claude Code CLI

But using it FROM WITHIN Claude Code itself is architecturally nonsensical.

## Registry Update

Added to `registry/existing-capabilities.md`:
- Section: Context Management / Multi-Agent Orchestration
- Trigger: "claude-code-mcp", "MCP claude code wrapper", "nested claude code", "recursive agent invocation"

## Full Evaluation

See: `claude-evolution/archive/rejected/claude-code-mcp-rejected.md`
