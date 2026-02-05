#!/bin/bash
set -e

echo "🔒 Starting OFFLINE sandbox (no network access)..."

# Ensure Colima is running
if ! colima status 2>/dev/null | grep -q "Running"; then
    echo "📦 Starting Colima..."
    colima start
fi

cd "$(dirname "$0")/.."
docker-compose --profile offline up -d sandbox-offline

echo ""
echo "✅ Offline sandbox ready!"
echo ""
echo "🔬 JupyterLab:  http://localhost:8889?token=offline-sandbox-token"
echo ""
echo "⚠️  This sandbox has NO network access."
echo "⚠️  Projects mounted READ-ONLY. Write to ~/output inside container."
