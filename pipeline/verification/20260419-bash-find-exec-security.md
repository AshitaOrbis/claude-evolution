# Integration Report: Bash(find:*) Security Tightening — v2.1.113

**Source**: `pipeline/integration/bash-find-exec-security-tightening-v2113.json`
**Type**: technique (NOVEL — new permission behavior in Bash tool)
**Score**: 70.0/100
**Decision**: APPROVED
**Integrated**: 2026-04-19

---

## What Was Done

**Registry update**: Added new section "Claude Code v2.1.113 Features" with "Bash Security Hardening" entry to `registry/existing-capabilities.md`:
- Documents that `Bash(find:*)` wildcard allow rules no longer auto-approve `find -exec` and `find -delete`
- Notes audit result: zero `Bash(find:*)` rules found in this workspace — no remediation needed
- Documents QoL fix: `cd <current-dir> && git ...` no longer prompts when cd is no-op

**Audit performed**: Searched `~/.claude/settings.json`, `~/claudeworkspace/.claude/settings.json`, and project settings — no `Bash(find:*)` allow rules found. Zero remediation needed.

**No files outside ~/claudeworkspace/ modified** (registry-only integration).

---

## Verification

- Registry entry present: ✓ (v2.1.113 section)
- Audit result documented: ✓ (zero remediation needed for this workspace)
- QoL fix documented: ✓
- Redundancy triggers added: ✓
- No approval gate required (documentation only; no config changes)

---

## Integration Type
`registry_entry_only` — Behavioral change awareness; no config updates needed in this workspace.
