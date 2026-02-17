---
name: genealogy-toolkit
description: Comprehensive toolkit for genealogy research including templates, reference guides, and workflows for investigating family history using AI-powered tools.
---

# Genealogy Toolkit Skill

A comprehensive resource for genealogy research using Claude Code's multi-agent system.

## Overview

This skill provides templates, reference materials, and workflows for conducting genealogy research with:
- **Codex** (GPT-5) for web research
- **Gemini** for document/image analysis
- **Specialized subagents** for research, analysis, and reporting

## Quick Start

### 1. Begin Research Session

```
Use genealogy-researcher to search for [ancestor name] born around [year] in [location]
```

### 2. Analyze Downloaded Documents

```
Use document-analyzer to extract text from genealogy/data/raw/[file]
```

### 3. Check Data Quality

```
Use discrepancy-detective to scan the repository
```

### 4. Break Through Stuck Points

```
Use brick-wall-breaker to analyze the research block for [ancestor name]
```

### 5. Generate Reports

```
Use family-chronicler to create a PDF report for [person-id]
```

## Available Templates

| Template | Path | Use For |
|----------|------|---------|
| Person Profile | `templates/person-profile.json` | New person records |
| Family Unit | `templates/family-unit.json` | New family records |
| Research Log | `templates/research-log.md` | Session documentation |
| Source Citation | `templates/source-citation.json` | New source entries |

## Reference Guides

| Guide | Path | Contents |
|-------|------|----------|
| Record Types | `references/record-types.md` | Guide to genealogy records |
| European Archives | `references/european-archives.md` | Country-specific databases |
| Citation Formats | `references/citation-formats.md` | Proper citation examples |

## Specialized Subagents

### genealogy-researcher
- **Purpose**: Web search and database queries
- **Uses**: Codex (GPT-5) for research
- **Output**: Downloaded records, research logs

### document-analyzer
- **Purpose**: Image/PDF analysis and OCR
- **Uses**: Gemini for visual analysis
- **Output**: Transcriptions, structured data

### discrepancy-detective
- **Purpose**: Data quality validation
- **Output**: Discrepancy reports, action items

### brick-wall-breaker
- **Purpose**: Research strategy development
- **Output**: Strategy documents, action plans

### family-chronicler
- **Purpose**: Report generation
- **Output**: PDF reports, family histories

## Research Workflow

```
1. ONBOARD → Document known family information
         ↓
2. SEARCH → Use genealogy-researcher to find records
         ↓
3. DOWNLOAD → Save records to genealogy/data/raw/
         ↓
4. ANALYZE → Use document-analyzer to extract data
         ↓
5. VALIDATE → Use discrepancy-detective to check
         ↓
6. INTEGRATE → Update person/family profiles
         ↓
7. REPORT → Use family-chronicler to generate output
```

## Data Storage

All research data is stored in `genealogy/`:

```
genealogy/
├── data/raw/          # Original downloads
├── data/extracted/    # OCR/transcriptions
├── people/            # Person profiles
├── families/          # Family units
├── sources/           # Citation registry
├── research/          # Logs, tasks, brick-walls
└── reports/           # Generated outputs
```

## European Research Focus

This toolkit prioritizes free European genealogy resources:

1. **FamilySearch** (familysearch.org) - Global
2. **Geneanet** (geneanet.org) - France/Europe
3. **Matricula Online** (matricula-online.eu) - Church records
4. **Country-specific archives** - See `references/european-archives.md`

## Citation Requirements

Every fact requires a source citation following the Evidence Explained format:
- Repository
- Collection
- Specific locator
- Access date

## Genealogical Proof Standard

Follow the GPS for conclusions:
1. Reasonably exhaustive search
2. Complete source citations
3. Analysis and correlation
4. Conflict resolution
5. Written conclusion

## Best Practices

1. **Document negative searches** - What you didn't find is valuable
2. **Use multiple sources** - Don't rely on single records
3. **Note confidence levels** - Distinguish certain from uncertain
4. **Follow the FAN Club** - Friends, Associates, Neighbors
5. **Consider name variations** - Especially European names
6. **Check borders** - Historical boundaries differ from modern
