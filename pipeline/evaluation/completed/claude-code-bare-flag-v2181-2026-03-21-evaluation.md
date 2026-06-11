# Discovery: `--bare` Flag for Scripted `-p` Calls (v2.1.81)

**Source**: Claude Code v2.1.81 official release (2026-03-20)
**Discovery Date**: 2026-03-21
**Evaluated**: 2026-03-21
**Type**: Built-in CLI feature (zero integration cost)

---

## What It Is

A new `--bare` CLI flag for headless (`-p`) calls that strips all non-essential startup overhead:

```bash
# Before: normal -p call loads hooks, LSP, plugins, skills, memory
claude -p "summarize this file"

# After: --bare skips all of that
claude -p --bare "summarize this file"
```

**What `--bare` skips:**
- All hooks (PreToolUse, PostToolUse, Stop, StopFailure, etc.)
- LSP initialization
- Plugin sync
- Skill directory walks (`.claude/skills/` not loaded)
- OAuth and keychain auth (requires `ANTHROPIC_API_KEY` or `apiKeyHelper` via `--settings`)
- Auto-memory (fully disabled)

**What it retains:**
- Full native tool access (Read, Write, Edit, Bash, Grep, etc.)
- MCP tool access
- Normal model behavior

---

## Why It Matters

Different from existing capability **CLAUDE_CODE_SIMPLE** (env var):
- `CLAUDE_CODE_SIMPLE=1`: Restricts tools to Read/Edit/Glob/Grep+Bash; also disables MCP, attachments, hooks, CLAUDE.md
- `--bare`: Full tool access; skips hooks/LSP/skills/memory/auth overhead at startup

They are complementary — different tradeoffs for different automation scenarios.

**Key use cases:**
1. CI/CD one-shot queries where hooks would cause unintended side effects
2. Cost-sensitive heartbeat sub-calls (no hook overhead, no skill loading delay)
3. Ultra-fast scripted automation where startup time matters
4. Sandboxed contexts where hook bypass is intentional

---

## Redundancy Check

| Trigger | Match | Notes |
|---------|-------|-------|
| CLAUDE_CODE_SIMPLE | COMPLEMENTARY | Different tradeoff: SIMPLE restricts tools; --bare keeps full tools, skips overhead |
| headless mode | NOVEL | No prior "skip startup overhead" flag exists |
| bare flag | NOVEL | First explicit bare/minimal startup mode |

---

## Scoring

| Criterion | Weight | Score | Notes |
|-----------|--------|-------|-------|
| Integration complexity | 20% | 100 | Zero — built-in flag, no config, no setup |
| Token efficiency impact | 25% | 65 | Skips skill/CLAUDE.md loading = less context per call |
| Capability expansion | 25% | 80 | Novel: no existing equivalent for hook-free full-tool scripted calls |
| Maintenance burden | 15% | 100 | Zero — built-in CLI feature |
| Community validation | 15% | 100 | Official Anthropic release (v2.1.81) |

**Weighted Score**: (100×0.20) + (65×0.25) + (80×0.25) + (100×0.15) + (100×0.15)
= 20 + 16.25 + 20 + 15 + 15 = **86.25/100** → **APPROVED**

---

## Integration Plan

1. Add to registry under Token Efficiency > Tool Loading Optimization: `--bare flag | IMPLEMENTED (v2.1.81) | claude -p --bare "..." | Skips hooks/LSP/skills/memory; retains full native + MCP tools`
2. Update `helpers/commands/heartbeat-commands.md` with `--bare` pattern for cost-sensitive sub-calls
3. Note in `~/.claude/CLAUDE.md` that `--bare` is the preferred flag for automated scripted -p calls where hooks would cause side effects
4. Add to existing CLAUDE_CODE_SIMPLE documentation as a comparison/complement

---

## Key Constraint

- Requires `ANTHROPIC_API_KEY` or `apiKeyHelper` configured (Max plan keychain bypass skipped)
- On Max plan without API key, use `claude -p` without `--bare` (keychain handles auth)
- Auto-memory disabled means no memory writes during `--bare` calls — desired for automation
