/* TypeScript file generated from Types.res by genType. */

/* eslint-disable */
/* tslint:disable */

import type {Bundle_t as Entities_Bundle_t} from '../src/db/Entities.gen';

import type {Burn_t as Entities_Burn_t} from '../src/db/Entities.gen';

import type {Collect_t as Entities_Collect_t} from '../src/db/Entities.gen';

import type {Factory_t as Entities_Factory_t} from '../src/db/Entities.gen';

import type {HandlerContext as $$handlerContext} from './Types.ts';

import type {HandlerWithOptions as $$fnWithEventConfig} from './bindings/OpaqueTypes.ts';

import type {Mint_t as Entities_Mint_t} from '../src/db/Entities.gen';

import type {PoolDayData_t as Entities_PoolDayData_t} from '../src/db/Entities.gen';

import type {PoolHourData_t as Entities_PoolHourData_t} from '../src/db/Entities.gen';

import type {Pool_t as Entities_Pool_t} from '../src/db/Entities.gen';

import type {SingleOrMultiple as $$SingleOrMultiple_t} from './bindings/OpaqueTypes';

import type {Swap_t as Entities_Swap_t} from '../src/db/Entities.gen';

import type {Tick_t as Entities_Tick_t} from '../src/db/Entities.gen';

import type {TokenDayData_t as Entities_TokenDayData_t} from '../src/db/Entities.gen';

import type {TokenHourData_t as Entities_TokenHourData_t} from '../src/db/Entities.gen';

import type {Token_t as Entities_Token_t} from '../src/db/Entities.gen';

import type {Transaction_t as Entities_Transaction_t} from '../src/db/Entities.gen';

import type {UniswapDayData_t as Entities_UniswapDayData_t} from '../src/db/Entities.gen';

import type {eventOptions as Internal_eventOptions} from 'envio/src/Internal.gen';

import type {genericContractRegisterArgs as Internal_genericContractRegisterArgs} from 'envio/src/Internal.gen';

import type {genericContractRegister as Internal_genericContractRegister} from 'envio/src/Internal.gen';

import type {genericEvent as Internal_genericEvent} from 'envio/src/Internal.gen';

import type {genericHandlerArgs as Internal_genericHandlerArgs} from 'envio/src/Internal.gen';

import type {genericHandler as Internal_genericHandler} from 'envio/src/Internal.gen';

import type {logger as Envio_logger} from 'envio/src/Envio.gen';

import type {noEventFilters as Internal_noEventFilters} from 'envio/src/Internal.gen';

import type {t as Address_t} from 'envio/src/Address.gen';

export type id = string;
export type Id = id;

export type contractRegistrations = {
  readonly log: Envio_logger; 
  readonly addUniswapV3Factory: (_1:Address_t) => void; 
  readonly addUniswapV3Pool: (_1:Address_t) => void
};

export type entityHandlerContext<entity,indexedFieldOperations> = {
  readonly get: (_1:id) => Promise<(undefined | entity)>; 
  readonly getOrThrow: (_1:id, message:(undefined | string)) => Promise<entity>; 
  readonly getWhere: indexedFieldOperations; 
  readonly getOrCreate: (_1:entity) => Promise<entity>; 
  readonly set: (_1:entity) => void; 
  readonly deleteUnsafe: (_1:id) => void
};

export type handlerContext = $$handlerContext;

export type bundle = Entities_Bundle_t;
export type Bundle = bundle;

export type burn = Entities_Burn_t;
export type Burn = burn;

export type collect = Entities_Collect_t;
export type Collect = collect;

export type factory = Entities_Factory_t;
export type Factory = factory;

export type mint = Entities_Mint_t;
export type Mint = mint;

export type pool = Entities_Pool_t;
export type Pool = pool;

export type poolDayData = Entities_PoolDayData_t;
export type PoolDayData = poolDayData;

export type poolHourData = Entities_PoolHourData_t;
export type PoolHourData = poolHourData;

export type swap = Entities_Swap_t;
export type Swap = swap;

export type tick = Entities_Tick_t;
export type Tick = tick;

export type token = Entities_Token_t;
export type Token = token;

export type tokenDayData = Entities_TokenDayData_t;
export type TokenDayData = tokenDayData;

export type tokenHourData = Entities_TokenHourData_t;
export type TokenHourData = tokenHourData;

export type transaction = Entities_Transaction_t;
export type Transaction = transaction;

export type uniswapDayData = Entities_UniswapDayData_t;
export type UniswapDayData = uniswapDayData;

