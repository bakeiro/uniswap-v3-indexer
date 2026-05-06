# Uniswap V3 Tick Indexer

Indexer minimalista para trackear el estado de los ticks de pools específicas de Uniswap V3, usando [Envio HyperIndex](https://docs.envio.dev).

Solo procesa eventos `Mint` y `Burn` — los únicos que modifican `liquidityGross` y `liquidityNet` de los ticks. Los eventos `Swap` no se indexan porque no alteran el estado de los ticks.

---

## Cómo funciona

Usa un patrón **snapshot + replay**:

1. Tu script RPC lee el estado actual de los ticks en un bloque concreto N y lo guarda en `snapshot.json`
2. Envio arranca desde el bloque N y carga ese snapshot como estado inicial
3. A partir de ahí, cada `Mint` y `Burn` actualiza los ticks incrementalmente

Esto evita indexar toda la historia desde el bloque 0, lo que para pools activas supera fácilmente el límite de eventos del plan gratuito de Envio.

---

## Pools trackeadas

Definidas en `config.yaml` bajo `networks > contracts > address`. Solo se indexan eventos de esas addresses — HyperSync filtra a nivel de red.

Para añadir o quitar pools, edita `config.yaml`. Puedes mezclar pools de distintas cadenas:

```yaml
networks:
  - id: 1 # Ethereum Mainnet
    start_block: 25029000
    contracts:
      - name: UniswapV3Pool
        address:
          - 0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8
          - 0xe6ff8b9a37b0fab776134636d9981aa778c4e718

  - id: 10 # Optimism
    start_block: 130000000
    contracts:
      - name: UniswapV3Pool
        address:
          - 0xabc1234567890000000000000000000000000001
```

Cada red puede tener su propio `start_block` — toma el snapshot de cada cadena en el bloque correspondiente.

---

## Snapshot

### Dónde va

El archivo `snapshot.json` va en la **raíz del proyecto** (al mismo nivel que `package.json`).

### Cómo generarlo

Usa tu script RPC existente apuntando a un bloque concreto N (por ejemplo usando un fork de Alchemy). El script debe leer los ticks inicializados de cada pool via `TickBitmap` + `pool.ticks(tickIndex)`.

### Formato

```json
[
  {
    "chainId": 1,
    "address": "0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8",
    "ticks": [
      {
        "tickIdx": "-887272",
        "liquidityGross": "1000000000000000000",
        "liquidityNet": "500000000000000000",
        "price0": "0.000000000000000001",
        "price1": "1000000000000000000"
      },
      {
        "tickIdx": "0",
        "liquidityGross": "2000000000000000000",
        "liquidityNet": "-500000000000000000",
        "price0": "1.0",
        "price1": "1.0"
      }
    ]
  },
  {
    "chainId": 10,
    "address": "0xabc1234567890000000000000000000000000001",
    "ticks": []
  }
]
```

Notas del formato:
- `chainId` es el ID numérico de la red (1 = Mainnet, 10 = Optimism, 42161 = Arbitrum...)
- `address` en minúsculas
- `tickIdx`, `liquidityGross`, `liquidityNet` como strings (son bigints)
- `price0`, `price1` como strings decimales (`1.0001^tickIdx` y su inverso)
- El array incluye **todos** los ticks inicializados de la pool en el bloque N
- Cada entrada del array es una pool de una cadena concreta — puedes mezclar cadenas en el mismo archivo

### Qué pasa si no hay snapshot

Si `snapshot.json` no existe o una pool no aparece en él, el indexer arranca con ticks vacíos y los va construyendo desde `start_block`. Los datos serán correctos solo para el periodo indexado, no para el histórico anterior.

---

## Configurar el bloque de inicio

En `config.yaml`, `start_block` debe ser el **mismo bloque N** donde tomaste el snapshot:

```yaml
networks:
  - id: 1
    start_block: 21500000  # mismo bloque que el snapshot
```

Si `start_block` es posterior al snapshot → ticks incorrectos (pierdes eventos entre snapshot y start_block).
Si `start_block` es anterior al snapshot → ticks incorrectos (aplicas eventos ya reflejados en el snapshot).

---

## Entidades

### `Pool`
Solo contiene el `id` (`{chainId}-{poolAddress}`). Es un contenedor para agrupar ticks.

### `Tick`
```graphql
type Tick {
  id: ID!                        # {chainId}-{poolAddress}#{tickIdx}
  pool: Pool! @index
  poolAddress: String @index     # igual que pool.id
  tickIdx: BigInt! @index
  liquidityGross: BigInt!        # liquidez total que referencia este tick
  liquidityNet: BigInt!          # cambio de liquidez al cruzar el tick
  price0: BigDecimal!            # precio de token0 en este tick (1.0001^tickIdx)
  price1: BigDecimal!            # precio de token1 en este tick (inverso de price0)
  createdAtTimestamp: BigInt!
  createdAtBlockNumber: BigInt!
}
```

---

## Arrancar

### Requisitos
- Node.js v22+
- pnpm v8+
- Docker Desktop

### Primera vez (o tras cambiar schema/config)

```bash
pnpm install
pnpm codegen
docker compose -f generated/docker-compose.yaml down -v   # limpia DB anterior
pnpm dev
```

### Arranques normales (sin cambios de schema)

```bash
pnpm dev
```

### Subir a Envio Cloud

```bash
pnpm start
```

---

## Consultar los ticks

El playground GraphQL está en `http://localhost:8080` (local, contraseña: `testing`).

```graphql
# Todos los ticks de una pool ordenados por tick
{
  Tick(
    where: { poolAddress: { _eq: "1-0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8" } }
    order_by: { tickIdx: asc }
  ) {
    tickIdx
    liquidityGross
    liquidityNet
    price0
    price1
  }
}
```

```graphql
# Un tick específico
{
  Tick(
    where: {
      poolAddress: { _eq: "1-0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8" }
      tickIdx: { _eq: "0" }
    }
  ) {
    tickIdx
    liquidityGross
    liquidityNet
  }
}
```

El prefijo `1-` en el `poolAddress` es el `chainId` (1 = Ethereum Mainnet).

---

## Estructura del proyecto

```
├── config.yaml                  # pools, red, start_block
├── schema.graphql               # entidades Pool y Tick
├── snapshot.json                # snapshot de ticks (generado externamente)
├── src/
│   ├── EventHandlers.ts         # entry point, registra handlers
│   └── handlers/
│       ├── mint.ts              # crea/actualiza ticks en Mint
│       ├── burn.ts              # actualiza ticks en Burn
│       └── utils/
│           ├── constants.ts     # ZERO_BI, ZERO_BD, etc.
│           ├── index.ts         # fastExponentiation, safeDiv
│           └── snapshot.ts      # carga snapshot.json e inicializa pools
```
