FROM n8nio/n8n:next

USER root

# Install packages globally - proven working method
RUN npm install -g xlsx papaparse moment lodash

# You can also install system packages if needed
# RUN apk add --no-cache python3 py3-pip

# Switch back to node user for security
USER node

# Expose the default n8n port
EXPOSE 5678