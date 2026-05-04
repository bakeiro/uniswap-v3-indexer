//*************
//***ENTITIES**
//*************
@genType.as("Id")
type id = string

@genType
type contractRegistrations = {
  log: Envio.logger,
  // TODO: only add contracts we've registered for the event in the config
  addUniswapV3Factory: (Address.t) => unit,
  addUniswapV3Pool: (Address.t) => unit,
}

@genType
type entityHandlerContext<'entity, 'indexedFieldOperations> = {
  get: id => promise<option<'entity>>,
  getOrThrow: (id, ~message: string=?) => promise<'entity>,
  getWhere: 'indexedFieldOperations,
  getOrCreate: ('entity) => promise<'entity>,
  set: 'entity => unit,
  deleteUnsafe: id => unit,
}

@genType.import(("./Types.ts", "HandlerContext"))
type handlerContext = {
  log: Envio.logger,
  effect: 'input 'output. (Envio.effect<'input, 'output>, 'input) => promise<'output>,
  isPreload: bool,
  chains: Internal.chains,
  @as("Bundle") bundle: entityHandlerContext<Entities.Bundle.t, Entities.Bundle.indexedFieldOperations>,
  @as("Burn") burn: entityHandlerContext<Entities.Burn.t, Entities.Burn.indexedFieldOperations>,
  @as("Collect") collect: entityHandlerContext<Entities.Collect.t, Entities.Collect.indexedFieldOperations>,
  @as("Factory") factory: entityHandlerContext<Entities.Factory.t, Entities.Factory.indexedFieldOperations>,
  @as("Mint") mint: entityHandlerContext<Entities.Mint.t, Entities.Mint.indexedFieldOperations>,
  @as("Pool") pool: entityHandlerContext<Entities.Pool.t, Entities.Pool.indexedFieldOperations>,
  @as("PoolDayData") poolDayData: entityHandlerContext<Entities.PoolDayData.t, Entities.PoolDayData.indexedFieldOperations>,
  @as("PoolHourData") poolHourData: entityHandlerContext<Entities.PoolHourData.t, Entities.PoolHourData.indexedFieldOperations>,
  @as("Swap") swap: entityHandlerContext<Entities.Swap.t, Entities.Swap.indexedFieldOperations>,
  @as("Tick") tick: entityHandlerContext<Entities.Tick.t, Entities.Tick.indexedFieldOperations>,
  @as("Token") token: entityHandlerContext<Entities.Token.t, Entities.Token.indexedFieldOperations>,
  @as("TokenDayData") tokenDayData: entityHandlerContext<Entities.TokenDayData.t, Entities.TokenDayData.indexedFieldOperations>,
  @as("TokenHourData") tokenHourData: entityHandlerContext<Entities.TokenHourData.t, Entities.TokenHourData.indexedFieldOperations>,
  @as("Transaction") transaction: entityHandlerContext<Entities.Transaction.t, Entities.Transaction.indexedFieldOperations>,
  @as("UniswapDayData") uniswapDayData: entityHandlerContext<Entities.UniswapDayData.t, Entities.UniswapDayData.indexedFieldOperations>,
}

//Re-exporting types for backwards compatability
@genType.as("Bundle")
type bundle = Entities.Bundle.t
@genType.as("Burn")
type burn = Entities.Burn.t
@genType.as("Collect")
type collect = Entities.Collect.t
@genType.as("Factory")
type factory = Entities.Factory.t
@genType.as("Mint")
type mint = Entities.Mint.t
@genType.as("Pool")
type pool = Entities.Pool.t
@genType.as("PoolDayData")
type poolDayData = Entities.PoolDayData.t
@genType.as("PoolHourData")
type poolHourData = Entities.PoolHourData.t
@genType.as("Swap")
type swap = Entities.Swap.t
@genType.as("Tick")
type tick = Entities.Tick.t
@genType.as("Token")
type token = Entities.Token.t
@genType.as("TokenDayData")
type tokenDayData = Entities.TokenDayData.t
@genType.as("TokenHourData")
type tokenHourData = Entities.TokenHourData.t
@genType.as("Transaction")
type transaction = Entities.Transaction.t
@genType.as("UniswapDayData")
type uniswapDayData = Entities.UniswapDayData.t

//*************
//**CONTRACTS**
//*************

module Transaction = {
  @genType
  type t = {}

  let schema = S.object((_): t => {})
}

module Block = {
  @genType
  type t = {number: int, timestamp: int, hash: string}

  let schema = S.object((s): t => {number: s.field("number", S.int), timestamp: s.field("timestamp", S.int), hash: s.field("hash", S.string)})

  @get
  external getNumber: Internal.eventBlock => int = "number"

  @get
  external getTimestamp: Internal.eventBlock => int = "timestamp"
 
  @get
  external getId: Internal.eventBlock => string = "hash"

  let cleanUpRawEventFieldsInPlace: Js.Json.t => () = %raw(`fields => {
    delete fields.hash
    delete fields.number
    delete fields.timestamp
  }`)
}

module AggregatedBlock = {
  @genType
  type t = {hash: string, number: int, timestamp: int}
}
module AggregatedTransaction = {
  @genType
  type t = {from: option<Address.t>, gasPrice: option<bigint>, hash: string}
}

@genType.as("EventLog")
type eventLog<'params> = Internal.genericEvent<'params, Block.t, Transaction.t>

module SingleOrMultiple: {
  @genType.import(("./bindings/OpaqueTypes", "SingleOrMultiple"))
  type t<'a>
  let normalizeOrThrow: (t<'a>, ~nestedArrayDepth: int=?) => array<'a>
  let single: 'a => t<'a>
  let multiple: array<'a> => t<'a>
} = {
  type t<'a> = Js.Json.t

  external single: 'a => t<'a> = "%identity"
  external multiple: array<'a> => t<'a> = "%identity"
  external castMultiple: t<'a> => array<'a> = "%identity"
  external castSingle: t<'a> => 'a = "%identity"

  exception AmbiguousEmptyNestedArray

  let rec isMultiple = (t: t<'a>, ~nestedArrayDepth): bool =>
    switch t->Js.Json.decodeArray {
    | None => false
    | Some(_arr) if nestedArrayDepth == 0 => true
    | Some([]) if nestedArrayDepth > 0 =>
      AmbiguousEmptyNestedArray->ErrorHandling.mkLogAndRaise(
        ~msg="The given empty array could be interperated as a flat array (value) or nested array. Since it's ambiguous,
        please pass in a nested empty array if the intention is to provide an empty array as a value",
      )
    | Some(arr) => arr->Js.Array2.unsafe_get(0)->isMultiple(~nestedArrayDepth=nestedArrayDepth - 1)
    }

  let normalizeOrThrow = (t: t<'a>, ~nestedArrayDepth=0): array<'a> => {
    if t->isMultiple(~nestedArrayDepth) {
      t->castMultiple
    } else {
      [t->castSingle]
    }
  }
}

module HandlerTypes = {
  @genType
  type args<'eventArgs, 'context> = {
    event: eventLog<'eventArgs>,
    context: 'context,
  }

  @genType
  type contractRegisterArgs<'eventArgs> = Internal.genericContractRegisterArgs<eventLog<'eventArgs>, contractRegistrations>
  @genType
  type contractRegister<'eventArgs> = Internal.genericContractRegister<contractRegisterArgs<'eventArgs>>


  @genType
  type eventConfig<'eventFilters> = Internal.eventOptions<'eventFilters>
}

module type Event = {
  type event

  let handlerRegister: EventRegister.t

  type eventFilters
}

@genType.import(("./bindings/OpaqueTypes.ts", "HandlerWithOptions"))
type fnWithEventConfig<'fn, 'eventConfig> = ('fn, ~eventConfig: 'eventConfig=?) => unit

type handlerWithOptions<'eventArgs, 'eventFilters> = fnWithEventConfig<
  Internal.genericHandler<'eventArgs>,
  HandlerTypes.eventConfig<'eventFilters>,
>

@genType
type contractRegisterWithOptions<'eventArgs, 'eventFilters> = fnWithEventConfig<
  HandlerTypes.contractRegister<'eventArgs>,
  HandlerTypes.eventConfig<'eventFilters>,
>

module MakeRegister = (Event: Event) => {
  let contractRegister: fnWithEventConfig<
    Internal.genericContractRegister<
      Internal.genericContractRegisterArgs<Event.event, contractRegistrations>,
    >,
    HandlerTypes.eventConfig<Event.eventFilters>,
  > = (contractRegister, ~eventConfig=?) =>
    Event.handlerRegister->EventRegister.setContractRegister(
      contractRegister,
      ~eventOptions=eventConfig,
    )

  let handler: fnWithEventConfig<
    Internal.genericHandler<Internal.genericHandlerArgs<Event.event, handlerContext, unit>>,
    HandlerTypes.eventConfig<Event.eventFilters>,
  > = (handler, ~eventConfig=?) => {
    Event.handlerRegister->EventRegister.setHandler(
      handler->(
        Utils.magic: Internal.genericHandler<
          Internal.genericHandlerArgs<Event.event, handlerContext, unit>,
        > => Internal.genericHandler<
          Internal.genericHandlerArgs<Event.event, Internal.handlerContext, 'a>,
        >
      ),
      ~eventOptions=eventConfig,
    )
  }
}

module UniswapV3Factory = {
let abi = Ethers.makeAbi((%raw(`[{"type":"event","name":"PoolCreated","inputs":[{"name":"token0","type":"address","indexed":true},{"name":"token1","type":"address","indexed":true},{"name":"fee","type":"uint24","indexed":true},{"name":"tickSpacing","type":"int24","indexed":false},{"name":"pool","type":"address","indexed":false}],"anonymous":false}]`): Js.Json.t))
let eventSignatures = ["PoolCreated(address indexed token0, address indexed token1, uint24 indexed fee, int24 tickSpacing, address pool)"]
@genType type chainId = [#1]
let contractName = "UniswapV3Factory"

module PoolCreated = {

let id = "0x783cca1c0412dd0d695e784568c96da2e9c22ff989357a2e8b1d9b2b4e6b7118_4"
let sighash = "0x783cca1c0412dd0d695e784568c96da2e9c22ff989357a2e8b1d9b2b4e6b7118"
let name = "PoolCreated"
let contractName = contractName

@genType
type eventArgs = {token0: Address.t, token1: Address.t, fee: bigint, tickSpacing: bigint, pool: Address.t}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
  /** The parameters or arguments associated with this event. */
  params: eventArgs,
  /** The unique identifier of the blockchain network where this event occurred. */
  chainId: chainId,
  /** The address of the contract that emitted this event. */
  srcAddress: Address.t,
  /** The index of this event's log within the block. */
  logIndex: int,
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  transaction: transaction,
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext, unit>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {token0: s.field("token0", Address.schema), token1: s.field("token1", Address.schema), fee: s.field("fee", BigInt.schema), tickSpacing: s.field("tickSpacing", BigInt.schema), pool: s.field("pool", Address.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
  ~contractName,
  ~eventName=name,
)

@genType
type eventFilter = {@as("token0") token0?: SingleOrMultiple.t<Address.t>, @as("token1") token1?: SingleOrMultiple.t<Address.t>, @as("fee") fee?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>)

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
  let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["token0","token1","fee",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("token0")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("token1")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic3=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("fee")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromBigInt)))
  {
    getEventFiltersOrThrow,
    filterByAddresses,
    dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
    blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
    transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
    convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {token0: decodedEvent.indexed->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, token1: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, fee: decodedEvent.indexed->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickSpacing: decodedEvent.body->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, pool: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
    id,
  name,
  contractName,
  isWildcard: (handlerRegister->EventRegister.isWildcard),
  handler: handlerRegister->EventRegister.getHandler,
  contractRegister: handlerRegister->EventRegister.getContractRegister,
  paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
  }
}
}
}

module UniswapV3Pool = {
let abi = Ethers.makeAbi((%raw(`[{"type":"event","name":"Burn","inputs":[{"name":"owner","type":"address","indexed":true},{"name":"tickLower","type":"int24","indexed":true},{"name":"tickUpper","type":"int24","indexed":true},{"name":"amount","type":"uint128","indexed":false},{"name":"amount0","type":"uint256","indexed":false},{"name":"amount1","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"Collect","inputs":[{"name":"owner","type":"address","indexed":true},{"name":"recipient","type":"address","indexed":false},{"name":"tickLower","type":"int24","indexed":true},{"name":"tickUpper","type":"int24","indexed":true},{"name":"amount0","type":"uint128","indexed":false},{"name":"amount1","type":"uint128","indexed":false}],"anonymous":false},{"type":"event","name":"Initialize","inputs":[{"name":"sqrtPriceX96","type":"uint160","indexed":false},{"name":"tick","type":"int24","indexed":false}],"anonymous":false},{"type":"event","name":"Mint","inputs":[{"name":"sender","type":"address","indexed":false},{"name":"owner","type":"address","indexed":true},{"name":"tickLower","type":"int24","indexed":true},{"name":"tickUpper","type":"int24","indexed":true},{"name":"amount","type":"uint128","indexed":false},{"name":"amount0","type":"uint256","indexed":false},{"name":"amount1","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"Swap","inputs":[{"name":"sender","type":"address","indexed":true},{"name":"recipient","type":"address","indexed":true},{"name":"amount0","type":"int256","indexed":false},{"name":"amount1","type":"int256","indexed":false},{"name":"sqrtPriceX96","type":"uint160","indexed":false},{"name":"liquidity","type":"uint128","indexed":false},{"name":"tick","type":"int24","indexed":false}],"anonymous":false}]`): Js.Json.t))
let eventSignatures = ["Burn(address indexed owner, int24 indexed tickLower, int24 indexed tickUpper, uint128 amount, uint256 amount0, uint256 amount1)", "Collect(address indexed owner, address recipient, int24 indexed tickLower, int24 indexed tickUpper, uint128 amount0, uint128 amount1)", "Initialize(uint160 sqrtPriceX96, int24 tick)", "Mint(address sender, address indexed owner, int24 indexed tickLower, int24 indexed tickUpper, uint128 amount, uint256 amount0, uint256 amount1)", "Swap(address indexed sender, address indexed recipient, int256 amount0, int256 amount1, uint160 sqrtPriceX96, uint128 liquidity, int24 tick)"]
@genType type chainId = [#1]
let contractName = "UniswapV3Pool"

module Initialize = {

let id = "0x98636036cb66a9c19a37435efc1e90142190214e8abeb821bdba3f2990dd4c95_1"
let sighash = "0x98636036cb66a9c19a37435efc1e90142190214e8abeb821bdba3f2990dd4c95"
let name = "Initialize"
let contractName = contractName

@genType
type eventArgs = {sqrtPriceX96: bigint, tick: bigint}
@genType
type block = Block.t
@genType
type transaction = Transaction.t

@genType
type event = {
  /** The parameters or arguments associated with this event. */
  params: eventArgs,
  /** The unique identifier of the blockchain network where this event occurred. */
  chainId: chainId,
  /** The address of the contract that emitted this event. */
  srcAddress: Address.t,
  /** The index of this event's log within the block. */
  logIndex: int,
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  transaction: transaction,
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext, unit>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {sqrtPriceX96: s.field("sqrtPriceX96", BigInt.schema), tick: s.field("tick", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

let handlerRegister: EventRegister.t = EventRegister.make(
  ~contractName,
  ~eventName=name,
)

@genType
type eventFilter = {}

@genType type eventFilters = Internal.noEventFilters

let register = (): Internal.evmEventConfig => {
  let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=[])
  {
    getEventFiltersOrThrow,
    filterByAddresses,
    dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
    blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
    transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
    convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {sqrtPriceX96: decodedEvent.body->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tick: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
    id,
  name,
  contractName,
  isWildcard: (handlerRegister->EventRegister.isWildcard),
  handler: handlerRegister->EventRegister.getHandler,
  contractRegister: handlerRegister->EventRegister.getContractRegister,
  paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
  }
}
}

module Collect = {

let id = "0x70935338e69775456a85ddef226c395fb668b63fa0115f5f20610b388e6ca9c0_4"
let sighash = "0x70935338e69775456a85ddef226c395fb668b63fa0115f5f20610b388e6ca9c0"
let name = "Collect"
let contractName = contractName

@genType
type eventArgs = {owner: Address.t, recipient: Address.t, tickLower: bigint, tickUpper: bigint, amount0: bigint, amount1: bigint}
@genType
type block = {number: int, timestamp: int, hash: string}
@genType
type transaction = {hash: string, gasPrice: option<bigint>}

@genType
type event = {
  /** The parameters or arguments associated with this event. */
  params: eventArgs,
  /** The unique identifier of the blockchain network where this event occurred. */
  chainId: chainId,
  /** The address of the contract that emitted this event. */
  srcAddress: Address.t,
  /** The index of this event's log within the block. */
  logIndex: int,
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  transaction: transaction,
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext, unit>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {owner: s.field("owner", Address.schema), recipient: s.field("recipient", Address.schema), tickLower: s.field("tickLower", BigInt.schema), tickUpper: s.field("tickUpper", BigInt.schema), amount0: s.field("amount0", BigInt.schema), amount1: s.field("amount1", BigInt.schema)})
let blockSchema = S.object((s): block => {number: s.field("number", S.int), timestamp: s.field("timestamp", S.int), hash: s.field("hash", S.string)})
let transactionSchema = S.object((s): transaction => {hash: s.field("hash", S.string), gasPrice: s.field("gasPrice", S.nullable(BigInt.nativeSchema))})

let handlerRegister: EventRegister.t = EventRegister.make(
  ~contractName,
  ~eventName=name,
)

@genType
type eventFilter = {@as("owner") owner?: SingleOrMultiple.t<Address.t>, @as("tickLower") tickLower?: SingleOrMultiple.t<bigint>, @as("tickUpper") tickUpper?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>)

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
  let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["owner","tickLower","tickUpper",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("owner")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("tickLower")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromSignedBigInt)), ~topic3=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("tickUpper")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromSignedBigInt)))
  {
    getEventFiltersOrThrow,
    filterByAddresses,
    dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
    blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
    transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
    convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {owner: decodedEvent.indexed->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickLower: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickUpper: decodedEvent.indexed->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, recipient: decodedEvent.body->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount0: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount1: decodedEvent.body->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
    id,
  name,
  contractName,
  isWildcard: (handlerRegister->EventRegister.isWildcard),
  handler: handlerRegister->EventRegister.getHandler,
  contractRegister: handlerRegister->EventRegister.getContractRegister,
  paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
  }
}
}

module Burn = {

let id = "0x0c396cd989a39f4459b5fa1aed6a9a8dcdbc45908acfd67e028cd568da98982c_4"
let sighash = "0x0c396cd989a39f4459b5fa1aed6a9a8dcdbc45908acfd67e028cd568da98982c"
let name = "Burn"
let contractName = contractName

@genType
type eventArgs = {owner: Address.t, tickLower: bigint, tickUpper: bigint, amount: bigint, amount0: bigint, amount1: bigint}
@genType
type block = {number: int, timestamp: int, hash: string}
@genType
type transaction = {hash: string, gasPrice: option<bigint>, from: option<Address.t>}

@genType
type event = {
  /** The parameters or arguments associated with this event. */
  params: eventArgs,
  /** The unique identifier of the blockchain network where this event occurred. */
  chainId: chainId,
  /** The address of the contract that emitted this event. */
  srcAddress: Address.t,
  /** The index of this event's log within the block. */
  logIndex: int,
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  transaction: transaction,
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext, unit>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {owner: s.field("owner", Address.schema), tickLower: s.field("tickLower", BigInt.schema), tickUpper: s.field("tickUpper", BigInt.schema), amount: s.field("amount", BigInt.schema), amount0: s.field("amount0", BigInt.schema), amount1: s.field("amount1", BigInt.schema)})
let blockSchema = S.object((s): block => {number: s.field("number", S.int), timestamp: s.field("timestamp", S.int), hash: s.field("hash", S.string)})
let transactionSchema = S.object((s): transaction => {hash: s.field("hash", S.string), gasPrice: s.field("gasPrice", S.nullable(BigInt.nativeSchema)), from: s.field("from", S.nullable(Address.schema))})

let handlerRegister: EventRegister.t = EventRegister.make(
  ~contractName,
  ~eventName=name,
)

@genType
type eventFilter = {@as("owner") owner?: SingleOrMultiple.t<Address.t>, @as("tickLower") tickLower?: SingleOrMultiple.t<bigint>, @as("tickUpper") tickUpper?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>)

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
  let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["owner","tickLower","tickUpper",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("owner")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("tickLower")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromSignedBigInt)), ~topic3=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("tickUpper")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromSignedBigInt)))
  {
    getEventFiltersOrThrow,
    filterByAddresses,
    dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
    blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
    transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
    convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {owner: decodedEvent.indexed->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickLower: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickUpper: decodedEvent.indexed->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount: decodedEvent.body->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount0: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount1: decodedEvent.body->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
    id,
  name,
  contractName,
  isWildcard: (handlerRegister->EventRegister.isWildcard),
  handler: handlerRegister->EventRegister.getHandler,
  contractRegister: handlerRegister->EventRegister.getContractRegister,
  paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
  }
}
}

module Mint = {

let id = "0x7a53080ba414158be7ec69b987b5fb7d07dee101fe85488f0853ae16239d0bde_4"
let sighash = "0x7a53080ba414158be7ec69b987b5fb7d07dee101fe85488f0853ae16239d0bde"
let name = "Mint"
let contractName = contractName

@genType
type eventArgs = {sender: Address.t, owner: Address.t, tickLower: bigint, tickUpper: bigint, amount: bigint, amount0: bigint, amount1: bigint}
@genType
type block = {number: int, timestamp: int, hash: string}
@genType
type transaction = {hash: string, gasPrice: option<bigint>, from: option<Address.t>}

@genType
type event = {
  /** The parameters or arguments associated with this event. */
  params: eventArgs,
  /** The unique identifier of the blockchain network where this event occurred. */
  chainId: chainId,
  /** The address of the contract that emitted this event. */
  srcAddress: Address.t,
  /** The index of this event's log within the block. */
  logIndex: int,
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  transaction: transaction,
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext, unit>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {sender: s.field("sender", Address.schema), owner: s.field("owner", Address.schema), tickLower: s.field("tickLower", BigInt.schema), tickUpper: s.field("tickUpper", BigInt.schema), amount: s.field("amount", BigInt.schema), amount0: s.field("amount0", BigInt.schema), amount1: s.field("amount1", BigInt.schema)})
let blockSchema = S.object((s): block => {number: s.field("number", S.int), timestamp: s.field("timestamp", S.int), hash: s.field("hash", S.string)})
let transactionSchema = S.object((s): transaction => {hash: s.field("hash", S.string), gasPrice: s.field("gasPrice", S.nullable(BigInt.nativeSchema)), from: s.field("from", S.nullable(Address.schema))})

let handlerRegister: EventRegister.t = EventRegister.make(
  ~contractName,
  ~eventName=name,
)

@genType
type eventFilter = {@as("owner") owner?: SingleOrMultiple.t<Address.t>, @as("tickLower") tickLower?: SingleOrMultiple.t<bigint>, @as("tickUpper") tickUpper?: SingleOrMultiple.t<bigint>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>)

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
  let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["owner","tickLower","tickUpper",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("owner")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("tickLower")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromSignedBigInt)), ~topic3=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("tickUpper")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromSignedBigInt)))
  {
    getEventFiltersOrThrow,
    filterByAddresses,
    dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
    blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
    transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
    convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {owner: decodedEvent.indexed->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickLower: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tickUpper: decodedEvent.indexed->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, sender: decodedEvent.body->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount0: decodedEvent.body->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount1: decodedEvent.body->Js.Array2.unsafe_get(3)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
    id,
  name,
  contractName,
  isWildcard: (handlerRegister->EventRegister.isWildcard),
  handler: handlerRegister->EventRegister.getHandler,
  contractRegister: handlerRegister->EventRegister.getContractRegister,
  paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
  }
}
}

