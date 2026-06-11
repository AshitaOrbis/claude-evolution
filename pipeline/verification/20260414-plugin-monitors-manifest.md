# Integration Report: Plugin `monitors` Manifest Key (v2.1.105)

**Source**: `pipeline/integration/plugin-monitors-manifest-v2.1.105.md`
**Type**: technique (NOVEL — declarative background monitoring for plugins)
**Score**: 76.5/100
**Decision**: APPROVED
**Integrated**: 2026-04-19

---

## What Was Done

**Registry update**: Added entry to `registry/existing-capabilities.md`:
- In Plugin System section: "Background Plugin Monitors" entry documenting `monitors` manifest key
- In v2.1.101-105 section: detailed entry with comparison to Monitor Tool, use cases, open questions

**Pending approval** (files outside ~/claudeworkspace/):
- `hook-lifecycle` skill update for §19 Plugin monitors section in `pipeline/pending-approval/skill-updates-v2105-v2108.proposal.md`

**No files outside ~/claudeworkspace/ modified directly** (registry done; hook-lifecycle skill update pending approval).

---

## Verification

- Registry entry present: ✓ (two locations — Plugin System table + v2.1.105 section)
- Key difference from Monitor Tool documented: ✓ (declarative vs explicit invocation)
- Open questions preserved: ✓ (lifecycle, session-start behavior, interaction with CLAUDE_CODE_DISABLE_CRON)
- Redundancy triggers added: ✓
- Skill update: pending_approval → `pipeline/pending-approval/skill-updates-v2105-v2108.proposal.md`

---

## Integration Type
`registry_entry + pending_approval(skill-update)` — Registry done; hook-lifecycle skill §19 requires approval gate (file outside ~/claudeworkspace/).
