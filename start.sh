#!/usr/bin/env bash
set -euo pipefail

# start.sh - startet rsyslog + sshd, zeigt connection-info und überwacht logins

echo "== start.sh: beginne boot sequence =="

# 1) Start rsyslog (Syslog benötigt, damit /var/log/auth.log gefüllt wird)
#    In Containers: rsyslogd ist lightweight und schreibt Logs in /var/log.
echo "[1/4] Starte rsyslog..."
/usr/sbin/rsyslogd

# 2) Start sshd (in background)
echo "[2/4] Starte sshd..."
/usr/sbin/sshd

# 3) Kurze Info ausgeben: hostname, interne IP, öffentliche IP (falls erreichbar)
echo "[3/4] Sammle Verbindungsinformationen..."
HOSTNAME="$(hostname --fqdn 2>/dev/null || hostname)"
INTERNAL_IP="$(hostname -I 2>/dev/null | awk '{print $1}' || echo 'N/A')"

# versuche öffentliche IP (kann fehlschlagen, falls ausgehende Verbindungen blockiert sind)
PUB_IP="$(curl -s --max-time 5 https://ifconfig.me || curl -s --max-time 5 https://api.ipify.org || echo 'public-ip-unavailable')"

echo "==========================================="
echo "SSH Server läuft jetzt."
echo "Hostname: $HOSTNAME"
echo "Interne IP: $INTERNAL_IP"
echo "Öffentliche IP (sofern erreichbar): $PUB_IP"
echo "Benutzer: root"
echo "Passwort: root"
echo "Port: 22"
echo "==========================================="
echo ""
echo "Hinweis: Wenn du diesen Container auf Render betreibst, stelle sicher, dass Render den Port 22 freigibt"
echo "oder deploye als Background Worker. Ansonsten kann keine externe SSH-Verbindung hergestellt werden."
echo ""

# 4) Überwache /var/log/auth.log auf erfolgreiche Logins und logge sie
LOGFILE="/var/log/auth.log"

# Warte bis logfile existiert
i=0
while [ ! -f "$LOGFILE" ] && [ $i -lt 10 ]; do
  echo "Warte auf $LOGFILE..."
  sleep 1
  i=$((i+1))
done

if [ ! -f "$LOGFILE" ]; then
  echo "WARN: $LOGFILE existiert nicht - Login-Überwachung nicht möglich."
else
  echo "[4/4] Starte Login-Monitor (Überwacht 'Accepted' Einträge in $LOGFILE)."
  # tail -F und filter: bei "Accepted password for" oder "Accepted publickey" eine Meldung ausgeben
  tail -F "$LOGFILE" 2>/dev/null | \
  while read -r line; do
    # Beispiel-Logzeilen:
    # Oct 24 17:00:00 hostname sshd[123]: Accepted password for root from 1.2.3.4 port 55822 ssh2
    if echo "$line" | grep -E "Accepted (password|publickey) for" >/dev/null 2>&1; then
      TIMESTAMP="$(date --iso-8601=seconds)"
      echo "=== LOGIN-EVENT [$TIMESTAMP] ==="
      echo "$line"
      echo "==============================="
      # Optional: hier kannst du Benachrichtigungscmds einfügen (z.B. curl zu einem webhook)
      # Beispiel: curl -s -X POST -H 'Content-Type: application/json' -d "{\"text\":\"SSH login: $line\"}" https://example.com/webhook
    fi
  done
fi

# Fallback: falls tail oben beendet, blockiere den Container, damit er nicht exitet
# (dieser Befehl wird normalerweise nicht erreicht, da tail -F läuft)
echo "Login-monitor beendet — script endet. Halte Container offen..."
sleep infinity
