#!/bin/sh
# Node: Mika
# Mengunduh manifesto lalu membuktikan bahwa upload ditolak.

lftp -u mika,mika 10.72.2.2 -e \
  "get protocol7_manifesto.txt -o /root/protocol7_manifesto.txt; bye"

head -n 8 /root/protocol7_manifesto.txt
echo 'Percobaan upload oleh Mika' > /root/mika_upload_test.txt

lftp -u mika,mika 10.72.2.2 -e \
  "set net:max-retries 1; set net:timeout 5; put /root/mika_upload_test.txt; bye"

