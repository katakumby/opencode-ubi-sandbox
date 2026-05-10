#!/usr/bin/env bash
set -euo pipefail

OPENCODE_RUN_USER="${OPENCODE_RUN_USER:-opencode}"
WORKSPACE_DIR="${WORKSPACE_DIR:-/workspace}"
OPENCODE_CONFIG="${OPENCODE_CONFIG:-${WORKSPACE_DIR%/}/config.json}"

export WORKSPACE_DIR
export OPENCODE_CONFIG
export OPENCODE_DISABLE_AUTOUPDATE="${OPENCODE_DISABLE_AUTOUPDATE:-true}"
export OPENCODE_HEADER_USER="${OPENCODE_HEADER_USER:-${USERNAME:-${USER:-developer}}}"
export OPENCODE_HEADER_DOMAIN="${OPENCODE_HEADER_DOMAIN:-${USER_DOMAIN:-${DOMAIN:-local}}}"

COMMAND=()

warn() {
  printf 'opencode-entrypoint: %s\n' "$*" >&2
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
ensure_runtime_dirs

if [ "$(id -u)" = "0" ]; then
  set_local_identity
  chown -R "$OPENCODE_RUN_USER:$(id -gn "$OPENCODE_RUN_USER")" "$HOME"

  cd "$WORKSPACE_DIR"
  exec setpriv \
    --reuid="$(id -u "$OPENCODE_RUN_USER")" \
    --regid="$(id -g "$OPENCODE_RUN_USER")" \
    --init-groups \
    "${COMMAND[@]}"
fi

run_command
