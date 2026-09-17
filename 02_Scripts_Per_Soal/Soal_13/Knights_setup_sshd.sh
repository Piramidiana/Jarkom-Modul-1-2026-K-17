#!/bin/sh
# Node: Knights
# Instalasi OpenSSH Server dan konfigurasi public key authentication.

apk update
apk add openssh-server

adduser -D -h /home/mika_admin -s /bin/ash mika_admin 2>/dev/null || true
echo 'mika_admin:mika' | chpasswd
mkdir -p /home/mika_admin/.ssh /run/sshd
chmod 700 /home/mika_admin/.ssh

printf '%s\n' \
  'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO9MXkw/VQ/8OSFImkGGoKPIR1SyY5OsYf7MBm+CKs1a mika_admin@Mika' \
  > /home/mika_admin/.ssh/authorized_keys

chown -R mika_admin:mika_admin /home/mika_admin
chmod 600 /home/mika_admin/.ssh/authorized_keys

ssh-keygen -A
/usr/sbin/sshd -t -f ./sshd_config
/usr/sbin/sshd -f ./sshd_config
ss -lntp | grep ':22'

