# Stellar Elite Bolivia · Semana 4

RWA Launchpad basado en `dia-3` de Oppia Software Labs. La variación exige **al menos 500 unidades mínimas del token de pago en cada inversión**.

## Regla y prueba

En `src/lib.rs`, `invest` pasa `payment_amount` a `check_variation_gate`. Si es menor a `MIN_INVESTMENT = 500`, devuelve `AmountTooLow` (error de contrato **#7**) antes de transferir el pago o emitir RWA.

`test_minimum_investment_100_fails_500_succeeds` comprueba:

- 100 falla específicamente con `AmountTooLow` y no modifica los saldos.
- 500 funciona, transfiere el pago y genera 5 RWA (`price_per_unit = 100`).
- Una inversión posterior de 100 sigue fallando: el mínimo se aplica por operación.

Hay pruebas adicionales para 499, whitelist, retiro y permisos del administrador. Se corrigió la comprobación del admin: además de firmar, debe coincidir con la dirección guardada en `initialize`.

## Token de pago y unidades

Para esta entrega se autorizó usar **XLM de Testnet** en lugar del token del instructor. Se mantuvo la escala entera del repo y de sus tests: `payment_amount=100` y `payment_amount=500`.

Con XLM, una unidad mínima es un stroop. Por tanto, **500 = 0.00005 XLM de prueba** y el precio por RWA es 100 stroops. No se afirma que la inversión sea de 500 XLM completos. La firma y las comisiones también usan XLM de Testnet obtenidos gratuitamente de Friendbot.

Este es un ejercicio educativo. `BoliviaRWA` es un activo de demostración; no representa un derecho sobre un activo real.

## Ejecutar las pruebas y compilar

Con Rust, el target `wasm32v1-none` y Stellar CLI instalados:

```bash
cd dia-3
bash scripts/build.sh
```

Opcionalmente, `.env.local` (ignorado por Git) puede contener `export RWA_TOOLS_DIR=/ruta/a/herramientas` con subdirectorios `bin`, `cargo` y `rustup`. Si no existe, los scripts usan las herramientas de `PATH`.

## Reproducir desde un despliegue propio

`deployment.env` contiene únicamente datos públicos del despliegue de esta entrega. Para crear otro, renómbralo primero y luego ejecuta:

```bash
mv deployment.env deployment-anterior.env
bash scripts/build.sh
bash scripts/deploy.sh
bash scripts/admin-tool.sh setup
bash scripts/user-tool.sh demo
```

`deploy.sh` crea dos identidades locales, solicita saldo de Friendbot y despliega en Testnet. Guarda el nuevo ID y el SAC nativo en `deployment.env`. Las claves quedan en `.testnet/`, fuera de Git. Las identidades de esta entrega NO están en el repo: clonar el código no da acceso a las cuentas originales.

## Scripts originales adaptados

Se conservaron `admin-tool.sh` y `user-tool.sh`, agregando subcomandos para ejecutar solo las operaciones necesarias:

```bash
# Admin: ejecutar una sola vez en un contrato nuevo
bash scripts/admin-tool.sh setup

# Inversionista: 100 falla, 500 funciona y consulta balance
bash scripts/user-tool.sh demo

# También se pueden ejecutar por separado
bash scripts/user-tool.sh invest 100
bash scripts/user-tool.sh invest 500
bash scripts/user-tool.sh balance
```

El comando individual de 100 sale con error; es lo esperado. `demo` comprueba que sea exactamente el error #7 antes de continuar. El rechazo sucede durante la simulación del CLI: **no existe una transacción fallida enviada** para ese intento. La inversión de 500 sí se firma, se envía y queda confirmada en el explorer.

Las operaciones opcionales `mint`, `withdraw`, `pause`, `unpause` y `transfer` siguen disponibles como subcomandos. No se ejecutan en la demostración, para que el balance final de 5 provenga exclusivamente de la inversión de 500.

Repetir `demo` hace otra inversión exitosa de 500 y suma 5 al saldo; no reinicia el estado. Repetir `initialize` falla con `AlreadyInitialized`.

## Entrega

Consulta [ENTREGA.md](ENTREGA.md) para el Contract ID, la transacción y las capturas. Los archivos `.log` de `evidence/` contienen las salidas reales del CLI. Las capturas de esos registros están identificadas como tales; la captura del explorer muestra la confirmación independiente en Testnet.
