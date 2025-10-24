# Basis-Image Ubuntu 24.04
FROM ubuntu:24.04

# Umgebungsvariablen
ENV DEBIAN_FRONTEND=noninteractive

# Installationen
RUN apt update && apt install -y \
    openssh-server \
    sudo \
    curl \
    nano \
    iproute2 \
    net-tools \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Root-Passwort setzen
RUN echo "root:root" | chpasswd

# SSH konfigurieren
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Startscript kopieren
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Port freigeben
EXPOSE 22

# Start Befehl
CMD ["/start.sh"]
