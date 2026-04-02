#!/usr/bin/env bash
set -e
wget -O tunnel-obf.sh https://raw.githubusercontent.com/assassin255/tunnel/refs/heads/main/tunnel-obf.sh &&
# Nhập thông tin từ người dùng
read -rp "Nhập Tên Bạn Muốn Đặt Cho Tunnel: " a1b2
read -rp "Nhập Port: " c3d4
read -rp "Nhập Token: " TOKEN

# Chạy tunnel
bash tunnel-obf.sh --ten="$a1b2" --port="$c3d4" --token="$TOKEN"
