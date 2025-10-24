#!/usr/bin/env bash
# ===========================
# start.sh - startet SSH Server + zeigt Info
# ===========================

# SSH starten
/usr/sbin/sshd

# IP ermitteln
IP_ADDR=$(hostname -I | awk '{print $1}')
USERNAME="root"
PASSWORD="root"
PORT=22

echo "==========================================="
echo "SSH Server läuft!"
echo "IP Address : $IP_ADDR"
echo "Username   : $USERNAME"
echo "Password   : $PASSWORD"
echo "Port       : $PORT"
echo "==========================================="

# SSH Logins live überwachen
LOG_FILE="/var/log/auth.log"

# Prüfen, ob Datei existiert (Ubuntu 24.04)
touch $LOG_FILE
tail -F $LOG_FILE | while read line; do
    if echo "$line" | grep -q "Accepted password"; then
        echo "=== SSH Login Detected ==="
        echo "$line"
        echo "=========================="
    fi
done
