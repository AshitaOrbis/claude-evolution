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

## Integration Sandbox Testing + Discord Approval Gate (IMPLEMENTED 2026-04-13)

**Added**: 2026-04-13
**Priority**: High
**Triggered by**: CLAUDE_CODE_SUBPROCESS_ENV_SCRUB incident (12 days of broken permissions)

### Problem
The integration step (`INTEGRATE-APPROVED.md`) runs autonomously at 6 AM and can modify system files without human review. On 2026-04-01 it added an env var to `~/.bashrc` that broke all Claude session permissions.

### Immediate Fix (DONE)
- Added system file guard to `INTEGRATE-APPROVED.md` (NEVER modify ~/.bashrc, ~/.profile, etc.)
- Added approval gate: high-impact integrations write to `pipeline/pending-approval/` and post to Discord
- Created `pipeline/pending-approval/` directory

### Remaining Work (ALL DONE 2026-04-13)

**1. Sandbox test harness** (`scripts/sandbox-test-integration.sh`)
For env var and config integrations, the heartbeat should:
- Spawn a subprocess with the proposed env var set
- Run `claude -p --max-turns 2 --dangerously-skip-permissions -- "echo hello"` in that environment
- Verify the output contains "hello" (not permission errors)
- Report pass/fail in the proposal file
- This catches the exact failure mode from the April incident

**2. Discord approval flow**
Currently: webhook-post.sh posts one-way to Discord (no response mechanism).
Needed: The sentinel bot (Orchestrator) should:
- Watch for "APPROVAL NEEDED" embeds in #evolution
- Surface them as actionable items (reaction-based approval?)
- Or: write approval status to a file that the next heartbeat checks
- Simplest: user manually moves file from `pipeline/pending-approval/` to `pipeline/integration/` to approve

**3. Evaluation sandbox**
The evaluation step (`EVALUATE-PENDING.md`) should also test behavioral impact, not just read changelogs:
- For env vars: test in subprocess (same as integration sandbox)
- For settings changes: verify against `claude doctor` output
- Flag any evaluation that claims "zero impact" without empirical test


## Pre-Flight Holdout Safety Gate (DONE 2026-04-15)

**Added**: 2026-04-15
**Triggered by**: April optimization verification round (code-reviewer 0.525→0.314 regression in March campaign)

Implemented `pre_flight_holdout_check()` in `verification.py` and `--holdout-gate` flag in both `batch_optimize.py` and `optimize_publication_review.py`. Backs up `_latest.json` before optimization, runs holdout comparison, restores backup if new score drops >0.02. Three unit tests. Also fixed CodexModelRunner MCP config bug (tried to disable non-existent MCP servers).

## April 2026 Optimization Verification Round (DONE 2026-04-15)

Verified token-efficiency changes preserved quality. Publication-review holdouts stable or improved (opus -0.038 OK, gemini +0.024, gpt +0.001). Created 2 new datasets (writing-reviews 15+4, fact-checks 8+2). New fact-checker baseline: 0.667. Full report: `dspy-prompt-optimizer/reports/april-2026-optimization-round.md`.

**Round 2 — Remaining Work (DONE 2026-04-19)**:

1. **GeminiModelRunner output parsing fix** — DONE
   - Modified `_clean_output` to strip "YOLO mode", "Loaded cached credentials", and other CLI preamble lines
   - 5 unit tests in `tests/test_model_runners.py`
   - Verified: Gemini optimization now completes 26/26 training without parse failures (previously 0 demos)

2. **Demo transformers for writing-review and fact-checker** — DONE
   - Added `transform_writing_review_demo()` (perspective-section condensation, ~300 word cap)
   - Added `transform_factcheck_demo()` (claims table extraction, ~300 word cap)
   - Registered in TRANSFORMER_MAP and TARGET_TRANSFORMER_MAP
   - 6 unit tests in `tests/test_demo_transformers.py`

