#!/usr/bin/env bash
set -e

# Parse arguments
TEN=""
PORT=""

for arg in "$@"; do
    case $arg in
        --ten=*)
        TEN="${arg#*=}"
        shift
        ;;
        --port=*)
        PORT="${arg#*=}"
        shift
        ;;
        *)
        ;;
    esac
done

if [[ -z "$TEN" ]] || [[ -z "$PORT" ]]; then
    echo "Usage: $0 --ten=<name> --port=<port>"
    exit 1
fi

# Cài dependencies
sudo apt-get update && sudo apt-get install -y software-properties-common gnupg curl

# Tạo keyring và import key
sudo mkdir -p /usr/share/keyrings
curl -fsSL https://es.buddy.works/bdy/apt-repo/public.key | sudo gpg --dearmor -o /usr/share/keyrings/buddy.gpg

# Add repo
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/buddy.gpg] https://es.buddy.works/bdy/apt-repo prod main" | sudo tee /etc/apt/sources.list.d/buddy.list > /dev/null

# Update và cài bdy
sudo apt-get update
sudo apt-get install -y bdy

# Chạy tunnel
bdy tunnel tcp "$PORT" --token eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJybmQiOjI3NjIwMjgxNTEyODAwMjM4LCJob3N0IjoiaHR0cHM6Ly9hcHAuYnVkZHkud29ya3MiLCJ3c0lkIjoxNzM2MjQsInYiOjN9.jjxyuTf_tPcbKojHklYTNdPfOusO3gjSbM52nwySA-k -n "$TEN"
