#!/usr/bin/env bash
set -Eeuo pipefail

MODEL_ID="__REQUIRED_MODEL_ID__"
MODEL_REVISION="__REQUIRED_REVISION__"
SERVED_MODEL_NAME="__REQUIRED_SERVED_NAME__"
VLLM_IMAGE="__REQUIRED_VLLM_IMAGE__"
CONTAINER_NAME="__REQUIRED_CONTAINER_NAME__"

MAX_MODEL_LEN="${MAX_MODEL_LEN:-65536}"
API_HOST="${API_HOST:-0.0.0.0}"
API_PORT="${API_PORT:-8000}"
ADVERTISE_IP="${ADVERTISE_IP:-}"
ADVERTISE_INTERFACE="${ADVERTISE_INTERFACE:-}"
ROUTE_PROBE_IP="${ROUTE_PROBE_IP:-1.1.1.1}"

GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:-0.85}"
HF_HOME="${HF_HOME:-${HOME}/.cache/huggingface}"

die() { echo "ERROR: $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null || die "Missing $1"; }

validate_port() {
  [[ "$API_PORT" =~ ^[0-9]+$ ]] &&
    (( API_PORT >= 1 && API_PORT <= 65535 )) ||
    die "Invalid API_PORT: $API_PORT"
}

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
  validate_port
  [[ "$MAX_MODEL_LEN" =~ ^[0-9]+$ ]] && (( MAX_MODEL_LEN > 0 )) ||
    die "Invalid context: $MAX_MODEL_LEN"
  export MAX_MODEL_LEN API_HOST API_PORT ADVERTISE_IP ADVERTISE_INTERFACE
}

network_info() {
  echo "Bind:     ${API_HOST}:${API_PORT}"
  echo "Endpoint: http://$(detect_advertise_ip):${API_PORT}/v1"
}

download() {
  need docker
  docker run --rm \
    --user "$(id -u):$(id -g)" \
    -e HOME=/tmp -e HF_HOME=/cache \
    -v "${HF_HOME}:/cache" \
    --entrypoint python3 "$VLLM_IMAGE" -c "
from huggingface_hub import snapshot_download
snapshot_download(repo_id='${MODEL_ID}', revision='${MODEL_REVISION}', cache_dir='/cache')
"
}

verify_files() {
  echo "Implement exact config/index/template verification before delivery."
  exit 2
}

start() {
  verify_files
  docker run -d --name "$CONTAINER_NAME" \
    --network host --ipc host --gpus all \
    -v "${HF_HOME}:/root/.cache/huggingface" \
    --entrypoint vllm "$VLLM_IMAGE" \
    serve "$MODEL_ID" \
    --revision "$MODEL_REVISION" \
    --served-model-name "$SERVED_MODEL_NAME" \
    --max-model-len "$MAX_MODEL_LEN" \
    --gpu-memory-utilization "$GPU_MEMORY_UTILIZATION" \
    --host "$API_HOST" \
    --port "$API_PORT"
}

stop() { docker rm -f "$CONTAINER_NAME" 2>/dev/null || true; }
status() { docker ps -a --filter "name=${CONTAINER_NAME}"; }
logs() { docker logs --tail "${1:-300}" "$CONTAINER_NAME"; }

parse_options "$@"
set -- "${REMAINING_ARGS[@]}"

case "${1:-help}" in
  download) download ;;
  verify-files) verify_files ;;
  start) start ;;
  stop) stop ;;
  restart) stop; start ;;
  status) status ;;
  logs) logs "${2:-300}" ;;
  network-info) network_info ;;
  *) echo "Customize and validate this evidence-backed scaffold before use." ;;
esac
