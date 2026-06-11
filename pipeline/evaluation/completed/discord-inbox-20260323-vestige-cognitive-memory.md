# Vestige: Cognitive Memory for AI Agents

- **Date**: 2026-03-23
- **Source**: Discord #general inbox
- **URL**: https://github.com/samvallad33/vestige
- **Category**: mcp, tool
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1485759278404079830

## Description

Vestige is a neuroscience-inspired cognitive memory system for AI agents that enables persistent memory across sessions. Unlike traditional RAG systems, it actively manages what matters through prediction error gating, importance scoring, and spaced repetition (FSRS-6). Implements 7-stage cognitive search combining keyword matching, semantic similarity, and graph-based spreading activation. Memory consolidation through "dreaming" (replaying and synthesizing insights).

## Technical Details

- **Implementation**: Single Rust binary (~22MB), runs as MCP server
- **Storage**: SQLite with vector embeddings (Nomic Embed v1.5 by default)
- **Tools**: 21 MCP tools for memory management
- **Codebase**: 29 cognitive modules, 79,600+ lines, 1,238 tests
- **Visualization**: 3D neural network dashboard (WebGL, Three.js)
- **Infrastructure**: Local-only, zero cloud dependency

## Key Features

- **Prediction error gating**: Stores only novel/surprising information
- **Importance scoring**: 4-channel system (novelty, arousal, reward, attention)
- **Spaced repetition**: Manages memory decay naturally using FSRS-6
- **Memory consolidation**: Automatic replay and synthesis of connected memories
- **Deduplication**: Automatic detection and merging of similar memories

## Relevance

Highly relevant for:
- Agent memory systems (complements existing memory infrastructure in claude-evolution)
- Improving context persistence across long-running cron jobs and subagents
- Building knowledge graphs with intelligent pruning (vs simple RAG)
- Research into cognitive modeling for agents (aligns with Psyche and agent-event-bus work)
- Potential integration with capability-discoverer for maintaining learned patterns

Direct fit for the evolution system's memory and knowledge management needs.

## Classification

To be evaluated by the standard pipeline.
