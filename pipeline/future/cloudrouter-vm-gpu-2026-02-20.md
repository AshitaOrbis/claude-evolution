# CloudRouter - VM and GPU Skill for Agents

**Discovery Date**: 2026-02-15
**Source**: Hacker News (134 points, 33 comments)
**Type**: Skill + CLI Tool
**Category**: Infrastructure / Cloud Resources

## Summary

CloudRouter is a skill + CLI that gives coding agents like Claude Code and Codex the ability to start cloud VMs and GPUs on demand. Agents can spin up isolated environments, run code, use browsers, and tear down resources when complete.

## Key Features

- **VM Management**: Start/stop cloud VMs from local project directory
- **GPU Support**: Request specific GPUs (e.g., `--gpu B200`)
- **Browser Automation**: VNC desktop + browser automation via agent-browser
- **Environment Isolation**: Each agent gets own VM, ports, resources
- **Cloud-First**: Agent work happens on VMs instead of local machine
- **Parallel Execution**: Run multiple agents in parallel on separate VMs

## Commands

```bash
cloudrouter start ./my-project
cloudrouter start --gpu B200 ./my-project
cloudrouter ssh cr_abc123 "npm install && npm run dev"
cloudrouter browser open cr_abc123 "http://localhost:3000"
cloudrouter browser snapshot -i cr_abc123
cloudrouter browser click cr_abc123 @e2
cloudrouter browser screenshot cr_abc123 result.png
```

## Technical Details

- **Installation**: `curl -fsSL https://cloudrouter.dev/install/install.sh | bash`
- **Repository**: https://github.com/manaflow-ai/manaflow (packages/cloudrouter)
- **Browser Integration**: Wraps agent-browser (vercel-labs)
- **VNC Desktop**: Auth-protected URL for real-time monitoring
- **Environment**: VS Code + Jupyter Lab pre-installed

## Use Cases

- Parallel agent tasks without local resource contention
- GPU workloads (training, inference experiments)
- Browser automation with visual monitoring
- Testing across different environments
- Isolating agent work from local machine

## Integration Potential

**Score Estimate**: 70-75/100

**Pros**:
- Novel capability (no existing VM provisioning skill)
- Official demo: https://youtu.be/SCkkzxKBcPE
- Strong community validation (134 HN points)
- Complements parallel agents skill
- GPU access for AI workloads

**Cons**:
- Requires CloudRouter account/API keys
- Monthly cost for VM usage
- Adds external dependency
- Browser automation overlaps with Better Playwright

**Redundancy Check**:
- ❌ No VM provisioning capability exists
- ❌ No GPU request capability exists
- ✅ Browser automation covered by Better Playwright (but different use case)

## Evaluation Needed

- [ ] Test CloudRouter CLI installation
- [ ] Evaluate cost model (free tier? pricing?)
- [ ] Compare browser automation vs Better Playwright
- [ ] Test GPU provisioning workflow
- [ ] Assess security (VM isolation, credential storage)
- [ ] Integration path as skill vs MCP

## Links

- Repository: https://github.com/manaflow-ai/manaflow
- Demo: https://youtu.be/SCkkzxKBcPE
- Website: https://cloudrouter.dev/
- HN Discussion: https://news.ycombinator.com/item?id=47006393
