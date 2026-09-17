# JARKOM MODUL 1 2026 - K17

## Member

| Nama | NRP |
| ---------------------------- | ---------- |
| Dian Piramidiana Rachmatika | 5027251031 |
| [Nama Anggota Kelompok] | [NRP] |

## Laporan

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
