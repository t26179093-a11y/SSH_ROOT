# === Basis: Ubuntu 24.04 ===
FROM ubuntu:24.04

# === Updates & Tools ===
RUN apt-get update && apt-get install -y \
    tmate openssh-server sudo curl nano wget git \
    && apt-get clean

# === Root-Passwort setzen ===
RUN echo "root:root" | chpasswd

# === SSH konfigurieren ===
RUN mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# === Tmate konfigurieren ===
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh

# === Startskript hinzufügen ===
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
CMD ["/start.sh"]
