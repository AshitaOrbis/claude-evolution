# FreeCAD MCP — Evaluation

- **Source**: https://github.com/neka-nat/freecad-mcp
- **Type**: MCP server
- **Discovered**: 2026-04-19 (Discord inbox)
- **Evaluated**: 2026-04-19

## Verified Facts

| Metric | Value | Source |
|--------|-------|--------|
| Stars | 790 | `gh api repos/neka-nat/freecad-mcp` |
| License | MIT | repo |
| Last push | 2026-04-12 | repo |
| Open issues | 13 | repo |
| Language | Python | README |

## Redundancy Check

NOVEL — no existing CAD or 3D modeling MCPs in registry. Fills a genuinely new domain (spatial/visual control vs code/text).

## Scoring

| Criterion | Weight | Score | Reasoning |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 35 | Requires FreeCAD installed + Python deps + MCP config. Workspace has no CAD pipeline to integrate with. |
| Token efficiency | 25% | 50 | Neutral — adds capability but no token savings. |
| Capability expansion | 25% | 70 | Genuinely novel domain (3D CAD), but orthogonal to all current workspace projects. |
| Maintenance burden | 15% | 60 | Active recent push, but small-team OSS with 13 open issues. |
| Community validation | 15% | 60 | 790 stars — solid for a niche MCP, but not "official" or 1k+ tier. |

**Total**: (35×0.20) + (50×0.25) + (70×0.25) + (60×0.15) + (60×0.15) = 7 + 12.5 + 17.5 + 9 + 9 = **55.0**

## Decision: REJECT

Score sits in NEEDS_RESEARCH band (50-69), but the dispositive factor is **strategic fit**: there is no CAD experiment, no 3D modeling project, and no plan to start one. Adding an MCP for a domain we don't work in just inflates the registry and the per-startup tool-search surface.

**Reconsider if**: a parts-design, manufacturing, or CAD experiment is added to `experiments/`. The tool itself is solid (790 stars, MIT, active) and would be a strong choice in that scenario.

## Cross-Validation Note

Codex MCP was unreachable during this evaluation (connection closed). Cross-validation deferred to GitHub API for repo facts and the original maintainer README for capability claims. The decision (REJECT for fit, not for quality) is robust enough not to require cross-model scoring.
