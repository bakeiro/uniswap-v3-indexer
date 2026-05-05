//*************
//***ENTITIES**
//*************
@genType.as("Id")
type id = string

@genType
type contractRegistrations = {
  log: Envio.logger,
  // TODO: only add contracts we've registered for the event in the config
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
  @as("Pool") pool: entityHandlerContext<Entities.Pool.t, Entities.Pool.indexedFieldOperations>,
  @as("Tick") tick: entityHandlerContext<Entities.Tick.t, Entities.Tick.indexedFieldOperations>,
}

//Re-exporting types for backwards compatability
@genType.as("Pool")
type pool = Entities.Pool.t
@genType.as("Tick")
type tick = Entities.Tick.t

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
  type t = {}
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

module UniswapV3Pool = {
let abi = Ethers.makeAbi((%raw(`[{"type":"event","name":"Burn","inputs":[{"name":"owner","type":"address","indexed":true},{"name":"tickLower","type":"int24","indexed":true},{"name":"tickUpper","type":"int24","indexed":true},{"name":"amount","type":"uint128","indexed":false},{"name":"amount0","type":"uint256","indexed":false},{"name":"amount1","type":"uint256","indexed":false}],"anonymous":false},{"type":"event","name":"Mint","inputs":[{"name":"sender","type":"address","indexed":false},{"name":"owner","type":"address","indexed":true},{"name":"tickLower","type":"int24","indexed":true},{"name":"tickUpper","type":"int24","indexed":true},{"name":"amount","type":"uint128","indexed":false},{"name":"amount0","type":"uint256","indexed":false},{"name":"amount1","type":"uint256","indexed":false}],"anonymous":false}]`): Js.Json.t))
let eventSignatures = ["Burn(address indexed owner, int24 indexed tickLower, int24 indexed tickUpper, uint128 amount, uint256 amount0, uint256 amount1)", "Mint(address sender, address indexed owner, int24 indexed tickLower, int24 indexed tickUpper, uint128 amount, uint256 amount0, uint256 amount1)"]
@genType type chainId = [#1]
let contractName = "UniswapV3Pool"

module Mint = {

let id = "0x7a53080ba414158be7ec69b987b5fb7d07dee101fe85488f0853ae16239d0bde_4"
let sighash = "0x7a53080ba414158be7ec69b987b5fb7d07dee101fe85488f0853ae16239d0bde"
let name = "Mint"
let contractName = contractName

@genType
type eventArgs = {sender: Address.t, owner: Address.t, tickLower: bigint, tickUpper: bigint, amount: bigint, amount0: bigint, amount1: bigint}
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

let paramsRawEventSchema = S.object((s): eventArgs => {sender: s.field("sender", Address.schema), owner: s.field("owner", Address.schema), tickLower: s.field("tickLower", BigInt.schema), tickUpper: s.field("tickUpper", BigInt.schema), amount: s.field("amount", BigInt.schema), amount0: s.field("amount0", BigInt.schema), amount1: s.field("amount1", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

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

module Burn = {

let id = "0x0c396cd989a39f4459b5fa1aed6a9a8dcdbc45908acfd67e028cd568da98982c_4"
let sighash = "0x0c396cd989a39f4459b5fa1aed6a9a8dcdbc45908acfd67e028cd568da98982c"
let name = "Burn"
let contractName = contractName

@genType
type eventArgs = {owner: Address.t, tickLower: bigint, tickUpper: bigint, amount: bigint, amount0: bigint, amount1: bigint}
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

let paramsRawEventSchema = S.object((s): eventArgs => {owner: s.field("owner", Address.schema), tickLower: s.field("tickLower", BigInt.schema), tickUpper: s.field("tickUpper", BigInt.schema), amount: s.field("amount", BigInt.schema), amount0: s.field("amount0", BigInt.schema), amount1: s.field("amount1", BigInt.schema)})
let blockSchema = Block.schema
let transactionSchema = Transaction.schema

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
}

@genType
type chainId = int

@genType
type chain = [#1]
