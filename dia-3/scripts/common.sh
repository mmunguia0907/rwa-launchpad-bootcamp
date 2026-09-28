#!/usr/bin/env bash
set -euo pipefail
DAY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [[ -f "$DAY_DIR/.env.local" ]]; then source "$DAY_DIR/.env.local"; fi
TOOLS_DIR="${RWA_TOOLS_DIR:-}"
if [[ -n "$TOOLS_DIR" && -x "$TOOLS_DIR/bin/stellar" ]]; then
  export PATH="$TOOLS_DIR/bin:$TOOLS_DIR/cargo/bin:$PATH"
  export CARGO_HOME="$TOOLS_DIR/cargo"
  export RUSTUP_HOME="$TOOLS_DIR/rustup"
fi
export STELLAR_CONFIG_DIR="${STELLAR_CONFIG_DIR:-$DAY_DIR/.testnet}"
export STELLAR_NO_CACHE=true
stellar() { command stellar --config-dir "$STELLAR_CONFIG_DIR" --no-cache "$@"; }
if [[ -f "$DAY_DIR/deployment.env" ]]; then source "$DAY_DIR/deployment.env"; fi
NETWORK="${NETWORK:-testnet}"
ADMIN_KEY="${ADMIN_KEY:-rwa-admin}"
USER_KEY="${USER_KEY:-rwa-investor}"
