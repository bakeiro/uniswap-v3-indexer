/* TypeScript file generated from Entities.res by genType. */

/* eslint-disable */
/* tslint:disable */

import type {t as BigDecimal_t} from 'envio/src/bindings/BigDecimal.gen';

export type id = string;

export type whereOperations<entity,fieldType> = { readonly eq: (_1:fieldType) => Promise<entity[]>; readonly gt: (_1:fieldType) => Promise<entity[]> };

export type Bundle_t = { readonly ethPriceUSD: BigDecimal_t; readonly id: id };

export type Bundle_indexedFieldOperations = {};

export type Burn_t = {
  readonly amount: bigint; 
  readonly amount0: BigDecimal_t; 
  readonly amount1: BigDecimal_t; 
  readonly amountUSD: (undefined | BigDecimal_t); 
  readonly id: id; 
  readonly logIndex: (undefined | bigint); 
  readonly origin: string; 
  readonly owner: (undefined | string); 
  readonly pool_id: id; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly timestamp: bigint; 
  readonly token0_id: id; 
  readonly token1_id: id; 
  readonly transaction_id: id
};

export type Burn_indexedFieldOperations = {
  readonly origin: whereOperations<Burn_t,string>; 
  readonly owner: whereOperations<Burn_t,(undefined | string)>; 
  readonly pool_id: whereOperations<Burn_t,id>; 
  readonly tickLower: whereOperations<Burn_t,bigint>; 
  readonly tickUpper: whereOperations<Burn_t,bigint>; 
  readonly timestamp: whereOperations<Burn_t,bigint>; 
  readonly token0_id: whereOperations<Burn_t,id>; 
  readonly token1_id: whereOperations<Burn_t,id>; 
  readonly transaction_id: whereOperations<Burn_t,id>
};

export type Collect_t = {
  readonly amount0: BigDecimal_t; 
  readonly amount1: BigDecimal_t; 
  readonly amountUSD: (undefined | BigDecimal_t); 
  readonly id: id; 
  readonly logIndex: (undefined | bigint); 
  readonly owner: (undefined | string); 
  readonly pool_id: id; 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly timestamp: bigint; 
  readonly transaction_id: id
};

export type Collect_indexedFieldOperations = {
  readonly owner: whereOperations<Collect_t,(undefined | string)>; 
  readonly pool_id: whereOperations<Collect_t,id>; 
  readonly tickLower: whereOperations<Collect_t,bigint>; 
  readonly tickUpper: whereOperations<Collect_t,bigint>; 
  readonly timestamp: whereOperations<Collect_t,bigint>; 
  readonly transaction_id: whereOperations<Collect_t,id>
};

export type Factory_t = {
  readonly id: id; 
  readonly numberOfSwaps: bigint; 
  readonly owner: id; 
  readonly poolCount: bigint; 
  readonly totalFeesETH: BigDecimal_t; 
  readonly totalFeesUSD: BigDecimal_t; 
  readonly totalValueLockedETH: BigDecimal_t; 
  readonly totalValueLockedETHUntracked: BigDecimal_t; 
  readonly totalValueLockedUSD: BigDecimal_t; 
  readonly totalValueLockedUSDUntracked: BigDecimal_t; 
  readonly totalVolumeETH: BigDecimal_t; 
  readonly totalVolumeUSD: BigDecimal_t; 
  readonly txCount: bigint; 
  readonly untrackedVolumeUSD: BigDecimal_t
};

export type Factory_indexedFieldOperations = {};

export type Mint_t = {
  readonly amount: bigint; 
  readonly amount0: BigDecimal_t; 
  readonly amount1: BigDecimal_t; 
  readonly amountUSD: (undefined | BigDecimal_t); 
  readonly id: id; 
  readonly logIndex: (undefined | bigint); 
  readonly origin: string; 
  readonly owner: string; 
  readonly pool_id: id; 
  readonly sender: (undefined | string); 
  readonly tickLower: bigint; 
  readonly tickUpper: bigint; 
  readonly timestamp: bigint; 
  readonly token0_id: id; 
  readonly token1_id: id; 
  readonly transaction_id: id
};

