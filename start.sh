#!/usr/bin/env bash
set -e

echo "=== Starting SSH server ==="
service ssh start

# VM-Ordner
VM_DIR=/root/vm
IMG_DIR=$VM_DIR/images
mkdir -p $IMG_DIR

# Beispiel: einfache Linux-Cloud-VM
VM_NAME=myvm
VM_IMG=$IMG_DIR/ubuntu-24.04.qcow2

# Cloud-Image herunterladen, falls noch nicht vorhanden
if [ ! -f "$VM_IMG" ]; then
    echo "Downloading Ubuntu 24.04 Cloud Image..."
    wget -O "$VM_IMG" https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
fi

# Disk für VM
DISK=$IMG_DIR/${VM_NAME}-disk.qcow2
if [ ! -f "$DISK" ]; then
    qemu-img create -f qcow2 "$DISK" 10G
fi

# VM starten
echo "Starting VM $VM_NAME..."
qemu-system-x86_64 \
    -m 1024 -smp 1 \
    -drive file="$VM_IMG",if=virtio,readonly=on \
    -drive file="$DISK",if=virtio \
    -net nic -net user,hostfwd=tcp::2222-:22 \
    -nographic &

# SSH-Zugang zur VM
echo ""
echo "=== VM SSH Access ==="
echo "Host: localhost"
echo "Port: 2222"
echo "Username: ubuntu"
echo "Password: ubuntu"
echo ""
echo "You can connect via your iPad SSH client: ssh ubuntu@<render-container-ip> -p 2222"
echo ""
echo "Logs anzeigen:"
tail -f /root/vm/images/${VM_NAME}-disk.qcow2 || true
