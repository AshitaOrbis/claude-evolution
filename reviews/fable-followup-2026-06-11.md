# Fable 5 Adversarial Follow-up Review — 2026-06-11

Independent blind re-review (Claude Fable 5, general-purpose agent, no
knowledge of the prior GPT-5.5 Pro review or the fixes applied). Archived
verbatim.

---

## Adversarial Re-Review: `claude-evolution`

This repo was already hardened against an external review (`reviews/gptpro-2026-06-11.md`, 5×P1 + 7×P2). I verified each prior fix is genuinely applied in the current tree (they are — flock locks, private runtime dir, PID integer validation, pinned npx version, loopback-only DevTools instruction, NUL-delimited `find`, `grep -E --`, terminal-escape sanitization, Discord redaction, generic path regex). My job was to find what survived or got introduced. No P0s. The wrapper scripts are notably well-written. The remaining issues are architectural-residual and documentation-accuracy.

### P1 — Default ("review-gated") mode grants unrestricted filesystem Write to an agent ingesting attacker-controlled web content; the "write only to pipeline/registry" policy is unenforced
Evidence:
- `scripts/evolution-daily.sh:79-81` — review-gated default sets `DISCOVERY_TOOLS=(Read Write Glob Grep WebFetch WebSearch)` / `EVAL_TOOLS=(...)`. Bash is correctly removed, but **`Write` is present with no path scoping**.
- `HEARTBEAT-DAILY.md:12`, `EVALUATE-PENDING.md:10-11`, `INTEGRATE-APPROVED.md:30-32` all assert "Never write files outside `pipeline/` and `registry/`" — but this is a *soft prompt instruction to the model*, not a CLI-enforced sandbox. `claude -p --allowed-tools Write` can write anywhere the user can.

Attack: discovery/eval agents call `WebFetch`/`WebSearch` on attacker-authored GitHub READMEs / web pages (the explicit design per `HEARTBEAT-DAILY.md:18-23`). A prompt-injection payload in that content can instruct the agent to `Write` to `~/.claude.json` (MCP config → code exec on next `claude` start), `~/.bashrc`, `~/.claude/agents/*.md`, `.git/hooks/`, or `.env` (→ code exec on next cron run). This achieves persistence/code-execution **with `EVOLUTION_AUTONOMOUS=0`**, contradicting the reassuring framing in `README.md:29-33` ("default mode is review-gated (no agent Bash access, no autonomous integration)").

Nuance for fairness: `SECURITY.md:33-35` *does* disclose "even in this mode the agents can write files inside areas your `claude` CLI permits … reduces the blast radius; it does not eliminate it." So this is partially disclosed — but there is **zero technical control** backing the policy files' guarantees. Claude Code supports `permissions.deny` rules, `--add-dir` scoping, and sandbox modes; none are used. Recommendation: drop `Write` from discovery/eval (have the agent emit JSON to stdout; the wrapper writes the file), or add a `permissions.deny` settings layer blocking `~/.claude*`, `~/.*rc`, `.env`, `.ssh`, `.git/hooks`, crontabs.

### P2 — Doc/code mismatch: README and `.env.example` claim scripts enforce mode 600, but the check accepts world/group-readable `.env`
Evidence:
- Code (`scripts/evolution-daily.sh:26-30`, identical in `evolution-weekly.sh:19-23`): rejects only when `(8#$env_mode & 8#022) != 0`, i.e. only group/other-**writable**.
- Empirically verified: modes `600, 640, 644, 604, 700` → **ACCEPT**; only `660`/`022`-writable → REJECT.
- Docs: `.env.example:6` and `README.md:157` both state "mode 600 (the scripts refuse to load it otherwise)". That is false — a world-readable `0644` `.env` loads fine.

