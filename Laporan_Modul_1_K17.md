# LAPORAN PRAKTIKUM MODUL 1

## Identitas Kelompok

| Keterangan | Isi |
|---|---|
| Kelompok | K-17 |
| Project GNS3 | K-17-MODUL-1 |
| Anggota 1 | Dian Piramidiana Rachmatika - 5027251031 |
| Anggota 2 | Jude Athala Yazid Sari - 5027251098 |

## 1. Topologi dan Pembagian Alamat IP
Untuk mempersiapkan pembangunan The Wired, Lain yang berperan sebagai Router membuat tiga Switch/Gateway: Switch 1 menuju dua Entitas yaitu Alice dan Mika, Switch 2 menuju Chisa, sedangkan Switch 3 menuju Knights dan Eiri. Kelima Entitas tersebut dikonfigurasi sebagai Client di GNS3. [GUNAKAN PREFIX IP MASING-MASING KELOMPOK]


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

<img width="959" height="405" alt="Screenshot 2026-09-17 163157" src="https://github.com/user-attachments/assets/0cbbe79c-84a1-4abe-9f5b-89b0745c62d8" />

## 2. Koneksi Router Lain ke Internet
Karena menurut Lain pada saat itu The Wired masih terisolasi dari dunia luar, konfigurasikan router Lain agar dapat tersambung langsung ke jaringan internet publik melalui NAT/DHCP pada interface eth0.

Interface `eth0` pada router Lain memperoleh alamat IP melalui DHCP dari NAT1. Hasil pengujian menunjukkan bahwa router dapat menjangkau gateway NAT dan internet publik.

Perintah pengujian:

```bash
ip -br addr show eth0
ip route
ping -c 2 8.8.8.8
```

Hasil ping ke `8.8.8.8` berhasil tanpa packet loss. Dengan demikian, router Lain sudah terhubung ke internet.

<img width="495" height="288" alt="image" src="https://github.com/user-attachments/assets/61d17e05-c988-4d27-b495-991aff1cc3ba" />

