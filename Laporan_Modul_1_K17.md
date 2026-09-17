# LAPORAN PRAKTIKUM MODUL 1

## Identitas Kelompok

| Keterangan | Isi |
|---|---|
| Kelompok | K-17 |
| Project GNS3 | K-17-MODUL-1 |
| Anggota 1 | [Nama - NRP] |
| Anggota 2 | [Nama - NRP] |

## 1. Topologi dan Pembagian Alamat IP

Topologi terdiri dari satu router bernama **Lain**, tiga switch, lima client, dan satu NAT. Router Lain menghubungkan ketiga subnet dan jaringan internet.

| Perangkat | Interface | Alamat IP | Gateway |
|---|---|---|---|
| Lain | eth0 | DHCP (`192.168.122.66/24`) | `192.168.122.1` |
| Lain | eth1 | `10.72.1.1/24` | - |
| Lain | eth2 | `10.72.2.1/24` | - |
| Lain | eth3 | `10.72.3.1/24` | - |
| Alice | eth0 | `10.72.1.2/24` | `10.72.1.1` |
| Mika | eth0 | `10.72.1.3/24` | `10.72.1.1` |
| Chisa | eth0 | `10.72.2.2/24` | `10.72.2.1` |
| Knights | eth0 | `10.72.3.2/24` | `10.72.3.1` |
| Eiri | eth0 | `10.72.3.3/24` | `10.72.3.1` |

> **[LETAKKAN SCREENSHOT 1 DI SINI]**  
> Screenshot yang diperlukan: topologi GNS3 secara penuh. Pastikan nama semua perangkat dan label interface terlihat.

## 2. Koneksi Router Lain ke Internet

Interface `eth0` pada router Lain memperoleh alamat IP melalui DHCP dari NAT1. Hasil pengujian menunjukkan bahwa router dapat menjangkau gateway NAT dan internet publik.

Perintah pengujian:

```bash
ip -br addr show eth0
ip route
ping -c 2 8.8.8.8
```

Hasil ping ke `8.8.8.8` berhasil tanpa packet loss. Dengan demikian, router Lain sudah terhubung ke internet.

> **[LETAKKAN SCREENSHOT 2 DI SINI]**  
> Screenshot yang diperlukan: terminal Lain yang menampilkan IP `eth0`, default route, dan ping sukses ke `8.8.8.8`.

## 3. Routing Antar-Subnet

IP forwarding diaktifkan pada router Lain agar seluruh client pada Switch1, Switch2, dan Switch3 dapat saling berkomunikasi.

```bash
sysctl -w net.ipv4.ip_forward=1
```

Pengujian dilakukan dengan mengirim ping antarclient yang berada pada subnet berbeda. Semua pengujian berhasil dengan packet loss 0%.

> **[LETAKKAN SCREENSHOT 3 DI SINI]**  
> Screenshot yang diperlukan: hasil ping Alice ke client pada subnet `10.72.2.0/24` dan `10.72.3.0/24`.

> **[LETAKKAN SCREENSHOT 4 DI SINI]**  
> Screenshot yang diperlukan: hasil ping Chisa atau Knights ke client pada subnet lain.

## 4. [Judul Soal Nomor 4]

**Dikerjakan oleh anggota kelompok lain.**

[Tuliskan konfigurasi yang dilakukan dan hasil pengujiannya secara singkat.]

> **[LETAKKAN SCREENSHOT NOMOR 4 DI SINI]**  
> Screenshot yang diperlukan: [isi sesuai bukti hasil pekerjaan nomor 4].

## 5. [Judul Soal Nomor 5]

**Dikerjakan oleh anggota kelompok lain.**

[Tuliskan konfigurasi yang dilakukan dan hasil pengujiannya secara singkat.]

> **[LETAKKAN SCREENSHOT NOMOR 5 DI SINI]**  
> Screenshot yang diperlukan: [isi sesuai bukti hasil pekerjaan nomor 5].

## 6. [Judul Soal Nomor 6]

**Dikerjakan oleh anggota kelompok lain.**

[Tuliskan konfigurasi yang dilakukan dan hasil pengujiannya secara singkat.]

> **[LETAKKAN SCREENSHOT NOMOR 6 DI SINI]**  
> Screenshot yang diperlukan: [isi sesuai bukti hasil pekerjaan nomor 6].

## 7. Konfigurasi FTP Server Chisa

FTP Server dipasang pada node Chisa menggunakan vsFTPd. Folder yang dibagikan adalah `/var/wired/data`. Kebijakan akses yang diterapkan adalah:

