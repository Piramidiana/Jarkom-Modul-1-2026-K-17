#!/bin/sh
# Node: Lain
# Mengaktifkan routing dan NAT untuk seluruh subnet 10.72.0.0/16.

sysctl -w net.ipv4.ip_forward=1
iptables -t nat -C POSTROUTING -s 10.72.0.0/16 -o eth0 -j MASQUERADE 2>/dev/null || \
iptables -t nat -A POSTROUTING -s 10.72.0.0/16 -o eth0 -j MASQUERADE

cat /proc/sys/net/ipv4/ip_forward
iptables -t nat -L POSTROUTING -n -v