export type Transaction_t = {};

export type Block_t = {
  readonly number: number; 
  readonly timestamp: number; 
  readonly hash: string
};

export type AggregatedBlock_t = {
  readonly hash: string; 
  readonly number: number; 
  readonly timestamp: number
};

export type AggregatedTransaction_t = {
  readonly from: (undefined | Address_t); 
  readonly gasPrice: (undefined | bigint); 
  readonly hash: string
};

export type eventLog<params> = Internal_genericEvent<params,Block_t,Transaction_t>;
export type EventLog<params> = eventLog<params>;

export type SingleOrMultiple_t<a> = $$SingleOrMultiple_t<a>;

export type HandlerTypes_args<eventArgs,context> = { readonly event: eventLog<eventArgs>; readonly context: context };

export type HandlerTypes_contractRegisterArgs<eventArgs> = Internal_genericContractRegisterArgs<eventLog<eventArgs>,contractRegistrations>;

export type HandlerTypes_contractRegister<eventArgs> = Internal_genericContractRegister<HandlerTypes_contractRegisterArgs<eventArgs>>;

export type HandlerTypes_eventConfig<eventFilters> = Internal_eventOptions<eventFilters>;

export type fnWithEventConfig<fn,eventConfig> = $$fnWithEventConfig<fn,eventConfig>;

export type contractRegisterWithOptions<eventArgs,eventFilters> = fnWithEventConfig<HandlerTypes_contractRegister<eventArgs>,HandlerTypes_eventConfig<eventFilters>>;

export type UniswapV3Factory_chainId = 1;

export type UniswapV3Factory_PoolCreated_eventArgs = {
  readonly token0: Address_t; 
  readonly token1: Address_t; 
  readonly fee: bigint; 
  readonly tickSpacing: bigint; 
  readonly pool: Address_t
};

export type UniswapV3Factory_PoolCreated_block = Block_t;

export type UniswapV3Factory_PoolCreated_transaction = Transaction_t;

export type UniswapV3Factory_PoolCreated_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: UniswapV3Factory_PoolCreated_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: UniswapV3Factory_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: UniswapV3Factory_PoolCreated_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: UniswapV3Factory_PoolCreated_block
};

export type UniswapV3Factory_PoolCreated_handlerArgs = Internal_genericHandlerArgs<UniswapV3Factory_PoolCreated_event,handlerContext,void>;

export type UniswapV3Factory_PoolCreated_handler = Internal_genericHandler<UniswapV3Factory_PoolCreated_handlerArgs>;

export type UniswapV3Factory_PoolCreated_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<UniswapV3Factory_PoolCreated_event,contractRegistrations>>;

export type UniswapV3Factory_PoolCreated_eventFilter = {
  readonly token0?: SingleOrMultiple_t<Address_t>; 
  readonly token1?: SingleOrMultiple_t<Address_t>; 
  readonly fee?: SingleOrMultiple_t<bigint>
};

export type UniswapV3Factory_PoolCreated_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: UniswapV3Factory_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type UniswapV3Factory_PoolCreated_eventFiltersDefinition = 
    UniswapV3Factory_PoolCreated_eventFilter
  | UniswapV3Factory_PoolCreated_eventFilter[];

export type UniswapV3Factory_PoolCreated_eventFilters = 
    UniswapV3Factory_PoolCreated_eventFilter
  | UniswapV3Factory_PoolCreated_eventFilter[]
  | ((_1:UniswapV3Factory_PoolCreated_eventFiltersArgs) => UniswapV3Factory_PoolCreated_eventFiltersDefinition);

export type UniswapV3Pool_chainId = 1;

export type UniswapV3Pool_Initialize_eventArgs = { readonly sqrtPriceX96: bigint; readonly tick: bigint };

export type UniswapV3Pool_Initialize_block = Block_t;

export type UniswapV3Pool_Initialize_transaction = Transaction_t;

export type UniswapV3Pool_Initialize_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: UniswapV3Pool_Initialize_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: UniswapV3Pool_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: UniswapV3Pool_Initialize_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: UniswapV3Pool_Initialize_block
};

export type UniswapV3Pool_Initialize_handlerArgs = Internal_genericHandlerArgs<UniswapV3Pool_Initialize_event,handlerContext,void>;

export type UniswapV3Pool_Initialize_handler = Internal_genericHandler<UniswapV3Pool_Initialize_handlerArgs>;

export type UniswapV3Pool_Initialize_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<UniswapV3Pool_Initialize_event,contractRegistrations>>;

