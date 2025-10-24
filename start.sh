#!/bin/bash
service ssh start

echo "Starte tmate..."
tmate -F new-session
