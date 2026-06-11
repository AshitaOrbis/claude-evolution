# Discovery: Next.js DevTools MCP

- **Source**: https://www.npmjs.com/package/next-devtools-mcp (Vercel official)
- **Date Found**: 2026-02-06
- **Category**: mcp
- **Summary**: Official Vercel MCP server for Next.js 16+ development tools. Provides AI assistants with runtime diagnostics, automated upgrades, Cache Components setup, and browser testing integration via Playwright.
- **Potential Value**: High
- **Integration Complexity**: Easy

## Description

Next.js DevTools MCP is an official Vercel package (0.3.10, published 16 days ago) that bridges AI coding assistants to Next.js development workflows.

**Key Features**:

1. **Runtime Diagnostics (Next.js 16+)**: Connect to dev server's built-in `/\_next/mcp` endpoint
   - Real-time build/runtime errors
   - Application routes, pages, component metadata
   - Development server logs
   - Server Actions and component hierarchies

2. **Development Automation**:
   - Automated Next.js 16 upgrades with official codemods
   - Cache Components setup with error detection and automated fixes
   - Browser testing integration via Playwright

3. **Knowledge Base**:
   - Curated Next.js 16 knowledge base (12 focused resources)
   - Direct access to official Next.js documentation via search API
   - Pre-configured prompts for upgrades and Cache Components

**Version**: 0.3.10 (published Jan 2026)
**Support**: Claude Code, Amp, Codex (official docs for all)

## Redundancy Check

**Status**: NOVEL

Checked against registry:
- **No Next.js development MCP**: We have Playwright MCPs (better-playwright, chrome-devtools) but NOT Next.js-specific tooling
- **Not generic browser automation**: This provides Next.js runtime introspection + automated codemods
- **Complements existing**: better-playwright is for E2E testing; this is for Next.js dev workflows

Triggers checked:
- "browser automation" → We have Better Playwright, but that's for TESTING, not Next.js dev tooling
- "developer tools" → No existing dev-specific MCPs
- "framework integration" → No framework-specific MCPs in registry

**Novel capabilities**:
1. Next.js runtime introspection (routes, errors, logs from live dev server)
2. Automated Next.js version upgrades
3. Cache Components configuration automation
4. Next.js-specific knowledge base

## Evaluation Needs

1. **Use case fit**:
   - Is <private-project>-v2 using Next.js? (Yes, in applications/)
   - Are we actively developing Next.js apps? (Yes, v2 is active)
   - Would runtime diagnostics help? (Potentially for debugging)

2. **Token impact**:
   - Likely low (structured API responses from `/\_next/mcp`)
   - Knowledge base might add context, but on-demand

3. **Integration with existing Playwright MCPs**:
   - Does it replace or complement better-playwright?
   - Docs say it uses Playwright internally - duplication risk?

4. **Next.js 16 requirement**:
   - What version is <private-project>-v2 using?
   - Migration path if using older version?

5. **Key questions**:
   - Does <private-project>-v2 need this NOW or LATER?
   - Would automated Cache Components setup save time?
   - Is the MCP runtime endpoint secure (localhost only)?
   - How much context does the knowledge base add?

**Scoring factors**:
- **Integration complexity**: Easy (npx command)
- **Token efficiency**: Likely neutral to positive (structured data)
- **Capability expansion**: HIGH for Next.js projects (runtime diagnostics novel)
- **Maintenance burden**: Low (official Vercel package)
- **Community validation**: Official Vercel = HIGH

**Decision dependency**: Verify <private-project>-v2 is using Next.js and would benefit from runtime diagnostics.

---

## Evaluation

**Date**: 2026-02-06
**Evaluator**: Claude Opus 4.6 (capability-evaluator)

### Redundancy Analysis

**Registry check**: Better Playwright MCP exists for browser automation/testing. Chrome DevTools MCP exists for browser debugging. **Classification: NOVEL** - Next.js-specific development tooling is distinct from generic browser automation.

**Key distinction**:
- **Better Playwright MCP**: E2E testing (any website)
- **Chrome DevTools MCP**: Generic browser debugging
- **Next.js DevTools MCP**: Next.js runtime introspection + automated codemods

### Environment Check

Verified: `<private-project>-v2/apps/web/package.json` uses **Next.js ^15.1.3**

**Issue**: Next.js DevTools MCP requires **Next.js 16+** for runtime diagnostics (`/_next/mcp` endpoint).

### Scoring

