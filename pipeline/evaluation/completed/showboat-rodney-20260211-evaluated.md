# Discovery: Showboat and Rodney

- **Source**: https://simonwillison.net/2026/Feb/10/showboat-and-rodney/
- **Date Found**: 2026-02-11
- **Category**: technique
- **Summary**: Tools by Simon Willison enabling AI agents to demonstrate what they've built via automated deployments and video recording. Showboat creates temporary deployments (Python web apps on fly.io), Rodney records browser interactions as videos. Designed for agents to show their work to humans.
- **Potential Value**: Medium
- **Integration Complexity**: Medium

## Details

Showboat deploys Python web apps to fly.io with temporary URLs, allowing agents to build and immediately demonstrate prototypes. Rodney uses Playwright to record browser interactions as MP4 videos, enabling agents to create video demonstrations.

## Potential Use Cases
- Evolution pipeline: Agents could demo integrated MCPs
- Revenue pipeline: Agents could demo MVP builds
- Testing: Record E2E test runs as videos for debugging

## Next Steps
Full evaluation needed to assess:
- Integration effort vs value
- Token efficiency impact
- Maintenance burden
- Comparison to existing browser-tester + better-playwright stack
