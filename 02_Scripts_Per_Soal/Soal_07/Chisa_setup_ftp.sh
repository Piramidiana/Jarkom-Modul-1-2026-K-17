#!/bin/sh
# Node: Chisa
# Instalasi dan konfigurasi FTP Server.

apk update
apk add vsftpd

addgroup -S wiredftp 2>/dev/null || true
mkdir -p /var/wired/data /etc/vsftpd/user_conf
chown root:wiredftp /var/wired/data
chmod 2775 /var/wired/data

adduser -D -H -h /var/wired/data -s /bin/ash -G wiredftp alice 2>/dev/null || true
adduser -D -H -h /var/wired/data -s /bin/ash -G wiredftp mika 2>/dev/null || true
adduser -D -H -h /var/wired/data -s /bin/ash -G wiredftp eiri 2>/dev/null || true

echo 'alice:alice' | chpasswd
echo 'mika:mika' | chpasswd
echo 'eiri:eiri' | chpasswd

cp ./vsftpd.conf /etc/vsftpd/vsftpd.conf
cp ./mika_ftp.conf /etc/vsftpd/user_conf/mika
cp ./vsftpd_user_list /etc/vsftpd/user_list

pkill vsftpd 2>/dev/null || true
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
ss -lntp | grep ':21'

