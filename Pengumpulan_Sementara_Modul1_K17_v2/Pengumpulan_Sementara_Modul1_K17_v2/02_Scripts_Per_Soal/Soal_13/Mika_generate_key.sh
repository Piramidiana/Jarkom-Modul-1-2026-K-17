#!/bin/sh
# Node: Mika
# Membuat pasangan kunci SSH ED25519.

mkdir -p /root/.ssh
chmod 700 /root/.ssh
ssh-keygen -t ed25519 -f /root/.ssh/mika_admin_ed25519 -N '' -C 'mika_admin@Mika'
cat /root/.ssh/mika_admin_ed25519.pub

