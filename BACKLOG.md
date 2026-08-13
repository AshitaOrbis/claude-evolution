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

## Integration Sandbox Testing + Approval Gate (PARTIALLY SHIPPED — see status per part)

**Added**: 2026-04-13
**Priority**: High
**Triggered by**: CLAUDE_CODE_SUBPROCESS_ENV_SCRUB incident (12 days of broken permissions)
**Disposition corrected**: 2026-08-12 (`claude.approval_gate_not_published_04`)

> **Status honesty.** This section previously read IMPLEMENTED / ALL DONE while
> naming programs that were not in this repository at all. They are not included
> in this repository, so a reader cloning this repo and enabling
> autonomous mode believed a safeguard was present that the published bytes
> could not run. What each part's status actually is, in THIS tree, is stated
> below, and `publish.sh` now fails the publish if any executable named by the
> control-plane docs is missing from it.

### Problem
The integration step (`INTEGRATE-APPROVED.md`) runs autonomously and can modify system files without human review. On 2026-04-01 it added an env var to `~/.bashrc` that broke all Claude session permissions.

### Immediate Fix (SHIPPED)
- System file guard in `INTEGRATE-APPROVED.md` (NEVER modify ~/.bashrc, ~/.profile, etc.)
- Approval gate: high-impact integrations stop and write a proposal to `pipeline/pending-approval/` instead of applying
- `scripts/evolution-daily.sh` refuses `EVOLUTION_AUTONOMOUS=1` outright when the sandbox test harness is absent

**1. Sandbox test harness** (`scripts/sandbox-test-integration.sh`) — **SHIPPED**
For env var and config integrations:
- Spawns a subprocess with the proposed env var set
- Runs `claude -p --max-turns 2 --dangerously-skip-permissions` on a trivial Bash task in that environment
- Verifies the output contains the expected marker (not permission errors)
- Reports structured pass/fail JSON for the proposal file
- This catches the exact failure mode from the April incident

**2. Automated approval flow (Discord)** — **NOT IN THIS REPOSITORY**
A chat-bot round trip (post "APPROVAL NEEDED", read a reaction, apply on approve)
is not included in this repository, and nothing in this tree calls it. The shipped
approval mechanism is the file-based one, and it is the whole gate here:
- The integration agent stops and writes `pipeline/pending-approval/{item}.proposal.md`
- A human reads it and moves the record to `pipeline/integration/` to approve
- Nothing auto-applies. There is no approval poller in this tree, by design

**3. Evaluation sandbox** — **SHIPPED (prompt-level)**
`EVALUATE-PENDING.md` requires an empirical safety test for env var/config items:
- For env vars: test in a subprocess via the sandbox harness above
- A failed test forces `integration_complexity = 0`, which auto-rejects the item
- Explicitly warns against trusting changelog descriptions without testing
- Note this is a prompt rule enforced by the evaluating agent, not by the wrapper


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

### Implementation Summary (2026-04-13, statuses corrected 2026-08-12)

1. **Sandbox test harness** (`scripts/sandbox-test-integration.sh`) - SHIPPED HERE
   - Tests env vars in an isolated subprocess
   - Catches permission override, sandbox failure, and crash
   - Verified: ENV_SCRUB=1 returns `passed: false`, NO_FLICKER=1 returns `passed: true`

2. **Automated chat approval flow** - NOT IN THIS REPOSITORY
   - The bot round trip (post an approval request, read the response, apply on approve)
     is not included in this repository
   - No file in this tree invokes it
   - What ships here is the file-based gate: propose into `pipeline/pending-approval/`,
     a human moves the record to `pipeline/integration/` to approve, nothing auto-applies

3. **Evaluation sandbox** - SHIPPED HERE (prompt-level)
   - `EVALUATE-PENDING.md` requires an empirical safety test for env var/config items
   - Failed test forces `integration_complexity = 0`, auto-rejecting the item
   - Explicitly warns against trusting changelog descriptions without testing

## Confine Agent Writes Without Bash (Security)

**Source**: Security review follow-up, 2026-06-11
**Priority**: High (interim mitigation landed; robust fix still open)
**Effort**: Medium

In review-gated mode the discovery/evaluation/helper agents run without Bash
but still hold unrestricted `Write` (integration additionally holds `Edit`).
The "only write to `pipeline/`/`registry/`" rules in the prompt files are soft
instructions, not a sandbox, so prompt-injected content fetched from the web
could direct a write to `~/.claude.json`, `.env`, `.git/hooks/`, etc. Path-
scoped `--allowed-tools` rules and `permissions.deny` settings were tested and
did **not** reliably constrain `claude -p` writes (see SECURITY.md).

**Interim mitigation (IMPLEMENTED 2026-06-22)**: a `PreToolUse`
write-confinement hook (`.claude/hooks/block-sensitive-writes.sh`, wired in
`.claude/settings.json` for `Write|Edit|MultiEdit|NotebookEdit`) blocks
(exit 2) any write whose resolved target is on the sensitive-path denylist
(`~/.claude`, `~/.claude.json`, `.env`/`.env.*`, `.git/hooks/`, `~/.ssh`,
`~/.config`) or lands outside the repo tree. This is weaker than removing
`Write` — it is a path denylist, so it cannot catch every indirect write (new
symlink → later write through it, TOCTOU swap, or any write funneled through
`Bash` in autonomous mode). The robust fix below is still the target.

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

---

## Approval gate: two divergent copies of the approval poller

Noted 2026-08-02 during the executor truth-ledger work (out of scope there,
deliberately not fixed). Rewritten 2026-08-12 so it stops pointing readers at
files this repository does not carry (`claude.approval_gate_not_published_04`).

The chat-based approval poller is one of the components that is **not published
here** (see the sandbox/approval section above). Two copies of it exist in the
maintainer's private checkouts and have diverged by ~700 diff lines; the one that
actually runs on the schedule is not the one that sits beside the executor, so
approval authority cannot be reasoned about from either copy alone.

Consequence for a reader of this repository: nothing here polls for approvals, and
the file-based gate above is the whole mechanism. Consequence privately: decide
which copy is canonical and make the other a thin caller — do not merge the
checkouts. Tracked in the private backlog, not here, because neither file ships.
