#!/bin/sh
# Node: Alice
# Verifikasi koneksi dari subnet 10.72.1.0/24 ke subnet lain.

ping -c 2 10.72.2.2
ping -c 2 10.72.3.2

