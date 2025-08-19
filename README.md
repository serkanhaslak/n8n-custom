# n8n-custom

Custom n8n Docker image with additional npm packages for Railway deployment.

## Packages Included

This custom n8n image includes the following npm packages installed globally:
- `xlsx` - Excel file processing
- `papaparse` - CSV parsing
- `moment` - Date manipulation
- `lodash` - Utility functions

## Railway Configuration

This project uses `railway.json` for optimized Railway deployment with Docker. 

**Note**: `railpack.json` is for Railway's Railpack builder (non-Docker builds). Since we're using a custom Dockerfile, we use `railway.json` with `"builder": "DOCKERFILE"`.

## Railway Deployment

### Required Environment Variable

**CRITICAL**: You must set this environment variable in your Railway service:

```
NODE_FUNCTION_ALLOW_EXTERNAL=*
```

Without this environment variable, n8n will not allow access to external modules even if they're installed.

### Deployment Steps

1. Fork this repository
2. Connect your forked repository to Railway
3. In Railway dashboard, go to your service settings
4. Add the environment variable: `NODE_FUNCTION_ALLOW_EXTERNAL=*`
5. Deploy the service (Railway will automatically use the Dockerfile and railway.json configuration)

### Using the Packages in Code Nodes

Once deployed, you can use the installed packages in your n8n Code nodes:

```javascript
const xlsx = require('xlsx');
const Papa = require('papaparse');
const moment = require('moment');
const _ = require('lodash');

// Your code here
```

## Local Development

To run locally with Docker:

```bash
docker build -t n8n-custom .
docker run -p 5678:5678 -e NODE_FUNCTION_ALLOW_EXTERNAL=* n8n-custom
```

## Adding More Packages

To add more npm packages:

1. Edit the `Dockerfile`
2. Add your package to the npm install command:
   ```dockerfile
   RUN mkdir -p /home/node/.n8n/nodes/node_modules && \
       cd /home/node/.n8n/nodes/node_modules && \
       npm install xlsx papaparse moment lodash your-new-package && \
       chown -R node:node /home/node/.n8n
   ```
3. Commit and push to trigger a new Railway deployment

## Technical Notes

- **Correct Installation Path**: Installs packages in `/home/node/.n8n/nodes/node_modules/` where n8n actually looks for external modules
- **Railway Logs Discovery**: Found the correct path by analyzing Railway deployment logs that showed n8n module loading paths
- **Railway Optimization**: `railway.json` configures Railway to use the Dockerfile with optimal settings
- **Docker Best Practices**: Creates proper directory structure and sets correct ownership for node user

## Troubleshooting

If you still get "Cannot find module 'xlsx'" errors:
1. **CRITICAL**: Verify `NODE_FUNCTION_ALLOW_EXTERNAL=*` is set in Railway environment variables
2. Check Railway deployment logs for any npm install errors
3. Ensure packages are installed in `/home/node/.n8n/nodes/node_modules/` not globally

### Root Cause & Solution
- **Issue**: Global npm install puts packages where n8n doesn't look (`/usr/local/lib/node_modules/`)
- **Solution**: Install packages in `/home/node/.n8n/nodes/node_modules/` where n8n actually searches
- **Discovery Method**: Analyzed Railway logs which showed exact paths n8n uses for module loading