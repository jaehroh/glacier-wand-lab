# Glacier Wand Lab
Sandboxed local development environment with JupyterLab, Python 3.11, Node.js 20,
and Ollama integration for local LLM inference.

Designed to run locally on an M1-Max (10 core CPU, 32 core GPU) with 64GB RAM. Adjust docker-compose.yml to suit your setup.

Disclaimer: Limited testing. Free to use at your own risk. Welcome feedback.

## Design Considerations

### 🔒 Security

- **Filesystem isolation** — Container only sees ~/projects, not your home directory or system files
- **Untrusted code containment** — AI-generated code runs sandboxed; can't damage your system
- **Network control** — Optional offline mode for maximum isolation

### 🔄 Reproducibility

- **Infrastructure-as-code** — Entire environment defined in Dockerfile + docker-compose.yml
- **One-command rebuild** — `./scripts/rebuild.sh` returns to clean state
- **Disposable containers** — Experiment freely; your code persists, container state doesn't

### ⚡ Resource Efficiency

- **GPU stays native** — Ollama and pyenv use M1 Metal directly (no GPU passthrough overhead)
- **Colima over Docker Desktop** — Lighter footprint, open source, no licensing fees
- **Shared models** — Ollama serves multiple environments from one model cache

### 🔧 Flexibility

- **IDE-agnostic** — Edit with VS Code, Cursor, Claude Code, or any tool; execute in sandbox
- **Two environments** — Container for safety, native for GPU-intensive ML work
- **Same codebase** — ~/projects accessible from both environments

## Architecture
```
┌─────────────────────────────────────────────────────────────────────┐
│  Your Mac                                                           │
│                                                                     │
│  SERVICES (native, GPU-accelerated)                                 │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Ollama         — LLM inference (llama3, codellama, etc.)     │  │
│  │                   localhost:11434                             │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  SANDBOXED ENVIRONMENT (Colima + Docker)                            │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  dev-sandbox container                                        │  │
│  │  • JupyterLab on localhost:8888                               │  │
│  │  • Python 3.11 + Node.js 20                                   │  │
│  │  • General experimentation, untrusted code                    │  │
│  │  • Can call: Ollama API, internet (configurable)              │  │
│  │  • Mounts: ~/projects (your code)                             │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  NATIVE ML ENVIRONMENT (for when you need direct GPU)               │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  pyenv + venv                                                 │  │
│  │  • PyTorch with MPS backend                                   │  │
│  │  • MLX for Apple-optimized ML                                 │  │
│  │  • JupyterLab on localhost:8889                               │  │
│  │  • For: training, fine-tuning, heavy GPU work                 │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│  YOUR FILES                                                         │
│  ~/projects/         — Code (accessed by both environments)         │
│  ~/dev-environment/  — Dockerfiles, configs (infra-as-code)         │
│  ~/.ollama/          — Downloaded models (managed by Ollama)        │
└─────────────────────────────────────────────────────────────────────┘
```
## When to Use What:

| Task                                  | Environment                  |
| ------------------------------------- | ---------------------------- |
| Run AI-generated code you don't trust | Sandboxed container          |
| Call an LLM for inference             | Either → both call Ollama    |
| Data wrangling, visualization         | Sandboxed container          |
| Train/fine-tune a model               | Native ML environment        |
| Experiment with PyTorch MPS           | Native ML environment        |
| Node.js development                   | Sandboxed container          |
| Quick prototype with LLM              | Sandboxed container (safest) |

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
