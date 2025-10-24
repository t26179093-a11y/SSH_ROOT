# ===========================
# Dockerfile für SSH auf Render
# ===========================
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Update & Basis Tools
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nano \
    curl \
    git \
    iproute2 \
    net-tools \
    vim \
    && rm -rf /var/lib/apt/lists/*

# SSH Konfiguration
RUN mkdir /var/run/sshd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Root Passwort setzen
RUN echo "root:root" | chpasswd

# Start Script kopieren
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22

CMD ["/start.sh"]
