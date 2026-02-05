FROM python:3.11-slim-bookworm

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    wget \
    vim \
    ca-certificates \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install global npm packages (as root, before switching users)
RUN npm install -g tslab

# Create non-root user for security
RUN useradd -m -s /bin/bash developer

# Switch to non-root user
USER developer
WORKDIR /home/developer

# Create cache directory (used by matplotlib, pip, etc.)
RUN mkdir -p /home/developer/.cache

# Set up Python environment
ENV PATH="/home/developer/.local/bin:$PATH"

# Install Python packages (now as developer, so --user goes to the right place)
RUN pip install --user --no-cache-dir \
    jupyterlab \
    ipykernel \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    scikit-learn \
    ollama \
    openai \
    httpx \
    python-dotenv \
    requests \
    tqdm

# Install tslab kernel for Jupyter (now jupyter is available)
RUN tslab install --user

# Configure Jupyter
RUN mkdir -p /home/developer/.jupyter
COPY --chown=developer:developer config/jupyter_lab_config.py /home/developer/.jupyter/

# Working directory for projects
WORKDIR /home/developer/projects

# Expose JupyterLab port
EXPOSE 8888

# Default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
