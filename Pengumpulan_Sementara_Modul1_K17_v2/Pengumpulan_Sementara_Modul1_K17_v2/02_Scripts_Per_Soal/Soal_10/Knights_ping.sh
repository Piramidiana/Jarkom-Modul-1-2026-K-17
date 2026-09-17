#!/bin/sh
# Node: Knights
# Mengirim 77 ICMP Echo Request dengan payload 128 byte.

ping -c 77 -s 128 -i 0.3 10.72.2.2

