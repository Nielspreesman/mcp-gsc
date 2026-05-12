FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim

WORKDIR /app

# Dependencies first for layer caching
COPY pyproject.toml README.md ./
RUN uv sync --no-cache --no-install-project

# Application code + entrypoint
COPY gsc_server.py .
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Railway sets PORT env var; entrypoint.sh handles it
CMD ["./entrypoint.sh"]
