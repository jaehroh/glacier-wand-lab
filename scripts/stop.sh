#!/bin/bash

echo "🛑 Stopping development environment..."

cd "$(dirname "$0")/.."
docker-compose down

echo "✅ Containers stopped."
echo ""
echo "Note: Colima and Ollama are still running."
echo "To stop Colima:  colima stop"
echo "To stop Ollama:  pkill ollama"
