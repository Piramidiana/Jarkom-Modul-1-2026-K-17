# LAPORAN PRAKTIKUM MODUL 1

## Identitas Kelompok

| Keterangan | Isi |
|---|---|
| Kelompok | K-17 |
| Project GNS3 | K-17-MODUL-1 |
| Anggota 1 | Dian Piramidiana Rachmatika - 5027251031 |
| Anggota 2 | Jude Athala Yazid Sari - 5027251098 |

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


13. Lain memerintahkan agar administrasi jarak jauh menggunakan SSH secara aman tanpa password. Install OpenSSH server pada node Knights, buat pasangan kunci SSH (`ssh-keygen`) pada node Mika untuk user `mika_admin`, dan konfigurasikan public key authentication (`PasswordAuthentication no`). Lakukan koneksi SSH dari node Mika ke node Knights, tangkap sesi menggunakan Wireshark, identifikasi paket Protocol Version Exchange dan Key Exchange, serta jelaskan mengapa kredensial tidak terlihat dalam bentuk teks terbuka seperti pada Telnet.

Pertama, dibuat pasangan public key dan private key ED25519 pada node Mika menggunakan perintah berikut:

```sh
mkdir -p /root/.ssh
chmod 700 /root/.ssh
ssh-keygen -t ed25519 -f /root/.ssh/mika_admin_ed25519 -N '' -C 'mika_admin@Mika'
```

Hasil pembuatan pasangan kunci dapat dilihat pada screenshot berikut.

![](assets/13-keygen-mika.png)

Selanjutnya, OpenSSH Server dipasang pada node Knights dan dibuat user `mika_admin`.

```sh
apk update
apk add openssh-server
adduser -D -h /home/mika_admin -s /bin/ash mika_admin
mkdir -p /home/mika_admin/.ssh
chmod 700 /home/mika_admin/.ssh
```

Public key milik Mika kemudian disimpan pada `/home/mika_admin/.ssh/authorized_keys` di Knights. Konfigurasi SSH yang digunakan mengaktifkan public key authentication dan mematikan autentikasi password.

```text
Port 22
ListenAddress 0.0.0.0
PermitRootLogin no
PubkeyAuthentication yes
PasswordAuthentication no
KbdInteractiveAuthentication no
AuthorizedKeysFile .ssh/authorized_keys
```

SSH Server berhasil berjalan pada port 22. Mika kemudian melakukan koneksi ke Knights menggunakan private key berikut:

```sh
ssh -i /root/.ssh/mika_admin_ed25519 \
  -o IdentitiesOnly=yes \
  -o StrictHostKeyChecking=accept-new \
  mika_admin@10.72.3.2
```

Koneksi berhasil tanpa meminta password. Perintah `whoami` menghasilkan `mika_admin` dan `hostname` menghasilkan `Knights`.

![](assets/13-login-ssh.png)

Pada saat koneksi berlangsung dilakukan capture menggunakan Wireshark. Filter yang digunakan adalah:

```text
ssh
```

Capture memperlihatkan Protocol Version Exchange `SSH-2.0-OpenSSH_10.2`, paket Client dan Server `Key Exchange Init`, proses `PQ/T Hybrid Key Exchange`, `New Keys`, dan paket-paket terenkripsi.

![](assets/13-wireshark-ssh.png)

Username, private key, dan isi sesi tidak terlihat karena SSH membuat session key melalui proses key exchange. Setelah paket `New Keys`, komunikasi dilindungi oleh enkripsi. Autentikasi public key menggunakan tanda tangan digital sehingga private key tidak pernah dikirim melalui jaringan. Hal tersebut berbeda dengan Telnet yang mengirimkan username, password, dan isi komunikasi dalam bentuk teks terbuka.

| Pertanyaan | Jawaban |
| ---------- | ------- |
| IP client Mika | `10.72.1.3` |
| IP server Knights | `10.72.3.2` |
| User SSH | `mika_admin` |
| Metode autentikasi | Public key ED25519 |
| Protocol Version Exchange | `SSH-2.0-OpenSSH_10.2` |
| Key Exchange | Client/Server Key Exchange Init dan PQ/T Hybrid Key Exchange |
| Alasan kredensial tidak terbaca | Sesi SSH dienkripsi dan autentikasi menggunakan tanda tangan digital |

14. Setelah gagal mengakses FTP, Eiri melancarkan serangan brute-force terhadap form login web Alice. Analisis file capture `wired_bruteforce.pcapng` untuk mengidentifikasi alamat IP penyerang, target IP beserta port yang diserang, password user `lain_admin` yang berhasil ditembus, serta web server software dan versi yang dilaporkan pada response header. Validasi temuan pada socket server menggunakan `nc [IP_Group] 3401`.

File capture dibuka melalui Wireshark. Percobaan login yang berhasil ditemukan pada koneksi dengan source port `49203`. Filter berikut digunakan agar request dan response HTTP pada koneksi tersebut terlihat:

```text
tcp.port == 49203 && http
```

![](assets/14-http-request-response.png)

Paket POST menuju `/login.php` berasal dari IP `172.26.7.50` menuju `172.26.7.100` pada port `8080`. Pada bagian **HTML Form URL Encoded** ditemukan username dan password berikut:

