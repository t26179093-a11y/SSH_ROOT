# Dockerfile für sshx.io auf Render
FROM ubuntu:24.04

# Install Basics
RUN apt-get update && apt-get install -y \
    curl \
    bash \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Arbeitsverzeichnis für Persistenz
VOLUME ["/data"]
WORKDIR /data

# Kopiere start.sh
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Start
CMD ["/start.sh"]
