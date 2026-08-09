#!/usr/bin/env bash
set -Eeuo pipefail

MODEL_URL="__REQUIRED_MODEL_URL__"
MODEL_FILE="__REQUIRED_MODEL_FILE__"
MODEL_SIZE_BYTES="__REQUIRED_SIZE_BYTES__"
MODEL_SHA256="__REQUIRED_SHA256__"
LLAMA_CPP_REF="__REQUIRED_COMMIT_OR_TAG__"
CUDA_ARCHITECTURES="121a-real"

CTX_SIZE="${CTX_SIZE:-65536}"
API_HOST="${API_HOST:-0.0.0.0}"
API_PORT="${API_PORT:-8000}"
ADVERTISE_IP="${ADVERTISE_IP:-}"
ADVERTISE_INTERFACE="${ADVERTISE_INTERFACE:-}"
ROUTE_PROBE_IP="${ROUTE_PROBE_IP:-1.1.1.1}"

BASE_DIR="${HOME}/dgx-model"
MODEL_DIR="${HOME}/models/dgx-model"
LLAMA_CPP_DIR="${HOME}/src/llama.cpp"
MODEL_PATH="${MODEL_DIR}/${MODEL_FILE}"
SERVER="${LLAMA_CPP_DIR}/build/bin/llama-server"

die() { echo "ERROR: $*" >&2; exit 1; }

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
      --context) CTX_SIZE="$2"; shift 2 ;;
      --context=*) CTX_SIZE="${1#*=}"; shift ;;
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
  [[ "$API_PORT" =~ ^[0-9]+$ ]] &&
    (( API_PORT >= 1 && API_PORT <= 65535 )) ||
    die "Invalid API_PORT: $API_PORT"
  [[ "$CTX_SIZE" =~ ^[0-9]+$ ]] && (( CTX_SIZE > 0 )) ||
    die "Invalid context: $CTX_SIZE"
  export CTX_SIZE API_HOST API_PORT ADVERTISE_IP ADVERTISE_INTERFACE
}

build_runtime() {
  git clone https://github.com/ggml-org/llama.cpp.git "$LLAMA_CPP_DIR" 2>/dev/null || true
  git -C "$LLAMA_CPP_DIR" fetch --all --tags
  git -C "$LLAMA_CPP_DIR" checkout --detach "$LLAMA_CPP_REF"
  cmake -S "$LLAMA_CPP_DIR" -B "$LLAMA_CPP_DIR/build" -G Ninja \
    -DGGML_CUDA=ON -DGGML_CURL=ON -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_CUDA_ARCHITECTURES="$CUDA_ARCHITECTURES"
  cmake --build "$LLAMA_CPP_DIR/build" --target llama-server -j "$(nproc)"
}

download() {
  mkdir -p "$MODEL_DIR"
  curl -fL --retry 10 -C - -o "$MODEL_PATH" "$MODEL_URL"
  [[ "$(stat -c '%s' "$MODEL_PATH")" == "$MODEL_SIZE_BYTES" ]] ||
    die "Exact file-size check failed"
  [[ "$(LC_ALL=C head -c 4 "$MODEL_PATH")" == "GGUF" ]] ||
    die "GGUF magic-header check failed"
  printf '%s  %s\n' "$MODEL_SHA256" "$MODEL_PATH" | sha256sum -c -
}

start() {
  [[ -x "$SERVER" ]] || die "Build runtime first"
  "$SERVER" \
    --model "$MODEL_PATH" \
    --n-gpu-layers all \
    --ctx-size "$CTX_SIZE" \
    --host "$API_HOST" \
    --port "$API_PORT"
}

network_info() {
  echo "Bind:     ${API_HOST}:${API_PORT}"
  echo "Endpoint: http://$(detect_advertise_ip):${API_PORT}/v1"
}

parse_options "$@"
set -- "${REMAINING_ARGS[@]}"

case "${1:-help}" in
  build-runtime) build_runtime ;;
  download) download ;;
  start) start ;;
  network-info) network_info ;;
  *) echo "Add lifecycle, logs, tests, and exact model flags before delivery." ;;
esac
