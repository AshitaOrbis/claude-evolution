# WebMCP Integration Guide

How to expose test helpers in your application for Claude to call directly.

## Overview

WebMCP allows your app to expose RPC-style endpoints that Claude can call without browser automation. This is the cleanest approach for testing your own applications.

## Benefits Over Browser Automation

| Aspect | Browser Automation | WebMCP |
|--------|-------------------|--------|
| Speed | Slow (renders UI) | Fast (direct API) |
| Reliability | Fragile (selectors break) | Stable (API contract) |
| Data setup | Complex (click through UI) | Simple (seed directly) |
| Auth | Must log in via UI | Can bypass or mock |
| Debugging | Screenshots, DOM inspection | Structured responses |

## Implementation Example

### 1. Create Test Helpers Module

```typescript
// apps/api/src/test-helpers/index.ts
import { FastifyInstance } from 'fastify';

export function registerTestHelpers(app: FastifyInstance) {
  // SECURITY: Only register in non-production
  if (process.env.NODE_ENV === 'production') {
    return;
  }

  // Prefix all test routes
  app.register(async (testApp) => {
    // Login as test user
    testApp.post('/login-test-user', async (req, reply) => {
      const { email = 'test@example.com' } = req.body as any;
      // Generate session token for test user
      const token = await createTestSession(email);
      return { token, user: { email } };
    });

    // Seed test data
    testApp.post('/seed-test-data', async (req, reply) => {
      const { scenario = 'default' } = req.body as any;
      const data = await seedScenario(scenario);
      return { success: true, seeded: data };
    });

    // Reset app state
    testApp.post('/reset-app-state', async (req, reply) => {
      await clearTestData();
      return { success: true };
    });

    // Get current state (for assertions)
    testApp.get('/app-state', async (req, reply) => {
      return {
        utilities: await getUtilitiesCount(),
        projects: await getProjectsCount(),
        // ... other relevant state
      };
    });
  }, { prefix: '/__test__' });
}
```

### 2. Register in Main App

```typescript
// apps/api/src/app.ts
import { registerTestHelpers } from './test-helpers';

// ... existing setup ...

// Only in non-production
if (process.env.NODE_ENV !== 'production') {
  registerTestHelpers(app);
}
```

### 3. Environment Guard

```bash
# .env.local (development/test only)
NODE_ENV=development
TEST_HELPERS_ENABLED=true
```

## WebMCP Server Setup

Once your app exposes test helpers, create a WebMCP server:

```typescript
// tools/webmcp-server/index.ts
import { MCPServer } from '@anthropic-ai/mcp-sdk';

const server = new MCPServer({
  name: 'my-app-test',
  version: '1.0.0',
});

const API_BASE = process.env.API_BASE || 'http://localhost:3001';

server.tool('login_test_user', {
  description: 'Authenticate as a test user',
  parameters: {
    email: { type: 'string', description: 'Test user email' },
  },
  handler: async ({ email }) => {
    const res = await fetch(`${API_BASE}/__test__/login-test-user`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email }),
    });
    return res.json();
  },
});

server.tool('seed_test_data', {
  description: 'Seed database with test scenario',
  parameters: {
    scenario: { type: 'string', enum: ['default', 'complex'] },
  },
  handler: async ({ scenario }) => {
    const res = await fetch(`${API_BASE}/__test__/seed-test-data`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ scenario }),
    });
    return res.json();
  },
});

server.tool('reset_app_state', {
  description: 'Clear all test data and reset to clean state',
  handler: async () => {
    const res = await fetch(`${API_BASE}/__test__/reset-app-state`, {
      method: 'POST',
    });
    return res.json();
  },
});

server.tool('get_app_state', {
  description: 'Get current application state for assertions',
  handler: async () => {
    const res = await fetch(`${API_BASE}/__test__/app-state`);
    return res.json();
  },
});

server.start();
```

## MCP Configuration

Add to `~/.claude.json`:

```json
{
  "mcpServers": {
    "my-app-test": {
      "command": "node",
      "args": ["~/your-project/tools/webmcp-server/index.js"],
      "env": {
        "API_BASE": "http://localhost:3001"
      }
    }
  }
}
```

## Test Scenarios

Define reusable test scenarios:

```typescript
// apps/api/src/test-helpers/scenarios.ts
export const SCENARIOS = {
  default: {
    users: [{ email: 'test@example.com', name: 'Test User' }],
    data: [],
  },
  complex: {
    users: [
      { email: 'admin@example.com', name: 'Admin', role: 'admin' },
      { email: 'user@example.com', name: 'Regular User', role: 'user' },
    ],
    data: Array.from({ length: 10 }, (_, i) => ({
      name: `Item ${i + 1}`,
      value: (i + 1) * 100,
    })),
  },
};
```

## Security Considerations

1. **Never enable in production** - Check `NODE_ENV` at registration time
2. **Use separate database** - Point test helpers at test database
3. **Rate limit** - Even test endpoints should have basic rate limiting
4. **Audit log** - Log all test helper calls for debugging

## Migration Path

When ready to add WebMCP to your app:

1. Implement test helpers in API
2. Create WebMCP server as separate package
3. Add to `~/.claude.json`
4. Update test agents to use WebMCP tools
5. Keep Playwright as fallback for visual verification
