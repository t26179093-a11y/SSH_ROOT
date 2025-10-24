#!/bin/bash

# SSH starten
/usr/sbin/sshd

# IP-Adresse ermitteln
IP_ADDR=$(hostname -I | awk '{print $1}')

# Infos anzeigen
echo "==============================="
echo "SSH Server läuft!"
echo "IP-Adresse: $IP_ADDR"
echo "Benutzer: root"
echo "Passwort: root"
echo "Port: 22"
echo "==============================="

# Logs überwachen
echo "SSH Login Logs:"
tail -f /var/log/auth.log