export type UniswapV3Pool_Initialize_eventFilter = {};

export type UniswapV3Pool_Initialize_eventFilters = Internal_noEventFilters;

export type UniswapV3Pool_Collect_eventArgs = {
  readonly owner: Address_t; 
  readonly recipient: Address_t; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly amount0: bigint; 
  readonly amount1: bigint
};

export type UniswapV3Pool_Collect_block = {
  readonly number: number; 
  readonly timestamp: number; 
  readonly hash: string
};

export type UniswapV3Pool_Collect_transaction = { readonly hash: string; readonly gasPrice: (undefined | bigint) };

export type UniswapV3Pool_Collect_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: UniswapV3Pool_Collect_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: UniswapV3Pool_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: UniswapV3Pool_Collect_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: UniswapV3Pool_Collect_block
};

export type UniswapV3Pool_Collect_handlerArgs = Internal_genericHandlerArgs<UniswapV3Pool_Collect_event,handlerContext,void>;

export type UniswapV3Pool_Collect_handler = Internal_genericHandler<UniswapV3Pool_Collect_handlerArgs>;

export type UniswapV3Pool_Collect_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<UniswapV3Pool_Collect_event,contractRegistrations>>;

export type UniswapV3Pool_Collect_eventFilter = {
  readonly owner?: SingleOrMultiple_t<Address_t>; 
  readonly tickLower?: SingleOrMultiple_t<bigint>; 
  readonly tickUpper?: SingleOrMultiple_t<bigint>
};

export type UniswapV3Pool_Collect_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: UniswapV3Pool_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type UniswapV3Pool_Collect_eventFiltersDefinition = 
    UniswapV3Pool_Collect_eventFilter
  | UniswapV3Pool_Collect_eventFilter[];

export type UniswapV3Pool_Collect_eventFilters = 
    UniswapV3Pool_Collect_eventFilter
  | UniswapV3Pool_Collect_eventFilter[]
  | ((_1:UniswapV3Pool_Collect_eventFiltersArgs) => UniswapV3Pool_Collect_eventFiltersDefinition);

export type UniswapV3Pool_Burn_eventArgs = {
  readonly owner: Address_t; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly amount: bigint; 
  readonly amount0: bigint; 
  readonly amount1: bigint
};

export type UniswapV3Pool_Burn_block = {
  readonly number: number; 
  readonly timestamp: number; 
  readonly hash: string
};

export type UniswapV3Pool_Burn_transaction = {
  readonly hash: string; 
  readonly gasPrice: (undefined | bigint); 
  readonly from: (undefined | Address_t)
};

export type UniswapV3Pool_Burn_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: UniswapV3Pool_Burn_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: UniswapV3Pool_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: UniswapV3Pool_Burn_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: UniswapV3Pool_Burn_block
};

export type UniswapV3Pool_Burn_handlerArgs = Internal_genericHandlerArgs<UniswapV3Pool_Burn_event,handlerContext,void>;

export type UniswapV3Pool_Burn_handler = Internal_genericHandler<UniswapV3Pool_Burn_handlerArgs>;

export type UniswapV3Pool_Burn_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<UniswapV3Pool_Burn_event,contractRegistrations>>;

export type UniswapV3Pool_Burn_eventFilter = {
  readonly owner?: SingleOrMultiple_t<Address_t>; 
  readonly tickLower?: SingleOrMultiple_t<bigint>; 
  readonly tickUpper?: SingleOrMultiple_t<bigint>
};

export type UniswapV3Pool_Burn_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: UniswapV3Pool_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type UniswapV3Pool_Burn_eventFiltersDefinition = 
    UniswapV3Pool_Burn_eventFilter
  | UniswapV3Pool_Burn_eventFilter[];

export type UniswapV3Pool_Burn_eventFilters = 
    UniswapV3Pool_Burn_eventFilter
  | UniswapV3Pool_Burn_eventFilter[]
  | ((_1:UniswapV3Pool_Burn_eventFiltersArgs) => UniswapV3Pool_Burn_eventFiltersDefinition);

export type UniswapV3Pool_Mint_eventArgs = {
  readonly sender: Address_t; 
  readonly owner: Address_t; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly amount: bigint; 
  readonly amount0: bigint; 
  readonly amount1: bigint
};

export type UniswapV3Pool_Mint_block = {
  readonly number: number; 
  readonly timestamp: number; 
  readonly hash: string
};

