#!/bin/sh
# Node: Alice
# Membuat dan mengunggah signal_alice.txt.

echo 'Signal dari Alice untuk The Wired' > /root/signal_alice.txt
lftp -u alice,alice 10.72.2.2 -e \
  "set ftp:passive-mode true; put /root/signal_alice.txt; ls; bye"

