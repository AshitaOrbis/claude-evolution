---
date: 2026-05-11
topic: "Create a new experiment based on this, and investigate what might need to be changed for a Canadian context"
discord_message_id: "1501975523633532928"
url: "https://github.com/TraderAlice/OpenAlice"
status: complete
---

# OpenAlice: AI Trading Agent — Canadian Context Investigation

## Topic
> Create a new experiment based on this, and investigate what might need to be changed for a Canadian context: https://github.com/TraderAlice/OpenAlice

## Key Findings

- **What it is**: OpenAlice is a full-stack AI trading agent in TypeScript/Python that covers equities, crypto, commodities, forex, and macro — from research through position entry, management, and exit. Explicit "one-person Wall Street" framing.
- **Architecture fit**: Four-layer design (Interface → Core → Domain → Automation) is well-structured and mirrors our Claude-evolution pipeline patterns. Uses Claude Agent SDK or Vercel AI SDK, switchable at runtime — directly compatible with our stack.
- **Canadian broker gap**: Default brokers are Alpaca, Interactive Brokers (IBKR), and CCXT. Alpaca supports Canadian accounts; IBKR is the best-supported Canadian option. Questrade (via API) is missing but feasible to add.
- **Regulatory differences**: Canada operates under IIROC (now CIRO) and provincial securities commissions — not SEC/FINRA. PDT (Pattern Day Trader) 25k rule does not apply in Canada; margin requirements differ. Futures and options have different registration thresholds.
- **Tax treatment divergence**: Canadian trading income may be classified as business income (100% taxable) vs capital gains (50% inclusion rate) — the classification test depends on frequency and intent. TFSA and RRSP accounts have special rules (TFSA gains tax-free; CRA scrutinizes "active trading" in registered accounts).
- **Exchange coverage**: NYSE/NASDAQ are accessible via IBKR, but TSX (Toronto Stock Exchange) and TSX Venture need explicit symbol routing. CAD-denominated instruments need FX handling. Crypto exchanges like Bitget, Newton, and Shakepay are Canadian-relevant.
- **Safety**: Repository explicitly warns against live trading with real funds — well-suited for paper trading experiments only.

## Details

OpenAlice is architecturally impressive for an open-source project: it implements a "Trading-as-Git" workflow (stage/commit/push operations with full history), a Guard Pipeline with mandatory pre-execution safety checks, and multi-interface delivery routing (Web UI, Telegram, MCP server). The MCP server interface is directly composable with our Claude Code toolchain.

The Canadian regulatory context creates two substantive differences: (1) broker integration and (2) tax/account logic. IBKR is the strongest path for Canadian equities — it supports TSX, TFSA/RRSP accounts (though with caveats), and has an established API via the `ib_insync` Python library. Alpaca does not support TSX-listed stocks. Questrade has an unofficial API but nothing production-grade.

The tax calculation module (if OpenAlice has one) would need to be adapted: Canadian ACB (Adjusted Cost Base) tracking is required for capital gains, and the CRA's "superficial loss" rules (analogous to US wash-sale rules) apply. Active traders in registered accounts face potential reclassification risk — the experiment should flag this.

For a workspace experiment, the most interesting adaptation would be: run OpenAlice in paper-trading mode with IBKR sandbox, targeting TSX-listed small/mid-caps with a fundamental-research filter (the project already includes company profiles, analyst estimates, insider trading data). The multi-asset coverage (equities + crypto) maps well to a diversified Canadian retail investor.

## Relevance to Workspace

- **experiments/** directory: This fits cleanly as an experiment under `experiments/` — start with paper trading, document Canadian modifications.
- **Claude Agent SDK integration**: OpenAlice is already built on the Claude Agent SDK and supports MCP server mode, so it could potentially be called from Claude Code as a tool.
- **Hermes compatibility**: The automation layer (cron + heartbeat) mirrors Hermes-style long-running agent patterns.
- **Revenue pipeline**: Mothballed but relevant context — AGPL-3.0 license means any fork must be open-sourced if distributed.

## Recommended Actions

1. **Fork and create a Canadian-context branch** in `experiments/` — start with IBKR paper trading integration.
2. **Add TSX symbol routing** to the market data module (IBKR supports this; just needs the exchange code mapping).
3. **Document TFSA/RRSP trading restrictions** as a Guard Pipeline rule — prevent trades that would trigger CRA scrutiny.
4. **Build ACB tracking** as a Canadian-specific tax module alongside any US capital gains module.
5. **Start paper-only**: The experimental warning is serious. Run at least 30 days on paper before considering any live testing.
