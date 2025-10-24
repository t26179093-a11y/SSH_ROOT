#!/bin/bash
echo "==============================="
echo "Starting SSH + WebSSH (tmate)..."
echo "User: root"
echo "Password: root"
echo "Port: 22 (internal)"
echo "==============================="

# SSH starten
/usr/sbin/sshd

# tmate Session starten (WebSSH)
tmate -F
