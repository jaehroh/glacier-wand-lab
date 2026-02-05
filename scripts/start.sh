#!/bin/bash
set -e

# Ensure Colima is running
if ! colima status 2>/dev/null | grep -q "Running"; then
    echo "📦 Starting Colima..."
    colima start
fi

# Start Ollama if not running
if ! pgrep -x "ollama" > /dev/null; then
    echo "🤖 Starting Ollama..."
    ollama serve > /dev/null 2>&1 &
    sleep 2
fi

# Start the development container
echo "🚀 Starting development sandbox..."
cd "$(dirname "$0")/.."
docker-compose up -d dev-sandbox

echo ""
echo "✅ Environment ready!"
echo ""
echo "🔬 JupyterLab:  http://localhost:8888?token=dev-sandbox-token"
echo "🤖 Ollama API:  http://localhost:11434"
echo ""
echo "To enter container shell:  docker exec -it dev-sandbox bash"
echo "To view logs:              docker-compose logs -f"
