# Setup Instructions

Follow these steps in your Mac's Terminal app.

## Step 1: Install Prerequisites (one-time)

```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install required tools
brew install colima docker docker-compose ollama
```

## Step 2: Move Files to Home Directory

The files I created are in your Sandbox folder. Move them to your home directory:

```bash
# Move dev-environment to home directory
mv ~/Sandbox/dev-environment ~/dev-environment

# Move sandbox-experiments to projects folder
mkdir -p ~/projects
mv ~/Sandbox/sandbox-experiments ~/projects/sandbox-experiments
```

## Step 3: Make Scripts Executable

```bash
chmod +x ~/dev-environment/scripts/*.sh
```

## Step 4: Start Colima (Container Runtime)

```bash
# Start Colima with resources appropriate for your M1 Max
colima start --cpu 8 --memory 16 --disk 100 --arch aarch64
```

This takes a minute the first time as it downloads the VM image.

## Step 5: Run Setup

```bash
cd ~/dev-environment
./scripts/setup.sh
```

This builds the Docker container (takes 2-5 minutes the first time).

## Step 6: Start Ollama and Pull Models

```bash
# Start Ollama (runs in background)
ollama serve &

# Pull a model (llama3 is a good general-purpose choice)
ollama pull llama3
```

## Step 7: Start the Environment

```bash
cd ~/dev-environment
./scripts/start.sh
```

## Step 8: Open JupyterLab

Open in your browser:
```
http://localhost:8888?token=dev-sandbox-token
```

## Step 9: Verify Everything Works

In JupyterLab, open `sandbox-experiments/notebooks/00-environment-test.ipynb` and run all cells.

---

## Daily Usage

```bash
# Start everything
cd ~/dev-environment && ./scripts/start.sh

# Stop when done
./scripts/stop.sh

# Full reset if needed
./scripts/rebuild.sh
```

## Initialize Git Repos (optional but recommended)

```bash
# Environment repo
cd ~/dev-environment
git init
git add .
git commit -m "Initial dev environment setup"

# Project repo
cd ~/projects/sandbox-experiments
git init
git add .
git commit -m "Initial project structure"
```
