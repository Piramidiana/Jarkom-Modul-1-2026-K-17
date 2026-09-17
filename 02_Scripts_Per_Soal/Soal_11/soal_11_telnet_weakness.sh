#!/bin/bash
# =====================================================================
# SOAL 11 - Bagian A dijalankan di NODE CHISA (server)
#           Bagian B dijalankan di NODE EIRI (client, penyerang)
# Tujuan: buktikan Telnet mengirim kredensial dalam plain text
# =====================================================================

echo "############################################"
echo "# BAGIAN A - DI NODE CHISA (jalankan bagian ini di Chisa)"
echo "############################################"
cat <<'EOF'
apt-get update
apt-get install -y telnetd xinetd

useradd -m phantom_user
echo "phantom_user:wired_ghost" | chpasswd

# Aktifkan service telnet lewat xinetd
cat > /etc/xinetd.d/telnet <<TELNET
service telnet
{
    disable         = no
    flags           = REUSE
    socket_type     = stream
    wait            = no
    user            = root
    server          = /usr/sbin/in.telnetd
    log_on_failure  += USERID
}
TELNET

systemctl restart xinetd
systemctl enable xinetd
EOF

echo ""
echo "############################################"
echo "# BAGIAN B - DI NODE EIRI (jalankan bagian ini di Eiri)"
echo "############################################"
cat <<'EOF'
IFACE="eth0"          # GANTI sesuai interface Eiri
IP_CHISA="<ISI_IP_CHISA>"

# 1. Mulai capture di background
tshark -i $IFACE -f "port 23" -w eiri_telnet_capture.pcapng &

# 2. Login telnet
telnet $IP_CHISA
# saat diminta login, masukkan:
#   login: phantom_user
#   password: wired_ghost

# 3. Setelah login berhasil, hentikan tshark (fg lalu Ctrl+C)
EOF

echo ""
echo "############################################"
echo "# ANALISIS DI WIRESHARK (buka eiri_telnet_capture.pcapng)"
echo "############################################"
cat <<'EOF'
1. Klik salah satu paket TCP port 23, klik kanan -> Follow -> TCP Stream.
   Kredensial phantom_user / wired_ghost akan terlihat dalam bentuk teks biasa (plain text).

2. Alasan tiap karakter terkirim dalam paket TCP terpisah:
   Telnet secara default berjalan dalam mode "character mode" (unbuffered), bukan
   "line mode". Setiap tombol yang ditekan langsung dikirim sebagai satu paket TCP
   tanpa menunggu buffer baris penuh (tidak seperti SSH yang mengenkripsi seluruh
   sesi setelah key exchange).
EOF
