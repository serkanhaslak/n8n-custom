# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a custom n8n Docker image configuration for Railway deployment. It extends the official n8n Docker image with additional npm packages that can be used in n8n Code nodes.

## Build & Run Commands

```bash
# Build the Docker image
docker build -t n8n-custom .

# Run locally
docker run -p 5678:5678 -e NODE_FUNCTION_ALLOW_EXTERNAL=* n8n-custom
```

## Architecture

- **Dockerfile**: Extends `n8nio/n8n:2.0.0-rc.3` and installs npm packages in `/home/node/.n8n/nodes/node_modules/` (the specific path where n8n looks for external modules)
- **railway.json**: Railway deployment configuration using Dockerfile builder

## Key Technical Details

- **Package installation path**: Must be `/home/node/.n8n/nodes/node_modules/` - global npm install won't work because n8n doesn't look in `/usr/local/lib/node_modules/`
- **Required environment variable**: `NODE_FUNCTION_ALLOW_EXTERNAL=*` must be set for n8n to allow external module access

## Adding New Packages

Edit the Dockerfile and add packages to the `npm install` command:
```dockerfile
RUN mkdir -p /home/node/.n8n/nodes/node_modules && \
    cd /home/node/.n8n/nodes/node_modules && \
    npm install xlsx your-new-package && \
    chown -R node:node /home/node/.n8n
```

## Railway Infrastructure

See `railway.yaml` for full service configuration. Quick reference:

| Service | ID | Domain |
|---------|-----|--------|
| n8n-Primary | `81e635c6-2570-4c1b-84df-25e004587f0f` | n8n.pragmaticgrowth.com |
| n8n-Worker | `2a232831-1903-49e5-8f64-b9c026fccca9` | worker.railway.internal |
| n8n-MCP | `0430c739-b849-4c46-b37c-5c5da133eddb` | pg-n8n.up.railway.app |
| n8n-Postgres | `97adab60-a2ab-4db9-8ff8-19535ec6f35d` | postgres.railway.internal |
| n8n-Redis | `4c7dca91-befb-4a68-a18c-bf735b7c880d` | redis.railway.internal |

**Project:** pragmatic-growth (`2876e1ca-003b-4365-99c2-e56d7d40d7a6`)
**Environment:** production (`dda723c4-1d72-4cf4-957a-769ca5623cf3`)

### Railway MCP Commands

```bash
# Get logs for a service
railway logs --service n8n-Primary

# List variables for a service
railway variables --service n8n-Worker

# Deploy
railway up
```
