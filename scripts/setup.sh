#!/bin/bash
set -e

echo "🚀 Setting up development environment..."

# Check prerequisites
command -v colima >/dev/null 2>&1 || { echo "❌ Colima not installed. Run: brew install colima"; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "❌ Docker CLI not installed. Run: brew install docker"; exit 1; }
command -v ollama >/dev/null 2>&1 || { echo "❌ Ollama not installed. Run: brew install ollama"; exit 1; }

# Start Colima if not running
if ! colima status 2>/dev/null | grep -q "Running"; then
    echo "📦 Starting Colima..."
    colima start --cpu 8 --memory 16 --disk 100 --arch aarch64
fi

# Create projects directory - redundant, already done
# mkdir -p ~/projects

# Build the container
echo "🐳 Building development container..."
cd "$(dirname "$0")/.."
docker-compose build

echo ""
echo "✅ Setup complete!"
echo ""
echo "To start the environment:  ./scripts/start.sh"
echo "To stop the environment:   ./scripts/stop.sh"
