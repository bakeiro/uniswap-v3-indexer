/* TypeScript file generated from Types.res by genType. */

/* eslint-disable */
/* tslint:disable */

import type {HandlerContext as $$handlerContext} from './Types.ts';

import type {HandlerWithOptions as $$fnWithEventConfig} from './bindings/OpaqueTypes.ts';

import type {Pool_t as Entities_Pool_t} from '../src/db/Entities.gen';

import type {SingleOrMultiple as $$SingleOrMultiple_t} from './bindings/OpaqueTypes';

import type {Tick_t as Entities_Tick_t} from '../src/db/Entities.gen';

import type {eventOptions as Internal_eventOptions} from 'envio/src/Internal.gen';

import type {genericContractRegisterArgs as Internal_genericContractRegisterArgs} from 'envio/src/Internal.gen';

import type {genericContractRegister as Internal_genericContractRegister} from 'envio/src/Internal.gen';

import type {genericEvent as Internal_genericEvent} from 'envio/src/Internal.gen';

import type {genericHandlerArgs as Internal_genericHandlerArgs} from 'envio/src/Internal.gen';

import type {genericHandler as Internal_genericHandler} from 'envio/src/Internal.gen';

import type {logger as Envio_logger} from 'envio/src/Envio.gen';

import type {t as Address_t} from 'envio/src/Address.gen';

export type id = string;
export type Id = id;

export type contractRegistrations = { readonly log: Envio_logger; readonly addUniswapV3Pool: (_1:Address_t) => void };

export type entityHandlerContext<entity,indexedFieldOperations> = {
  readonly get: (_1:id) => Promise<(undefined | entity)>; 
  readonly getOrThrow: (_1:id, message:(undefined | string)) => Promise<entity>; 
  readonly getWhere: indexedFieldOperations; 
  readonly getOrCreate: (_1:entity) => Promise<entity>; 
  readonly set: (_1:entity) => void; 
  readonly deleteUnsafe: (_1:id) => void
};

export type handlerContext = $$handlerContext;

export type pool = Entities_Pool_t;
export type Pool = pool;

export type tick = Entities_Tick_t;
export type Tick = tick;

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

export type AggregatedTransaction_t = {};

export type eventLog<params> = Internal_genericEvent<params,Block_t,Transaction_t>;
export type EventLog<params> = eventLog<params>;

export type SingleOrMultiple_t<a> = $$SingleOrMultiple_t<a>;

export type HandlerTypes_args<eventArgs,context> = { readonly event: eventLog<eventArgs>; readonly context: context };

export type HandlerTypes_contractRegisterArgs<eventArgs> = Internal_genericContractRegisterArgs<eventLog<eventArgs>,contractRegistrations>;

export type HandlerTypes_contractRegister<eventArgs> = Internal_genericContractRegister<HandlerTypes_contractRegisterArgs<eventArgs>>;

export type HandlerTypes_eventConfig<eventFilters> = Internal_eventOptions<eventFilters>;

export type fnWithEventConfig<fn,eventConfig> = $$fnWithEventConfig<fn,eventConfig>;

export type contractRegisterWithOptions<eventArgs,eventFilters> = fnWithEventConfig<HandlerTypes_contractRegister<eventArgs>,HandlerTypes_eventConfig<eventFilters>>;

export type UniswapV3Pool_chainId = 1;

export type UniswapV3Pool_Mint_eventArgs = {
  readonly sender: Address_t; 
  readonly owner: Address_t; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly amount: bigint; 
  readonly amount0: bigint; 
  readonly amount1: bigint
};

export type UniswapV3Pool_Mint_block = Block_t;

export type UniswapV3Pool_Mint_transaction = Transaction_t;

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

export type UniswapV3Pool_Burn_eventArgs = {
  readonly owner: Address_t; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly amount: bigint; 
  readonly amount0: bigint; 
  readonly amount1: bigint
};

export type UniswapV3Pool_Burn_block = Block_t;

export type UniswapV3Pool_Burn_transaction = Transaction_t;

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

export type chainId = number;

export type chain = 1;
