#!/bin/bash
# =====================================================================
# SOAL 20 - Analisis wired_tls_decrypt.pcapng + keyslogfile.txt
# Yang dicari: versi TLS, SNI (domain), IP server HTTPS penyerang,
#              User-Agent, HTTP method & path tersembunyi di dalam TLS
# =====================================================================

PCAP="wired_tls_decrypt.pcapng"
KEYLOG="keyslogfile.txt"

echo "[1] Cek versi TLS yang dinegosiasikan (Client Hello / Server Hello):"
tshark -r "$PCAP" -Y "tls.handshake.type==1 or tls.handshake.type==2" -T fields \
  -e ip.src -e ip.dst -e tls.handshake.type -e tls.handshake.version

echo ""
echo "[2] Cek SNI (domain) yang diakses (dari Client Hello):"
tshark -r "$PCAP" -Y "tls.handshake.extensions_server_name" -T fields \
  -e ip.src -e ip.dst -e tls.handshake.extensions_server_name

echo ""
echo "[3] Dekripsi trafik pakai keylog file, lalu lihat HTTP di dalamnya:"
tshark -r "$PCAP" -o "tls.keylog_file:$KEYLOG" -Y "http.request" -T fields \
  -e ip.src -e ip.dst -e http.request.method -e http.request.uri -e http.user_agent

echo ""
echo "    (Cara di GUI Wireshark: Edit > Preferences > Protocols > TLS >"
echo "     '(Pre)-Master-Secret log filename' -> arahkan ke keyslogfile.txt,"
echo "     lalu paket TLS otomatis terdekripsi dan bisa difilter dengan 'http')"
echo ""
echo "    IP server HTTPS penyerang = ip.dst pada request (server tujuan koneksi)"

echo ""
echo "[4] Setelah semua jawaban didapat, validasi ke socket server:"
echo "    nc [IP_Group] 3407"