export type Mint_indexedFieldOperations = {
  readonly origin: whereOperations<Mint_t,string>; 
  readonly owner: whereOperations<Mint_t,string>; 
  readonly pool_id: whereOperations<Mint_t,id>; 
  readonly sender: whereOperations<Mint_t,(undefined | string)>; 
  readonly tickLower: whereOperations<Mint_t,bigint>; 
  readonly tickUpper: whereOperations<Mint_t,bigint>; 
  readonly timestamp: whereOperations<Mint_t,bigint>; 
  readonly token0_id: whereOperations<Mint_t,id>; 
  readonly token1_id: whereOperations<Mint_t,id>; 
  readonly transaction_id: whereOperations<Mint_t,id>
};

export type Pool_t = {
  readonly collectedFeesToken0: BigDecimal_t; 
  readonly collectedFeesToken1: BigDecimal_t; 
  readonly collectedFeesUSD: BigDecimal_t; 
  readonly createdAtBlockNumber: bigint; 
  readonly createdAtTimestamp: bigint; 
  readonly feeTier: bigint; 
  readonly feesUSD: BigDecimal_t; 
  readonly id: id; 
  readonly liquidity: bigint; 
  readonly liquidityProviderCount: bigint; 
  readonly observationIndex: bigint; 
  readonly sqrtPrice: bigint; 
  readonly tick: (undefined | bigint); 
  readonly token0_id: id; 
  readonly token0Price: BigDecimal_t; 
  readonly token1_id: id; 
  readonly token1Price: BigDecimal_t; 
  readonly totalValueLockedETH: BigDecimal_t; 
  readonly totalValueLockedToken0: BigDecimal_t; 
  readonly totalValueLockedToken1: BigDecimal_t; 
  readonly totalValueLockedUSD: BigDecimal_t; 
  readonly totalValueLockedUSDUntracked: BigDecimal_t; 
  readonly txCount: bigint; 
  readonly untrackedVolumeUSD: BigDecimal_t; 
  readonly volumeToken0: BigDecimal_t; 
  readonly volumeToken1: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t
};

export type Pool_indexedFieldOperations = {
  readonly createdAtBlockNumber: whereOperations<Pool_t,bigint>; 
  readonly createdAtTimestamp: whereOperations<Pool_t,bigint>; 
  readonly feeTier: whereOperations<Pool_t,bigint>; 
  readonly token0_id: whereOperations<Pool_t,id>; 
  readonly token1_id: whereOperations<Pool_t,id>
};

export type PoolDayData_t = {
  readonly close: BigDecimal_t; 
  readonly date: number; 
  readonly feesUSD: BigDecimal_t; 
  readonly high: BigDecimal_t; 
  readonly id: id; 
  readonly liquidity: bigint; 
  readonly low: BigDecimal_t; 
  readonly openingPrice: BigDecimal_t; 
  readonly pool_id: id; 
  readonly sqrtPrice: bigint; 
  readonly tick: (undefined | bigint); 
  readonly token0Price: BigDecimal_t; 
  readonly token1Price: BigDecimal_t; 
  readonly tvlUSD: BigDecimal_t; 
  readonly txCount: bigint; 
  readonly volumeToken0: BigDecimal_t; 
  readonly volumeToken1: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t
};

export type PoolDayData_indexedFieldOperations = { readonly date: whereOperations<PoolDayData_t,number>; readonly pool_id: whereOperations<PoolDayData_t,id> };

export type PoolHourData_t = {
  readonly close: BigDecimal_t; 
  readonly feesUSD: BigDecimal_t; 
  readonly high: BigDecimal_t; 
  readonly id: id; 
  readonly liquidity: bigint; 
  readonly low: BigDecimal_t; 
  readonly openingPrice: BigDecimal_t; 
  readonly periodStartUnix: number; 
  readonly pool_id: id; 
  readonly sqrtPrice: bigint; 
  readonly tick: (undefined | bigint); 
  readonly token0Price: BigDecimal_t; 
  readonly token1Price: BigDecimal_t; 
  readonly tvlUSD: BigDecimal_t; 
  readonly txCount: bigint; 
  readonly volumeToken0: BigDecimal_t; 
  readonly volumeToken1: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t
};

export type PoolHourData_indexedFieldOperations = { readonly periodStartUnix: whereOperations<PoolHourData_t,number>; readonly pool_id: whereOperations<PoolHourData_t,id> };

export type Swap_t = {
  readonly amount0: BigDecimal_t; 
  readonly amount1: BigDecimal_t; 
  readonly amountUSD: BigDecimal_t; 
  readonly id: id; 
  readonly logIndex: (undefined | bigint); 
  readonly origin: string; 
  readonly pool_id: id; 
  readonly recipient: string; 
  readonly sender: string; 
  readonly sqrtPriceX96: bigint; 
  readonly tick: bigint; 
  readonly timestamp: bigint; 
  readonly token0_id: id; 
  readonly token1_id: id; 
  readonly transaction_id: id
};

