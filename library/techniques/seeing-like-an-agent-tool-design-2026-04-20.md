# Seeing Like an Agent — Anthropic Tool Design Philosophy

**Source**: https://claude.com/blog/seeing-like-an-agent  
**Author**: Thariq Shihipar (Anthropic Engineering)  
**Published**: 2026-04-10  
**Type**: First-Party Design Philosophy  
**Discovered**: 2026-04-20

---

## Core Insight

Tools fail not because they're wrong, but because the **agent can't see through them correctly**. The primary failure mode is designing tools from a human's perceptual model instead of the agent's.

> "What does Claude see when it encounters this tool? What information does it need to choose it, invoke it correctly, and interpret its output?"

---

## Three Core Principles

### 1. Progressive Disclosure

Tools should surface just enough information for the agent to act, without flooding context with irrelevant detail.

**Pattern**:
- Tool description → ONE sentence that captures when to use it
- Tool parameters → minimal, clearly named, default-friendly
- Tool output → structured summary, not raw data dump

**Anti-pattern**: A tool description that explains HOW the tool works rather than WHEN to use it. The agent must parse mechanics when it needs intent.

**Application to SKILL.md files**:
- First ~50 words of a skill: clear trigger condition + one-sentence capability summary
- Decision trees before implementation details (users skim; so does the model)
- Cap-and-expand: overview first, full details below a fold

### 2. Seeing Like an Agent

Design tools by reasoning through the **agent's perceptual model**, not a human's:

| Human model | Agent model |
|-------------|-------------|
| "This button sends a form" | "This tool submits an HTTP POST with these fields" |
| "Just drag it to the folder" | "Move file from source path to destination path" |
| "You can see everything on the screen" | "I receive only what the tool returns — nothing more" |

The agent cannot see, infer, or remember what isn't in the tool result. Design the result as if the agent has zero other context.

**Concrete check**: For every tool, ask: "If this were the ONLY thing Claude could see, could it take the next correct action?"

### 3. Discoverability Over Completeness

Even a perfect tool fails if Claude can't find or invoke it. Discoverability is a first-class design concern:

- **Tool names**: Verb + noun, action-oriented (`search_documents`, not `document_handler`)
- **Descriptions**: Lead with the use case trigger, not the implementation
- **Parameter names**: Self-documenting (`target_directory`, not `td`)
- **Default values**: Cover the common case so the agent doesn't need to guess

---

## Case Studies (from the post)

### AskUserQuestion

**Problem**: Users were getting buried under intermediate model chatter. Critical clarification questions appeared mid-conversation, easy to miss.

**Solution**: `AskUserQuestion` as a **blocking modal** — it stops the agent until the human responds. The tool's design forces the interaction pattern.

**Why this worked**: The tool's behavioral contract (blocking vs. non-blocking) was chosen first, then the API was designed to enforce it. The human-perceptual insight ("users miss mid-conversation questions") was translated into agent-native terms ("block execution until answered").

### Task Tool (context isolation)

**Problem**: Subagents were polluting parent context with intermediate work.

**Solution**: Task tool creates an isolated context sandbox — the subagent's full working memory never enters the parent's context window.

**Why this worked**: "Isolation" is intuitive to humans (sandbox), but the agent-native insight is "I cannot see the subagent's reasoning, only its final output." The tool was designed around that constraint.

---

## Application to This System

### SKILL.md Authoring

| Old pattern | New pattern (progressive disclosure) |
|-------------|--------------------------------------|
| Long system-level overview first | Decision tree / quick reference first |
| Explain every option and edge case | Document the 80% case; link details below |
| Vague "use when needed" trigger | Explicit: "Trigger when X" |
| Implementation-first description | Use-case-first: "This skill handles Y" |

Existing skills that apply this well: `mcp-search-framework` (decision tree → details), `mgrep-guide` (quick reference → comparison table → examples).

### MCP Tool Description Writing

For any tool Claude needs to discover and invoke:
1. Lead with: "Use this when [specific trigger condition]"
2. Describe output format: "Returns [summary/list/structured JSON]"
3. Name parameters for self-documentation
4. Test discoverability: strip the implementation, does the description alone tell Claude when to use it?

### Agent Design Patterns

- Agent `description` field in frontmatter = the discoverability surface. Write it as "Use this agent when [trigger]" not "This agent does [implementation]"
- Tool lists in agent frontmatter: include only tools the agent needs; the model's attention distributes across the full list

---

## Relationship to Existing Capabilities

| Existing capability | Relationship |
|--------------------|-------------|
| `advanced-tool-use` skill | That skill covers WHICH tools to use and when; this technique covers HOW to write tools/skills so agents discover and use them correctly |
| Tool Search Tool (v2.1.7+) | Progressive disclosure is the supply-side complement to Tool Search's demand-side filtering |
| SKILL.md design conventions | This provides first-principles justification for the existing 2KB cap + decision-tree-first convention |
| Context7 library docs | Same progressive disclosure principle: query-optimized summaries before full docs |

---

## Key Takeaway

> "The 2KB skill cap, decision-tree-first layout, and use-case-first agent descriptions aren't aesthetic preferences — they're implementations of the progressive disclosure principle. The model perceives skills as tools; tool design principles apply."

**Redundancy triggers**: "seeing like an agent", "progressive disclosure tool design", "tool design philosophy anthropic", "agent perceptual model", "tool discoverability design", "AskUserQuestion blocking modal", "tool design first-party", "thariq shihipar tool design", "SKILL.md progressive disclosure", "agent-native tool design"
