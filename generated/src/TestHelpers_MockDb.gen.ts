/* TypeScript file generated from TestHelpers_MockDb.res by genType. */

/* eslint-disable */
/* tslint:disable */

const TestHelpers_MockDbJS = require('./TestHelpers_MockDb.res.js');

import type {Bundle_t as Entities_Bundle_t} from '../src/db/Entities.gen';

import type {Burn_t as Entities_Burn_t} from '../src/db/Entities.gen';

import type {Collect_t as Entities_Collect_t} from '../src/db/Entities.gen';

import type {DynamicContractRegistry_t as InternalTable_DynamicContractRegistry_t} from 'envio/src/db/InternalTable.gen';

import type {Factory_t as Entities_Factory_t} from '../src/db/Entities.gen';

import type {Mint_t as Entities_Mint_t} from '../src/db/Entities.gen';

import type {PoolDayData_t as Entities_PoolDayData_t} from '../src/db/Entities.gen';

import type {PoolHourData_t as Entities_PoolHourData_t} from '../src/db/Entities.gen';

import type {Pool_t as Entities_Pool_t} from '../src/db/Entities.gen';

import type {RawEvents_t as InternalTable_RawEvents_t} from 'envio/src/db/InternalTable.gen';

import type {Swap_t as Entities_Swap_t} from '../src/db/Entities.gen';

import type {Tick_t as Entities_Tick_t} from '../src/db/Entities.gen';

import type {TokenDayData_t as Entities_TokenDayData_t} from '../src/db/Entities.gen';

import type {TokenHourData_t as Entities_TokenHourData_t} from '../src/db/Entities.gen';

import type {Token_t as Entities_Token_t} from '../src/db/Entities.gen';

import type {Transaction_t as Entities_Transaction_t} from '../src/db/Entities.gen';

import type {UniswapDayData_t as Entities_UniswapDayData_t} from '../src/db/Entities.gen';

import type {eventLog as Types_eventLog} from './Types.gen';

import type {rawEventsKey as InMemoryStore_rawEventsKey} from './InMemoryStore.gen';

/** The mockDb type is simply an InMemoryStore internally. __dbInternal__ holds a reference
to an inMemoryStore and all the the accessor methods point to the reference of that inMemory
store */
export abstract class inMemoryStore { protected opaque!: any }; /* simulate opaque types */

export type t = {
  readonly __dbInternal__: inMemoryStore; 
  readonly entities: entities; 
  readonly rawEvents: storeOperations<InMemoryStore_rawEventsKey,InternalTable_RawEvents_t>; 
  readonly dynamicContractRegistry: entityStoreOperations<InternalTable_DynamicContractRegistry_t>; 
  readonly processEvents: (_1:Types_eventLog<unknown>[]) => Promise<t>
};

export type entities = {
  readonly Bundle: entityStoreOperations<Entities_Bundle_t>; 
  readonly Burn: entityStoreOperations<Entities_Burn_t>; 
  readonly Collect: entityStoreOperations<Entities_Collect_t>; 
  readonly Factory: entityStoreOperations<Entities_Factory_t>; 
  readonly Mint: entityStoreOperations<Entities_Mint_t>; 
  readonly Pool: entityStoreOperations<Entities_Pool_t>; 
  readonly PoolDayData: entityStoreOperations<Entities_PoolDayData_t>; 
  readonly PoolHourData: entityStoreOperations<Entities_PoolHourData_t>; 
  readonly Swap: entityStoreOperations<Entities_Swap_t>; 
  readonly Tick: entityStoreOperations<Entities_Tick_t>; 
  readonly Token: entityStoreOperations<Entities_Token_t>; 
  readonly TokenDayData: entityStoreOperations<Entities_TokenDayData_t>; 
  readonly TokenHourData: entityStoreOperations<Entities_TokenHourData_t>; 
  readonly Transaction: entityStoreOperations<Entities_Transaction_t>; 
  readonly UniswapDayData: entityStoreOperations<Entities_UniswapDayData_t>
};

export type entityStoreOperations<entity> = storeOperations<string,entity>;

export type storeOperations<entityKey,entity> = {
  readonly getAll: () => entity[]; 
  readonly get: (_1:entityKey) => (undefined | entity); 
  readonly set: (_1:entity) => t; 
  readonly delete: (_1:entityKey) => t
};

/** The constructor function for a mockDb. Call it and then set up the inital state by calling
any of the set functions it provides access to. A mockDb will be passed into a processEvent 
helper. Note, process event helpers will not mutate the mockDb but return a new mockDb with
new state so you can compare states before and after. */
export const createMockDb: () => t = TestHelpers_MockDbJS.createMockDb as any;
