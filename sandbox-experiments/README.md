# Sandbox Experiments

A project for experimenting with code in the sandboxed development environment.

## Structure

```
sandbox-experiments/
├── notebooks/          # Jupyter notebooks
│   └── 00-environment-test.ipynb
├── src/                # Python modules
├── data/               # Data files (gitignored)
└── README.md
```

## Getting Started

1. Start the development environment:
   ```bash
   cd ~/dev-environment
   ./scripts/start.sh
   ```

2. Open JupyterLab at http://localhost:8888

3. Run `notebooks/00-environment-test.ipynb` to verify setup

## Using Ollama

```python
import ollama

response = ollama.chat(
    model='llama3',
    messages=[{'role': 'user', 'content': 'Hello!'}]
)
print(response['message']['content'])
```
