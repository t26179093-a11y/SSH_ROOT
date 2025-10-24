FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /root

# Install dependencies
RUN apt-get update && apt-get install -y \
    qemu-kvm qemu-utils qemu-system-x86 cloud-image-utils cloud-init \
    curl sudo git python3 python3-pip openssh-client \
    && apt-get clean

# SSHX installieren
RUN curl -L https://s3.amazonaws.com/sshx/sshx-x86_64-unknown-linux-musl.tar.gz \
    | tar -xz -C /usr/local/bin && chmod +x /usr/local/bin/sshx

# Startscript kopieren
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port (nur für Render Web Worker)
EXPOSE 8080

CMD ["/start.sh"]
