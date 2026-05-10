#!/usr/bin/env bash
set -euo pipefail

OPENCODE_RUN_USER="${OPENCODE_RUN_USER:-opencode}"
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"
OPENCODE_CONFIG="${OPENCODE_CONFIG:-${WORKSPACE_DIR%/}/config.json}"
SYSTEM_CA_BUNDLE="${SYSTEM_CA_BUNDLE:-/etc/pki/tls/certs/ca-bundle.crt}"
OPENCODE_VLLM_PROXY_ADDR="${OPENCODE_VLLM_PROXY_ADDR:-127.0.0.1:11434}"

export WORKSPACE_DIR
export OPENCODE_CONFIG
export OPENCODE_VLLM_PROXY_ADDR
export SSL_CERT_FILE="${SSL_CERT_FILE:-$SYSTEM_CA_BUNDLE}"
export CURL_CA_BUNDLE="${CURL_CA_BUNDLE:-$SYSTEM_CA_BUNDLE}"
export NODE_EXTRA_CA_CERTS="${NODE_EXTRA_CA_CERTS:-$SYSTEM_CA_BUNDLE}"
export OPENCODE_DISABLE_AUTOUPDATE="${OPENCODE_DISABLE_AUTOUPDATE:-true}"
export OPENCODE_HEADER_USER="${OPENCODE_HEADER_USER:-${USERNAME:-${USER:-developer}}}"
export OPENCODE_HEADER_DOMAIN="${OPENCODE_HEADER_DOMAIN:-${USER_DOMAIN:-${DOMAIN:-local}}}"

COMMAND=()

warn() {
  printf 'opencode-entrypoint: %s\n' "$*" >&2
}

append_no_proxy() {
  local value="$1"

  case ",${NO_PROXY:-}," in
    *,"$value",*) ;;
    *) export NO_PROXY="${NO_PROXY:+$NO_PROXY,}$value" ;;
  esac

  case ",${no_proxy:-}," in
    *,"$value",*) ;;
    *) export no_proxy="${no_proxy:+$no_proxy,}$value" ;;
  esac
}

rewrite_loopback_proxy_url() {
  local value="$1"
  local host="${HOST_PROXY_HOST:-host.docker.internal}"

  if [ "${REWRITE_LOOPBACK_PROXY:-true}" != "true" ]; then
    printf '%s' "$value"
    return
  fi

  value="${value//:\/\/127.0.0.1:/:\/\/$host:}"
  value="${value//:\/\/localhost:/:\/\/$host:}"
  value="${value//:\/\/[::1]:/:\/\/$host:}"
  printf '%s' "$value"
}

normalize_proxy_env() {
  if [ -n "${HTTPS_PROXY:-${https_proxy:-}}" ]; then
    export HTTPS_PROXY
    HTTPS_PROXY="$(rewrite_loopback_proxy_url "${HTTPS_PROXY:-$https_proxy}")"
    export https_proxy="${https_proxy:-$HTTPS_PROXY}"
    https_proxy="$(rewrite_loopback_proxy_url "$https_proxy")"
  fi

  if [ -n "${HTTP_PROXY:-${http_proxy:-}}" ]; then
    export HTTP_PROXY
    HTTP_PROXY="$(rewrite_loopback_proxy_url "${HTTP_PROXY:-$http_proxy}")"
    export http_proxy="${http_proxy:-$HTTP_PROXY}"
    http_proxy="$(rewrite_loopback_proxy_url "$http_proxy")"
  fi

  if [ -n "${NO_PROXY:-${no_proxy:-}}" ]; then
    export NO_PROXY="${NO_PROXY:-$no_proxy}"
    export no_proxy="${no_proxy:-$NO_PROXY}"
  fi

  if [ -n "${ALL_PROXY:-${all_proxy:-}}" ]; then
    export ALL_PROXY
    ALL_PROXY="$(rewrite_loopback_proxy_url "${ALL_PROXY:-$all_proxy}")"
    export all_proxy="${all_proxy:-$ALL_PROXY}"
    all_proxy="$(rewrite_loopback_proxy_url "$all_proxy")"
  fi
}

