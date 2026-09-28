#!/usr/bin/env bash
# Script del bootcamp: firma con el inversionista, nunca con el admin.
source "$(dirname "$0")/common.sh"
: "${CONTRACT_ID:?Falta CONTRACT_ID; configura deployment.env o exporta la variable}"
INVESTOR="$(stellar keys address "$USER_KEY")"
invoke_user() {
  stellar contract invoke --id "$CONTRACT_ID" --source "$USER_KEY" --network "$NETWORK" -- "$@"
}
invest() {
  local amount="$1"
  printf '\n=== INVERSIONISTA: invest %s ===\nContrato: %s\nInversionista: %s\n' "$amount" "$CONTRACT_ID" "$INVESTOR"
  printf '$ stellar contract invoke --id %s --source %s --network %s -- invest --investor %s --payment_amount %s\n' "$CONTRACT_ID" "$USER_KEY" "$NETWORK" "$INVESTOR" "$amount"
  invoke_user invest --investor "$INVESTOR" --payment_amount "$amount"
}
balance() {
  echo '=== INVERSIONISTA: balance RWA ==='
  invoke_user balance --id "$INVESTOR"
}
case "${1:-demo}" in
  invest) invest "${2:?Indica 100 o 500}" ;;
  balance) balance ;;
  transfer) invoke_user transfer --from "$INVESTOR" --to "${RECIPIENT:?Falta RECIPIENT}" --amount "${2:?Indica cantidad}" ;;
  demo)
    mkdir -p "$DAY_DIR/evidence"
    set +e
    invest 100 > "$DAY_DIR/evidence/invest-100.log" 2>&1
    attempt_exit=$?
    set -e
    if [[ "$attempt_exit" -eq 0 ]]; then
      cat "$DAY_DIR/evidence/invest-100.log"
      echo 'ERROR: 100 no debía aceptarse.' >&2; exit 1
    fi
    cat "$DAY_DIR/evidence/invest-100.log"
    if ! grep -Fq 'Error(Contract, #7)' "$DAY_DIR/evidence/invest-100.log"; then
      echo 'El fallo no es AmountTooLow; revisar antes de continuar.' >&2; exit 1
    fi
    echo 'VERIFICADO: 100 falla con AmountTooLow (#7); no se envía transacción.'
    invest 500 2>&1 | tee "$DAY_DIR/evidence/invest-500.log"
    balance 2>&1 | tee "$DAY_DIR/evidence/balance.log"
    ;;
  *) echo 'Uso: user-tool.sh {demo|invest N|balance|transfer N}' >&2; exit 2 ;;
esac
