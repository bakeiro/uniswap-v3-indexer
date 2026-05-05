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

module Pool = {
  let name = (Pool :> string)
  let index = 0
  @genType
  type t = {
    id: id,
    
  }

  let schema = S.object((s): t => {
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
      "id", 
      Text,
      ~fieldSchema=S.string,
      ~isPrimaryKey,
      
      
      
      
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

module Tick = {
  let name = (Tick :> string)
  let index = 1
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

let userEntities = [
  module(Pool),
  module(Tick),
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
