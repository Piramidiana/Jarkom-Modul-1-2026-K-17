#!/bin/sh
# Node: Lain
# Mendapatkan IP DHCP dari NAT dan melakukan verifikasi internet.

ip link set eth0 up
/gns3/bin/udhcpc -i eth0 -q -n
printf 'nameserver 1.1.1.1\nnameserver 8.8.8.8\n' > /etc/resolv.conf

ip -br addr show eth0
ip route
ping -c 2 8.8.8.8