configure_vllm_proxy() {
  export OPENCODE_VLLM_CODE_BASE_URL="${OPENCODE_VLLM_CODE_BASE_URL:-${VLLM_CODE_BASE_URL:-}}"

  if [ "${OPENCODE_VLLM_PROXY_ENABLED:-false}" != "true" ]; then
    return
  fi

  if [ -z "${VLLM_CODE_BASE_URL:-}" ]; then
    warn "OPENCODE_VLLM_PROXY_ENABLED=true requires VLLM_CODE_BASE_URL"
    return
  fi

  export VLLM_PROXY_UPSTREAM_BASE_URL="${VLLM_PROXY_UPSTREAM_BASE_URL:-$VLLM_CODE_BASE_URL}"
  export OPENCODE_VLLM_CODE_BASE_URL="http://${OPENCODE_VLLM_PROXY_ADDR%/}/v1"
  append_no_proxy "127.0.0.1"
  append_no_proxy "localhost"
}

ensure_runtime_dirs() {
  mkdir -p "$WORKSPACE_DIR" "$(dirname "$OPENCODE_CONFIG")" "$HOME/.config/opencode" "$HOME/.local/share/opencode"

  if should_warn_missing_config && [ ! -f "$OPENCODE_CONFIG" ]; then
    warn "config file not found at $OPENCODE_CONFIG"
    warn "place config.json in the mounted workspace root or set OPENCODE_CONFIG to another mounted path"
  fi
}

should_warn_missing_config() {
  [ "${COMMAND[0]:-}" = "opencode" ] || return 1

  case "${COMMAND[1]:-}" in
    --help|-h|--version|-v|help)
      return 1
      ;;
    *)
      return 0
      ;;
  esac
}

start_vllm_proxy() {
  if [ "${OPENCODE_VLLM_PROXY_ENABLED:-false}" != "true" ]; then
    return
  fi

  if [ "$(id -u)" = "0" ]; then
    setpriv \
      --reuid="$(id -u "$OPENCODE_RUN_USER")" \
      --regid="$(id -g "$OPENCODE_RUN_USER")" \
      --init-groups \
      /usr/local/bin/vllm-h2-proxy &
  else
    /usr/local/bin/vllm-h2-proxy &
  fi

  local attempt
  for attempt in $(seq 1 50); do
    if curl -fsS --noproxy '*' "http://${OPENCODE_VLLM_PROXY_ADDR}/healthz" >/dev/null 2>&1; then
      return
    fi
    sleep 0.1
  done

  warn "vLLM HTTP/2 proxy did not become ready on ${OPENCODE_VLLM_PROXY_ADDR}"
  return 1
}

set_local_identity() {
  if [ -n "${LOCAL_GID:-}" ] && [ "$LOCAL_GID" != "$(id -g "$OPENCODE_RUN_USER")" ]; then
    if getent group "$LOCAL_GID" >/dev/null 2>&1; then
      local existing_group
      existing_group="$(getent group "$LOCAL_GID" | cut -d: -f1)"
      usermod -g "$existing_group" "$OPENCODE_RUN_USER"
    else
      groupmod -g "$LOCAL_GID" "$OPENCODE_RUN_USER"
    fi
  fi

  if [ -n "${LOCAL_UID:-}" ] && [ "$LOCAL_UID" != "$(id -u "$OPENCODE_RUN_USER")" ]; then
    usermod -u "$LOCAL_UID" "$OPENCODE_RUN_USER"
  fi
}

resolve_command() {
  if [ "$#" -eq 0 ]; then
    COMMAND=(opencode)
  elif [ "$1" = "opencode" ]; then
    COMMAND=("$@")
  elif command -v "$1" >/dev/null 2>&1; then
    COMMAND=("$@")
  else
    COMMAND=(opencode "$@")
  fi
}

run_command() {
  cd "$WORKSPACE_DIR"
  exec "${COMMAND[@]}"
}

resolve_command "$@"
normalize_proxy_env
configure_vllm_proxy
ensure_runtime_dirs

if [ "$(id -u)" = "0" ]; then
  set_local_identity
  chown -R "$OPENCODE_RUN_USER:$(id -gn "$OPENCODE_RUN_USER")" "$HOME"
  start_vllm_proxy

  cd "$WORKSPACE_DIR"
  exec setpriv \
    --reuid="$(id -u "$OPENCODE_RUN_USER")" \
    --regid="$(id -g "$OPENCODE_RUN_USER")" \
    --init-groups \
    "${COMMAND[@]}"
fi

start_vllm_proxy
run_command
