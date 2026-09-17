#!/bin/bash
# =====================================================================
# SOAL 12 - Jalankan di NODE ALICE
# Tujuan: scan port 22, 80 (harus terbuka) dan 7777 (harus tertutup) di Knights
# =====================================================================

IFACE="eth0"                  # <-- GANTI sesuai interface Alice
IP_KNIGHTS="<ISI_IP_KNIGHTS>" # <-- GANTI dengan IP node Knights

echo "[1] Mulai capture TCP di background:"
echo "    tshark -i $IFACE -f \"host $IP_KNIGHTS and tcp\" -w alice_portscan.pcapng &"
tshark -i "$IFACE" -f "host $IP_KNIGHTS and tcp" -w alice_portscan.pcapng &
TSHARK_PID=$!
sleep 1

echo "[2] Scan port dengan netcat:"
for port in 22 80 7777; do
  echo "--- Cek port $port ---"
  nc -vz -w 2 "$IP_KNIGHTS" "$port"
done

sleep 1
kill "$TSHARK_PID" 2>/dev/null

echo ""
echo "[3] Analisis di Wireshark (alice_portscan.pcapng):"
echo "    - Port TERBUKA (22, 80): balasan dari Knights berupa SYN, ACK"
echo "      (tcp.flags.syn==1 and tcp.flags.ack==1)"
echo "    - Port TERTUTUP (7777): balasan dari Knights berupa RST, ACK"
echo "      (tcp.flags.reset==1 and tcp.flags.ack==1)"
echo "    Filter cepat di Wireshark: tcp.flags.syn==1 or tcp.flags.reset==1"
