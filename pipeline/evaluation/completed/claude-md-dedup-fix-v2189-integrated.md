{
  "title": "Nested CLAUDE.md Re-injection Deduplication Fix (v2.1.89)",
  "source": "https://github.com/anthropics/claude-code/releases/tag/v2.1.89",
  "type": "technique",
  "description": "Bug fix in v2.1.89: nested CLAUDE.md files (project-level, subdirectory-level) that were being re-injected repeatedly in long sessions are now deduplicated. In large codebases with multiple nested CLAUDE.md files (e.g., per-service configs in a monorepo), the prior behavior caused silent context bloat — each CLAUDE.md was re-injected on each tool use. The fix is passive (no configuration change needed). Understanding the prior behavior explains unexpected context exhaustion in long monorepo sessions.",
  "discovered_at": "2026-04-05",
  "keywords": ["CLAUDE.md", "nested", "deduplication", "context-leak", "token-bloat", "monorepo", "long-session", "bug-fix", "context-management", "re-injection"]
}

## Redundancy Check

- Not present in registry (searched "CLAUDE.md.*inject", "nested.*dedup", "context.*leak" — no matches).
- Existing related capability: Compact with Instructions (manual compaction guidance) and Rules Directory (conditional loading). Neither addresses re-injection deduplication specifically.
- Classification: **NOVEL** — patch-level behavior change with material impact on monorepo sessions.

## Verification Status

**CONFIRMED** — Fetched v2.1.89 release notes directly (2026-04-05).

Exact changelog text:
> "Fixed nested CLAUDE.md files being re-injected dozens of times in long sessions that read many files"

Adjacent releases checked:
- v2.1.90: Separate issue — "Fixed collapsed search/read summary badge appearing multiple times in fullscreen scrollback when a CLAUDE.md file auto-loads during a tool call" (UI artifact, different root cause)
- v2.1.91: No CLAUDE.md/injection content

---

## Evaluation (2026-04-05)

```json
{
  "evaluation": {
    "scores": {
      "integration_complexity": 100,
      "token_efficiency": 70,
      "capability_expansion": 40,
      "maintenance_burden": 100,
      "community_validation": 100
    },
    "total": 77.5,
    "decision": "APPROVED",
    "reasoning": "Passive fix — zero config, zero maintenance, automatic in v2.1.89+. Official Anthropic release (100 community). Token efficiency scored 70 (minor-to-significant): workspace has 3 nested CLAUDE.md files (~/.claude/, ~/claudeworkspace/, ~/claudeworkspace/claude-evolution/) — in very long file-intensive sessions these were being re-injected 'dozens of times', which explains past context exhaustion on long sessions. Capability expansion scored low (40) because this is a bug fix, not new capability; primary value is explanatory (past behavior) + registry documentation. Integration action: registry-only update, no code/config change needed. Already active since upgrade past v2.1.89."
  }
}
```

## Integration Instructions

**Action required: Registry update only.** Fix is automatic in v2.1.89+ (already running).

1. Add entry to `registry/existing-capabilities.md` under Context Management section
2. Add redundancy triggers: "CLAUDE.md re-injection", "nested CLAUDE.md dedup", "CLAUDE.md context bloat", "re-injected CLAUDE.md"
3. Note in context management docs: long sessions with many file reads no longer bloat from repeated CLAUDE.md injection
4. No `~/.bashrc`, settings.json, or config changes needed
