#!/bin/bash

# SSH starten (im Vordergrund, damit Docker nicht stoppt)
mkdir -p /var/run/sshd

# Root Login sicherstellen
echo "root:root" | chpasswd

# SSH Server starten im Vordergrund
/usr/sbin/sshd -D -e &

# IP-Adresse anzeigen
IP_ADDR=$(hostname -I | awk '{print $1}')

echo "==============================="
echo "SSH Server läuft!"
echo "IP-Adresse: $IP_ADDR"
echo "Benutzer: root"
echo "Passwort: root"
echo "Port: 22"
echo "==============================="

# Logs direkt aus stdout (Docker log)
echo "SSH Logs werden in Docker-Console angezeigt."
wait
