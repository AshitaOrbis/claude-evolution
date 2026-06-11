# Evaluation: UV Single-File Script Hooks

- **Date**: 2026-02-06
- **Category**: Technique
- **Source**: https://github.com/disler/claude-code-hooks-mastery
- **License**: N/A (technique using MIT-licensed UV tool)
- **UV Stars**: 53k+ (Astral UV is a major project)

## Redundancy Check

**Classification**: NOVEL

Registry documents hook types (PreToolUse, PostToolUse, Stop) and shell conventions (set -euo pipefail, jq), but has NO pattern for Python hook dependency management. Current hooks are bash-only. This addresses a genuine implementation gap.

## Scores

| Criterion | Score | Rationale |
|-----------|-------|-----------|
| Integration Complexity | 100/100 | UV already installed (v0.9.27). Drop-in pattern: change shebang to `#!/usr/bin/env uv run` and add inline deps |
| Token Efficiency Impact | 50/100 | Neutral -- hooks run outside conversation context, no token impact |
| Capability Expansion | 80/100 | Significant -- enables Python hooks with arbitrary dependencies (pylint, mypy, requests, pydantic) without venv management |
| Maintenance Burden | 80/100 | Low -- UV handles caching, no venvs to manage, self-contained scripts |
| Community Validation | 80/100 | UV itself has 53k+ stars. Hooks mastery repo is a tutorial, but UV is industry-standard |

**WEIGHTED TOTAL**: (100 * 0.20) + (50 * 0.25) + (80 * 0.25) + (80 * 0.15) + (80 * 0.15) = 20.0 + 12.5 + 20.0 + 12.0 + 12.0 = **76.5/100**

## Cross-Validation

- **Claude Assessment**: 76.5/100
- **Codex Assessment**: N/A (MCP unavailable)
- **Variance**: N/A

## Analysis

This is a clean win. UV is already installed on the system, the pattern is trivial to adopt, and it solves a real problem: Python hooks currently require either global pip installs or manual venv setup. With UV inline deps, each hook is self-contained and portable.

The token efficiency score is neutral (50) because hooks execute outside the conversation context -- they don't consume conversation tokens. But the capability expansion is significant: we can now write hooks that use pylint, mypy, requests, pydantic, or any Python library without polluting the system environment.

**Key strengths**:
- Zero new tooling needed (UV already at v0.9.27)
- Self-documenting (deps visible in script header)
- Fast (UV's Rust resolver + caching)
- Isolated (no cross-script dependency conflicts)

## Security Assessment

- [x] No sensitive permissions required
- [x] No excessive data access
- [x] License compatible (UV is MIT)
- [x] No known vulnerabilities
- [x] No API keys needed

## Recommendation

**DECISION**: APPROVE (76.5 >= 70)

**Rationale**: UV is already installed, the pattern is drop-in, and it unlocks Python hooks with arbitrary dependencies -- a capability we currently lack. Zero maintenance burden since UV handles dependency resolution and caching.

**Integration Path**:
1. Document UV hook pattern in a hook-development skill or existing shell conventions
2. Create 1-2 example hooks using the pattern (e.g., a PostToolUse hook with pylint)
3. Update CLAUDE.md Shell/Bash Conventions to mention UV for Python hooks
