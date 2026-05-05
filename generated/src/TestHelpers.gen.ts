/* TypeScript file generated from TestHelpers.res by genType. */

/* eslint-disable */
/* tslint:disable */

const TestHelpersJS = require('./TestHelpers.res.js');

import type {UniswapV3Pool_Burn_event as Types_UniswapV3Pool_Burn_event} from './Types.gen';

import type {UniswapV3Pool_Mint_event as Types_UniswapV3Pool_Mint_event} from './Types.gen';

import type {t as Address_t} from 'envio/src/Address.gen';

import type {t as TestHelpers_MockDb_t} from './TestHelpers_MockDb.gen';

/** The arguements that get passed to a "processEvent" helper function */
export type EventFunctions_eventProcessorArgs<event> = {
  readonly event: event; 
  readonly mockDb: TestHelpers_MockDb_t; 
  readonly chainId?: number
};

export type EventFunctions_eventProcessor<event> = (_1:EventFunctions_eventProcessorArgs<event>) => Promise<TestHelpers_MockDb_t>;

export type EventFunctions_MockBlock_t = {
  readonly hash?: string; 
  readonly number?: number; 
  readonly timestamp?: number
};

export type EventFunctions_MockTransaction_t = {};

export type EventFunctions_mockEventData = {
  readonly chainId?: number; 
  readonly srcAddress?: Address_t; 
  readonly logIndex?: number; 
  readonly block?: EventFunctions_MockBlock_t; 
  readonly transaction?: EventFunctions_MockTransaction_t
};

export type UniswapV3Pool_Mint_createMockArgs = {
  readonly sender?: Address_t; 
  readonly owner?: Address_t; 
  readonly tickLower?: bigint; 
  readonly tickUpper?: bigint; 
  readonly amount?: bigint; 
  readonly amount0?: bigint; 
  readonly amount1?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export type UniswapV3Pool_Burn_createMockArgs = {
  readonly owner?: Address_t; 
  readonly tickLower?: bigint; 
  readonly tickUpper?: bigint; 
  readonly amount?: bigint; 
  readonly amount0?: bigint; 
  readonly amount1?: bigint; 
  readonly mockEventData?: EventFunctions_mockEventData
};

export const MockDb_createMockDb: () => TestHelpers_MockDb_t = TestHelpersJS.MockDb.createMockDb as any;

export const Addresses_mockAddresses: Address_t[] = TestHelpersJS.Addresses.mockAddresses as any;

export const Addresses_defaultAddress: Address_t = TestHelpersJS.Addresses.defaultAddress as any;

export const UniswapV3Pool_Mint_processEvent: EventFunctions_eventProcessor<Types_UniswapV3Pool_Mint_event> = TestHelpersJS.UniswapV3Pool.Mint.processEvent as any;

export const UniswapV3Pool_Mint_createMockEvent: (args:UniswapV3Pool_Mint_createMockArgs) => Types_UniswapV3Pool_Mint_event = TestHelpersJS.UniswapV3Pool.Mint.createMockEvent as any;

export const UniswapV3Pool_Burn_processEvent: EventFunctions_eventProcessor<Types_UniswapV3Pool_Burn_event> = TestHelpersJS.UniswapV3Pool.Burn.processEvent as any;

export const UniswapV3Pool_Burn_createMockEvent: (args:UniswapV3Pool_Burn_createMockArgs) => Types_UniswapV3Pool_Burn_event = TestHelpersJS.UniswapV3Pool.Burn.createMockEvent as any;

export const Addresses: { mockAddresses: Address_t[]; defaultAddress: Address_t } = TestHelpersJS.Addresses as any;

export const UniswapV3Pool: { Mint: { processEvent: EventFunctions_eventProcessor<Types_UniswapV3Pool_Mint_event>; createMockEvent: (args:UniswapV3Pool_Mint_createMockArgs) => Types_UniswapV3Pool_Mint_event }; Burn: { processEvent: EventFunctions_eventProcessor<Types_UniswapV3Pool_Burn_event>; createMockEvent: (args:UniswapV3Pool_Burn_createMockArgs) => Types_UniswapV3Pool_Burn_event } } = TestHelpersJS.UniswapV3Pool as any;

export const MockDb: { createMockDb: () => TestHelpers_MockDb_t } = TestHelpersJS.MockDb as any;
