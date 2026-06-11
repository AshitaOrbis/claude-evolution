# Discovery: UV Single-File Script Hooks

- **Source**: https://github.com/disler/claude-code-hooks-mastery
- **Date Found**: 2026-02-06
- **Category**: technique
- **Summary**: Hook implementation pattern using Astral UV for inline dependency declarations, eliminating virtual environments and dependency pollution while maintaining portability. Each hook script declares its own dependencies inline.
- **Potential Value**: Medium
- **Integration Complexity**: Easy

## Description

Traditional hook implementations face dependency management challenges:
- **venv approach**: Each hook needs its own virtualenv (overhead, complexity)
- **Global install**: Pollutes user's Python environment
- **Requirements.txt**: Requires separate dependency file per hook

**UV Single-File Pattern** solves this with Astral UV's inline dependency syntax:

```python
#!/usr/bin/env uv run
# /// script
# dependencies = [
#   "requests>=2.31.0",
#   "pydantic>=2.0.0",
# ]
# ///

import requests
import pydantic

# Hook logic here
```

**Benefits**:
1. **Zero setup**: No venv creation, no pip install steps
2. **Portable**: Script carries its own dependencies
3. **Isolated**: Each hook has its own dependency resolution
4. **Fast**: UV's Rust implementation resolves and caches quickly
5. **Declarative**: Dependencies visible in script itself

**UV features**:
- Inline `# dependencies = [...]` declarations
- Automatic virtual environment creation per script
- Dependency caching across invocations
- Python version specification support

**Use cases**:
- PostToolUse hooks that validate code (need pylint, mypy)
- PreToolUse hooks that check APIs (need requests)
- Stop hooks that generate reports (need jinja2, markdown)
- Hooks that parse configs (need pyyaml, toml)

## Redundancy Check

**Status**: NOVEL

Checked against registry:
- **Hooks**: Listed extensively (PreToolUse, PostToolUse, Stop, etc.) with shell script examples
- **Shell/Bash Conventions**: Mandates `set -euo pipefail`, `jq` for JSON
- **TDD enforcement**: tdd-guard hooks mentioned

**Key distinction**:
- Registry documents WHAT hooks exist and WHEN they fire
- Does NOT document HOW to manage hook dependencies cleanly
- No existing pattern for Python hook dependency management
- UV pattern solves a practical implementation challenge not addressed

This is a TECHNIQUE for implementing hooks, not a new hook type.

## Evaluation Needs

1. **UV availability**: Is UV widely available on target systems (Linux, macOS, Windows/WSL)?
2. **Performance**: How much overhead does UV add vs pre-installed dependencies?
3. **Caching**: Does UV cache work reliably across Claude Code sessions?
4. **Python version conflicts**: How does UV handle version mismatches?
5. **Fallback strategy**: What if UV not available? Fail gracefully or error?
6. **Alternative**: Could inline dependencies work with pipx or poetry?
7. **Documentation**: Are there other UV features relevant to hooks (run, tool, etc.)?

## Integration Path

If approved:
- **Skill**: `~/.claude/skills/hook-development/SKILL.md` section on dependency management
- **Templates**: Example hooks using UV pattern in `~/.claude/hooks/examples/`
- **Installation**: Add UV to recommended tools in setup docs
- **Best practices**: When to use UV vs system packages vs shell-only hooks
- **Migration guide**: Converting existing Python hooks to UV pattern

## Alternative Considerations

If UV adoption is too aggressive, consider:
- **pipx run**: Similar inline pattern with pipx
- **Docker hooks**: Containerized hooks with their own dependencies
- **Bash-only mandate**: Avoid Python dependencies entirely in hooks
