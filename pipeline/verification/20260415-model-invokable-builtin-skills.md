# Integration Report: Model-Invokable Built-in Slash Commands via Skill Tool

**Source**: `pipeline/integration/model-invokable-builtin-skills-v2.1.108.md`
**Type**: technique (NOVEL — agents can now invoke built-in slash commands autonomously)
**Score**: 83.75/100
**Decision**: APPROVED
**Integrated**: 2026-04-19

---

## What Was Done

**Registry update**: Added entry to `registry/existing-capabilities.md` (v2.1.104/105/108 section):
- Documents that models can now discover and invoke built-in slash commands (`/init`, `/review`, `/security-review`) via the Skill tool
- Notes agent workflow expansions: `feature-implementer` → `/init`, `code-reviewer` → `/review`, `security-auditor` → `/security-review`

**Pending approval** (files outside ~/claudeworkspace/):
- Agent definition updates in `pipeline/pending-approval/skill-updates-v2105-v2108.proposal.md` — optional documentation-only notes in agent `.md` files

**No files outside ~/claudeworkspace/ modified directly** (registry done; agent doc notes pending approval).

---

## Verification

- Registry entry present: ✓ (v2.1.108 Built-in Commands section)
- Capability automatic (no config needed): ✓
- Agent workflow examples documented: ✓
- Redundancy triggers added: ✓
- Agent definition updates: pending_approval (optional documentation) → `pipeline/pending-approval/skill-updates-v2105-v2108.proposal.md`

---

## Integration Type
`registry_entry + optional_pending_approval(agent-docs)` — Feature is automatic (v2.1.108+); agent definition notes are optional documentation improvements.