- `alice`: dapat membaca dan menulis file.
- `mika`: hanya dapat membaca dan mengunduh file.
- `eiri`: masuk blacklist dan tidak dapat login.

Alice berhasil mengunggah `signal_alice.txt`. File tersebut tersimpan di server dengan pemilik `alice:wiredftp`. Percobaan login Eiri ditolak dengan respons `530 Permission denied`.

> **[LETAKKAN SCREENSHOT 7A DI SINI]**  
> Screenshot yang diperlukan: terminal Alice ketika upload `signal_alice.txt` berhasil dan muncul jumlah byte yang ditransfer.

> **[LETAKKAN SCREENSHOT 7B DI SINI]**  
> Screenshot yang diperlukan: terminal Chisa yang menampilkan `ls -l /var/wired/data` dan isi `signal_alice.txt`.

> **[LETAKKAN SCREENSHOT 7C DI SINI]**  
> Screenshot yang diperlukan: terminal Eiri yang menampilkan penolakan `530 Permission denied`.

## 8. Upload Laporan Knights dan Analisis FTP

Knights terhubung ke FTP Server Chisa menggunakan akun Alice. File `knights_report.txt` berhasil diunggah sebesar 1087 bytes.

Berdasarkan capture Wireshark:

- Perintah upload: `STOR knights_report.txt`
- Respons sukses: `226 Transfer complete`
- Respons PASV: `227 Entering Passive Mode (10,72,2,2,117,55)`

Port data PASV dihitung sebagai berikut:

```text
(117 × 256) + 55 = 30007
```

Jadi, port data TCP yang digunakan untuk upload adalah **30007**.

> **[LETAKKAN SCREENSHOT 8A DI SINI]**  
> Screenshot yang diperlukan: terminal Knights yang menampilkan upload `knights_report.txt` berhasil.

> **[LETAKKAN SCREENSHOT 8B DI SINI]**  
> Screenshot yang diperlukan: Wireshark dengan filter FTP yang memperlihatkan `PASV`, respons `227`, `STOR knights_report.txt`, dan `226 Transfer complete`.

## 9. Akses Read-Only Mika

Mika login ke FTP Server Chisa menggunakan akun `mika`. File `protocol7_manifesto.txt` berhasil diunduh sebesar 1738 bytes dan isinya dapat dibaca.

Setelah itu, Mika mencoba mengunggah `mika_upload_test.txt`. Server menolak upload dengan respons:

```text
550 Permission denied
```

Hasil tersebut membuktikan bahwa akun Mika hanya mempunyai akses baca dan download.

> **[LETAKKAN SCREENSHOT 9 DI SINI]**  
> Screenshot yang diperlukan: terminal Mika yang memperlihatkan download berhasil, isi awal file, dan percobaan upload yang ditolak dengan `550 Permission denied`.

## 10. Uji Latensi Knights ke Chisa

Knights mengirim 77 paket ICMP ke Chisa dengan payload 128 bytes dan interval 0,3 detik.

```bash
ping -c 77 -s 128 -i 0.3 10.72.2.2
```

Hasil analisis:

| Parameter | Hasil |
|---|---|
| ICMP Echo Request | Type 8, Code 0 |
| ICMP Echo Reply | Type 0, Code 0 |
| Paket dikirim | 77 |
| Paket diterima | [Isi dari hasil ping] |
| Packet loss | [Isi dari hasil ping] |
| RTT minimum | [Isi] ms |
| RTT rata-rata | [Isi] ms |
| RTT maksimum | [Isi] ms |

> **[LETAKKAN SCREENSHOT 10A DI SINI]**  
> Screenshot yang diperlukan: terminal Knights yang menampilkan perintah ping dan bagian akhir statistik 77 paket.

> **[LETAKKAN SCREENSHOT 10B DI SINI]**  
> Screenshot yang diperlukan: Wireshark yang menampilkan ICMP Echo Request dan Echo Reply. Buka detail ICMP agar nilai Type dan Code terlihat.

## Kesimpulan

Topologi The Wired berhasil dibangun menggunakan tiga subnet yang dihubungkan oleh router Lain. Seluruh client dapat berkomunikasi dan mengakses layanan yang dikonfigurasi. FTP Server Chisa juga berhasil menerapkan hak akses berbeda untuk Alice, Mika, dan Eiri. Hasil capture Wireshark membuktikan proses transfer FTP dan penggunaan port data PASV.

