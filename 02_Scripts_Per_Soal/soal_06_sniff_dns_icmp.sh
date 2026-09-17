#!/bin/bash
# =====================================================================
# SOAL 6 - Jalankan di NODE MIKA
# Tujuan: generate traffic, lalu sniffing khusus paket DNS/ICMP
# =====================================================================

IFACE="eth0"   # <-- GANTI sesuai interface Mika

echo "[1] Jalankan traffic generator dari soal (file link yang diberikan asisten)."
echo "    Contoh jika berupa script:"
echo "      chmod +x traffic_generator.sh"
echo "      ./traffic_generator.sh &"
echo ""
echo "    Jika tidak ada file generator, kamu bisa generate traffic manual, contoh:"
echo "      ping -c 20 8.8.8.8 &"
echo "      for i in \$(seq 1 20); do nslookup google.com; sleep 1; done &"
echo ""

echo "[2] Sniffing dengan tshark (CLI dari Wireshark), capture semua dulu lalu filter pas dibuka:"
echo "    tshark -i $IFACE -w mika_capture.pcapng"
echo "    (biarkan jalan sambil traffic generator jalan, lalu Ctrl+C setelah cukup)"
echo ""
echo "[3] Buka file mika_capture.pcapng di Wireshark GUI, lalu di kolom Display Filter ketik:"
echo "    dns or icmp"
echo ""
echo "    Kalau mau langsung filter lewat CLI tanpa GUI:"
echo "    tshark -r mika_capture.pcapng -Y \"dns or icmp\""
echo ""
echo "[4] Ambil screenshot hasil filter + ringkasan (Statistics > Protocol Hierarchy) untuk laporan."
