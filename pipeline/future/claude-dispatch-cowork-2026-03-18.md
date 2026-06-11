# Future: Claude Dispatch — Mobile Remote Control for Desktop Sessions

- **Source**: https://www.ndtv.com/offbeat/anthropic-launches-claude-dispatch-this-new-claude-feature-lets-your-phone-run-your-pc-heres-how-11233014
- **Date Found**: 2026-03-18
- **Category**: Claude.ai product feature (async delegation)
- **Status**: NOT ADOPTABLE — UI-only, Mac-only, research preview; monitoring for API/CLI expansion

## The Gap

The workspace already achieves mobile-to-desktop Claude access via Tailscale SSH + tmux + Claude Code. Dispatch is Anthropic's first-party equivalent: kick off long tasks on desktop from a phone and return to find completed work. The pattern is the same; the implementation is different.

## Why Not Integrated Now

1. **Mac-only at launch** — workspace runs Linux (requiem, native Debian). Not compatible.
2. **Claude.ai UI feature** — no API, no MCP, no CLI path. Zero integration surface.
3. **Research preview** — behavior/availability may change significantly.
4. **Already solved** — Tailscale SSH handles the phone→desktop use case today.

## What We're Watching For

- Dispatch expanding beyond Mac (Linux support)
- Dispatch exposed as API endpoint or MCP tool
- Dispatch enabling webhook-style task completion notifications
- GA release with cross-platform support

## Revisit Trigger

- Anthropic announces Linux/cross-platform Dispatch support
- Dispatch gains programmatic triggering (API/MCP interface)
- Claude Code gains Dispatch integration natively

## Evaluation Score at Rejection: 48.0 (REJECTED)
