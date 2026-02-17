# Generate Helpers

Extract reusable patterns from today's run and save as helpers.

## What to Extract

Scan the daily log for:

1. **Error-solution pairs**: Problem encountered -> how it was resolved
2. **Useful commands**: Multi-step command sequences worth remembering
3. **Decision trees**: Choices made and their rationale
4. **Templates**: Patterns that could be reused

## Output Location

Save helpers to `helpers/` organized by category:

- `helpers/scripts/` - Shell snippets
- `helpers/templates/` - Reusable templates
- `helpers/playbooks/` - Error->solution mappings
- `helpers/commands/` - Common command sequences

## Format

Each helper is a markdown file with:

```markdown
# [Helper Name]

[Description of what this helper does]

**Tags**: keyword1, keyword2

## Content

[The actual helper content]
```

## Deduplication

Before creating a new helper, check if one already exists in `helpers/` with similar content.
Update existing helpers rather than creating duplicates.

## Output

```json
{"created": 1, "updated": 0, "skipped": 2}
```
