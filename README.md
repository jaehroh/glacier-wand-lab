# Development Environment

Sandboxed development environment with JupyterLab, Python 3.11, Node.js 20,
and Ollama integration for local LLM inference.

## Prerequisites

Install these via Homebrew on your Mac:

```bash
brew install colima docker docker-compose ollama
```

## Quick Start

```bash
# First-time setup
./scripts/setup.sh

# Start environment
./scripts/start.sh

# Open JupyterLab
open "http://localhost:8888?token=dev-sandbox-token"
```

## Commands

| Command | Description |
|---------|-------------|
| `./scripts/setup.sh` | First-time setup (builds container) |
| `./scripts/start.sh` | Start sandbox + Ollama |
| `./scripts/stop.sh` | Stop sandbox (keeps Colima running) |
| `./scripts/rebuild.sh` | Nuke and rebuild from scratch |
| `./scripts/start-offline.sh` | Start network-isolated sandbox |

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Your Mac                                                   │
│                                                             │
│  Ollama (native, GPU-accelerated)                           │
│  └── localhost:11434                                        │
│           ▲                                                 │
│           │ API calls                                       │
│  ┌────────┴──────────────────────────────────────────────┐  │
│  │  Docker Container (dev-sandbox)                       │  │
│  │  • JupyterLab on localhost:8888                       │  │
│  │  • Python 3.11 + Node.js 20                           │  │
│  │  • Mounts ~/projects                                  │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## Using Ollama from Notebooks

```python
import ollama

response = ollama.chat(
    model='llama3',
    messages=[{'role': 'user', 'content': 'Hello!'}]
)
print(response['message']['content'])
```

Or using the OpenAI-compatible API:

```python
from openai import OpenAI

client = OpenAI(
    base_url='http://host.docker.internal:11434/v1',
    api_key='ollama'  # Required but unused
)

response = client.chat.completions.create(
    model='llama3',
    messages=[{'role': 'user', 'content': 'Hello!'}]
)
print(response.choices[0].message.content)
```

## Offline Mode

For running untrusted code with no network access:

```bash
./scripts/start-offline.sh
# Access at http://localhost:8889
```

In offline mode:
- No network access at all (can't reach internet OR Ollama)
- Projects mounted read-only
- Write outputs to `~/output` inside the container

## Managing Ollama Models

```bash
# List installed models
ollama list

# Pull new models
ollama pull llama3
ollama pull codellama
ollama pull mistral

# Remove a model
ollama rm modelname
```

## Resource Limits

The container is configured with these limits (adjustable in docker-compose.yml):
- CPU: 6 cores (of your 10)
- Memory: 12GB (of your 64GB)

## Troubleshooting

**Container won't start:**
```bash
colima status          # Check Colima is running
colima start           # Start if needed
```

**Can't connect to Ollama from container:**
```bash
curl http://localhost:11434/api/tags    # Test Ollama on host
ollama serve                             # Start if not running
```

**Need a fresh start:**
```bash
./scripts/rebuild.sh
```
