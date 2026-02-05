#!/bin/bash
set -e

echo "🔄 Rebuilding development environment from scratch..."

cd "$(dirname "$0")/.."

# Stop and remove everything
docker-compose down -v --rmi local

# Rebuild
docker-compose build --no-cache

echo "✅ Rebuild complete!"
echo "Run ./scripts/start.sh to start fresh environment"
