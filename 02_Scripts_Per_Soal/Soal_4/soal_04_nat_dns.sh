#!/bin/bash
# =====================================================================
# SOAL 4 - Jalankan di ROUTER LAIN
# Tujuan: Setiap Client punya kemandirian internet (ping 8.8.8.8 & buka google.com)
# =====================================================================

# --- GANTI SESUAI NAMA INTERFACE DI ROUTER LAIN ---
WAN_IF="eth0"   # interface yang mengarah ke internet / uplink
LAN_IF="eth1"   # interface yang mengarah ke jaringan Client (bisa lebih dari satu, tambahkan baris jika perlu)

echo "[1] Mengaktifkan IP forwarding..."
sysctl -w net.ipv4.ip_forward=1
# Persist supaya tetap aktif setelah reboot
grep -q "net.ipv4.ip_forward" /etc/sysctl.conf \
  && sed -i 's/^net.ipv4.ip_forward.*/net.ipv4.ip_forward = 1/' /etc/sysctl.conf \
  || echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf

echo "[2] Konfigurasi NAT Masquerade..."
iptables -t nat -A POSTROUTING -o "$WAN_IF" -j MASQUERADE
iptables -A FORWARD -i "$LAN_IF" -o "$WAN_IF" -j ACCEPT
iptables -A FORWARD -i "$WAN_IF" -o "$LAN_IF" -m state --state RELATED,ESTABLISHED -j ACCEPT

echo "[3] Simpan iptables supaya tidak hilang saat restart (dipakai juga untuk soal 5)..."
apt-get update -y
apt-get install -y iptables-persistent
netfilter-persistent save

echo "[4] Cek hasil:"
ip -br a
iptables -t nat -L -v -n

echo ""
echo "=== DI SETIAP NODE CLIENT, jalankan ini juga (DNS resolver) ==="
cat <<'EOF'
# /etc/resolv.conf pada Client
nameserver 8.8.8.8
nameserver 1.1.1.1
EOF
echo "Lalu tes dari Client:"
echo "  ping -c 4 8.8.8.8"
echo "  ping -c 4 google.com   (atau: curl -I https://google.com)"
