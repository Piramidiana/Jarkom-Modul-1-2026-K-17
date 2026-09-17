#!/bin/sh
# Node: Mika
# Melakukan koneksi SSH tanpa password ke Knights.

ssh -i /root/.ssh/mika_admin_ed25519 \
  -o IdentitiesOnly=yes \
  -o StrictHostKeyChecking=accept-new \
  mika_admin@10.72.3.2