| Criterion | Score | Weight | Weighted | Rationale |
|-----------|-------|--------|----------|-----------|
| Integration Complexity | 90/100 | 20% | 18.0 | Simple npx command, official Vercel package |
| Token Efficiency Impact | 85/100 | 25% | 21.25 | Structured API responses, on-demand knowledge base, likely low token overhead |
| Capability Expansion | 75/100 | 25% | 18.75 | Novel Next.js runtime introspection + codemods, but REQUIRES Next.js 16 upgrade |
| Maintenance Burden | 95/100 | 15% | 14.25 | Official Vercel package, actively maintained, stable |
| Community Validation | 100/100 | 15% | 15.0 | Official Vercel (highest validation possible) |
| **TOTAL** | | | **87.25/100** | **APPROVE** |

### Cross-Validation (Codex)

Used codex-researcher to cross-validate:

**Codex assessment**: 85/100 - "Official Vercel package with high value for Next.js developers. Runtime diagnostics and automated codemods are compelling. Next.js 16 requirement is a blocker for immediate use but upgrade is inevitable. Approve with condition: integrate after Next.js 16 upgrade."

**Variance**: 2.25 points (excellent consensus)

### Decision: **APPROVE WITH CONDITION** (Score: 87.25/100)

**Rationale**: Well above 70+ threshold due to:
1. **Official Vercel package**: Highest possible validation
2. **Novel capabilities**: Runtime diagnostics (`/_next/mcp` endpoint), automated codemods, Next.js-specific knowledge base
3. **Token efficiency**: Structured API responses, on-demand loading
4. **Low maintenance**: Official package with active development
5. **Real value**: Automated upgrades, Cache Components setup, real-time build errors

**BLOCKER**: Requires Next.js 16+, we're on Next.js 15.1.3

### Conditions for Integration

1. **Upgrade Next.js to 16+**: Required for runtime diagnostics feature
2. **Test with Playwright MCPs**: Ensure no conflicts (Next.js DevTools uses Playwright internally)
3. **Verify `/_next/mcp` security**: Ensure endpoint is localhost-only (not exposed to production)
4. **Document use cases**:
   - When to use Next.js DevTools (dev workflows, upgrades)
   - When to use Better Playwright (E2E testing)
   - When to use Chrome DevTools (generic debugging)

### Integration Path (After Next.js 16 Upgrade)

1. **Upgrade Next.js**: `pnpm upgrade next@16` (future task)
2. **Install MCP**: `claude mcp add --transport stdio next-devtools`
3. **Configure**:
   ```json
   {
     "mcpServers": {
       "next-devtools": {
         "command": "npx",
         "args": ["next-devtools-mcp@latest"]
       }
     }
   }
   ```
4. **Verify runtime endpoint**: Start Next.js dev server, check `http://localhost:3000/_next/mcp` exists
5. **Create skill file**: `~/.claude/skills/nextjs-development/SKILL.md`
   - When to use runtime diagnostics
   - How to interpret build/runtime errors
   - Automated upgrade workflows
   - Cache Components setup patterns
6. **Update registry**: Add to existing-capabilities.md under "Framework Integration" (new section)

### Use Cases (After Integration)

1. **Runtime Diagnostics**: Real-time build/runtime errors from dev server
2. **Automated Upgrades**: Next.js 16+ codemods with error detection
3. **Cache Components**: Automated setup with validation
4. **Component Introspection**: Server Actions, component hierarchies, routes/pages metadata
5. **Knowledge Base**: Curated Next.js 16 resources + official docs search

### Comparison: Next.js DevTools vs Playwright MCPs

| Feature | Better Playwright | Chrome DevTools | Next.js DevTools |
|---------|------------------|-----------------|------------------|
| Purpose | E2E testing | Generic debugging | Next.js dev workflows |
| Target | Any website | Any web app | Next.js apps only |
| Runtime diagnostics | No | Yes (generic) | Yes (Next.js-specific) |
| Automated codemods | No | No | Yes (Next.js upgrades) |
| Token efficiency | 91% DOM compression | 89% with WebMCP | High (structured API) |

**Verdict**: COMPLEMENTARY - Use Next.js DevTools for development, Better Playwright for testing.

### Notes

This is the strongest MCP evaluation yet: official Vercel package, novel capabilities, excellent token efficiency, perfect fit for our Next.js stack. The only blocker is the Next.js 16 requirement, which makes this a "integrate soon" rather than "integrate now" approval.

**Action**: Mark as APPROVED, move to pipeline/integration/, but add note "BLOCKED: Requires Next.js 16 upgrade" in integration file.
