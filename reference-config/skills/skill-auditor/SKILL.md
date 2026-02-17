# Skill Auditor

Security scanner for Claude Code skills. Use BEFORE installing any skill from external sources.

## When to Use

- Before installing a skill from GitHub, Moltbook, or other external sources
- Periodic audit of existing skills in `~/.claude/skills/`
- After updating skills from external repositories

## Quick Scan

```bash
# Scan a skill directory before installation
skill-audit /path/to/downloaded/skill

# Scan all installed skills
skill-audit ~/.claude/skills/

# Scan with verbose output
skill-audit --verbose ~/.claude/skills/skill-name/
```

## What It Checks

### High-Risk Patterns (Block)
| Pattern | Risk | Example |
|---------|------|---------|
| External HTTP requests | Data exfiltration | `requests.post()`, `fetch()`, `curl` |
| Environment access | Credential theft | `os.environ`, `process.env`, `~/.env` |
| File system access outside project | Data theft | `open('/etc/passwd')`, `fs.readFile('~/')` |
| Webhook URLs | Phone-home | `webhook.site`, `requestbin`, `ngrok` |
| Encoded payloads | Obfuscation | Base64 strings > 100 chars, hex-encoded URLs |
| Shell execution | RCE | `subprocess`, `exec()`, `eval()` |

### Medium-Risk Patterns (Review)
| Pattern | Risk | Example |
|---------|------|---------|
| Network imports | Potential exfil | `import requests`, `import urllib` |
| Dynamic code execution | Injection | `eval()`, `exec()`, `Function()` |
| Hidden files | Persistence | `.hidden`, `__pycache__` with code |

### Low-Risk Patterns (Note)
| Pattern | Risk | Example |
|---------|------|---------|
| Large encoded strings | May be legitimate | Base64 images, embedded data |
| Complex regex | May be obfuscation | Regex > 200 chars |

## Implementation

```python
#!/usr/bin/env python3
"""Skill security auditor for Claude Code."""

import re
import sys
from pathlib import Path

HIGH_RISK_PATTERNS = [
    (r'requests\.(post|put|patch)', 'HTTP data send'),
    (r'urllib\.request\.urlopen', 'URL open'),
    (r'os\.environ', 'Environment access'),
    (r'process\.env', 'Node env access'),
    (r'~\/\.env|\.env\b', 'Env file access'),
    (r'webhook\.site|requestbin|ngrok', 'Known exfil domains'),
    (r'subprocess\.(run|call|Popen)', 'Shell execution'),
    (r'\beval\s*\(', 'Dynamic eval'),
    (r'\bexec\s*\(', 'Dynamic exec'),
    (r'open\s*\([\'"][~/]', 'Home directory access'),
]

MEDIUM_RISK_PATTERNS = [
    (r'^import requests', 'Requests library'),
    (r'^import urllib', 'URL library'),
    (r'Function\s*\(', 'Dynamic function'),
]

def scan_file(path: Path) -> list:
    """Scan a file for suspicious patterns."""
    findings = []
    try:
        content = path.read_text()
        for pattern, desc in HIGH_RISK_PATTERNS:
            if re.search(pattern, content, re.MULTILINE):
                findings.append(('HIGH', desc, str(path)))
        for pattern, desc in MEDIUM_RISK_PATTERNS:
            if re.search(pattern, content, re.MULTILINE):
                findings.append(('MEDIUM', desc, str(path)))
    except Exception as e:
        findings.append(('ERROR', str(e), str(path)))
    return findings

def audit_skill(skill_path: Path) -> dict:
    """Audit a skill directory."""
    findings = []
    for f in skill_path.rglob('*'):
        if f.is_file() and f.suffix in ['.py', '.js', '.ts', '.sh', '.md']:
            findings.extend(scan_file(f))

    high_count = sum(1 for f in findings if f[0] == 'HIGH')
    return {
        'path': str(skill_path),
        'safe': high_count == 0,
        'high_risk': high_count,
        'findings': findings
    }

if __name__ == '__main__':
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.home() / '.claude/skills'
    result = audit_skill(path)

    if result['safe']:
        print(f"✅ {result['path']}: No high-risk patterns found")
    else:
        print(f"⚠️  {result['path']}: {result['high_risk']} high-risk patterns")
        for level, desc, file in result['findings']:
            print(f"  [{level}] {desc}: {file}")
```

## Usage Notes

- This is a static analysis tool - it catches obvious patterns but not sophisticated obfuscation
- Always review skill source code manually for external skills
- Prefer skills from trusted sources with community review
- When in doubt, don't install

## Not a Replacement For

- Manual code review
- Sandboxed execution environments
- Reputation/trust systems
- Community audits
