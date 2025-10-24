#!/usr/bin/env bash
set -e

echo "=== Starting Web-SSH via sshx.io ==="

# VM vorbereiten
VM_DIR=/root/vm
IMG_DIR=$VM_DIR/images
mkdir -p $IMG_DIR

VM_NAME=myvm
VM_IMG=$IMG_DIR/ubuntu-24.04.qcow2

# Cloud Image
if [ ! -f "$VM_IMG" ]; then
    wget -O "$VM_IMG" https://cloud-images.ubuntu.com/noble/current/noble-server-cloudimg-amd64.img
fi

DISK=$IMG_DIR/${VM_NAME}-disk.qcow2
if [ ! -f "$DISK" ]; then
    qemu-img create -f qcow2 "$DISK" 10G
fi

# VM starten (Port 22 intern)
qemu-system-x86_64 \
    -m 1024 -smp 1 \
    -drive file="$VM_IMG",if=virtio,readonly=on \
    -drive file="$DISK",if=virtio \
    -net nic -net user,hostfwd=tcp::2222-:22 \
    -nographic &

# SSHX starten
sshx

echo "Web-SSH verfügbar:"
echo "Besuche die angezeigte sshx.io URL oben!"
echo ""
echo "Wenn du den VM-SSH nutzen willst, verbinde über Port 2222 auf sshx-Container."
