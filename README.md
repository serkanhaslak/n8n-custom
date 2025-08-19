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
2. Add your package to the global npm install command:
   ```dockerfile
   RUN npm install -g xlsx papaparse moment lodash your-new-package
   ```
3. Commit and push to trigger a new Railway deployment

## Technical Notes

- **Global Installation**: Uses `npm install -g` which is the proven working method for n8n Docker containers
- **Railway Optimization**: `railway.json` configures Railway to use the Dockerfile with optimal settings
- **Docker Best Practices**: Switches to root user for installation, then back to node user for security