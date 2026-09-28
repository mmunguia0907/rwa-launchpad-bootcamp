# Guion opcional · máximo 2 minutos

La entrega incluye capturas; no hace falta video adicional si el profesor acepta cualquiera de los dos formatos.

- **0:00–0:20:** «Mi RWA Launchpad usa la base de día 3. Agregué una regla en check_variation_gate: cada inversión debe ser al menos de 500 unidades mínimas del token. Si no, devuelve AmountTooLow.» Muestra el código.
- **0:20–0:40:** Muestra el resultado de los tests y el registro del admin: initialize y set_whitelist. «El admin configura el activo y autoriza al inversionista.»
- **0:40–1:10:** Muestra el intento de 100. «Es rechazado con el error #7 antes de mover fondos.» Muestra 500 y el balance. «La inversión funciona y genera 5 RWA al precio de 100.»
- **1:10–1:40:** Abre el enlace de la inversión exitosa en Stellar Expert. Expande la operación y muestra el evento invest y el estado.
- **1:40–1:55:** «Usé XLM de Testnet. Los montos son unidades mínimas: 500 stroops, no 500 XLM completos. El mínimo se valida en cada inversión, independientemente del saldo acumulado.»

No muestres `.testnet/` ni frases secretas. Si vas a ejecutar nuevamente, el saldo aumentará otros 5; el balance de la primera demostración fue 5.
