# glacier-wand-lab
Set up a local workbend to experiment with building with AI.

Includes support for Jupyter notebooks, local LLM models, native ML workloads that can make use of M-series GPUs.

Disclaimer: Free to use at your own risk. Limited testing. Welcome any feedback.

Setup for a local dev environment for experimenting with AI/LLM development. Intended for an M-series Mac, but presumably could run on most linux setups as well.

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
