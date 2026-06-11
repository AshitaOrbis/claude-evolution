# Evaluation: CAD MCP Server

- **Date**: 2026-02-06
- **Source**: https://github.com/daobataotie/CAD-MCP
- **Category**: MCP
- **License**: MIT
- **Stars**: 223
- **Last Updated**: 2026 (recent)

## Scores

| Criterion | Weight | Score | Rationale |
|-----------|--------|-------|-----------|
| Integration complexity | 20% | 20 | Requires CAD software (Revit/AutoCAD = expensive licenses). No CAD software installed, no plans to acquire. |
| Token efficiency impact | 25% | 40 | 3D model data is inherently token-heavy. Coordinates, meshes, geometry descriptions. |
| Capability expansion | 25% | 30 | Novel domain (3D CAD) but ZERO applicability - no CAD software, no engineering/architecture projects |
| Maintenance burden | 15% | 50 | 223 stars moderate, depends on proprietary CAD APIs that change with vendor updates |
| Community validation | 15% | 60 | 223 stars, MIT license, moderate validation |

**Weighted Score**: (20x0.20) + (40x0.25) + (30x0.25) + (50x0.15) + (60x0.15) = 4 + 10 + 7.5 + 7.5 + 9 = **38.0/100**

## Cross-Validation

- **Claude Assessment**: 38.0/100
- **Codex Assessment**: Unavailable (MCP error)

## Decision

**REJECT** - Score 38.0, well below threshold.

**Reason**: Requires expensive proprietary CAD software we do not have. Zero applicability to our software development workflow. Novel domain but irrelevant without the underlying toolchain.

**Reconsideration Trigger**: CAD/architecture project with licensed software.
