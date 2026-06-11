{
  "name": "CLAUDE_CODE_FORK_SUBAGENT — Forked Subagent Process Model",
  "source": "Official Claude Code v2.1.117 changelog",
  "version": "2.1.117",
  "date_discovered": "2026-04-22",
  "type": "novel",
  "classification": "NOVEL",
  "existing_capability": "Subagents are spawned as new subprocesses via the Task tool. No current control over the process model (fork vs spawn). Claude Code Auto Mode and Agent Spawn Restrictions exist but do not control process model.",
  "description": "New env var `CLAUDE_CODE_FORK_SUBAGENT=1` changes how Claude Code spawns subagents in external builds (non-standard/compiled distributions, e.g. Tauri, Electron, bun-compiled). With this flag, subagents fork from the current process rather than spawning a fresh subprocess. Potential benefits: reduced subagent startup overhead, shared memory pages before CoW divergence, lower latency for high-frequency subagent dispatch.",
  "relevance": "Unclear applicability to standard npm/native Linux builds. The 'external builds' qualifier suggests this is primarily for packaged distributions where subprocess spawning is expensive. On requiem (native npm/npx install), effect may be zero. Needs empirical verification: set the env var, spawn 10 subagents, measure time vs without.",
  "integration_complexity": 100,
  "token_efficiency_impact": 60,
  "capability_expansion": 50,
  "maintenance_burden": 90,
  "community_validation": 100,
  "preliminary_score": 78,
  "action": "NEEDS_RESEARCH — verify whether flag affects standard npm builds on native Linux, or only compiled/packaged distributions. Test empirically before adding to bashrc.",
  "redundancy_check": "NOVEL — no existing process-model control for subagent spawning. Agent Spawn Restrictions control WHICH agents can be spawned (security), not HOW they're launched (process model).",
  "notes": "Score range 65-80. If the flag is effective on standard npm builds and reduces per-subagent startup time, this is an easy bashrc addition. If it only applies to compiled distributions (Tauri/Electron), it has zero relevance to this setup. The single action item is: test with `CLAUDE_CODE_FORK_SUBAGENT=1 claude -p` and spawn a subagent, checking whether timing or behavior changes. 'External builds' language implies it may be a no-op on npm.",
  "final_decision": {
    "decision": "REJECTED",
    "decided_at": "2026-04-30",
    "decided_by": "user (interactive walkthrough)",
    "reasoning": "Empirically confirmed no benefit on standard npm install on native Linux (requiem).",
    "empirical_evidence": {
      "sandbox_test": "passed (no permission lock-out, no sandbox failures)",
      "timing_benchmark": "3 sequential 'claude -p --model haiku' calls: 58.47s without var vs 58.87s with var (+0.4s, within noise). No measurable speedup.",
      "interpretation": "Confirms doc's 'external builds' hint — var targets compiled distributions (Tauri/Electron/bun-compiled), not standard npm. Within-session subagent spawn (Task tool) is in-process anyway on standard build."
    }
  }
}
