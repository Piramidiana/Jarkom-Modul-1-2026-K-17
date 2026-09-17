#!/bin/bash
# =====================================================================
# SOAL 16 - Analisis file capture wired_ftp_theft.pcap
# Yang dicari: IP server FTP penyerang, banner FTP, kredensial login,
#              ukuran file knights_payload.exe
# =====================================================================

PCAP="wired_ftp_theft.pcap"

echo "[1] Lihat semua command & response FTP (kontrol, port 21):"
tshark -r "$PCAP" -Y "ftp" -T fields \
  -e frame.number -e ip.src -e ip.dst -e ftp.request.command -e ftp.request.arg -e ftp.response.code -e ftp.response.arg

echo ""
echo "[2] Cari banner FTP (biasanya response code 220 saat pertama connect):"
tshark -r "$PCAP" -Y 'ftp.response.code=="220"' -T fields -e ip.src -e ftp.response.arg

echo ""
echo "[3] Cari kredensial (USER & PASS command):"
tshark -r "$PCAP" -Y 'ftp.request.command=="USER" or ftp.request.command=="PASS"' -T fields -e ip.src -e ftp.request.command -e ftp.request.arg

echo ""
echo "[4] Cari command STOR/RETR untuk file knights_payload.exe & ukurannya:"
tshark -r "$PCAP" -Y 'ftp.request.command=="RETR" or ftp.request.command=="STOR"' -T fields -e ftp.request.command -e ftp.request.arg

echo ""
echo "    Untuk ukuran file persis, paling gampang lewat GUI Wireshark:"
echo "      File > Export Objects > FTP-DATA  -> lihat kolom Size untuk knights_payload.exe"
echo "    Atau lewat CLI, jumlahkan panjang paket ftp-data:"
tshark -r "$PCAP" -Y "ftp-data" -T fields -e frame.len

echo ""
echo "[5] Setelah semua jawaban didapat, validasi ke socket server:"
echo "    nc [IP_Group] 3403"
echo "    (masukkan jawaban sesuai format yang diminta server)"
