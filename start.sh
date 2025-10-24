#!/usr/bin/env bash
set -e

# Verzeichnis sichern (persistente Daten)
mkdir -p /data

# Prüfen, ob Link schon existiert
if [ -f /data/sshx_link.txt ]; then
    echo "==> sshx.io Link bereits vorhanden:"
    cat /data/sshx_link.txt
else
    echo "==> Starte sshx.io..."
    # Starte sshx.io und speichere Link
    LINK=$(curl -sSf https://sshx.io/get | sh -s run)
    echo "$LINK" | tee /data/sshx_link.txt
fi

echo "==> sshx.io läuft 24/7!"
# Container am Leben halten
tail -f /dev/null
