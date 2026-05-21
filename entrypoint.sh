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

# Decode the service-account JSON from an env var to a file on disk.
# gsc_server.py's service-account auth expects a file PATH (GSC_CREDENTIALS_PATH),
# and Railway's filesystem is ephemeral, so we (re)write it fresh on every boot.
if [ -n "$GSC_CREDENTIALS_JSON" ]; then
    echo "$GSC_CREDENTIALS_JSON" > /app/service_account_credentials.json
    export GSC_CREDENTIALS_PATH=/app/service_account_credentials.json
    # Service-account-only deploy: skip the OAuth attempt entirely.
    export GSC_SKIP_OAUTH="${GSC_SKIP_OAUTH:-true}"
fi

# Default to SSE transport on the port Railway assigns.
export MCP_TRANSPORT="${MCP_TRANSPORT:-sse}"
export MCP_HOST="${MCP_HOST:-0.0.0.0}"
export MCP_PORT="${MCP_PORT:-${PORT:-3001}}"

exec uv run --no-sync python gsc_server.py
