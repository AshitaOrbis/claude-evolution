# GPT-5.3-Codex-Spark Model Release

**Discovery Date**: 2026-02-15
**Source**: Simon Willison's Weblog (Feb 12, 2026)
**Type**: Model Release
**Category**: AI Models / Codex

## Summary

OpenAI announced GPT-5.3-Codex-Spark, a new specialized coding model in the Codex family.

## Key Information

- **Model**: GPT-5.3-Codex-Spark
- **Announced**: February 12, 2026
- **Source**: Simon Willison (high-signal AI news curator)

## Integration Potential

**Score Estimate**: N/A (Monitoring Item)

**Status**: MONITOR

**Why Monitor**:
- Codex integration already exists via `mcp__codex__codex`
- New model version may offer better performance
- Need to check if MCP automatically uses new model or requires update

**Actions**:
1. Check if `mcp__codex__codex` MCP supports GPT-5.3-Codex-Spark
2. If yes: Test performance vs GPT-5.2-Codex (current default)
3. If better: Update default model in `~/.codex/config.toml`
4. If MCP doesn't support: Check for MCP update

**Redundancy Check**:
- ✅ Codex integration exists (mcp__codex__codex)
- This is VERSION UPGRADE, not new capability

## Classification

**Status**: VERSION TRACKER (not a discovery, just model release monitoring)

**Next Steps**:
1. Check Codex MCP documentation for supported models
2. Test GPT-5.3-Codex-Spark if available
3. Update model selection guide if performance improved

## Links

- Announcement: https://simonwillison.net/2026/Feb/12/codex-spark/
