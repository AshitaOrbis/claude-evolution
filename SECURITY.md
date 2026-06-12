# Security Model

Claude Evolution deliberately connects **untrusted internet content** (GitHub
repos, forum posts, newsletters, web pages) to an **AI agent with local file
write authority**. That boundary is the point of the tool — and it is also the
main risk. Read this before enabling the cron automation, and especially
before enabling autonomous mode.

## Threat model

The discovery and evaluation agents fetch and read content that anyone on the
internet can author. A malicious repo README, MCP server listing, or forum
post can contain **prompt-injection payloads**: instructions crafted to make
the agent write files, alter configs, or (in autonomous mode) run shell
commands. The shell wrappers in `scripts/` are deliberately conservative, but
no wrapper can make an agent that reads attacker-controlled text and holds
Write/Bash authority fully safe.

## Operating modes

### Review-gated mode (default)

`./scripts/evolution-daily.sh` with `EVOLUTION_AUTONOMOUS` unset or `0`:

- Discovery and evaluation agents run with `Read Write Glob Grep WebFetch
  WebSearch` — **no Bash**.
- The **integration phase is skipped**. Approved items accumulate in
  `pipeline/integration/` and the log tells you how many await review.
- You review each approved item and integrate it yourself (or run a one-off
  autonomous pass after reading the queue).
- Helper generation runs with `Read Write Glob Grep` only.

**Important limitation:** review-gated mode removes Bash but the agents still
hold **unrestricted `Write`** (and the integration step `Edit`). The
"only write to `pipeline/` and `registry/`" rules in the prompt files are
**soft instructions to the model, not a sandbox**. A prompt-injection payload
in fetched content could direct the agent to write to sensitive targets
(`~/.claude.json` or `~/.claude/agents/*.md` → code execution on the next
`claude` start; `.env` → code execution on the next cron run; `.git/hooks/`,
shell rc files, etc.).

Path-scoped `--allowed-tools` rules (e.g. `Write(pipeline/**)`) and
`permissions.deny` settings were evaluated as an enforcement layer and did
**not** reliably constrain `claude -p` file writes in testing, so they are
deliberately not relied upon here — a control that silently fails open would
be worse than an honest warning. The only dependable containment is OS-level:

Review-gated mode reduces the blast radius (no Bash, no autonomous config
writes); it does **not** confine writes to the repo. For unattended runs,
use the disposable-account / container guidance below rather than trusting
the prompt-level rules. Tracking a robust fix (capture agent output via
stdout and have the wrapper write files, removing `Write` from the
web-fetching phases) in `BACKLOG.md`.

### Autonomous mode (`EVOLUTION_AUTONOMOUS=1`)

Restores the original fully autonomous behavior: agents get Bash, and the
integration phase writes skills/agents/MCP configs directly into your live
Claude Code setup (`~/.claude/...`, `~/.claude.json`).

**Do not run autonomous mode on a workstation that holds real credentials.**
If you want unattended integration, run it inside a disposable container or a
dedicated low-privilege account with:

- no SSH keys, cloud tokens, browser profiles, or password stores
- a throwaway or read-only home directory outside the repo
- restricted network egress
- no access to your real `~/.claude` config (mount a copy if needed)

Treat anything the autonomous run produces as untrusted until you have read
the diff.

## Configuration loading (`.env`)

`scripts/evolution-daily.sh` and `scripts/evolution-weekly.sh` **source**
`.env` as shell code — standard practice for shell tooling, but it means
anything in that file executes with your privileges. The scripts refuse to
source a `.env` that is not owned by you or is writable by group/others, but
they cannot detect malicious content in a file you own. Consequences:

- Never let automation (including this tool's own agents) write to `.env`.
  In autonomous mode the integration agent holds `Write`/`Edit`; a
  prompt-injected run could rewrite `.env` (keeping it user-owned and `600`
  so it passes the next-run ownership/mode guard) and thereby execute
  arbitrary shell on the next cron run, because the scripts **source** it.
  This is the strongest reason not to run autonomous mode outside a
  disposable account/container.
- Keep it `chmod 600` and out of version control (it is gitignored).
- Put only `KEY=value` lines in it — treat any command syntax in `.env` as a
  compromise indicator.

## Discord notifications

When `DISCORD_WEBHOOK_URL` is set, the first 20 lines of each daily discovery
report are sent to Discord — a third party. The script defensively redacts
webhook URLs and credential-shaped strings (`api_key=`, `token:`, etc.) from
the summary, but the redaction is best-effort pattern matching. Do not rely
on it: keep secrets out of discovery reports, and leave the webhook unset if
your pipeline may touch sensitive material.

## Prompt files are policy

`HEARTBEAT-DAILY.md`, `EVALUATE-PENDING.md`, `INTEGRATE-APPROVED.md`, and
`GENERATE-HELPERS.md` are effectively executable policy for the agent runs.
Review changes to them with the same care as shell-script changes, and keep
the "treat external content as data" rules they contain intact.

## Runtime files

Locks and PID files live in `${XDG_RUNTIME_DIR:-$HOME/.cache}/claude-evolution`
(created `0700`), not in world-writable `/tmp`. Locking uses `flock` (atomic);
PID file contents are validated as positive integers before any `kill`.

## Reporting

This is a personal-workflow repository published as a reference. If you find
a security issue, open a GitHub issue (omit sensitive details) or contact the
maintainer via the site linked in the README.