```text
username=lain_admin
password=wired_pr0tocol_7
```

![](assets/14-http-credentials.png)

Response server memberikan status `HTTP/1.1 200 OK`. Pada response header ditemukan informasi web server `Apache/2.4.62`.

![](assets/14-http-server.png)

Temuan kemudian divalidasi menggunakan perintah berikut:

```sh
nc 10.4.89.246 3401
```

![](assets/14-validation.png)

| Pertanyaan | Jawaban |
| ---------- | ------- |
| IP penyerang | `172.26.7.50` |
| IP dan port target | `172.26.7.100:8080` |
| Password user `lain_admin` | `wired_pr0tocol_7` |
| Web server dan versi | `Apache/2.4.62` |
| Validasi socket | Berhasil |

15. Eiri menyusup ke ruang server dan memasang perangkat keyboard USB berbahaya pada node Alice. Buka file capture `wired_usb_hid.pcap`, identifikasi Vendor ID dan Product ID perangkat USB dari deskriptor USB, alamat nomor device USB, serta pesan rahasia yang berhasil dicuri dari keystroke. Validasi temuan pada socket server menggunakan `nc [IP_Group] 3402`.

Untuk menemukan identitas perangkat, digunakan display filter berikut:

```text
usb.bDescriptorType == 1
```

Pada bagian **DEVICE DESCRIPTOR** ditemukan bahwa perangkat merupakan Logitech Keyboard K120 dengan Vendor ID `0x046d` dan Product ID `0xc31c`.

![](assets/15-usb-descriptor.png)

Selanjutnya paket dari perangkat keyboard difilter menggunakan:

```text
usb.device_address == 7
```

Detail paket menunjukkan USB bus ID `2`, device address `7`, endpoint `0x81`, dan transfer type `URB_INTERRUPT`. Salah satu data keystroke yang ditemukan adalah `02001a0000000000`. Byte `02` merupakan modifier Shift dan keycode `1a` merupakan tombol W sehingga menghasilkan huruf kapital `W`.

![](assets/15-usb-device-address.png)

Setelah seluruh keycode HID disusun, pesan yang diketikkan adalah:

```text
Wired_Protocol_7_is_alive_2026
```

Hasil tersebut divalidasi menggunakan perintah berikut:

```sh
nc 10.4.89.246 3402
```

![](assets/15-validation.png)

| Pertanyaan | Jawaban |
| ---------- | ------- |
| Vendor ID | `0x046d` |
| Product ID | `0xc31c` |
| Perangkat | Logitech Keyboard K120 |
| USB device address | `7` |
| Pesan rahasia | `Wired_Protocol_7_is_alive_2026` |
| Validasi socket | Berhasil |

19. Eiri meneror jaringan dengan mengirimkan email pemerasan melalui protokol SMTP tanpa enkripsi. Analisis file capture `wired_smtp_threat.pcap` pada stream TCP terkait, identifikasi alamat email korban yang ditargetkan, password korban yang diklaim bocor oleh penyerang, jenis malware yang diinfeksikan, batas waktu dalam hari yang diberikan, serta MailClientID yang tercantum pada pesan. Validasi temuan pada socket server menggunakan `nc [IP_Group] 3406`.

File capture dibuka melalui Wireshark. Trafik penyerang dapat dicari menggunakan filter berikut:

```text
ip.addr == 185.234.72.19 && tcp.port == 25
```

Paket email kemudian dibuka menggunakan **Follow → TCP Stream**. Pesan ancaman berada pada TCP stream 6. Bagian awal stream memperlihatkan pengirim `attacker@darkwired.net`, penerima `victim@protocol7.co.jp`, password `pr0tocol_7_user`, dan jenis malware `ransomware`.

![](assets/19-smtp-stream-email.png)

Pada bagian selanjutnya, penyerang memberikan waktu `72 hours (3 days)` untuk membayar. Pada bagian bawah email juga ditemukan `MailClientID: 7719980706`.

![](assets/19-smtp-stream-deadline.png)

Karena SMTP digunakan tanpa enkripsi, seluruh isi email dapat dibaca sebagai teks terbuka melalui Follow TCP Stream. Hal ini menunjukkan bahwa protokol tanpa enkripsi tidak mampu menjaga kerahasiaan pesan ketika trafik jaringan berhasil disadap.

Temuan kemudian divalidasi menggunakan perintah berikut:

```sh
nc 10.4.89.246 3406
```

![](assets/19-validation.png)

| Pertanyaan | Jawaban |
| ---------- | ------- |
| Email korban | `victim@protocol7.co.jp` |
| Password yang diklaim bocor | `pr0tocol_7_user` |
| Jenis malware | `ransomware` |
| Batas waktu | `3 hari` atau 72 jam |
| MailClientID | `7719980706` |
| TCP stream | `6` |
| Validasi socket | Berhasil |


## Kesimpulan

Topologi The Wired berhasil dibangun menggunakan tiga subnet yang dihubungkan oleh router Lain. Seluruh client dapat berkomunikasi dan mengakses layanan yang dikonfigurasi. FTP Server Chisa juga berhasil menerapkan hak akses berbeda untuk Alice, Mika, dan Eiri. Hasil capture Wireshark membuktikan proses transfer FTP dan penggunaan port data PASV.

