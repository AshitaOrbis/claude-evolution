# Discovery: Wake MCP - Terminal Session Context for Claude Code

- **Source**: https://github.com/joemckenney/wake
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Wake captures terminal session context via PTY and shell hooks, stores everything in SQLite, and exposes it through an MCP server. Claude Code can then query terminal history directly instead of requiring manual output pasting.
- **Potential Value**: High
- **Integration Complexity**: Medium

## Description

Wake is a Rust-based tool that automatically captures terminal commands and output through PTY (pseudo-terminal) spawning and shell hooks (supports Zsh and Bash). All session data is stored locally in SQLite at `~/.wake/` for privacy, and the system exposes this through an MCP server allowing Claude Code to directly access terminal history.

**Workflow**: Run `wake shell`, work normally in terminal, and Claude Code automatically gains visibility into session context without manual copying.

**Key Features**:
- Automatic command and output capture via shell hooks
- Local SQLite storage for privacy
- MCP server integration for Claude Code queries
- Zero manual copying required
- Supports Zsh and Bash shells

## Redundancy Check

**Status**: NOVEL

**Registry Check**:
- Searched for: "terminal context", "shell history MCP", "PTY capture", "session capture", "command history mcp"
- No existing capability matches this functionality
- Bash tool provides shell execution but doesn't capture persistent session context
- No existing MCP provides automatic terminal history querying

**Key Differentiator**: This is the first tool that creates a persistent, queryable context of terminal sessions accessible via MCP. Different from:
- Bash tool (one-shot execution, no persistent context)
- TodoWrite (task tracking, not terminal context)
- Memory systems (conversational memory, not terminal session capture)

## Evaluation Needs

1. **Token efficiency**: How much context does a typical terminal history query consume?
2. **Privacy concerns**: SQLite storage is local, but what data is captured? Passwords? Secrets?
3. **Performance impact**: Does PTY wrapping affect shell performance?
4. **Integration effort**: How difficult is MCP server setup and Claude Code integration?
5. **Maintenance**: Is the project actively maintained? (Check GitHub activity)
6. **Use cases**: When would Claude need terminal context vs. just re-running commands?
7. **Comparison**: How does this compare to just using `history` command or manual output copying?
8. **Security**: What happens if sensitive commands are captured (API keys, passwords)?

## Potential Integration Blockers

- **Security**: Need to evaluate data capture policies and filtering mechanisms
- **Privacy**: Ensure no sensitive data leakage (credentials, API keys, secrets)
- **Compatibility**: WSL environment compatibility (may need testing)
- **Resource usage**: SQLite database growth over time

## Initial Assessment

This appears to be a genuinely novel capability that could reduce friction in Claude Code workflows by eliminating manual output copying. The automatic context capture could be especially valuable for debugging sessions where Claude needs to see the full history of what was tried.

**Approval indicators**:
- Novel capability (no existing tool does this)
- Addresses real friction point (manual copying)
- Local-first privacy model
- Active GitHub repository (check stars/activity)

**Concerns**:
- Security/privacy implications need careful evaluation
- Token efficiency unclear
- May encourage lazy prompting instead of explicit context