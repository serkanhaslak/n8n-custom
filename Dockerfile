FROM n8nio/n8n:beta

USER root

# Install packages where n8n actually looks for them
RUN mkdir -p /home/node/.n8n/nodes/node_modules && \
    cd /home/node/.n8n/nodes/node_modules && \
    npm install xlsx && \
    chown -R node:node /home/node/.n8n

# You can also install system packages if needed
# RUN apk add --no-cache python3 py3-pip

# Switch back to node user for security
USER node

# Expose the default n8n port
EXPOSE 5678