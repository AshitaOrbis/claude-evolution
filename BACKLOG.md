# Claude Evolution Backlog

Deferred improvements and ideas tracked from development sessions.

## ~~Prompt Optimization for Review Subagents~~ (DONE)

**Completed**: 2026-03-26
**Commits**: `b0431f5`, `9a269d8`, `47a5caa` (dspy-prompt-optimizer)

Deployed format instruction to all three prompts in `~/.claude/skills/publication-review/SKILL.md`. Built full optimization pipeline: data conversion from review-audit manifests, 3-signal hybrid matching metric (anchor entities + char n-grams + keyword Jaccard), model runners for Codex/Gemini/Claude CLIs, checkpoint-enabled optimization script.

**Results** (holdout, 3-signal hybrid metric):
- Opus 4.6: 0.669 PASS (3 demos)
- Gemini: 0.532 PASS (3 demos)
- GPT-5.4: 0.473 PASS (3 demos)

**Key learnings**:
- Anchor-based matching (entities, numbers, tech terms) is 4-7x better than Jaccard for cross-vocabulary finding comparison — documented in `library/techniques/anchor-based-paraphrase-matching-2026-03-23.md`
- Codex `exec` should disable MCP servers (`mcp_servers.*.enabled=false`) for text-generation tasks — saves 10K tokens/call
- Codex has native web search independent of MCP (controlled by `search = true` in config.toml)
- `gemini-3.1-pro-preview` has persistent capacity issues from CLI; omitting the `-m` flag uses the available default model

## Confine Agent Writes Without Bash (Security)

**Source**: Security review follow-up, 2026-06-11
**Priority**: High
**Effort**: Medium

In review-gated mode the discovery/evaluation/helper agents run without Bash
but still hold unrestricted `Write` (integration additionally holds `Edit`).
The "only write to `pipeline/`/`registry/`" rules in the prompt files are soft
instructions, not a sandbox, so prompt-injected content fetched from the web
could direct a write to `~/.claude.json`, `.env`, `.git/hooks/`, etc. Path-
scoped `--allowed-tools` rules and `permissions.deny` settings were tested and
did **not** reliably constrain `claude -p` writes (see SECURITY.md).

**Robust fix options** (pick one, validate against a real run):
- Remove `Write` from the web-fetching phases; have each agent emit its
  results as JSON on stdout and let the wrapper script persist them to
  `pipeline/` via `jq` (deterministic, no agent filesystem authority).
- Run every phase inside a disposable container / low-privilege account with a
  bind-mounted repo and no access to the real `~/.claude` config.
- Re-evaluate Claude Code sandbox/permission features once the path-glob
  enforcement semantics for `Write`/`Edit` are confirmed working.

Until one of these lands, unattended runs should follow the container/account
guidance in SECURITY.md rather than trusting the prompt-level rules.
