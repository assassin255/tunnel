#!/usr/bin/env bash
set -e
wget -O tunnel-obf.sh https://raw.githubusercontent.com/assassin255/tunnel/refs/heads/main/tunnel-obf.sh &&
# Nhập thông tin từ người dùng
read -rp "Nhập Tên Bạn Muốn Đặt Cho Tunnel: " a1b2
read -rp "Nhập Port: " c3d4

# Chạy tunnel
bash tunnel-obf.sh --ten="$a1b2" --port="$c3d4" --token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJybmQiOjI3NjIwMjgxNTEyODAwMjM4LCJob3N0IjoiaHR0cHM6Ly9hcHAuYnVkZHkud29ya3MiLCJ3c0lkIjoxNzM2MjQsInYiOjN9.jjxyuTf_tPcbKojHklYTNdPfOusO3gjSbM52nwySA-k
