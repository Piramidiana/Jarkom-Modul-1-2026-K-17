#!/bin/sh
# Node: Knights
# Mengunggah knights_report.txt ke FTP Server Chisa.

lftp -u alice,alice 10.72.2.2 -e \
  "set ftp:passive-mode true; put /root/knights_report.txt; ls; bye"

