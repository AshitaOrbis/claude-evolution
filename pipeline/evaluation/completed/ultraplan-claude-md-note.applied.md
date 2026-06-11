**Triage 2026-06-10**: needs user decision because (a) the provenance claim doesn't verify — the changelog's `/ultraplan` mentions are v2.1.101/2.1.113/2.1.149, not "v2.1.91+, documented in v2.1.111" as written, so the note can't be applied verbatim as verified-accurate; and (b) it adds ~24 lines about a research-preview feature to `~/.claude/CLAUDE.md`, which was refreshed/curated today — whether to carry this in the global file vs. an @-imported doc is a curation call. The feature itself does still exist (fix shipped in v2.1.149).

# Pending Approval: /ultraplan Note in Plan Mode Quality CLAUDE.md

**Type**: claude-md-update (file outside ~/claudeworkspace/)
**Target**: `~/.claude/CLAUDE.md` — Plan Mode Quality section
**Status**: pending_approval
**Created**: 2026-04-17
**Source item**: `pipeline/integration/20260417-ultraplan-cloud-interactive-planning.json`

---

## What to Change

In `~/.claude/CLAUDE.md`, find the `## Plan Mode Quality` section.

**Add after the anti-patterns table** (or at the end of the section, before `## Plan Mode Completion`):

```markdown
### /ultraplan — Cloud-Based Interactive Planning (Research Preview)

`/ultraplan` hands a planning task from the local terminal to a Claude Code web session, freeing the terminal while the plan drafts in the cloud.

**Triggers**:
- Type `/ultraplan` explicitly
- Include the word "ultraplan" in any prompt
- Select "Refine with Ultraplan" when declining a local plan

**Browser review**: Inline section comments, emoji reactions, iterative refinement with Claude in the browser.

**Two execution paths**:
- **Path A**: Execute approved plan on web → open PR (requires GitHub repo)
- **Path B**: Teleport approved plan back to local terminal → continue locally

**When to use over local plan mode**:
- Collaboration required (share plan link for async review)
- Plan is exploratory and benefits from browser annotation
- Local context budget needs to be preserved for implementation

**Requirements**: claude.ai account + GitHub repo. Not available on Bedrock/Vertex/Foundry.
**Status**: Research preview (v2.1.91+, documented in v2.1.111 changelog).
```

---

## Why

`/ultraplan` is a genuine complement to local plan mode — it adds browser-based annotation and cloud off-loading that aren't available locally. The Plan Mode Quality section is where users look for planning workflow guidance. Documenting this alongside local plan mode ensures it's discoverable as an alternative trigger.

**Risk**: Zero — documentation update only. The feature is Anthropic-maintained; no configuration required.

---

**Status**: pending_approval
**Apply manually** to `~/.claude/CLAUDE.md`


**Approved by human via Discord reaction** (2026-06-11) — ready to apply.


**Applied 2026-06-11**: content extracted to ~/.claude/docs/ultraplan.md (curator policy — @-doc, not inline) with one-line pointer in the Plan Mode Quality section. Version provenance corrected to the verified changelog mentions (v2.1.101 / v2.1.113 / fix v2.1.149).
