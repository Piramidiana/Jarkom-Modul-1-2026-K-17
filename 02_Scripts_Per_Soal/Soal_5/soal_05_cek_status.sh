#!/bin/bash
# =====================================================================
# SOAL 5 - Simpan sebagai /root/cek_status.sh di ROUTER LAIN
# Tujuan: bukti bahwa konfigurasi jaringan tetap ada setelah node di-restart
# =====================================================================

LOGFILE="/root/status_$(date +%Y%m%d_%H%M%S).log"

{
  echo "===== STATUS JARINGAN ROUTER LAIN (dijalankan: $(date)) ====="
  echo ""
  echo "----- Ringkasan Interface (ip -br a) -----"
  ip -br a
  echo ""
  echo "----- Tabel NAT (iptables -t nat -L -v -n) -----"
  iptables -t nat -L -v -n
} | tee "$LOGFILE"

echo ""
echo "Log tersimpan di: $LOGFILE"
