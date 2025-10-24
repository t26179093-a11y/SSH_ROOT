# Base image
FROM ubuntu:22.04

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV WORKDIR=/data
ENV SSHX_LINK_FILE=/data/sshx_link.txt

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    screen \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Create workdir (persistent)
RUN mkdir -p $WORKDIR
VOLUME ["$WORKDIR"]
WORKDIR $WORKDIR

# Copy start script
COPY sshx-start.sh /sshx-start.sh
RUN chmod +x /sshx-start.sh

# Expose default SSHX port (optional)
EXPOSE 2222

# Start script on container run
CMD ["/start.sh"]