3. **Sonnet code-reviewer re-optimization** — RUN, GATE-RESTORED
   - Sonnet collected 9 demos avg 0.676 training, but holdout dropped to 0.340 (vs 0.525 baseline)
   - Pre-flight holdout gate fired correctly, restored original 0.525 demos
   - Conclusion: code-reviewer holdout dataset shifted; baseline 0.525 may not be reproducible. Needs holdout dataset audit.

4. **GPT pub-review re-optimization** — IMPROVED
   - Holdout: 0.534 → 0.596 (+0.062). Gate passed, new demos deployed.
   - Training avg 0.655, 25/26 successful (1 timeout on largest post)

5. **Gemini pub-review re-optimization** — RUN, GATE-RESTORED
   - With parsing fix: 26/26 training success, avg 0.515. Holdout 0.532 vs 0.556 baseline.
   - Gate fired (0.532 < 0.556 - 0.02), restored 0.556 demos
   - Parsing bug RESOLVED (independent benefit)

6. **Fact-checker dataset expansion via Claude fallback** — PARTIAL
   - 8+2 → 9+3 examples (modest gain)
   - Most Codex calls still timed out, Claude fallback also failed 8/10 times (likely concurrent-process resource conflict)
   - Could improve by running serially when system is idle

**Final scores after Round 2**:
| Target | Round 2 Holdout | vs Round 1 |
|--------|----------------|------------|
| publication-review-opus | 0.584 | unchanged |
| publication-review-gemini | 0.556 | unchanged (gate-restored) |
| publication-review-gpt | 0.596 | **+0.062** |
| code-reviewer | 0.525 | unchanged (gate-restored) |
| writing-review | 0.625 | unchanged |
| fact-checker | 0.667 | unchanged |

**Persistent issues for future rounds**:
- ~~Code-reviewer holdout (3 examples) is too noisy — expand to 8-10 minimum~~ DONE Round 3
- ~~Codex timeouts on >2K word blog posts — investigate xhigh reasoning effort vs default~~ DONE Round 3
- ~~Claude fallback fails under concurrent load — serialize dataset generation~~ DONE Round 3
- ~~Pre-flight gate compares against `avg_score` (training) not previous holdout~~ DONE Round 3

## April 2026 Round 3 (DONE 2026-04-19)

Cleanup round addressing all persistent issues from Round 2.

**Quick wins**:
- `transform_severity_demo` NoneType bug fixed (guard None severity → "Unknown")
- Pre-flight gate now evaluates backup prompt on same holdout data (apples-to-apples), not training avg_score
- All Round 1 + Round 2 work committed (4 commits across dspy-prompt-optimizer + claude-evolution)

**Medium-effort infrastructure**:
- **Codex timeout investigation**: reasoning_effort=medium completes 100% (137-283s), xhigh always times out, high fails on large posts. Finding documented in `dspy-prompt-optimizer/reports/codex-timeout-investigation.json`
- **Code-reviewer holdout expanded 3 → 8** with one example per category (security, code_quality, performance, error_handling, concurrency, memory, null_safety, best_practices). New baseline 0.466 Haiku on expanded set
- **Fact-checker dataset 9+3 → 15+5** with zero failures using medium reasoning effort + serial execution
- 16 tests passing (added severity None regression test)

### Implementation Summary (2026-04-13)

All three backlog items implemented:

1. **Sandbox test harness** (`scripts/sandbox-test-integration.sh`) - DONE
   - Tests env vars in isolated subprocess
   - Catches permission override, sandbox failure, and crash
   - Verified: ENV_SCRUB=1 returns `passed: false`, NO_FLICKER=1 returns `passed: true`

2. **Discord approval flow** - DONE
   - `discord/webhook-post-approval.sh` posts orange embeds with approval instructions, captures message ID
   - `scripts/check-pending-approvals.sh` polls #evolution-chat for approve/reject keywords
   - Wired into heartbeat as Step 0.9 (before evaluation)
   - Re-notifies after 3 days of no response

3. **Evaluation sandbox** - DONE
   - `EVALUATE-PENDING.md` now requires empirical safety test for env var/config items
   - Failed test forces `integration_complexity = 0`, auto-rejecting the item
   - Explicitly warns against trusting changelog descriptions without testing

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
