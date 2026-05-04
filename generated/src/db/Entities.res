open Table
open Enums.EntityType
type id = string

type internalEntity = Internal.entity
module type Entity = {
  type t
  let index: int
  let name: string
  let schema: S.t<t>
  let rowsSchema: S.t<array<t>>
  let table: Table.table
  let entityHistory: EntityHistory.t<t>
}
external entityModToInternal: module(Entity with type t = 'a) => Internal.entityConfig = "%identity"
external entityModsToInternal: array<module(Entity)> => array<Internal.entityConfig> = "%identity"
external entitiesToInternal: array<'a> => array<Internal.entity> = "%identity"

@get
external getEntityId: internalEntity => string = "id"

exception UnexpectedIdNotDefinedOnEntity
let getEntityIdUnsafe = (entity: 'entity): id =>
  switch Utils.magic(entity)["id"] {
  | Some(id) => id
  | None =>
    UnexpectedIdNotDefinedOnEntity->ErrorHandling.mkLogAndRaise(
      ~msg="Property 'id' does not exist on expected entity object",
    )
  }

//shorthand for punning
let isPrimaryKey = true
let isNullable = true
let isArray = true
let isIndex = true

@genType
type whereOperations<'entity, 'fieldType> = {
  eq: 'fieldType => promise<array<'entity>>,
  gt: 'fieldType => promise<array<'entity>>
}

module Bundle = {
  let name = (Bundle :> string)
  let index = 0
  @genType
  type t = {
    ethPriceUSD: BigDecimal.t,
    id: id,
  }

  let schema = S.object((s): t => {
    ethPriceUSD: s.field("ethPriceUSD", BigDecimal.schema),
    id: s.field("id", S.string),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "ethPriceUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Burn = {
  let name = (Burn :> string)
  let index = 1
  @genType
  type t = {
    amount: bigint,
    amount0: BigDecimal.t,
    amount1: BigDecimal.t,
    amountUSD: option<BigDecimal.t>,
    id: id,
    logIndex: option<bigint>,
    origin: string,
    owner: option<string>,
    pool_id: id,
    tickLower: bigint,
    tickUpper: bigint,
    timestamp: bigint,
    token0_id: id,
    token1_id: id,
    transaction_id: id,
  }

  let schema = S.object((s): t => {
    amount: s.field("amount", BigInt.schema),
    amount0: s.field("amount0", BigDecimal.schema),
    amount1: s.field("amount1", BigDecimal.schema),
    amountUSD: s.field("amountUSD", S.null(BigDecimal.schema)),
    id: s.field("id", S.string),
    logIndex: s.field("logIndex", S.null(BigInt.schema)),
    origin: s.field("origin", S.string),
    owner: s.field("owner", S.null(S.string)),
    pool_id: s.field("pool_id", S.string),
    tickLower: s.field("tickLower", BigInt.schema),
    tickUpper: s.field("tickUpper", BigInt.schema),
    timestamp: s.field("timestamp", BigInt.schema),
    token0_id: s.field("token0_id", S.string),
    token1_id: s.field("token1_id", S.string),
    transaction_id: s.field("transaction_id", S.string),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("origin") origin: whereOperations<t, string>,
    
      @as("owner") owner: whereOperations<t, option<string>>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
      @as("tickLower") tickLower: whereOperations<t, bigint>,
    
      @as("tickUpper") tickUpper: whereOperations<t, bigint>,
    
      @as("timestamp") timestamp: whereOperations<t, bigint>,
    
      @as("token0_id") token0_id: whereOperations<t, id>,
    
      @as("token1_id") token1_id: whereOperations<t, id>,
    
      @as("transaction_id") transaction_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "amount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "amount0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amount1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amountUSD", 
      Numeric,
      ~fieldSchema=S.null(BigDecimal.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "logIndex", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "origin", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "owner", 
      Text,
      ~fieldSchema=S.null(S.string),
      
      ~isNullable,
      
      ~isIndex,
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "tickLower", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "tickUpper", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "timestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "token0", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "token1", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "transaction", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      ~linkedEntity="Transaction",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Collect = {
  let name = (Collect :> string)
  let index = 2
  @genType
  type t = {
    amount0: BigDecimal.t,
    amount1: BigDecimal.t,
    amountUSD: option<BigDecimal.t>,
    id: id,
    logIndex: option<bigint>,
    owner: option<string>,
    pool_id: id,
    tickLower: bigint,
    tickUpper: bigint,
    timestamp: bigint,
    transaction_id: id,
  }

  let schema = S.object((s): t => {
    amount0: s.field("amount0", BigDecimal.schema),
    amount1: s.field("amount1", BigDecimal.schema),
    amountUSD: s.field("amountUSD", S.null(BigDecimal.schema)),
    id: s.field("id", S.string),
    logIndex: s.field("logIndex", S.null(BigInt.schema)),
    owner: s.field("owner", S.null(S.string)),
    pool_id: s.field("pool_id", S.string),
    tickLower: s.field("tickLower", BigInt.schema),
    tickUpper: s.field("tickUpper", BigInt.schema),
    timestamp: s.field("timestamp", BigInt.schema),
    transaction_id: s.field("transaction_id", S.string),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("owner") owner: whereOperations<t, option<string>>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
      @as("tickLower") tickLower: whereOperations<t, bigint>,
    
      @as("tickUpper") tickUpper: whereOperations<t, bigint>,
    
      @as("timestamp") timestamp: whereOperations<t, bigint>,
    
      @as("transaction_id") transaction_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "amount0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amount1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amountUSD", 
      Numeric,
      ~fieldSchema=S.null(BigDecimal.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "logIndex", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "owner", 
      Text,
      ~fieldSchema=S.null(S.string),
      
      ~isNullable,
      
      ~isIndex,
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "tickLower", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "tickUpper", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "timestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "transaction", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      ~linkedEntity="Transaction",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Factory = {
  let name = (Factory :> string)
  let index = 3
  @genType
  type t = {
    id: id,
    numberOfSwaps: bigint,
    owner: id,
    poolCount: bigint,
    totalFeesETH: BigDecimal.t,
    totalFeesUSD: BigDecimal.t,
    totalValueLockedETH: BigDecimal.t,
    totalValueLockedETHUntracked: BigDecimal.t,
    totalValueLockedUSD: BigDecimal.t,
    totalValueLockedUSDUntracked: BigDecimal.t,
    totalVolumeETH: BigDecimal.t,
    totalVolumeUSD: BigDecimal.t,
    txCount: bigint,
    untrackedVolumeUSD: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    id: s.field("id", S.string),
    numberOfSwaps: s.field("numberOfSwaps", BigInt.schema),
    owner: s.field("owner", S.string),
    poolCount: s.field("poolCount", BigInt.schema),
    totalFeesETH: s.field("totalFeesETH", BigDecimal.schema),
    totalFeesUSD: s.field("totalFeesUSD", BigDecimal.schema),
    totalValueLockedETH: s.field("totalValueLockedETH", BigDecimal.schema),
    totalValueLockedETHUntracked: s.field("totalValueLockedETHUntracked", BigDecimal.schema),
    totalValueLockedUSD: s.field("totalValueLockedUSD", BigDecimal.schema),
    totalValueLockedUSDUntracked: s.field("totalValueLockedUSDUntracked", BigDecimal.schema),
    totalVolumeETH: s.field("totalVolumeETH", BigDecimal.schema),
    totalVolumeUSD: s.field("totalVolumeUSD", BigDecimal.schema),
    txCount: s.field("txCount", BigInt.schema),
    untrackedVolumeUSD: s.field("untrackedVolumeUSD", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "numberOfSwaps", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "owner", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "poolCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "totalFeesETH", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalFeesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedETH", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedETHUntracked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSDUntracked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalVolumeETH", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalVolumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "txCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "untrackedVolumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Mint = {
  let name = (Mint :> string)
  let index = 4
  @genType
  type t = {
    amount: bigint,
    amount0: BigDecimal.t,
    amount1: BigDecimal.t,
    amountUSD: option<BigDecimal.t>,
    id: id,
    logIndex: option<bigint>,
    origin: string,
    owner: string,
    pool_id: id,
    sender: option<string>,
    tickLower: bigint,
    tickUpper: bigint,
    timestamp: bigint,
    token0_id: id,
    token1_id: id,
    transaction_id: id,
  }

  let schema = S.object((s): t => {
    amount: s.field("amount", BigInt.schema),
    amount0: s.field("amount0", BigDecimal.schema),
    amount1: s.field("amount1", BigDecimal.schema),
    amountUSD: s.field("amountUSD", S.null(BigDecimal.schema)),
    id: s.field("id", S.string),
    logIndex: s.field("logIndex", S.null(BigInt.schema)),
    origin: s.field("origin", S.string),
    owner: s.field("owner", S.string),
    pool_id: s.field("pool_id", S.string),
    sender: s.field("sender", S.null(S.string)),
    tickLower: s.field("tickLower", BigInt.schema),
    tickUpper: s.field("tickUpper", BigInt.schema),
    timestamp: s.field("timestamp", BigInt.schema),
    token0_id: s.field("token0_id", S.string),
    token1_id: s.field("token1_id", S.string),
    transaction_id: s.field("transaction_id", S.string),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("origin") origin: whereOperations<t, string>,
    
      @as("owner") owner: whereOperations<t, string>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
      @as("sender") sender: whereOperations<t, option<string>>,
    
      @as("tickLower") tickLower: whereOperations<t, bigint>,
    
      @as("tickUpper") tickUpper: whereOperations<t, bigint>,
    
      @as("timestamp") timestamp: whereOperations<t, bigint>,
    
      @as("token0_id") token0_id: whereOperations<t, id>,
    
      @as("token1_id") token1_id: whereOperations<t, id>,
    
      @as("transaction_id") transaction_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "amount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "amount0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amount1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amountUSD", 
      Numeric,
      ~fieldSchema=S.null(BigDecimal.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "logIndex", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "origin", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "owner", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "sender", 
      Text,
      ~fieldSchema=S.null(S.string),
      
      ~isNullable,
      
      ~isIndex,
      
      ),
      mkField(
      "tickLower", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "tickUpper", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "timestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "token0", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "token1", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "transaction", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      ~linkedEntity="Transaction",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Pool = {
  let name = (Pool :> string)
  let index = 5
  @genType
  type t = {
    
    collectedFeesToken0: BigDecimal.t,
    collectedFeesToken1: BigDecimal.t,
    collectedFeesUSD: BigDecimal.t,
    
    createdAtBlockNumber: bigint,
    createdAtTimestamp: bigint,
    feeTier: bigint,
    feesUSD: BigDecimal.t,
    id: id,
    liquidity: bigint,
    liquidityProviderCount: bigint,
    
    observationIndex: bigint,
    
    
    sqrtPrice: bigint,
    
    tick: option<bigint>,
    
    token0_id: id,
    token0Price: BigDecimal.t,
    token1_id: id,
    token1Price: BigDecimal.t,
    totalValueLockedETH: BigDecimal.t,
    totalValueLockedToken0: BigDecimal.t,
    totalValueLockedToken1: BigDecimal.t,
    totalValueLockedUSD: BigDecimal.t,
    totalValueLockedUSDUntracked: BigDecimal.t,
    txCount: bigint,
    untrackedVolumeUSD: BigDecimal.t,
    volumeToken0: BigDecimal.t,
    volumeToken1: BigDecimal.t,
    volumeUSD: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    
    collectedFeesToken0: s.field("collectedFeesToken0", BigDecimal.schema),
    collectedFeesToken1: s.field("collectedFeesToken1", BigDecimal.schema),
    collectedFeesUSD: s.field("collectedFeesUSD", BigDecimal.schema),
    
    createdAtBlockNumber: s.field("createdAtBlockNumber", BigInt.schema),
    createdAtTimestamp: s.field("createdAtTimestamp", BigInt.schema),
    feeTier: s.field("feeTier", BigInt.schema),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    id: s.field("id", S.string),
    liquidity: s.field("liquidity", BigInt.schema),
    liquidityProviderCount: s.field("liquidityProviderCount", BigInt.schema),
    
    observationIndex: s.field("observationIndex", BigInt.schema),
    
    
    sqrtPrice: s.field("sqrtPrice", BigInt.schema),
    
    tick: s.field("tick", S.null(BigInt.schema)),
    
    token0_id: s.field("token0_id", S.string),
    token0Price: s.field("token0Price", BigDecimal.schema),
    token1_id: s.field("token1_id", S.string),
    token1Price: s.field("token1Price", BigDecimal.schema),
    totalValueLockedETH: s.field("totalValueLockedETH", BigDecimal.schema),
    totalValueLockedToken0: s.field("totalValueLockedToken0", BigDecimal.schema),
    totalValueLockedToken1: s.field("totalValueLockedToken1", BigDecimal.schema),
    totalValueLockedUSD: s.field("totalValueLockedUSD", BigDecimal.schema),
    totalValueLockedUSDUntracked: s.field("totalValueLockedUSDUntracked", BigDecimal.schema),
    txCount: s.field("txCount", BigInt.schema),
    untrackedVolumeUSD: s.field("untrackedVolumeUSD", BigDecimal.schema),
    volumeToken0: s.field("volumeToken0", BigDecimal.schema),
    volumeToken1: s.field("volumeToken1", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("createdAtBlockNumber") createdAtBlockNumber: whereOperations<t, bigint>,
    
      @as("createdAtTimestamp") createdAtTimestamp: whereOperations<t, bigint>,
    
      @as("feeTier") feeTier: whereOperations<t, bigint>,
    
      @as("token0_id") token0_id: whereOperations<t, id>,
    
      @as("token1_id") token1_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "collectedFeesToken0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "collectedFeesToken1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "collectedFeesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "createdAtBlockNumber", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "createdAtTimestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "feeTier", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "liquidity", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "liquidityProviderCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "observationIndex", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "sqrtPrice", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "tick", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "token0", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "token0Price", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "token1", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "token1Price", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedETH", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedToken0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedToken1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSDUntracked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "txCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "untrackedVolumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeToken0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeToken1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkDerivedFromField(
      "burns", 
      ~derivedFromEntity="Burn",
      ~derivedFromField="pool",
      ),
      mkDerivedFromField(
      "collects", 
      ~derivedFromEntity="Collect",
      ~derivedFromField="pool",
      ),
      mkDerivedFromField(
      "mints", 
      ~derivedFromEntity="Mint",
      ~derivedFromField="pool",
      ),
      mkDerivedFromField(
      "poolDayData", 
      ~derivedFromEntity="PoolDayData",
      ~derivedFromField="pool",
      ),
      mkDerivedFromField(
      "poolHourData", 
      ~derivedFromEntity="PoolHourData",
      ~derivedFromField="pool",
      ),
      mkDerivedFromField(
      "swaps", 
      ~derivedFromEntity="Swap",
      ~derivedFromField="pool",
      ),
      mkDerivedFromField(
      "ticks", 
      ~derivedFromEntity="Tick",
      ~derivedFromField="pool",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module PoolDayData = {
  let name = (PoolDayData :> string)
  let index = 6
  @genType
  type t = {
    close: BigDecimal.t,
    date: int,
    feesUSD: BigDecimal.t,
    high: BigDecimal.t,
    id: id,
    liquidity: bigint,
    low: BigDecimal.t,
    openingPrice: BigDecimal.t,
    pool_id: id,
    sqrtPrice: bigint,
    tick: option<bigint>,
    token0Price: BigDecimal.t,
    token1Price: BigDecimal.t,
    tvlUSD: BigDecimal.t,
    txCount: bigint,
    volumeToken0: BigDecimal.t,
    volumeToken1: BigDecimal.t,
    volumeUSD: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    close: s.field("close", BigDecimal.schema),
    date: s.field("date", S.int),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    high: s.field("high", BigDecimal.schema),
    id: s.field("id", S.string),
    liquidity: s.field("liquidity", BigInt.schema),
    low: s.field("low", BigDecimal.schema),
    openingPrice: s.field("openingPrice", BigDecimal.schema),
    pool_id: s.field("pool_id", S.string),
    sqrtPrice: s.field("sqrtPrice", BigInt.schema),
    tick: s.field("tick", S.null(BigInt.schema)),
    token0Price: s.field("token0Price", BigDecimal.schema),
    token1Price: s.field("token1Price", BigDecimal.schema),
    tvlUSD: s.field("tvlUSD", BigDecimal.schema),
    txCount: s.field("txCount", BigInt.schema),
    volumeToken0: s.field("volumeToken0", BigDecimal.schema),
    volumeToken1: s.field("volumeToken1", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("date") date: whereOperations<t, int>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "close", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "date", 
      Integer,
      ~fieldSchema=S.int,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "high", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "liquidity", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "low", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "openingPrice", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "sqrtPrice", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "tick", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "token0Price", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "token1Price", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "tvlUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "txCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeToken0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeToken1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module PoolHourData = {
  let name = (PoolHourData :> string)
  let index = 7
  @genType
  type t = {
    close: BigDecimal.t,
    feesUSD: BigDecimal.t,
    high: BigDecimal.t,
    id: id,
    liquidity: bigint,
    low: BigDecimal.t,
    openingPrice: BigDecimal.t,
    periodStartUnix: int,
    pool_id: id,
    sqrtPrice: bigint,
    tick: option<bigint>,
    token0Price: BigDecimal.t,
    token1Price: BigDecimal.t,
    tvlUSD: BigDecimal.t,
    txCount: bigint,
    volumeToken0: BigDecimal.t,
    volumeToken1: BigDecimal.t,
    volumeUSD: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    close: s.field("close", BigDecimal.schema),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    high: s.field("high", BigDecimal.schema),
    id: s.field("id", S.string),
    liquidity: s.field("liquidity", BigInt.schema),
    low: s.field("low", BigDecimal.schema),
    openingPrice: s.field("openingPrice", BigDecimal.schema),
    periodStartUnix: s.field("periodStartUnix", S.int),
    pool_id: s.field("pool_id", S.string),
    sqrtPrice: s.field("sqrtPrice", BigInt.schema),
    tick: s.field("tick", S.null(BigInt.schema)),
    token0Price: s.field("token0Price", BigDecimal.schema),
    token1Price: s.field("token1Price", BigDecimal.schema),
    tvlUSD: s.field("tvlUSD", BigDecimal.schema),
    txCount: s.field("txCount", BigInt.schema),
    volumeToken0: s.field("volumeToken0", BigDecimal.schema),
    volumeToken1: s.field("volumeToken1", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("periodStartUnix") periodStartUnix: whereOperations<t, int>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "close", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "high", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "liquidity", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "low", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "openingPrice", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "periodStartUnix", 
      Integer,
      ~fieldSchema=S.int,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "sqrtPrice", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "tick", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "token0Price", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "token1Price", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "tvlUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "txCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeToken0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeToken1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Swap = {
  let name = (Swap :> string)
  let index = 8
  @genType
  type t = {
    amount0: BigDecimal.t,
    amount1: BigDecimal.t,
    amountUSD: BigDecimal.t,
    id: id,
    logIndex: option<bigint>,
    origin: string,
    pool_id: id,
    recipient: string,
    sender: string,
    sqrtPriceX96: bigint,
    tick: bigint,
    timestamp: bigint,
    token0_id: id,
    token1_id: id,
    transaction_id: id,
  }

  let schema = S.object((s): t => {
    amount0: s.field("amount0", BigDecimal.schema),
    amount1: s.field("amount1", BigDecimal.schema),
    amountUSD: s.field("amountUSD", BigDecimal.schema),
    id: s.field("id", S.string),
    logIndex: s.field("logIndex", S.null(BigInt.schema)),
    origin: s.field("origin", S.string),
    pool_id: s.field("pool_id", S.string),
    recipient: s.field("recipient", S.string),
    sender: s.field("sender", S.string),
    sqrtPriceX96: s.field("sqrtPriceX96", BigInt.schema),
    tick: s.field("tick", BigInt.schema),
    timestamp: s.field("timestamp", BigInt.schema),
    token0_id: s.field("token0_id", S.string),
    token1_id: s.field("token1_id", S.string),
    transaction_id: s.field("transaction_id", S.string),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("origin") origin: whereOperations<t, string>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
      @as("recipient") recipient: whereOperations<t, string>,
    
      @as("sender") sender: whereOperations<t, string>,
    
      @as("tick") tick: whereOperations<t, bigint>,
    
      @as("timestamp") timestamp: whereOperations<t, bigint>,
    
      @as("token0_id") token0_id: whereOperations<t, id>,
    
      @as("token1_id") token1_id: whereOperations<t, id>,
    
      @as("transaction_id") transaction_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "amount0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amount1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "amountUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "logIndex", 
      Numeric,
      ~fieldSchema=S.null(BigInt.schema),
      
      ~isNullable,
      
      
      
      ),
      mkField(
      "origin", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "recipient", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "sender", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "sqrtPriceX96", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "tick", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "timestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "token0", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "token1", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "transaction", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      ~linkedEntity="Transaction",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Tick = {
  let name = (Tick :> string)
  let index = 9
  @genType
  type t = {
    createdAtBlockNumber: bigint,
    createdAtTimestamp: bigint,
    id: id,
    liquidityGross: bigint,
    liquidityNet: bigint,
    pool_id: id,
    poolAddress: option<string>,
    price0: BigDecimal.t,
    price1: BigDecimal.t,
    tickIdx: bigint,
  }

  let schema = S.object((s): t => {
    createdAtBlockNumber: s.field("createdAtBlockNumber", BigInt.schema),
    createdAtTimestamp: s.field("createdAtTimestamp", BigInt.schema),
    id: s.field("id", S.string),
    liquidityGross: s.field("liquidityGross", BigInt.schema),
    liquidityNet: s.field("liquidityNet", BigInt.schema),
    pool_id: s.field("pool_id", S.string),
    poolAddress: s.field("poolAddress", S.null(S.string)),
    price0: s.field("price0", BigDecimal.schema),
    price1: s.field("price1", BigDecimal.schema),
    tickIdx: s.field("tickIdx", BigInt.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("createdAtBlockNumber") createdAtBlockNumber: whereOperations<t, bigint>,
    
      @as("createdAtTimestamp") createdAtTimestamp: whereOperations<t, bigint>,
    
      @as("pool_id") pool_id: whereOperations<t, id>,
    
      @as("poolAddress") poolAddress: whereOperations<t, option<string>>,
    
      @as("tickIdx") tickIdx: whereOperations<t, bigint>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "createdAtBlockNumber", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "createdAtTimestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "liquidityGross", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "liquidityNet", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "pool", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Pool",
      ),
      mkField(
      "poolAddress", 
      Text,
      ~fieldSchema=S.null(S.string),
      
      ~isNullable,
      
      ~isIndex,
      
      ),
      mkField(
      "price0", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "price1", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "tickIdx", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Token = {
  let name = (Token :> string)
  let index = 10
  @genType
  type t = {
    decimals: bigint,
    derivedETH: BigDecimal.t,
    feesUSD: BigDecimal.t,
    id: id,
    isWhitelisted: bool,
    name: string,
    poolCount: bigint,
    symbol: string,
    
    totalValueLocked: BigDecimal.t,
    totalValueLockedUSD: BigDecimal.t,
    totalValueLockedUSDUntracked: BigDecimal.t,
    txCount: bigint,
    untrackedVolumeUSD: BigDecimal.t,
    volume: BigDecimal.t,
    volumeUSD: BigDecimal.t,
    whitelistPools: array<string>,
  }

  let schema = S.object((s): t => {
    decimals: s.field("decimals", BigInt.schema),
    derivedETH: s.field("derivedETH", BigDecimal.schema),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    id: s.field("id", S.string),
    isWhitelisted: s.field("isWhitelisted", S.bool),
    name: s.field("name", S.string),
    poolCount: s.field("poolCount", BigInt.schema),
    symbol: s.field("symbol", S.string),
    
    totalValueLocked: s.field("totalValueLocked", BigDecimal.schema),
    totalValueLockedUSD: s.field("totalValueLockedUSD", BigDecimal.schema),
    totalValueLockedUSDUntracked: s.field("totalValueLockedUSDUntracked", BigDecimal.schema),
    txCount: s.field("txCount", BigInt.schema),
    untrackedVolumeUSD: s.field("untrackedVolumeUSD", BigDecimal.schema),
    volume: s.field("volume", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
    whitelistPools: s.field("whitelistPools", S.array(S.string)),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("decimals") decimals: whereOperations<t, bigint>,
    
      @as("isWhitelisted") isWhitelisted: whereOperations<t, bool>,
    
      @as("poolCount") poolCount: whereOperations<t, bigint>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "decimals", 
      Custom("NUMERIC(78, 0)"),
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "derivedETH", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "isWhitelisted", 
      Boolean,
      ~fieldSchema=S.bool,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "name", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "poolCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "symbol", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      
      
      ),
      mkField(
      "totalValueLocked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSDUntracked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "txCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "untrackedVolumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volume", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "whitelistPools", 
      Text,
      ~fieldSchema=S.array(S.string),
      
      
      ~isArray,
      
      
      ),
      mkDerivedFromField(
      "tokenDayData", 
      ~derivedFromEntity="TokenDayData",
      ~derivedFromField="token",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module TokenDayData = {
  let name = (TokenDayData :> string)
  let index = 11
  @genType
  type t = {
    close: BigDecimal.t,
    date: int,
    feesUSD: BigDecimal.t,
    high: BigDecimal.t,
    id: id,
    low: BigDecimal.t,
    openingPrice: BigDecimal.t,
    priceUSD: BigDecimal.t,
    token_id: id,
    totalValueLocked: BigDecimal.t,
    totalValueLockedUSD: BigDecimal.t,
    untrackedVolumeUSD: BigDecimal.t,
    volume: BigDecimal.t,
    volumeUSD: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    close: s.field("close", BigDecimal.schema),
    date: s.field("date", S.int),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    high: s.field("high", BigDecimal.schema),
    id: s.field("id", S.string),
    low: s.field("low", BigDecimal.schema),
    openingPrice: s.field("openingPrice", BigDecimal.schema),
    priceUSD: s.field("priceUSD", BigDecimal.schema),
    token_id: s.field("token_id", S.string),
    totalValueLocked: s.field("totalValueLocked", BigDecimal.schema),
    totalValueLockedUSD: s.field("totalValueLockedUSD", BigDecimal.schema),
    untrackedVolumeUSD: s.field("untrackedVolumeUSD", BigDecimal.schema),
    volume: s.field("volume", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("date") date: whereOperations<t, int>,
    
      @as("token_id") token_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "close", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "date", 
      Integer,
      ~fieldSchema=S.int,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "high", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "low", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "openingPrice", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "priceUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "token", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "totalValueLocked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "untrackedVolumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volume", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module TokenHourData = {
  let name = (TokenHourData :> string)
  let index = 12
  @genType
  type t = {
    close: BigDecimal.t,
    feesUSD: BigDecimal.t,
    high: BigDecimal.t,
    id: id,
    low: BigDecimal.t,
    openingPrice: BigDecimal.t,
    periodStartUnix: int,
    priceUSD: BigDecimal.t,
    token_id: id,
    totalValueLocked: BigDecimal.t,
    totalValueLockedUSD: BigDecimal.t,
    untrackedVolumeUSD: BigDecimal.t,
    volume: BigDecimal.t,
    volumeUSD: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    close: s.field("close", BigDecimal.schema),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    high: s.field("high", BigDecimal.schema),
    id: s.field("id", S.string),
    low: s.field("low", BigDecimal.schema),
    openingPrice: s.field("openingPrice", BigDecimal.schema),
    periodStartUnix: s.field("periodStartUnix", S.int),
    priceUSD: s.field("priceUSD", BigDecimal.schema),
    token_id: s.field("token_id", S.string),
    totalValueLocked: s.field("totalValueLocked", BigDecimal.schema),
    totalValueLockedUSD: s.field("totalValueLockedUSD", BigDecimal.schema),
    untrackedVolumeUSD: s.field("untrackedVolumeUSD", BigDecimal.schema),
    volume: s.field("volume", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("periodStartUnix") periodStartUnix: whereOperations<t, int>,
    
      @as("token_id") token_id: whereOperations<t, id>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "close", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "high", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "low", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "openingPrice", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "periodStartUnix", 
      Integer,
      ~fieldSchema=S.int,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "priceUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "token", 
      Text,
      ~fieldSchema=S.string,
      
      
      
      ~isIndex,
      ~linkedEntity="Token",
      ),
      mkField(
      "totalValueLocked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "totalValueLockedUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "untrackedVolumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volume", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module Transaction = {
  let name = (Transaction :> string)
  let index = 13
  @genType
  type t = {
    blockNumber: bigint,
    
    
    gasPrice: bigint,
    gasUsed: bigint,
    id: id,
    
    
    timestamp: bigint,
  }

  let schema = S.object((s): t => {
    blockNumber: s.field("blockNumber", BigInt.schema),
    
    
    gasPrice: s.field("gasPrice", BigInt.schema),
    gasUsed: s.field("gasUsed", BigInt.schema),
    id: s.field("id", S.string),
    
    
    timestamp: s.field("timestamp", BigInt.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("blockNumber") blockNumber: whereOperations<t, bigint>,
    
      @as("timestamp") timestamp: whereOperations<t, bigint>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "blockNumber", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "gasPrice", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "gasUsed", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "timestamp", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      ~isIndex,
      
      ),
      mkDerivedFromField(
      "burns", 
      ~derivedFromEntity="Burn",
      ~derivedFromField="transaction",
      ),
      mkDerivedFromField(
      "collects", 
      ~derivedFromEntity="Collect",
      ~derivedFromField="transaction",
      ),
      mkDerivedFromField(
      "mints", 
      ~derivedFromEntity="Mint",
      ~derivedFromField="transaction",
      ),
      mkDerivedFromField(
      "swaps", 
      ~derivedFromEntity="Swap",
      ~derivedFromField="transaction",
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

module UniswapDayData = {
  let name = (UniswapDayData :> string)
  let index = 14
  @genType
  type t = {
    date: int,
    feesUSD: BigDecimal.t,
    id: id,
    tvlUSD: BigDecimal.t,
    txCount: bigint,
    volumeETH: BigDecimal.t,
    volumeUSD: BigDecimal.t,
    volumeUSDUntracked: BigDecimal.t,
  }

  let schema = S.object((s): t => {
    date: s.field("date", S.int),
    feesUSD: s.field("feesUSD", BigDecimal.schema),
    id: s.field("id", S.string),
    tvlUSD: s.field("tvlUSD", BigDecimal.schema),
    txCount: s.field("txCount", BigInt.schema),
    volumeETH: s.field("volumeETH", BigDecimal.schema),
    volumeUSD: s.field("volumeUSD", BigDecimal.schema),
    volumeUSDUntracked: s.field("volumeUSDUntracked", BigDecimal.schema),
  })

  let rowsSchema = S.array(schema)

  @genType
  type indexedFieldOperations = {
    
      @as("date") date: whereOperations<t, int>,
    
  }

  let table = mkTable(
    (name :> string),
    ~fields=[
      mkField(
      "date", 
      Integer,
      ~fieldSchema=S.int,
      
      
      
      ~isIndex,
      
      ),
      mkField(
      "feesUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
      ),
      mkField(
      "tvlUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "txCount", 
      Numeric,
      ~fieldSchema=BigInt.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeETH", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSD", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
      mkField(
      "volumeUSDUntracked", 
      Numeric,
      ~fieldSchema=BigDecimal.schema,
      
      
      
      
      
      ),
    ],
  )

  let entityHistory = table->EntityHistory.fromTable(~schema, ~entityIndex=index)

  external castToInternal: t => Internal.entity = "%identity"
}

let userEntities = [
  module(Bundle),
  module(Burn),
  module(Collect),
  module(Factory),
  module(Mint),
  module(Pool),
  module(PoolDayData),
  module(PoolHourData),
  module(Swap),
  module(Tick),
  module(Token),
  module(TokenDayData),
  module(TokenHourData),
  module(Transaction),
  module(UniswapDayData),
]->entityModsToInternal

let allEntities =
  userEntities->Js.Array2.concat(
    [module(InternalTable.DynamicContractRegistry)]->entityModsToInternal,
  )

let byName =
  allEntities
  ->Js.Array2.map(entityConfig => {
    (entityConfig.name, entityConfig)
  })
  ->Js.Dict.fromArray
