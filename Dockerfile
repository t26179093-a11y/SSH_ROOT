FROM ubuntu:24.04

# Basis-Tools
RUN apt update && apt install -y \
    openssh-server \
    curl \
    git \
    python3 \
    python3-pip \
    sudo \
    nano \
    wget \
    unzip

# tmate installieren
RUN apt install -y tmate

# SSH konfigurieren
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Start-Skript kopieren
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
