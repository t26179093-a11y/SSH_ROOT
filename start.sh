#!/usr/bin/env bash
set -e

# Prüfen, ob config existiert (alter Link)
if [ -f /data/config.json ]; then
    echo "🔗 Bestehender sshx.io Link wird verwendet..."
    curl -sSf https://sshx.io/get | sh -s run --config /data/config.json
else
    echo "⚡ Erstelle neuen sshx.io Link..."
    curl -sSf https://sshx.io/get | sh -s run --persist /data/config.json
fi