module Swap = {

let id = "0xc42079f94a6350d7e6235f29174924f928cc2ac818eb64fed8004e115fbcca67_3"
let sighash = "0xc42079f94a6350d7e6235f29174924f928cc2ac818eb64fed8004e115fbcca67"
let name = "Swap"
let contractName = contractName

@genType
type eventArgs = {sender: Address.t, recipient: Address.t, amount0: bigint, amount1: bigint, sqrtPriceX96: bigint, liquidity: bigint, tick: bigint}
@genType
type block = {number: int, timestamp: int, hash: string}
@genType
type transaction = {hash: string, gasPrice: option<bigint>, from: option<Address.t>}

@genType
type event = {
  /** The parameters or arguments associated with this event. */
  params: eventArgs,
  /** The unique identifier of the blockchain network where this event occurred. */
  chainId: chainId,
  /** The address of the contract that emitted this event. */
  srcAddress: Address.t,
  /** The index of this event's log within the block. */
  logIndex: int,
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  transaction: transaction,
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  block: block,
}

@genType
type handlerArgs = Internal.genericHandlerArgs<event, handlerContext, unit>
@genType
type handler = Internal.genericHandler<handlerArgs>
@genType
type contractRegister = Internal.genericContractRegister<Internal.genericContractRegisterArgs<event, contractRegistrations>>

let paramsRawEventSchema = S.object((s): eventArgs => {sender: s.field("sender", Address.schema), recipient: s.field("recipient", Address.schema), amount0: s.field("amount0", BigInt.schema), amount1: s.field("amount1", BigInt.schema), sqrtPriceX96: s.field("sqrtPriceX96", BigInt.schema), liquidity: s.field("liquidity", BigInt.schema), tick: s.field("tick", BigInt.schema)})
let blockSchema = S.object((s): block => {number: s.field("number", S.int), timestamp: s.field("timestamp", S.int), hash: s.field("hash", S.string)})
let transactionSchema = S.object((s): transaction => {hash: s.field("hash", S.string), gasPrice: s.field("gasPrice", S.nullable(BigInt.nativeSchema)), from: s.field("from", S.nullable(Address.schema))})

let handlerRegister: EventRegister.t = EventRegister.make(
  ~contractName,
  ~eventName=name,
)

@genType
type eventFilter = {@as("sender") sender?: SingleOrMultiple.t<Address.t>, @as("recipient") recipient?: SingleOrMultiple.t<Address.t>}

@genType type eventFiltersArgs = {/** The unique identifier of the blockchain network where this event occurred. */ chainId: chainId, /** Addresses of the contracts indexing the event. */ addresses: array<Address.t>}

@genType @unboxed type eventFiltersDefinition = Single(eventFilter) | Multiple(array<eventFilter>)

@genType @unboxed type eventFilters = | ...eventFiltersDefinition | Dynamic(eventFiltersArgs => eventFiltersDefinition)

let register = (): Internal.evmEventConfig => {
  let {getEventFiltersOrThrow, filterByAddresses} = LogSelection.parseEventFiltersOrThrow(~eventFilters=handlerRegister->EventRegister.getEventFilters, ~sighash, ~params=["sender","recipient",], ~topic1=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("sender")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)), ~topic2=(_eventFilter) => _eventFilter->Utils.Dict.dangerouslyGetNonOption("recipient")->Belt.Option.mapWithDefault([], topicFilters => topicFilters->Obj.magic->SingleOrMultiple.normalizeOrThrow->Belt.Array.map(TopicFilter.fromAddress)))
  {
    getEventFiltersOrThrow,
    filterByAddresses,
    dependsOnAddresses: !(handlerRegister->EventRegister.isWildcard) || filterByAddresses,
    blockSchema: blockSchema->(Utils.magic: S.t<block> => S.t<Internal.eventBlock>),
    transactionSchema: transactionSchema->(Utils.magic: S.t<transaction> => S.t<Internal.eventTransaction>),
    convertHyperSyncEventArgs: (decodedEvent: HyperSyncClient.Decoder.decodedEvent) => {sender: decodedEvent.indexed->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, recipient: decodedEvent.indexed->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount0: decodedEvent.body->Js.Array2.unsafe_get(0)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, amount1: decodedEvent.body->Js.Array2.unsafe_get(1)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, sqrtPriceX96: decodedEvent.body->Js.Array2.unsafe_get(2)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, liquidity: decodedEvent.body->Js.Array2.unsafe_get(3)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, tick: decodedEvent.body->Js.Array2.unsafe_get(4)->HyperSyncClient.Decoder.toUnderlying->Utils.magic, }->(Utils.magic: eventArgs => Internal.eventParams),
    id,
  name,
  contractName,
  isWildcard: (handlerRegister->EventRegister.isWildcard),
  handler: handlerRegister->EventRegister.getHandler,
  contractRegister: handlerRegister->EventRegister.getContractRegister,
  paramsRawEventSchema: paramsRawEventSchema->(Utils.magic: S.t<eventArgs> => S.t<Internal.eventParams>),
  }
}
}
}

@genType
type chainId = int

@genType
type chain = [#1]
