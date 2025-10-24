# ---- Basis: Ubuntu 24.04 ----
FROM ubuntu:24.04

# ---- Pakete installieren ----
RUN apt update && apt install -y openssh-server tmate curl sudo nano

# ---- Root Passwort ----
RUN echo "root:root" | chpasswd

# ---- SSH konfigurieren ----
RUN mkdir /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

# ---- Startskript ----
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
