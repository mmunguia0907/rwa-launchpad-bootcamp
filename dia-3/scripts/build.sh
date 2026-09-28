#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ -f .env.local ]]; then source .env.local; fi
if [[ -n "${RWA_TOOLS_DIR:-}" ]]; then
  export PATH="$RWA_TOOLS_DIR/bin:$RWA_TOOLS_DIR/cargo/bin:$PATH"
  export CARGO_HOME="$RWA_TOOLS_DIR/cargo"
  export RUSTUP_HOME="$RWA_TOOLS_DIR/rustup"
fi
mkdir -p evidence
cargo test --locked 2>&1 | tee evidence/tests.log
stellar contract build 2>&1 | tee evidence/build.log
