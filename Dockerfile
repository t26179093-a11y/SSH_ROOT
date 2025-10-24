# Dockerfile: OpenSSH + rsyslog + login-watcher (Ubuntu 24.04)
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# System-Pakete installieren
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server rsyslog curl sudo ca-certificates nano wget gnupg \
  && rm -rf /var/lib/apt/lists/*

# Root-Passwort setzen (ACHTUNG: ändere das später!)
RUN echo "root:root" | chpasswd

# SSH konfigurieren: Root-Login und Passwort erlauben
RUN mkdir -p /var/run/sshd \
 && sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config || echo "PermitRootLogin yes" >> /etc/ssh/sshd_config \
 && sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config || echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# Arbeitsverzeichnis
WORKDIR /app

# Start-Skript kopieren
COPY start.sh /start.sh
RUN chmod +x /start.sh

# SSH-Port offenlegen (wichtig nur wenn Host es weiterreicht)
EXPOSE 22

# Start
CMD ["/start.sh"]
