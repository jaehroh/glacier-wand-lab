# glacier-wand-lab
Tools and Experiment in building with AI

Disclaimer: Free to use at your own risk. Limited testing. Welcome any feedback.

Setup for a local dev environment for experimenting with AI/LLM development.

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
