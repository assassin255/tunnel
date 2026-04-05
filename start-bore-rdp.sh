#!/usr/bin/env bash
set -euo pipefail

RELAY="${BORE_RELAY:-bore.pub}"
LOCAL_HOST="${BORE_LOCAL_HOST:-127.0.0.1}"
LOCAL_PORT="${BORE_LOCAL_PORT:-3389}"
REMOTE_PORT="${BORE_REMOTE_PORT:-0}"
WAIT_SECS="${BORE_WAIT_SECS:-180}"
LOG_FILE="${BORE_LOG_FILE:-/dev/shm/bore-rdp.log}"
PID_FILE="${BORE_PID_FILE:-/dev/shm/bore-rdp.pid}"
URL_FILE="${BORE_URL_FILE:-/dev/shm/bore-rdp.url}"

usage() {
  cat <<EOF
Usage: $(basename "$0") [start|status|stop] [local-port]

Environment:
  BORE_RELAY       default: bore.pub
  BORE_LOCAL_HOST  default: 127.0.0.1
  BORE_LOCAL_PORT  default: 3389
  BORE_REMOTE_PORT default: 0 (random)
  BORE_WAIT_SECS   default: 180
EOF
}

port_open() {
  timeout 1 bash -lc "</dev/tcp/${LOCAL_HOST}/${LOCAL_PORT}" >/dev/null 2>&1
}

is_running() {
  [[ -f "$PID_FILE" ]] || return 1
  local pid
  pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  [[ "$pid" =~ ^[0-9]+$ ]] || return 1
  kill -0 "$pid" 2>/dev/null
}

current_url() {
  [[ -f "$URL_FILE" ]] && cat "$URL_FILE" || true
}

stop_tunnel() {
  if [[ -f "$PID_FILE" ]]; then
    local pid
    pid="$(cat "$PID_FILE" 2>/dev/null || true)"
    if [[ "$pid" =~ ^[0-9]+$ ]]; then
      kill "$pid" 2>/dev/null || true
    fi
  fi
  pkill -f "bore local ${LOCAL_PORT} --to ${RELAY}" 2>/dev/null || true
  rm -f "$PID_FILE" "$URL_FILE"
}

start_tunnel() {
  command -v bore >/dev/null 2>&1 || { echo "bore not found" >&2; exit 1; }

  if is_running; then
    current_url
    exit 0
  fi

  local waited=0
  until port_open; do
    sleep 1
    waited=$((waited + 1))
    if (( waited >= WAIT_SECS )); then
      echo "local port ${LOCAL_HOST}:${LOCAL_PORT} not ready after ${WAIT_SECS}s" >&2
      exit 1
    fi
  done

  : > "$LOG_FILE"
  nohup bore local "$LOCAL_PORT" --local-host "$LOCAL_HOST" --to "$RELAY" ${REMOTE_PORT:+--port "$REMOTE_PORT"} > "$LOG_FILE" 2>&1 &
  echo $! > "$PID_FILE"

  local url=""
  for _ in $(seq 1 30); do
    url="$(grep -oE 'bore\.pub:[0-9]+' "$LOG_FILE" | tail -n1 || true)"
    if [[ -n "$url" ]]; then
      printf '%s\n' "$url" | tee "$URL_FILE"
      return 0
    fi
    if ! is_running; then
      echo "bore exited early" >&2
      tail -n 40 "$LOG_FILE" >&2 || true
      exit 1
    fi
    sleep 1
  done

  echo "bore started, waiting for URL..." >&2
  tail -n 20 "$LOG_FILE" >&2 || true
  exit 1
}

cmd="${1:-start}"
case "$cmd" in
  start)
    if [[ $# -ge 2 ]]; then
      LOCAL_PORT="$2"
    fi
    start_tunnel
    ;;
  status)
    if is_running; then
      echo "running"
      current_url
    else
      echo "stopped"
      exit 1
    fi
    ;;
  stop)
    stop_tunnel
    ;;
  -h|--help|help)
    usage
    ;;
  *)
    echo "unknown command: $cmd" >&2
    usage >&2
    exit 1
    ;;
esac
