#!/bin/bash
# =====================================================================
# SOAL 18 - Analisis file capture wired_smb_transfer.pcapng
# Yang dicari: protokol yang dieksploitasi, IP pengirim/penerima,
#              folder tujuan, nama file executable
# =====================================================================

PCAP="wired_smb_transfer.pcapng"

echo "[1] Cek trafik SMB/SMB2 secara umum:"
tshark -r "$PCAP" -Y "smb or smb2" -T fields \
  -e frame.number -e ip.src -e ip.dst -e smb2.cmd -e smb.cmd

echo ""
echo "[2] Cari operasi Create/Write file (di sinilah nama file & path muncul):"
tshark -r "$PCAP" -Y "smb2.filename" -T fields -e ip.src -e ip.dst -e smb2.filename

echo ""
echo "[3] Cara paling mudah untuk lihat isi & nama file yang ditransfer (via GUI Wireshark):"
echo "      File > Export Objects > SMB/SMB2  -> lihat kolom Filename (path tujuan + nama file .exe)"
echo ""
echo "    Protokol yang dieksploitasi: SMB (Server Message Block), biasanya lewat port 445."
echo "    IP pengirim = ip.src pada paket write request, IP penerima = ip.dst nya."

echo ""
echo "[4] Setelah semua jawaban didapat, validasi ke socket server:"
echo "    nc [IP_Group] 3405"
