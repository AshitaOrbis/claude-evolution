# Claude Evolution

A self-improving AI development environment. Discovers new capabilities, evaluates them against a scoring framework, and automatically integrates approved tools as skills, agents, or MCP configurations.

## The Idea

Your AI development environment can improve itself. Here's how:

1. **Discovery**: A scheduled agent searches GitHub, newsletters, and forums for new Claude Code tools, MCP servers, prompt techniques, and workflow patterns
2. **Evaluation**: Each discovery is scored on 5 criteria (integration complexity, token efficiency, capability expansion, maintenance burden, community validation)
3. **Integration**: Items scoring 70+ are automatically integrated into your Claude Code setup (new skills, agents, MCP configs, or techniques)
4. **Verification**: Integrated capabilities are tested and added to a registry for redundancy checking

```
┌─────────────────────────────────────────────────────────────────────┐
│                    EVOLUTION PIPELINE                                │
│                                                                     │
│   Discovery ──> Evaluation ──> Integration ──> Verification         │
│       │              │              │               │               │
│   RSS feeds     5-criterion     Auto-write      Test & add          │
│   GitHub        scoring         SKILL.md or     to capability       │
│   Forums        (70+ approve)   agent config    registry            │
│   Newsletters                                                       │
└─────────────────────────────────────────────────────────────────────┘
```

The system runs on cron (daily discovery, evaluation, and integration) so your development environment improves while you sleep.

## Quick Start

```bash
# 1. Clone
git clone https://github.com/AshitaOrbis/claude-evolution.git
cd claude-evolution

# 2. Configure
cp .env.example .env
# Edit .env with your paths and optional Discord webhook

# 3. Run a manual discovery
./scripts/evolution-daily.sh

# 4. Check what was found
ls pipeline/discovery/daily/

# 5. Review evaluations
ls pipeline/evaluation/completed/

# 6. Set up the cron (optional)
# Add to crontab -e:
# 0 6 * * * /path/to/claude-evolution/scripts/evolution-daily.sh >> /path/to/claude-evolution/logs/cron.log 2>&1
```

## How It Works

### Discovery Phase

The discovery agent searches multiple sources for new capabilities:

- **GitHub**: Repos tagged with `claude-code`, `mcp-server`, `ai-agent`
- **RSS Feeds**: AI newsletters (The Batch, TLDR AI, Ben's Bites)
- **Forums**: r/ClaudeAI, Hacker News (AI-tagged)
- **Anthropic Blog**: Official releases and engineering posts

Each discovery is saved as a structured JSON file in `pipeline/discovery/`.

### Evaluation Phase

Discoveries are scored on 5 weighted criteria:

| Criterion | Weight | Scoring |
|-----------|--------|---------|
| Integration complexity | 20% | Easy=100, Hard=50, Impossible=0 |
| Token efficiency impact | 25% | Major savings=100, Neutral=50, Costs more=0 |
| Capability expansion | 25% | Novel=100, Incremental=70, None=0 |
| Maintenance burden | 15% | Low=100, Medium=70, High=30 |
| Community validation | 15% | Official/1k+ stars=100, <100 stars=50 |

**Thresholds:**
- **70+**: Approved for integration
- **50-69**: Needs more research (flagged for manual review)
- **<50**: Rejected (archived with reason)

Before evaluation, each discovery is checked against the **capability registry** to catch duplicates and identify improvements over existing capabilities.

### Integration Phase

Approved items are automatically integrated based on their type:

| Discovery Type | Integration Target |
|---------------|-------------------|
| MCP Server | Claude Code MCP configuration |
| Workflow pattern | New skill file (`SKILL.md`) |
| Agent behavior | New agent definition |
| Technique/docs | Updates to existing skills |

### Verification Phase

After integration, the new capability is tested:
1. Verify the tool/skill/agent works
2. Add to the capability registry
3. Create an integration report

## Directory Structure

```
claude-evolution/
├── pipeline/                     # Phase-based workflow
│   ├── discovery/               # Raw discovery results
│   │   └── daily/               # Daily discovery reports
│   ├── evaluation/              # Scoring and decisions
│   │   ├── pending/             # Awaiting evaluation
│   │   └── completed/           # Evaluated items
│   ├── integration/             # Items being integrated
│   └── verification/            # Testing new capabilities
├── registry/
│   └── existing-capabilities.md # Redundancy checking registry
├── scripts/
│   ├── evolution-daily.sh       # Daily heartbeat (discovery + evaluation + integration)
│   └── evolution-weekly.sh      # Weekly analysis and cleanup
├── helpers/                     # Auto-generated reusable patterns
├── examples/                    # Example discoveries and evaluations
├── .env.example                 # Configuration template
├── LICENSE                      # MIT
└── README.md
```

## Configuration

### Environment Variables (`.env`)

```bash
# Required: Path to this repository
EVOLUTION_DIR=/path/to/claude-evolution

# Optional: Discord webhook for notifications
DISCORD_WEBHOOK_URL=https://discord.com/api/webhooks/your/webhook

# Optional: Claude model for discovery (default: sonnet)
DISCOVERY_MODEL=sonnet

# Optional: Claude model for evaluation (default: sonnet)
EVAL_MODEL=sonnet
```

### Capability Registry

The registry (`registry/existing-capabilities.md`) prevents the system from wasting time on things you already have. Before evaluating any discovery, the system checks:

1. Does this match an existing capability? (DUPLICATE -> skip)
2. Is it better than what we have? (IMPROVEMENT -> compare)
3. Is it genuinely new? (NOVEL -> full evaluation)

## Multi-Model Orchestration

The system delegates to different AI models based on task type:

| Task | Model | Why |
|------|-------|-----|
| Discovery (search) | Sonnet | Fast, good at following instructions |
| Evaluation (scoring) | Sonnet/Opus | Needs judgment |
| Code review | Codex (GPT-5) | Different perspective catches different bugs |
| Integration (writing code) | Sonnet | Fast code generation |
| Helper generation | Haiku | Simple extraction tasks |

## Extending the System

### Adding Discovery Sources

Add RSS feed URLs or search queries to the discovery prompt in `HEARTBEAT-DAILY.md`.

### Adjusting Scoring Weights

Modify the evaluation criteria weights in the evaluation prompt. If you value token efficiency more than capability expansion, increase its weight.

### Adding Integration Types

The integration agent follows patterns. To add a new integration type (e.g., VS Code extensions), create a template in `helpers/templates/` and update the integration prompt.

## How This Was Built

This system emerged from noticing that Claude Code's capabilities expand faster than any person can track. New MCP servers, prompt techniques, and workflow patterns appear daily. Rather than manually checking GitHub and newsletters, why not have Claude do it?

The first version was a simple cron job that ran a discovery search and posted results to Discord. Over time, it grew evaluation scoring (to filter noise), automatic integration (to reduce manual work), and a capability registry (to prevent duplicate effort).

Read more: [Building an AI That Improves Itself](https://ashitaorbis.com/posts/building-an-ai-that-improves-itself) (coming soon)

## Acknowledgements

Built with [Claude Code](https://claude.ai/claude-code) by [Ashita Orbis](https://ashitaorbis.com).

## License

MIT
