#!/usr/bin/env bash
# Script del bootcamp adaptado a comandos independientes para la semana 4.
source "$(dirname "$0")/common.sh"
: "${CONTRACT_ID:?Falta CONTRACT_ID; configura deployment.env o exporta la variable}"
ADMIN="$(stellar keys address "$ADMIN_KEY")"
INVESTOR="${INVESTOR:-$(stellar keys address "$USER_KEY")}"
invoke_admin() {
  stellar contract invoke --id "$CONTRACT_ID" --source "$ADMIN_KEY" --network "$NETWORK" -- "$@"
}
initialize() {
  : "${PAYMENT_TOKEN:?Falta PAYMENT_TOKEN}"
  echo '=== ADMIN: initialize ==='
  invoke_admin initialize --admin "$ADMIN" \
    --asset '{"name":"BoliviaRWA","total_supply":"1000000","price_per_unit":"100","payment_token":"'"$PAYMENT_TOKEN"'","paused":false}'
}
whitelist() {
  echo '=== ADMIN: set_whitelist ==='
  invoke_admin set_whitelist --admin "$ADMIN" --investor "$INVESTOR" --approved true
}
case "${1:-setup}" in
  setup) initialize; whitelist ;;
  initialize) initialize ;;
  whitelist) whitelist ;;
  mint) invoke_admin mint --admin "$ADMIN" --to "$INVESTOR" --amount "${2:?Indica cantidad}" ;;
  withdraw) invoke_admin withdraw --admin "$ADMIN" --to "${TREASURY:-$ADMIN}" --amount "${2:?Indica cantidad}" ;;
  pause|unpause) invoke_admin "$1" --admin "$ADMIN" ;;
  *) echo 'Uso: admin-tool.sh {setup|initialize|whitelist|mint N|withdraw N|pause|unpause}' >&2; exit 2 ;;
esac