## 3. Routing Antar-Subnet
Setelah router Lain terhubung ke internet, pastikan seluruh Entitas (Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling terhubung dan berkomunikasi satu sama lain melalui konfigurasi routing.

IP forwarding diaktifkan pada router Lain agar seluruh client pada Switch1, Switch2, dan Switch3 dapat saling berkomunikasi.

```bash
sysctl -w net.ipv4.ip_forward=1
```

Pengujian dilakukan dengan mengirim ping antarclient yang berada pada subnet berbeda. Semua pengujian berhasil dengan packet loss 0%.

<img width="493" height="287" alt="image" src="https://github.com/user-attachments/assets/1b95fd46-31af-47e8-96c4-55e33750d373" />

<img width="413" height="231" alt="Screenshot 2026-09-17 180643" src="https://github.com/user-attachments/assets/25cc94dd-9627-4400-ba78-791c237b63c0" />

## 4. Konfigurasi NAT dan DNS Clien

Pada percobaan ini, semua client yaitu Alice, Mika, Chisa, Knights, dan Eiri dikonfigurasi agar dapat mengakses internet melalui NAT yang terdapat pada Router Lain.

### Konfigurasi pada Router Lain

Konfigurasi IP dilakukan pada masing-masing interface yang terhubung ke client. Setelah itu, IP forwarding diaktifkan agar Router Lain dapat meneruskan paket dari jaringan client ke internet.

```bash
ip addr add 10.4.89.1/29 dev eth1
ip addr add 10.4.89.9/29 dev eth2
ip addr add 10.4.89.17/29 dev eth3

sysctl -w net.ipv4.ip_forward=1

iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth2 -j ACCEPT
iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth3 -j ACCEPT
```
### Verifikasi

Setelah konfigurasi selesai, dilakukan pengecekan untuk memastikan interface, aturan NAT, aturan forwarding, dan IP forwarding sudah aktif.

```bash
ip -br a
iptables -t nat -L -v -n
iptables -L FORWARD -v -n
sysctl net.ipv4.ip_forward
```
### Konfigurasi pada Client

Setiap client diberikan IP sesuai dengan subnet masing-masing dan menggunakan IP Router Lain sebagai gateway.
```bash
ip addr add <IP_CLIENT>/29 dev eth0
ip route add default via <IP_GATEWAY_LAIN>
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```
### Verifikasi pada Client

Untuk memastikan koneksi berhasil, dilakukan pengujian menggunakan ping ke alamat IP publik dan domain.

```bash
ping -c 4 8.8.8.8
ping -c 4 google.com
```
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
Chisa memutuskan mendirikan FTP Server pada node miliknya dengan shared folder di /var/wired/data. Terapkan kebijakan akses: user alice (hak akses read & write), user mika (dibatasi read-only), dan user eiri (dibatasi tanpa izin akses / blacklist). Buktikan konfigurasi dengan membuat file signal_alice.txt dari user alice, dan buktikan penolakan akses saat user eiri mencoba login.


FTP Server dipasang pada node Chisa menggunakan vsFTPd. Folder yang dibagikan adalah `/var/wired/data`. Kebijakan akses yang diterapkan adalah:

- `alice`: dapat membaca dan menulis file.
- `mika`: hanya dapat membaca dan mengunduh file.
- `eiri`: masuk blacklist dan tidak dapat login.

Alice berhasil mengunggah `signal_alice.txt`. File tersebut tersimpan di server dengan pemilik `alice:wiredftp`. Percobaan login Eiri ditolak dengan respons `530 Permission denied`.

<img width="507" height="72" alt="image" src="https://github.com/user-attachments/assets/cc424c23-ee3e-4ffd-aff5-b9cb2c868439" />

<img width="383" height="77" alt="image" src="https://github.com/user-attachments/assets/3a793b5d-a05b-42e2-b215-b990af954bc1" />


<img width="514" height="139" alt="image" src="https://github.com/user-attachments/assets/e8e90158-f3fc-4016-9aac-ced8bdf48071" />


## 8. Upload Laporan Knights dan Analisis FTP
Kelompok rahasia Knights perlu mengirimkan dokumen laporan intelijen ke FTP Server Chisa. Lakukan koneksi FTP client dari node Knights ke FTP Server Chisa menggunakan akun alice. Upload file berikut (link file). Analisis sesi Wireshark dan sebutkan: perintah FTP untuk upload (STOR), kode status sukses server (226), dan port data TCP yang dinegosiasikan pada mode PASV.

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

<img width="509" height="201" alt="image" src="https://github.com/user-attachments/assets/22eb8631-4b1d-419e-8ba0-95730bf43d1a" />


<img width="795" height="565" alt="Screenshot 2026-09-16 232956" src="https://github.com/user-attachments/assets/b5fdb1ba-cb60-4b73-b7eb-b5f8f59e0c01" />


## 9. Akses Read-Only Mika
Mika mengakses dokumen Protokol Tujuh di (link file) dari FTP Server Chisa. Dari node Mika, unduh file tersebut menggunakan akun mika. Setelah itu, buktikan pembatasan read-only dengan mencoba mengunggah file baru dari akun mika, dan tunjukkan pesan error respon server (error 550 Permission denied) saat mika mencoba melakukan upload

Mika login ke FTP Server Chisa menggunakan akun `mika`. File `protocol7_manifesto.txt` berhasil diunduh sebesar 1738 bytes dan isinya dapat dibaca.

Setelah itu, Mika mencoba mengunggah `mika_upload_test.txt`. Server menolak upload dengan respons:

```text
550 Permission denied
```

Hasil tersebut membuktikan bahwa akun Mika hanya mempunyai akses baca dan download.

<img width="494" height="285" alt="Screenshot 2026-09-16 233704" src="https://github.com/user-attachments/assets/2c39a5ec-0c32-431b-bbc6-23456d4e705b" />


## 10. Uji Latensi Knights ke Chisa
Soal 10 — Uji Latensi Ping (Knights → Chisa)
Tujuan

Ping 77 paket, payload 128 byte, interval 0.3 detik, dari Knights ke Chisa. Analisis ICMP Type/Code, packet loss, RTT.

Langkah & Syntax

IP Chisa (dicek dari node): 10.4.89.10

Capture dulu, baru jalankan dari Knights:

bash
ping -c 77 -s 128 -i 0.3 10.4.89.10
Hasil
Length paket 170 bytes (konsisten payload 128 byte + header)
Interval antar paket konsisten ±0.3 detik
Filter Wireshark: icmp
Echo Request → Type 8, Code 0
Echo Reply → Type 0, Code 0
Statistik ping: packet loss & RTT (min/avg/max) dari output terminal

Soal 11 — Kelemahan Telnet
Tujuan

Buktikan Telnet mengirim kredensial plaintext. Akun phantom_user/wired_ghost di Chisa, login dari Eiri, capture Wireshark.

Langkah & Syntax

Di Chisa (Alpine):

bash
apk add busybox-extras
telnetd -l /bin/login
netstat -tulnp | grep 23
adduser phantom_user
# password: wired_ghost

Dari Eiri (capture dulu di Wireshark, baru login):

bash
telnet 10.4.89.10

Login phantom_user / wired_ghost, jalankan whoami, ls, lalu exit.

Filter Wireshark:

telnet

Klik kanan paket → Follow → TCP Stream.

Hasil

Kredensial plaintext kelihatan jelas (phantom_user, wired_ghost), termasuk pola karakter dobel (local echo + remote echo dari server).

Soal 12 — Port Scanning dengan Netcat
Tujuan

Dari Alice, scan port 22 & 80 (harus terbuka) dan 7777 (harus tertutup) di Knights. Bandingkan TCP flag di Wireshark.

Langkah & Syntax

Di Knights (Alpine, fix DNS dulu):

bash
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apk update
apk add openssh
ssh-keygen -A
/usr/sbin/sshd

apk add busybox-extras
mkdir -p /var/www
echo "Knights Node" > /var/www/index.html
httpd -h /var/www -p 80

netstat -tulnp

Dari Alice (capture dulu di Wireshark, baru scan):

bash
nc -zv 10.4.89.18 22
nc -zv 10.4.89.18 80
nc -zv 10.4.89.18 7777
Hasil
Connection to 10.4.89.18 22 port [tcp/ssh] succeeded!
Connection to 10.4.89.18 80 port [tcp/http] succeeded!
nc: connect to 10.4.89.18 port 7777 (tcp) failed: Connection refused

Filter Wireshark:

tcp.flags.syn==1
Port 22 & 80 → balasan Knights: Flags: SYN, ACK
Port 7777 → balasan Knights: Flags: RST, ACK

13. Lain memerintahkan agar administrasi jarak jauh menggunakan SSH secara aman tanpa password. Install OpenSSH server pada node Knights, buat pasangan kunci SSH (`ssh-keygen`) pada node Mika untuk user `mika_admin`, dan konfigurasikan public key authentication (`PasswordAuthentication no`). Lakukan koneksi SSH dari node Mika ke node Knights, tangkap sesi menggunakan Wireshark, identifikasi paket Protocol Version Exchange dan Key Exchange, serta jelaskan mengapa kredensial tidak terlihat dalam bentuk teks terbuka seperti pada Telnet.

Pertama, dibuat pasangan public key dan private key ED25519 pada node Mika menggunakan perintah berikut:

```sh
mkdir -p /root/.ssh
chmod 700 /root/.ssh
ssh-keygen -t ed25519 -f /root/.ssh/mika_admin_ed25519 -N '' -C 'mika_admin@Mika'
```

Hasil pembuatan pasangan kunci dapat dilihat pada screenshot berikut.

<img width="500" height="116" alt="image" src="https://github.com/user-attachments/assets/af749c44-7d24-4b30-8910-8cd68220f718" />


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

<img width="496" height="443" alt="image" src="https://github.com/user-attachments/assets/bd14aed7-4007-44a2-930b-12721be97398" />


Pada saat koneksi berlangsung dilakukan capture menggunakan Wireshark. Filter yang digunakan adalah:

```text
ssh
```

Capture memperlihatkan Protocol Version Exchange `SSH-2.0-OpenSSH_10.2`, paket Client dan Server `Key Exchange Init`, proses `PQ/T Hybrid Key Exchange`, `New Keys`, dan paket-paket terenkripsi.

<img width="959" height="599" alt="image" src="https://github.com/user-attachments/assets/297483af-b5e2-4232-bdb6-634f785f3910" />


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

<img width="797" height="568" alt="Screenshot 2026-09-17 134718" src="https://github.com/user-attachments/assets/37d619cd-7d18-48bd-9a32-88e42ed3123f" />


Paket POST menuju `/login.php` berasal dari IP `172.26.7.50` menuju `172.26.7.100` pada port `8080`. Pada bagian **HTML Form URL Encoded** ditemukan username dan password berikut:

```text
username=lain_admin
password=wired_pr0tocol_7
```

<img width="536" height="310" alt="Screenshot 2026-09-17 134939" src="https://github.com/user-attachments/assets/11b873c6-a9bf-40ea-b082-d334828765d2" />


Response server memberikan status `HTTP/1.1 200 OK`. Pada response header ditemukan informasi web server `Apache/2.4.62`.

<img width="379" height="372" alt="Screenshot 2026-09-17 135100" src="https://github.com/user-attachments/assets/a7a847bb-2a79-4704-9894-9caec06ce5fb" />


Temuan kemudian divalidasi menggunakan perintah berikut:

```sh
nc 10.4.89.246 3401
```

<img width="623" height="560" alt="Screenshot 2026-09-17 140744" src="https://github.com/user-attachments/assets/de17de65-5f3f-44cf-9b38-09ef6d24bb8b" />


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

<img width="794" height="568" alt="Screenshot 2026-09-17 140848" src="https://github.com/user-attachments/assets/8770541e-d477-4b6b-8baf-1d36d87ab498" />


Selanjutnya paket dari perangkat keyboard difilter menggunakan:

```text
usb.device_address == 7
```

Detail paket menunjukkan USB bus ID `2`, device address `7`, endpoint `0x81`, dan transfer type `URB_INTERRUPT`. Salah satu data keystroke yang ditemukan adalah `02001a0000000000`. Byte `02` merupakan modifier Shift dan keycode `1a` merupakan tombol W sehingga menghasilkan huruf kapital `W`.

<img width="959" height="599" alt="Screenshot 2026-09-17 141234" src="https://github.com/user-attachments/assets/45be7002-c817-4c39-9ff2-9ec29c69f65a" />

Setelah seluruh keycode HID disusun, pesan yang diketikkan adalah:

```text
Wired_Protocol_7_is_alive_2026
```

Hasil tersebut divalidasi menggunakan perintah berikut:

```sh
nc 10.4.89.246 3402
```

<img width="544" height="254" alt="15_validasi_socket" src="https://github.com/user-attachments/assets/0e635c74-7b35-4d08-961b-26a1df019b0f" />


| Pertanyaan | Jawaban |
| ---------- | ------- |
| Vendor ID | `0x046d` |
| Product ID | `0xc31c` |
| Perangkat | Logitech Keyboard K120 |
| USB device address | `7` |
| Pesan rahasia | `Wired_Protocol_7_is_alive_2026` |
| Validasi socket | Berhasil |

Soal 16 — Analisis FTP Theft (wired_ftp_theft.pcap)
Tujuan

Dari file capture, temukan IP server FTP penyerang, banner, kredensial, dan ukuran file malware.

Langkah
Buka file di Wireshark (File → Open)
Filter tcp.flags.syn==1 untuk cari koneksi ke port 21
Filter ftp untuk baca banner, USER/PASS, dan perintah RETR
File → Export Objects → FTP-DATA untuk verifikasi ukuran file
Temuan
Yang dicari	Jawaban
IP Server FTP	198.51.100.7
Banner	Welcome to Wired FTP Server (vsftpd 3.0.5)
Username	knights_agent
Password	N4v1_s3cur3_2026
Ukuran file knights_payload.exe	524288 bytes

Verifikasi silang: ukuran file disebut 2x di capture — respons SIZE (213 524288) dan respons RETR (150 ... (524288 bytes)) — konsisten.

Catatan: ada percobaan login lain yang gagal (USER guest → 530 Login incorrect), tidak dipakai sebagai jawaban.

Validasi
bash
nc 10.4.89.250 3403

Soal 17 — Analisis HTTP C2 (wired_http_c2.pcap)
Tujuan

Temukan domain (Host), IP server penyerang, nama file malware, kode status HTTP.

Langkah
Buka file di Wireshark
Filter:
   http.request || http.response
Cari paket GET /namafile HTTP/1.1 → expand Hypertext Transfer Protocol → cari Host: (domain)
Lihat kolom Destination paket itu → IP server penyerang
Nama file = bagian setelah slash terakhir pada path GET
Cari paket response → baris pertama (HTTP/1.1 200 OK dsb) → kode status
Verifikasi: File → Export Objects → HTTP
Temuan

Validasi
bash
nc 10.4.89.250 3404

Soal 18 — Analisis SMB Transfer (wired_smb_transfer.pcapng)
Tujuan

Temukan protokol yang dieksploitasi, IP pengirim & penerima, folder tujuan, nama file malware.

Langkah
Buka file di Wireshark
Filter:
   smb2

(kalau kosong, coba smb) 3. Cari paket "Create Request" → lihat Source (pengirim) & Destination (penerima) 4. Expand detail, cari field Filename → berisi path folder + nama file 5. Verifikasi: File → Export Objects → SMB

Temuan

[isi setelah dianalisis: protokol, IP pengirim, IP penerima, folder tujuan, nama file]

Validasi
bash
nc 10.4.89.250 3405

19. Eiri meneror jaringan dengan mengirimkan email pemerasan melalui protokol SMTP tanpa enkripsi. Analisis file capture `wired_smtp_threat.pcap` pada stream TCP terkait, identifikasi alamat email korban yang ditargetkan, password korban yang diklaim bocor oleh penyerang, jenis malware yang diinfeksikan, batas waktu dalam hari yang diberikan, serta MailClientID yang tercantum pada pesan. Validasi temuan pada socket server menggunakan `nc [IP_Group] 3406`.

File capture dibuka melalui Wireshark. Trafik penyerang dapat dicari menggunakan filter berikut:

```text
ip.addr == 185.234.72.19 && tcp.port == 25
```

Paket email kemudian dibuka menggunakan **Follow → TCP Stream**. Pesan ancaman berada pada TCP stream 6. Bagian awal stream memperlihatkan pengirim `attacker@darkwired.net`, penerima `victim@protocol7.co.jp`, password `pr0tocol_7_user`, dan jenis malware `ransomware`.

<img width="666" height="575" alt="19_smtp_stream_email" src="https://github.com/user-attachments/assets/61e25738-2aa4-4f05-8264-52949249800e" />


Pada bagian selanjutnya, penyerang memberikan waktu `72 hours (3 days)` untuk membayar. Pada bagian bawah email juga ditemukan `MailClientID: 7719980706`.

<img width="668" height="596" alt="19_smtp_stream_threat" src="https://github.com/user-attachments/assets/4884e34e-a153-4b50-a4db-5d1816a9288a" />

Karena SMTP digunakan tanpa enkripsi, seluruh isi email dapat dibaca sebagai teks terbuka melalui Follow TCP Stream. Hal ini menunjukkan bahwa protokol tanpa enkripsi tidak mampu menjaga kerahasiaan pesan ketika trafik jaringan berhasil disadap.

Temuan kemudian divalidasi menggunakan perintah berikut:

```sh
nc 10.4.89.246 3406
```

<img width="668" height="292" alt="19_validasi_socket" src="https://github.com/user-attachments/assets/69412f4e-6b16-43f8-b84d-5802f89834fe" />


| Pertanyaan | Jawaban |
| ---------- | ------- |
| Email korban | `victim@protocol7.co.jp` |
| Password yang diklaim bocor | `pr0tocol_7_user` |
| Jenis malware | `ransomware` |
| Batas waktu | `3 hari` atau 72 jam |
| MailClientID | `7719980706` |
| TCP stream | `6` |
| Validasi socket | Berhasil |

Soal 20 — Analisis & Dekripsi TLS (wired_tls_decrypt.pcapng)
Tujuan

Dekripsi trafik TLS pakai keylog file. Temukan versi TLS, SNI, IP server, User-Agent, HTTP method+path tersembunyi.

Langkah
Buka wired_tls_decrypt.pcapng di Wireshark
Setup keylog: Edit → Preferences → Protocols → TLS → (Pre)-Master-Secret log filename → browse ke keyslogfile.txt → OK
Cek dekripsi berhasil: filter http — kalau muncul paket, dekripsi sukses
Versi TLS: filter tls.handshake.type == 1 (Client Hello) → expand → field Version
SNI: masih di Client Hello yang sama → expand Extension: server_name → Server Name
IP server: kolom Destination pada paket Client Hello yang sama
User-Agent, method, path: filter http.request → expand Hypertext Transfer Protocol → baris GET /path HTTP/1.1 (method+path) dan User-Agent:

## Kesimpulan

Topologi The Wired berhasil dibangun menggunakan tiga subnet yang dihubungkan oleh router Lain. Seluruh client dapat berkomunikasi dan mengakses layanan yang dikonfigurasi. FTP Server Chisa juga berhasil menerapkan hak akses berbeda untuk Alice, Mika, dan Eiri. Hasil capture Wireshark membuktikan proses transfer FTP dan penggunaan port data PASV.

