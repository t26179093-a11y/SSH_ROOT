#!/bin/bash
service ssh start

echo "Starte tmate..."
tmate -F &
sleep 5

# Link anzeigen (Web & SSH)
tmate display -p '#{tmate_ssh}'
tmate display -p '#{tmate_web}'

# 24/7 laufen lassen
tail -f /dev/null