export type Swap_indexedFieldOperations = {
  readonly origin: whereOperations<Swap_t,string>; 
  readonly pool_id: whereOperations<Swap_t,id>; 
  readonly recipient: whereOperations<Swap_t,string>; 
  readonly sender: whereOperations<Swap_t,string>; 
  readonly tick: whereOperations<Swap_t,bigint>; 
  readonly timestamp: whereOperations<Swap_t,bigint>; 
  readonly token0_id: whereOperations<Swap_t,id>; 
  readonly token1_id: whereOperations<Swap_t,id>; 
  readonly transaction_id: whereOperations<Swap_t,id>
};

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

export type Token_t = {
  readonly decimals: bigint; 
  readonly derivedETH: BigDecimal_t; 
  readonly feesUSD: BigDecimal_t; 
  readonly id: id; 
  readonly isWhitelisted: boolean; 
  readonly name: string; 
  readonly poolCount: bigint; 
  readonly symbol: string; 
  readonly totalValueLocked: BigDecimal_t; 
  readonly totalValueLockedUSD: BigDecimal_t; 
  readonly totalValueLockedUSDUntracked: BigDecimal_t; 
  readonly txCount: bigint; 
  readonly untrackedVolumeUSD: BigDecimal_t; 
  readonly volume: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t; 
  readonly whitelistPools: string[]
};

export type Token_indexedFieldOperations = {
  readonly decimals: whereOperations<Token_t,bigint>; 
  readonly isWhitelisted: whereOperations<Token_t,boolean>; 
  readonly poolCount: whereOperations<Token_t,bigint>
};

export type TokenDayData_t = {
  readonly close: BigDecimal_t; 
  readonly date: number; 
  readonly feesUSD: BigDecimal_t; 
  readonly high: BigDecimal_t; 
  readonly id: id; 
  readonly low: BigDecimal_t; 
  readonly openingPrice: BigDecimal_t; 
  readonly priceUSD: BigDecimal_t; 
  readonly token_id: id; 
  readonly totalValueLocked: BigDecimal_t; 
  readonly totalValueLockedUSD: BigDecimal_t; 
  readonly untrackedVolumeUSD: BigDecimal_t; 
  readonly volume: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t
};

export type TokenDayData_indexedFieldOperations = { readonly date: whereOperations<TokenDayData_t,number>; readonly token_id: whereOperations<TokenDayData_t,id> };

export type TokenHourData_t = {
  readonly close: BigDecimal_t; 
  readonly feesUSD: BigDecimal_t; 
  readonly high: BigDecimal_t; 
  readonly id: id; 
  readonly low: BigDecimal_t; 
  readonly openingPrice: BigDecimal_t; 
  readonly periodStartUnix: number; 
  readonly priceUSD: BigDecimal_t; 
  readonly token_id: id; 
  readonly totalValueLocked: BigDecimal_t; 
  readonly totalValueLockedUSD: BigDecimal_t; 
  readonly untrackedVolumeUSD: BigDecimal_t; 
  readonly volume: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t
};

export type TokenHourData_indexedFieldOperations = { readonly periodStartUnix: whereOperations<TokenHourData_t,number>; readonly token_id: whereOperations<TokenHourData_t,id> };

export type Transaction_t = {
  readonly blockNumber: bigint; 
  readonly gasPrice: bigint; 
  readonly gasUsed: bigint; 
  readonly id: id; 
  readonly timestamp: bigint
};

export type Transaction_indexedFieldOperations = { readonly blockNumber: whereOperations<Transaction_t,bigint>; readonly timestamp: whereOperations<Transaction_t,bigint> };

export type UniswapDayData_t = {
  readonly date: number; 
  readonly feesUSD: BigDecimal_t; 
  readonly id: id; 
  readonly tvlUSD: BigDecimal_t; 
  readonly txCount: bigint; 
  readonly volumeETH: BigDecimal_t; 
  readonly volumeUSD: BigDecimal_t; 
  readonly volumeUSDUntracked: BigDecimal_t
};

export type UniswapDayData_indexedFieldOperations = { readonly date: whereOperations<UniswapDayData_t,number> };
