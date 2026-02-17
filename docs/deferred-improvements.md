# Deferred Improvements

Items researched during the git/GitHub integration (Feb 2026) but deferred.

## Considered & Deferred

### Branch-based agent testing
Test new agent configs on a git branch before merging to main.
Currently not needed -- daily auto-commit to main is sufficient.
Revisit when agent failures become costly enough to justify branch workflow.

### claudeworkspace/ top-level repo
Track workspace CLAUDE.md, orchestration state, and orchestration/ directory.
Lower priority than ~/.claude/ -- the workspace CLAUDE.md changes infrequently.

### SessionStart hook on laptop
Auto-pull from GitHub when starting a Claude Code session.
Deferred because Syncthing handles real-time sync already.
Only needed if Syncthing sync lags become a problem.

### Pre-commit hooks
Format checking, large file detection, secret scanning.
The auto-commit script already has a secret grep check.
Full pre-commit hooks are overhead for a config repo.

### Git tags for milestones
Version tags like v2026.02, v2026.03 for significant config states.
Add when the history is long enough to benefit from tags.

## Research Sources

- brianlovin/claude-config (193 stars) -- dedicated config repo with tests, sync.sh
- hesreallyhim/awesome-claude-code (23.9k stars) -- curated skills/hooks list
- VoltAgent/awesome-agent-skills (7.2k stars) -- 300+ cross-platform skills
- 0xfurai/claude-code-subagents (709 stars) -- 100+ categorized subagents
- anthropics/claude-plugins-official -- official plugin repo
- GitHub issue #764 -- symlinking entire ~/.claude breaks file detection
- ArXiv 2602.05447 -- domain-partitioned organization outperforms size-based

## Community Patterns Evaluated

| Pattern | Adopted? | Rationale |
|---------|----------|-----------|
| Git directly in ~/.claude/ | Yes | Symlinks break Claude Code (issue #764) |
| .git excluded from Syncthing | Yes | Git internals unsafe for bidirectional sync |
| Daily auto-commit cron | Yes | Captures evolution changes without noise |
| GNU Stow for symlinks | No | Too much maintenance with 34 skills |
| Git submodules for skills | No | Nobody in community uses them |
| Public plugin registry | N/A | None exists yet; git repos are the distribution mechanism |
| @imports for modular CLAUDE.md | Already done | 3 imports already in use |
