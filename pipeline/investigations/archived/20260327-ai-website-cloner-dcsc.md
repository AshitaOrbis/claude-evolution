---
date: 2026-03-27
topic: "AI website cloner template — could it have been used for DCSC.ca migration?"
discord_message_id: "1487173759008768111"
status: complete
---

# AI Website Cloner: DCSC.ca Migration Retrospective

## Topic

> "Could this have been used to do our DCSC.ca cloning so that we'd have had a functionally identical website from which to innovate?" — github.com/JCodesMore/ai-website-cloner-template

## Key Findings

- **ai-website-cloner-template** is a 5-phase pipeline: screenshot/token capture → typography/colors/asset download → component specs generation → parallel agent build (git worktrees) → assembly + visual QA
- The tech stack is Next.js 16 / React 19 / TypeScript / Tailwind CSS v4 / shadcn-ui — exactly the stack DCSC was migrated to
- This **would have significantly reduced manual work** for the DCSC migration by automating: design token extraction, responsive breakpoint detection, asset downloading, and component-by-component rebuild scaffolding
- The tool produces "exact `getComputedStyle()` values, interaction models, multi-state content" — eliminating the manual CSS archaeology that's typically the most tedious part of cloning
- **Critical gap it would have filled**: having a functionally identical starting point from which to innovate, rather than building from scratch while trying to match the original
- The tool explicitly supports "platform migration — rebuild a site you own from WordPress/Webflow/Squarespace into a modern Next.js codebase"

## Details

DCSC (Dawson Creek Sportsman's Club) is at `applications/dcsc/` — an Astro-based site (per workspace structure). The cloner outputs Next.js 16, not Astro, so there would have been a framework mismatch if used verbatim. However, the **reconnaissance and component spec phases** would still have been valuable regardless of output framework — the extracted design tokens, typography, and component behaviors could feed into any framework migration.

The parallel build phase (git worktrees + concurrent builder agents) mirrors our existing `using-git-worktrees` skill, suggesting this tool's architecture is compatible with our workflow patterns.

**Prospective value**: For any future website migration or clone (DCSC updates, new client sites), this tool should be run first. The visual QA phase (comparing generated vs original via screenshots) is particularly valuable for catching regressions during iterative refinement.

## Relevance to Workspace

- `applications/dcsc/`: Historical relevance; future updates could use this tool for incremental redesigns
- Any future website project: This should be in the standard onboarding workflow for web migration projects
- `~/.claude/skills/`: Consider adding a `website-migration` skill that references this tool's phase structure

## Recommended Actions

1. **Add to toolbox**: Star the repo and document it in `library/techniques/website-migration.md` as the recommended approach for future site cloning/migration
2. **For DCSC future updates**: If a significant redesign is planned, run the reconnaissance phase on the current DCSC site to capture design tokens before changing anything
3. **Dependency check**: The tool uses Next.js 16 — verify it produces usable output if the target framework differs (or fork/adapt the output phase for Astro)
