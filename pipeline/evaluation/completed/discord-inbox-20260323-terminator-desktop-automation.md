# Terminator: Desktop Automation via MCP

- **Date**: 2026-03-23
- **Source**: Discord #general inbox
- **URL**: https://github.com/mediar-ai/terminator
- **Category**: tool
- **Automated**: Yes (discord-inbox-scan)
- **Discord Message ID**: 1485680696759423077

## Description

Terminator is an open-source MCP agent that enables AI assistants (Claude, Cursor, VS Code) to control and automate Windows desktops. It provides desktop automation through multiple detection methods (pixel-based, DOM-based, Windows accessibility trees) and operates in the background without hijacking cursor/keyboard. Claims >95% success rate and 100x faster execution than competing computer-use solutions.

## Technical Details

- **License**: MIT
- **Platform**: Windows only (no macOS/Linux support)
- **Interfaces**: TypeScript/JavaScript SDKs, Python bindings, CLI, workflow recorder, native MCP integration
- **Architecture**: Deterministic workflows with AI-driven recovery; background execution with session persistence using existing cookies/auth
- **Core claim**: Background automation without cursor hijacking, high reliability

## Relevance

Could be useful for:
- Automating complex multi-application workflows within the evolution system
- Building desktop-based agent orchestration (running automation alongside Claude Code)
- Enhancing computer-use capabilities for agents requiring native desktop control
- Potentially integrating with the agent-embassy sandbox for isolated desktop experiments

Windows-only limitation is a constraint (workspace is primarily Linux).

## Classification

To be evaluated by the standard pipeline.
