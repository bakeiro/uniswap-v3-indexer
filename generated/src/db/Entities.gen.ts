/* TypeScript file generated from Entities.res by genType. */

/* eslint-disable */
/* tslint:disable */

import type {t as BigDecimal_t} from 'envio/src/bindings/BigDecimal.gen';

export type id = string;

export type whereOperations<entity,fieldType> = { readonly eq: (_1:fieldType) => Promise<entity[]>; readonly gt: (_1:fieldType) => Promise<entity[]> };

export type Pool_t = { readonly id: id };

export type Pool_indexedFieldOperations = {};

export type Tick_t = {
  readonly createdAtBlockNumber: bigint; 
  readonly createdAtTimestamp: bigint; 
  readonly id: id; 
  readonly liquidityGross: bigint; 
  readonly liquidityNet: bigint; 
  readonly pool_id: id; 
  readonly poolAddress: (undefined | string); 
  readonly price0: BigDecimal_t; 
  readonly price1: BigDecimal_t; 
  readonly tickIdx: bigint
};

export type Tick_indexedFieldOperations = {
  readonly createdAtBlockNumber: whereOperations<Tick_t,bigint>; 
  readonly createdAtTimestamp: whereOperations<Tick_t,bigint>; 
  readonly pool_id: whereOperations<Tick_t,id>; 
  readonly poolAddress: whereOperations<Tick_t,(undefined | string)>; 
  readonly tickIdx: whereOperations<Tick_t,bigint>
};
