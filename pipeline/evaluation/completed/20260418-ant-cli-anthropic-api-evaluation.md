# ant CLI (April 18 entry) — Evaluation

- **Source**: https://platform.claude.com/docs/en/release-notes/overview (third occurrence)
- **Type**: Skill / CLI tool
- **Discovered**: 2026-04-18
- **Evaluated**: 2026-04-19

## Decision: REJECT (DUPLICATE)

This is the **third pending entry** for the same tool. Resolution history:

| Entry | Date | Decision |
|-------|------|----------|
| `20260414-ant-cli.json` | 2026-04-14 → 2026-04-15 | **REJECTED** (score 48.75) |
| `20260416-ant-cli.json` | 2026-04-16 | Pending — should inherit rejection |
| `20260418-ant-cli-anthropic-api.json` | 2026-04-18 | **REJECT-DUPLICATE** (this entry) |

The 2026-04-15 rejection resolved the dispositive question via official docs and GitHub issue #39903:

> `ant` CLI strictly requires `ANTHROPIC_API_KEY`. Max plan keychain credentials (CLAUDE_CODE_OAUTH_TOKEN) do **not** work — `ant` uses the X-Api-Key header path, not OAuth bearer. Every `ant` call is billed at API token rates; Max plan subscription does not cover it.

Today's verification of Task Budgets docs (which use `ant` in their CLI examples) confirms the same auth model is still in force — the `ant beta:messages create` example shows `--beta` flags but no Max-plan-compatible auth path.

## Recommended Cleanup

1. Move this file to completed/ with this rejection note (done).
2. Apply same rejection to `20260416-ant-cli.json` — defer to the 2026-04-15 evaluation; do not re-score.
3. Add a registry note in `registry/existing-capabilities.md` to **suppress future ant CLI discoveries** until the auth model changes — e.g., a one-line entry "ant CLI: REJECTED 2026-04-15 (API-key-only, blocks Max plan). Re-evaluate only if Anthropic adds OAuth/keychain support."

## Re-evaluation Trigger

Re-evaluate `ant` CLI **only** when one of:
- Anthropic adds OAuth/Max-plan keychain support to `ant`
- Max plan adds an issued ANTHROPIC_API_KEY in the user's account
- The discovery source flags this specific change in the changelog

## Cross-Validation Note

Codex MCP unreachable. Not required — this is a duplicate-rejection administrative action, not a fresh capability evaluation.
