FROM ubuntu:24.04

# Updates & Basics
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    nodejs npm \
    curl \
    && rm -rf /var/lib/apt/lists/*

# WebSSH: Wetty
RUN npm install -g wetty

# SSH Setup
RUN mkdir /var/run/sshd
RUN echo "root:root" | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 22
EXPOSE 8080

CMD ["/start.sh"]
