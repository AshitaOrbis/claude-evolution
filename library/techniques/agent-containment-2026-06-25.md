# Agent Containment Checklist (Anthropic "How We Contain Claude")

**Source**: https://www.anthropic.com/engineering/how-we-contain-claude
**Date**: 2026-06-25 (integrated 2026-07-19)
**Type**: technique (safety architecture checklist)
**Score**: 81.5/100 (approved 2026-06-28)

## What It Is

Anthropic's engineering article on containing Claude agents describes the safety
architecture they use internally: containment comes from **structural boundaries**, not
from the model's judgment or from humans approving individual actions. The key insight
for unattended runs: approval prompts are a weak boundary because approval fatigue is
real and measurable — after enough prompts, humans rubber-stamp. Hard limits do not
fatigue.

## Containment Checklist for Unattended Agent Runs

1. **Credentials outside the sandbox.** The agent's environment holds no secrets it
   does not strictly need; signing/deploy keys live behind interfaces the agent calls,
   not files it can read.
2. **Filesystem boundaries.** Workspace-only writes, enforced by the sandbox — not by
   instructions. Anything outside the project tree is structurally read-only or
   invisible.
3. **Egress controls.** Network denied by default; allowlist the endpoints the task
   actually needs. Exfiltration needs egress — deny it the road.
4. **OS-level sandboxes / VMs for high-risk work.** Container or VM isolation when the
   task involves untrusted code or untrusted content, so a compromised agent process
   hits a wall that is not made of prompts.
5. **Hard limits over approval prompts.** Budget caps, time caps, operation caps that
   *stop* the run — versus prompts that ask a fatigued human to keep it going.

## Local Mapping

This workspace already implements portions of this: sandboxed Bash, the OpenClaw
Docker + egress-proxy setup, headless-spawn capability caps, and the
INTEGRATE-APPROVED System File Guard (born from the April 2026 `~/.bashrc` incident —
the local proof that "evaluation said harmless" is not a boundary). Gaps worth auditing
against the checklist: egress-default posture of long-running cron sessions, and
credential visibility inside routine automation sandboxes.

## Verification Note

Documentation-only: this records official guidance as a checklist for future unattended
runs; it changes no configuration by itself.

**Tags**: `agent-containment`, `sandboxing`, `egress-control`, `credential-isolation`,
`approval-fatigue`, `unattended-runs`, `anthropic-official`