Impact: false assurance + a world-readable `.env` (containing `DISCORD_WEBHOOK_URL`, and any future secret) is exposed to other local users while the user believes the script enforced 600. Note `SECURITY.md:60-61` is *accurate* ("not owned by you **or is writable by group/others**") — so fix the two overstated docs to match SECURITY.md, or tighten the code to also reject group/other-readable (`& 8#077`).

### P2 — Autonomous-mode `.env` rewrite is an unenforced persistence path
In `EVOLUTION_AUTONOMOUS=1`, integration runs with `Read Write Edit Bash` (`evolution-daily.sh:127`). `INTEGRATE-APPROVED.md:30-32` only *soft-forbids* writing `.env`/`.git/hooks`/etc. A prompt-injected integration agent can write `.env` (it can keep it user-owned + `chmod 600`, passing the next-run guard) → arbitrary shell executes on the next cron run because the scripts **source** `.env` (`:31-34`). Disclosed in `SECURITY.md:63` ("Never let automation … write to `.env`") but not enforced. The prior reviewer's F-02 recommended parsing `KEY=value` instead of sourcing; the maintainer kept sourcing + guards. Residual stands.

### P3 — Privacy: committed review doc leaks the `/home/ashita` username, and the portability test doesn't cover it
- `reviews/gptpro-2026-06-11.md` (tracked, public repo) contains literal `/home/ashita` at lines ~414 and 551-552.
- `scripts/test-public-config.sh:25` only scans `reference-config/` for private-path leaks — it never scans `reviews/`, so the exact leak the test exists to prevent slips through in a committed file. Either scrub the username from the review doc or extend the test's scan root.

### Verified-clean / non-findings
- No hardcoded secrets, no `.env`/`.private-patterns` ever committed (git history clean).
- `--allowed-tools "${ARRAY[@]}"` followed by `--` is correct: the `--` terminator bounds the variadic tool list before the prompt positional — not a bug.
- PID handling, flock locking, port validation, `lsof -sTCP:LISTEN`, terminal sanitization, Discord redaction, jq-based JSON construction (no injection): all correctly implemented per the prior fixes.
- `README.md:176` "Codex (GPT-5)" is stale model labeling — cosmetic only.

Bottom line: no P0. One P1 worth elevating — the default mode's unrestricted `Write` makes prompt-injection→persistence reachable without autonomous mode, and only a soft prompt rule (not the harness) guards it. The two P2s are an actionable doc/code mismatch on `.env` permission enforcement and the unenforced autonomous `.env`-rewrite loop.

---

## Disposition by the repo lead (2026-06-11)

- **P1 (unrestricted Write in review-gated mode)** — MITIGATED+DOCUMENTED. Path-scoped `--allowed-tools` (`Write(pipeline/**)`) and `permissions.deny` settings were tested against `claude -p` and did **not** reliably enforce (scoping silently blocked in-scope writes; deny did not block). Shipping a control that fails open would be worse than honest disclosure. README and SECURITY.md updated to state the Write gap explicitly and remove the over-reassuring framing; a robust fix (stdout-capture refactor / container) is tracked in `BACKLOG.md`.
- **P2 (doc/code mismatch on mode 600)** — FIXED. `README.md` and `.env.example` reworded to match the actual check (refuse if not user-owned or group/other-writable; 600 recommended), consistent with the accurate `SECURITY.md` text.
- **P2 (autonomous `.env` rewrite persistence)** — INHERENT+DOCUMENTED. Sourcing was retained by design (prior F-02 decision); `SECURITY.md` now spells out the specific `.env`-rewrite → next-cron-run code-execution vector and ties it to the disposable-account guidance.
- **P3 (`/home/ashita` in archived review; test scope)** — WONT-FIX. The GPT-5.5 Pro review is archived verbatim as a required campaign artifact; `ashita` is already the public identity (the repo lives under the `AshitaOrbis` GitHub org). `test-public-config.sh` is intentionally scoped to the published `reference-config/` subset, not review documentation.
- **"Codex (GPT-5)" stale label** — noted, cosmetic, left as-is.
