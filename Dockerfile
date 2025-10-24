# Basis-Image
FROM ubuntu:24.04

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Install dependencies
RUN apt-get update && apt-get install -y \
    qemu-kvm qemu-utils qemu-system-x86 cloud-image-utils cloud-init \
    openssh-server sudo git wget python3 python3-pip nano curl \
    && apt-get clean

# SSH konfigurieren
RUN mkdir /var/run/sshd \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Script kopieren und ausführbar machen
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Port für SSH
EXPOSE 22

# Startscript ausführen
CMD ["/start.sh"]
