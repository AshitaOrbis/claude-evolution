# Evaluation: Xcode 26.3 MCP Server (xcrun mcpbridge)

- **Date**: 2026-03-01
- **Evaluator**: Claude Opus 4.6 + Codex GPT-5 cross-validation
- **Source**: Official Apple toolchain (Xcode 26.3)
- **Category**: MCP Server (IDE integration)

## Redundancy Check

**Classification**: NOVEL — no existing Apple IDE integration in registry.

## Scoring

| Criterion | Weight | Claude Score | Codex Score | Final | Rationale |
|-----------|--------|-------------|-------------|-------|-----------|
| Integration complexity | 20% | 0 | 0 | 0 | **PLATFORM BLOCKED**: macOS only, we run WSL/Linux |
| Token efficiency impact | 25% | 50 | 60 | 50 | Neutral — local build/test reduces context but not applicable |
| Capability expansion | 25% | 90 | 95 | 90 | Genuinely novel Apple IDE integration via MCP |
| Maintenance burden | 15% | 90 | 85 | 90 | Official Apple toolchain — minimal maintenance |
| Community validation | 15% | 100 | 100 | 100 | Official Apple release, Anthropic partnership |

**Final Score: 63.5/100**

## Cross-Validation Notes

- **Codex confirmed** the platform blocker and FUTURE recommendation.
- **Spec gap noted**: `xcrun mcpbridge` may omit required `structuredContent` for some tools; wrapper projects exist (pypi: `mcpbridge-wrapper`).
- **Documentation sparse**: Apple hasn't published detailed MCP docs; confirmations from third-party sources (InfoQ, Ars Technica, individual blogs).
- **Codex scored capability expansion slightly higher** (95 vs 90) due to deep project control (tests, previews, docs). Reconciled at 90 since we can't test it.

## Decision: FUTURE (63.5/100 — platform blocked)

Move to `pipeline/future/`. High-quality official integration but unusable on current Linux/WSL environment.

### Adoption Triggers

- macOS machine available with Xcode 26.3+
- iOS/macOS development workflow initiated
- Remote macOS access (e.g., Mac Mini via Tailscale)

### If Adopting Later

```bash
# On macOS with Xcode 26.3+:
claude mcp add --transport stdio xcode -- xcrun mcpbridge
```

### Environment Detection

```bash
# Projects can detect Xcode vs pure Claude Code:
if echo "$CLAUDE_CONFIG_DIR" | grep -q "Xcode/CodingAssistant"; then
  echo "Running in Xcode 26.3+ Claude Agent SDK"
fi
```

## Redundancy Triggers

"xcode mcp", "xcrun mcpbridge", "apple ide mcp", "xcode agent", "xcode 26.3",
"ios development mcp", "macos development mcp", "apple agentic coding", "xcode coding agent"
