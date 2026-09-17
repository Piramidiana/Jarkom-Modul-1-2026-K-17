#!/bin/sh
# Node: Eiri
# Membuktikan bahwa user Eiri ditolak oleh FTP Server.

lftp -u eiri,eiri 10.72.2.2 -e \
  "set net:max-retries 1; set net:timeout 5; ls; bye"

