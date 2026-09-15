#!/usr/bin/env python3
"""Resolve every hook command configured in .claude/settings.json to a real executable.

WHY THIS EXISTS (claude.read_hook_missing_public_01)
    .claude/settings.json registers a PreToolUse guard for Read|Glob|Grep, and the
    published artifact shipped the registration without the script it names. A fresh
    checkout ran the configured command, the shell returned 127, and Claude Code's
    documented PreToolUse contract treats every hook failure other than exit 2 as
    NON-BLOCKING: the tool ran unguarded and nothing said so. The advertised filter
    was absent and silent at the same time.

    A guard that cannot start cannot fail closed from inside itself -- its own EXIT
    trap never runs. The only place this class can be caught is BEFORE the agents
    start, which is what this script exists for: scripts/evolution-daily.sh refuses
    the whole run when any configured hook command does not resolve.

WHAT COUNTS AS RESOLVED
    The command string is expanded for CLAUDE_PROJECT_DIR (the only variable Claude
    Code guarantees), split the way a POSIX shell would split it, and its argv[0] is
    required to be an existing regular file with the execute bit set. A command that
    still carries an unexpanded $VARIABLE after that is reported as unresolvable
    rather than assumed fine: this check exists precisely to refuse what it cannot
    verify.

Usage:  check-hook-commands.py [--settings PATH] [--project-dir PATH]
Exit:   0  every configured hook command resolves to an executable file
        1  at least one does not -- each is named on stdout
        2  the settings file itself is missing, unreadable, or not parseable
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shlex
import shutil
import sys
from pathlib import Path

UNEXPANDED = re.compile(r"\$(?:\{[A-Za-z_][A-Za-z0-9_]*\}|[A-Za-z_][A-Za-z0-9_]*)")


def _expand(command: str, project_dir: str) -> str:
    """Expand CLAUDE_PROJECT_DIR in both its `$NAME` and `${NAME}` spellings."""
    return command.replace("${CLAUDE_PROJECT_DIR}", project_dir).replace(
        "$CLAUDE_PROJECT_DIR", project_dir
    )


def iter_hook_commands(settings: dict):
    """Yield (event, matcher, command) for every type=command hook in the settings."""
    hooks = settings.get("hooks")
    if not isinstance(hooks, dict):
        return
    for event, entries in sorted(hooks.items()):
        if not isinstance(entries, list):
            continue
        for entry in entries:
            if not isinstance(entry, dict):
                continue
            matcher = entry.get("matcher", "*")
            inner = entry.get("hooks")
            if not isinstance(inner, list):
                continue
            for hook in inner:
                if not isinstance(hook, dict):
                    continue
                if hook.get("type") != "command":
                    continue
                command = hook.get("command")
                if not isinstance(command, str) or not command.strip():
                    yield event, matcher, ""
                    continue
                yield event, matcher, command


def resolve(command: str, project_dir: str) -> tuple[bool, str]:
    """Return (ok, detail) for one configured command string."""
    if not command:
        return False, "the hook entry carries no command string"
    expanded = _expand(command, project_dir)
    leftover = UNEXPANDED.search(expanded)
    if leftover:
        return False, (
            f"command still contains the unexpanded variable {leftover.group(0)} after "
            f"CLAUDE_PROJECT_DIR expansion -- refusing to assume it resolves: {expanded}"
        )
    try:
        argv = shlex.split(expanded)
    except ValueError as exc:
        return False, f"command is not shell-parseable ({exc}): {expanded}"
    if not argv:
        return False, f"command splits to nothing: {expanded!r}"
    target = argv[0]
    if "/" in target:
        path = Path(target)
        if not path.is_absolute():
            path = Path(project_dir) / path
    else:
        found = shutil.which(target)
        if found is None:
            return False, f"'{target}' is not on PATH"
        path = Path(found)
    if not path.exists():
        return False, f"'{path}' does not exist"
    if not path.is_file():
        return False, f"'{path}' is not a regular file"
    if not os.access(path, os.X_OK):
        return False, f"'{path}' exists but is not executable"
    return True, str(path)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "--settings",
        default=None,
        help="path to settings.json (default: <project-dir>/.claude/settings.json)",
    )
    parser.add_argument(
        "--project-dir",
        default=None,
        help="project root CLAUDE_PROJECT_DIR expands to "
        "(default: $CLAUDE_PROJECT_DIR, else this script's repository root)",
    )
    args = parser.parse_args(argv)

    repo_root = Path(__file__).resolve().parent.parent
    project_dir = args.project_dir or os.environ.get("CLAUDE_PROJECT_DIR") or str(repo_root)
    project_dir = str(Path(project_dir).resolve())
    settings_path = Path(args.settings) if args.settings else Path(project_dir) / ".claude" / "settings.json"

    try:
        raw = settings_path.read_text(encoding="utf-8")
    except OSError as exc:
        print(f"UNRESOLVABLE: cannot read {settings_path}: {exc}")
        return 2
    try:
        settings = json.loads(raw)
    except json.JSONDecodeError as exc:
        print(f"UNRESOLVABLE: {settings_path} is not valid JSON: {exc}")
        return 2
    if not isinstance(settings, dict):
        print(f"UNRESOLVABLE: {settings_path} does not hold a JSON object")
        return 2

    checked = 0
    bad = 0
    for event, matcher, command in iter_hook_commands(settings):
        checked += 1
        ok, detail = resolve(command, project_dir)
        if ok:
            print(f"ok   {event}[{matcher}] -> {detail}")
        else:
            bad += 1
            print(f"UNRESOLVED {event}[{matcher}]: {detail}")

    if checked == 0:
        print(f"no command hooks configured in {settings_path}")
        return 0
    if bad:
        print(
            f"{bad} of {checked} configured hook command(s) do not resolve to an executable file. "
            "Claude Code treats a hook that cannot start as NON-BLOCKING, so the tools they guard "
            "would run unguarded and silently."
        )
        return 1
    print(f"all {checked} configured hook command(s) resolve to executable files")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
