# Claude Code 2.1.x Hook Matcher Compatibility — Exact-Match Audit

**Source**: https://raw.githubusercontent.com/anthropics/claude-code/main/CHANGELOG.md
**Date**: 2026-06-28 (integrated 2026-07-19)
**Type**: doc-update (compatibility note + audit checklist)
**Score**: 72.25/100 (approved 2026-07-03)

## The Behavior Change

Claude Code **2.1.195** fixed hook matchers containing hyphenated identifiers so they
**exact-match instead of substring-match**. Before the fix, a matcher like
`mcp__brave-search` could fire for any tool name containing that substring; after it,
the matcher fires only on an exact tool-name match.

Consequence: hook configs written under the old behavior may have **silently lost
coverage**. A matcher that used to catch `mcp__brave-search__brave_web_search`,
`mcp__brave-search__brave_news_search`, etc. via substring now matches none of them —
the hook simply stops firing, with no error.

## Audit Checklist

Run this against every `hooks` block in `~/.claude/settings.json`, project
`.claude/settings.json`, and plugin-declared hooks:

1. **Find hyphenated matchers.** Any matcher string containing `-` (MCP server names
   are the usual case: `brave-search`, `gemini-cli`, `better-playwright`).
2. **Check for implicit-prefix reliance.** If the matcher names a server but the intent
   was "all tools of that server," rewrite it as an explicit wildcard pattern:
   `mcp__brave-search__.*` — patterns, unlike bare strings, keep their meaning.
3. **Verify each hook still fires** — empirically, not by reading the config: trigger a
   matching tool call and confirm the hook ran (log line, side-effect file). Silent
   non-firing is the failure mode being hunted.
4. **Sweep for obsolete workaround assumptions** while in there: hooks or scripts
   compensating for MCP auth flakiness predate 2.1.193's auth-helper reconnect on
   401/403 (see the 2.1.193/195 registry entry) and may now be dead scaffolding —
   candidates for the prune-constraints audit.

## Rule of Thumb Going Forward

Write hook matchers as **explicit regex patterns** whenever the intent is a family of
tools; reserve bare strings for genuinely single-tool matchers. Exact-match semantics
make bare strings precise but brittle against "all tools of server X" intent.

**Tags**: `claude-code-hooks`, `hook-matchers`, `exact-match`, `v2.1.195`,
`mcp-tool-names`, `silent-failure`, `config-audit`
