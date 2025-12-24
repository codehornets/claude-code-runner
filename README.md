# Claude Code Runner

Containerized service that accepts task prompts via HTTP and spawns Claude to autonomously implement them. Creates draft PRs immediately and commits after every change.

## Quick Start

```bash
docker pull ericvtheg/claude-code-runner:latest
```

```yaml
services:
  claude-runner:
    image: ericvtheg/claude-code-runner:latest
    ports:
      - "7334:3000"
    environment:
      - GITHUB_TOKEN=${GITHUB_TOKEN}
    volumes:
      - ~/.claude:/root/.claude:ro
    restart: unless-stopped
```

## API

```bash
# Submit a task
curl -X POST http://localhost:7334/task \
  -H "Content-Type: application/json" \
  -d '{"prompt": "In the acme-api repo, fix the token refresh bug"}'

# Check status
curl http://localhost:7334/task/<id>

# View logs
curl http://localhost:7334/task/<id>/logs

# Health check
curl http://localhost:7334/health
```

## Requirements

- `GITHUB_TOKEN` with repo scope
- Claude credentials mounted at `/root/.claude`
