#!/usr/bin/env bash
source "$(dirname "$0")/common.sh"
cd "$DAY_DIR"
if [[ -f deployment.env ]]; then
  echo "Ya existe un despliegue: $CONTRACT_ID"; exit 0
fi
: "${NETWORK:=testnet}"
if [[ "$NETWORK" != testnet ]]; then echo 'Este script es solo para Testnet.' >&2; exit 1; fi
umask 077
mkdir -p "$STELLAR_CONFIG_DIR" evidence
for identity in "$ADMIN_KEY" "$USER_KEY"; do
  if ! stellar keys address "$identity" >/dev/null 2>&1; then
    stellar keys generate "$identity" --network testnet --fund
  fi
done
WASM=target/wasm32v1-none/release/rwa_launchpad_dia_3.wasm
if [[ ! -f "$WASM" ]]; then echo 'Ejecuta primero bash scripts/build.sh' >&2; exit 1; fi
stellar contract deploy --wasm "$WASM" --source "$ADMIN_KEY" --network testnet \
  > evidence/contract-id.txt.tmp 2> >(tee evidence/deploy.log >&2)
CONTRACT_ID="$(cat evidence/contract-id.txt.tmp)"
if [[ ! "$CONTRACT_ID" =~ ^C[A-Z2-7]{55}$ ]]; then echo 'ID inesperado; revisa deploy.log' >&2; exit 1; fi
mv evidence/contract-id.txt.tmp evidence/contract-id.txt
PAYMENT_TOKEN="$(stellar contract id asset --asset native --network testnet)"
printf 'export NETWORK=testnet\nexport CONTRACT_ID=%s\nexport PAYMENT_TOKEN=%s\nexport ADMIN_KEY=%s\nexport USER_KEY=%s\n' \
  "$CONTRACT_ID" "$PAYMENT_TOKEN" "$ADMIN_KEY" "$USER_KEY" > deployment.env
printf 'Contrato desplegado: %s\n' "$CONTRACT_ID"