export type UniswapV3Pool_Mint_transaction = {
  readonly hash: string; 
  readonly gasPrice: (undefined | bigint); 
  readonly from: (undefined | Address_t)
};

export type UniswapV3Pool_Mint_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: UniswapV3Pool_Mint_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: UniswapV3Pool_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: UniswapV3Pool_Mint_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: UniswapV3Pool_Mint_block
};

export type UniswapV3Pool_Mint_handlerArgs = Internal_genericHandlerArgs<UniswapV3Pool_Mint_event,handlerContext,void>;

export type UniswapV3Pool_Mint_handler = Internal_genericHandler<UniswapV3Pool_Mint_handlerArgs>;

export type UniswapV3Pool_Mint_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<UniswapV3Pool_Mint_event,contractRegistrations>>;

export type UniswapV3Pool_Mint_eventFilter = {
  readonly owner?: SingleOrMultiple_t<Address_t>; 
  readonly tickLower?: SingleOrMultiple_t<bigint>; 
  readonly tickUpper?: SingleOrMultiple_t<bigint>
};

export type UniswapV3Pool_Mint_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: UniswapV3Pool_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type UniswapV3Pool_Mint_eventFiltersDefinition = 
    UniswapV3Pool_Mint_eventFilter
  | UniswapV3Pool_Mint_eventFilter[];

export type UniswapV3Pool_Mint_eventFilters = 
    UniswapV3Pool_Mint_eventFilter
  | UniswapV3Pool_Mint_eventFilter[]
  | ((_1:UniswapV3Pool_Mint_eventFiltersArgs) => UniswapV3Pool_Mint_eventFiltersDefinition);

export type UniswapV3Pool_Swap_eventArgs = {
  readonly sender: Address_t; 
  readonly recipient: Address_t; 
  readonly amount0: bigint; 
  readonly amount1: bigint; 
  readonly sqrtPriceX96: bigint; 
  readonly liquidity: bigint; 
  readonly tick: bigint
};

export type UniswapV3Pool_Swap_block = {
  readonly number: number; 
  readonly timestamp: number; 
  readonly hash: string
};

export type UniswapV3Pool_Swap_transaction = {
  readonly hash: string; 
  readonly gasPrice: (undefined | bigint); 
  readonly from: (undefined | Address_t)
};

export type UniswapV3Pool_Swap_event = {
  /** The parameters or arguments associated with this event. */
  readonly params: UniswapV3Pool_Swap_eventArgs; 
  /** The unique identifier of the blockchain network where this event occurred. */
  readonly chainId: UniswapV3Pool_chainId; 
  /** The address of the contract that emitted this event. */
  readonly srcAddress: Address_t; 
  /** The index of this event's log within the block. */
  readonly logIndex: number; 
  /** The transaction that triggered this event. Configurable in `config.yaml` via the `field_selection` option. */
  readonly transaction: UniswapV3Pool_Swap_transaction; 
  /** The block in which this event was recorded. Configurable in `config.yaml` via the `field_selection` option. */
  readonly block: UniswapV3Pool_Swap_block
};

export type UniswapV3Pool_Swap_handlerArgs = Internal_genericHandlerArgs<UniswapV3Pool_Swap_event,handlerContext,void>;

export type UniswapV3Pool_Swap_handler = Internal_genericHandler<UniswapV3Pool_Swap_handlerArgs>;

export type UniswapV3Pool_Swap_contractRegister = Internal_genericContractRegister<Internal_genericContractRegisterArgs<UniswapV3Pool_Swap_event,contractRegistrations>>;

export type UniswapV3Pool_Swap_eventFilter = { readonly sender?: SingleOrMultiple_t<Address_t>; readonly recipient?: SingleOrMultiple_t<Address_t> };

export type UniswapV3Pool_Swap_eventFiltersArgs = { 
/** The unique identifier of the blockchain network where this event occurred. */
readonly chainId: UniswapV3Pool_chainId; 
/** Addresses of the contracts indexing the event. */
readonly addresses: Address_t[] };

export type UniswapV3Pool_Swap_eventFiltersDefinition = 
    UniswapV3Pool_Swap_eventFilter
  | UniswapV3Pool_Swap_eventFilter[];

export type UniswapV3Pool_Swap_eventFilters = 
    UniswapV3Pool_Swap_eventFilter
  | UniswapV3Pool_Swap_eventFilter[]
  | ((_1:UniswapV3Pool_Swap_eventFiltersArgs) => UniswapV3Pool_Swap_eventFiltersDefinition);

export type chainId = number;

export type chain = 1;
