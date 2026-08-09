#!/usr/bin/env bash
set -Eeuo pipefail

MASTER_IP="${MASTER_IP:-__REQUIRED_MASTER_IP__}"
WORKER_IP="${WORKER_IP:-__REQUIRED_WORKER_IP__}"
SSH_USER="${SSH_USER:-__REQUIRED_SSH_USER__}"

MODEL_ID="__REQUIRED_MODEL_ID__"
MODEL_REVISION="__REQUIRED_REVISION__"
RUNTIME_IMAGE="__REQUIRED_RUNTIME_IMAGE__"
DISTRIBUTED_BACKEND="__REQUIRED_BACKEND__"

MAX_MODEL_LEN="${MAX_MODEL_LEN:-65536}"
API_HOST="${API_HOST:-0.0.0.0}"
API_PORT="${API_PORT:-8000}"
ADVERTISE_IP="${ADVERTISE_IP:-}"
ADVERTISE_INTERFACE="${ADVERTISE_INTERFACE:-}"
ROUTE_PROBE_IP="${ROUTE_PROBE_IP:-1.1.1.1}"

die() { echo "ERROR: $*" >&2; exit 1; }
ssh_worker() { ssh -o BatchMode=yes "${SSH_USER}@${WORKER_IP}" "$@"; }

detect_advertise_ip() {
  [[ -z "$ADVERTISE_IP" ]] || { printf '%s' "$ADVERTISE_IP"; return; }
  if [[ -n "$ADVERTISE_INTERFACE" ]]; then
    ip -4 -o addr show dev "$ADVERTISE_INTERFACE" scope global |
      awk 'NR == 1 { split($4, a, "/"); print a[1] }'
    return
  fi
  ip -4 route get "$ROUTE_PROBE_IP" 2>/dev/null |
    awk '{ for (i=1; i<=NF; i++) if ($i=="src") { print $(i+1); exit } }'
}

parse_options() {
  REMAINING_ARGS=()
  while (( $# )); do
    case "$1" in
      --context) MAX_MODEL_LEN="$2"; shift 2 ;;
      --context=*) MAX_MODEL_LEN="${1#*=}"; shift ;;
      --port) API_PORT="$2"; shift 2 ;;
      --port=*) API_PORT="${1#*=}"; shift ;;
      --bind) API_HOST="$2"; shift 2 ;;
      --bind=*) API_HOST="${1#*=}"; shift ;;
      --advertise-ip) ADVERTISE_IP="$2"; shift 2 ;;
      --advertise-ip=*) ADVERTISE_IP="${1#*=}"; shift ;;
      --interface) ADVERTISE_INTERFACE="$2"; shift 2 ;;
      --interface=*) ADVERTISE_INTERFACE="${1#*=}"; shift ;;
      *) REMAINING_ARGS+=("$1"); shift ;;
    esac
  done
  export MAX_MODEL_LEN API_HOST API_PORT ADVERTISE_IP ADVERTISE_INTERFACE
}

sync_worker() {
  echo "Implement model-specific cache path and full rsync."
  exit 2
}

verify_worker() {
  echo "Implement path, symlink, size, and SHA-256 manifest comparison."
  exit 2
}

start() {
  verify_worker
  echo "Implement the exact tested ${DISTRIBUTED_BACKEND} recipe."
  exit 2
}

network_info() {
  echo "Cluster Master: ${MASTER_IP}"
  echo "Cluster Worker: ${WORKER_IP}"
  echo "Public API:     http://$(detect_advertise_ip):${API_PORT}/v1"
}

stop() { echo "Implement clean shutdown on every node."; }
status() { echo "Show node count, GPU count, processes, logs, and API health."; }

parse_options "$@"
set -- "${REMAINING_ARGS[@]}"

case "${1:-help}" in
  sync-worker) sync_worker ;;
  verify-worker) verify_worker ;;
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  network-info) network_info ;;
  *) echo "Customize this evidence-backed scaffold before use." ;;
esac
