#!/usr/bin/env bash
set -e

# 1️⃣ Verzeichnis sicherstellen
mkdir -p /data

# 2️⃣ Wenn sshx.io noch nie gestartet wurde, starte einmalig und speichere Link
if [ ! -f /data/sshx_link.txt ]; then
    echo "==> Starte sshx.io..."
    # Start im Hintergrund
    curl -sSf https://sshx.io/get | sh -s run > /data/sshx_link.txt &
    sleep 10
else
    echo "==> sshx.io Link bereits vorhanden:"
    cat /data/sshx_link.txt
    # Starte sshx.io erneut im Hintergrund (gleicher Link)
    curl -sSf https://sshx.io/get | sh -s run --resume /data/sshx_link.txt &
fi

# 3️⃣ Log ausgeben und alive halten
echo "==> sshx.io läuft 24/7!"
tail -f /dev/null
