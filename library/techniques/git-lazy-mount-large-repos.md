# git-lazy-mount — Lazy Checkout for Very Large Repos

**Source**: https://github.com/mohsen1/git-lazy-mount
**Date**: 2026-06-26 (integrated 2026-07-19)
**Type**: technique (evaluation candidate for disposable agent sandboxes)
**Score**: 71.5/100 (approved 2026-06-28)

## The Problem It Targets

Coding agents pay a heavy cold-start cost on very large repositories: a full clone and
checkout materializes millions of files the session will never touch, and naive
search walks all of them. For disposable agent workspaces (spin up, do one task, throw
away), the checkout can dominate the task's wall time.

## What It Does

git-lazy-mount exposes a repository as a **lazily-materialized filesystem** (Linux/FUSE):
files appear in the tree but their contents are fetched on first read. Search is routed
through `sgrep` against the object store rather than walking materialized files. The
effect: a task that touches 40 files materializes ~40 files, regardless of repo size.
Upstream publishes strong benchmark claims for cold-start and search; treat them as
unverified until reproduced locally.

## Where It Would Fit Here

- Disposable sandboxes for agent tasks on repos the size of `historical-nanochat`'s
  data trees or large external codebases pulled for review — cases where today the
  choice is "full clone" vs "shallow clone that breaks tooling."
- NOT for the primary working copies of active projects: FUSE indirection under an
  interactive session adds a failure mode (mount dies → tools see an empty tree) with
  little benefit when the repo is already local and warm.

## Evaluation Plan (before any operational use)

1. Pick one genuinely large repo; measure baseline: full clone time, disk, first-search
   latency, and an agent task end-to-end.
2. Repeat under git-lazy-mount; verify correctness (same task output), then compare
   cold-start, disk, and search numbers against upstream claims.
3. Probe the failure modes: mount interruption mid-task, concurrent readers, and tools
   that stat/walk the whole tree (linters, LSP indexers) — these defeat laziness and
   may perform *worse*.

## Caveats

- Linux/FUSE only; requires FUSE availability inside whatever sandbox runs the agent.
- Any tool that eagerly indexes the workspace will force full materialization —
  check the task's toolchain before assuming savings.

**Tags**: `git-lazy-mount`, `large-repos`, `lazy-checkout`, `fuse`, `cold-start`,
`disposable-sandbox`, `sgrep`
