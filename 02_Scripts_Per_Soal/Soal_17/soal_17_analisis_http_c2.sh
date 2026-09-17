#!/bin/bash
# =====================================================================
# SOAL 17 - Analisis file capture wired_http_c2.pcap
# Yang dicari: domain (Host) sumber malware, IP server penyerang,
#              nama file executable, kode status HTTP
# =====================================================================

PCAP="wired_http_c2.pcap"

echo "[1] Lihat semua HTTP request (Host + URI):"
tshark -r "$PCAP" -Y "http.request" -T fields \
  -e frame.number -e ip.src -e ip.dst -e http.host -e http.request.method -e http.request.uri

echo ""
echo "[2] Lihat semua HTTP response (status code + content-type):"
tshark -r "$PCAP" -Y "http.response" -T fields \
  -e frame.number -e ip.src -e http.response.code -e http.content_type -e http.content_length

echo ""
echo "[3] Kalau di request/response tidak terlihat nama file executable,"
echo "    cek langsung objek yang ditransfer lewat GUI Wireshark:"
echo "      File > Export Objects > HTTP  -> cari file .exe pada kolom Filename"
echo ""
echo "    Ringkasan cara membaca hasil:"
echo "      - Domain      : nilai kolom http.host pada request"
echo "      - IP server   : ip.src pada paket response (server yang membalas)"
echo "      - Nama file   : kolom Filename di Export Objects, atau akhir path di http.request.uri"
echo "      - Status code : http.response.code (contoh 200 = OK)"

echo ""
echo "[4] Setelah semua jawaban didapat, validasi ke socket server:"
echo "    nc [IP_Group] 3404"
