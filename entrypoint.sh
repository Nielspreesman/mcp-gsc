#!/bin/bash
set -e

# Decode JSON secrets from env vars to files on disk.
# AminForou's gsc_server.py expects file paths, not JSON content.
if [ -n "$GSC_OAUTH_CLIENT_SECRETS_JSON" ]; then
    echo "$GSC_OAUTH_CLIENT_SECRETS_JSON" > /app/client_secrets.json
    export GSC_OAUTH_CLIENT_SECRETS_FILE=/app/client_secrets.json
fi

if [ -n "$GSC_TOKEN_JSON" ]; then
    echo "$GSC_TOKEN_JSON" > /app/token.json
fi

# Default to SSE transport on the port Railway assigns.
export MCP_TRANSPORT="${MCP_TRANSPORT:-sse}"
export MCP_HOST="${MCP_HOST:-0.0.0.0}"
export MCP_PORT="${MCP_PORT:-${PORT:-3001}}"

exec uv run --no-sync python gsc_server.py
