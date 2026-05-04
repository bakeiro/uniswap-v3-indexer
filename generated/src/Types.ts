// This file is to dynamically generate TS types
// which we can't get using GenType
// Use @genType.import to link the types back to ReScript code

import type { Logger, EffectCaller } from "envio";
import type * as Entities from "./db/Entities.gen.ts";

export type HandlerContext = {
  /**
   * Access the logger instance with event as a context. The logs will be displayed in the console and Envio Hosted Service.
   */
  readonly log: Logger;
  /**
   * Call the provided Effect with the given input.
   * Effects are the best for external calls with automatic deduplication, error handling and caching.
   * Define a new Effect using createEffect outside of the handler.
   */
  readonly effect: EffectCaller;
  /**
   * True when the handlers run in preload mode - in parallel for the whole batch.
   * Handlers run twice per batch of events, and the first time is the "preload" run
   * During preload entities aren't set, logs are ignored and exceptions are silently swallowed.
   * Preload mode is the best time to populate data to in-memory cache.
   * After preload the handler will run for the second time in sequential order of events.
   */
  readonly isPreload: boolean;
  /**
   * Per-chain state information accessible in event handlers and block handlers.
   * Each chain ID maps to an object containing chain-specific state:
   * - isReady: true when the chain has completed initial sync and is processing live events,
   *            false during historical synchronization
   */
  readonly chains: {
    [chainId: string]: {
      readonly isReady: boolean;
    };
  };
  readonly Bundle: {
    /**
     * Load the entity Bundle from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Bundle_t | undefined>,
    /**
     * Load the entity Bundle from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Bundle_t>,
    readonly getWhere: Entities.Bundle_indexedFieldOperations,
    /**
     * Returns the entity Bundle from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Bundle_t) => Promise<Entities.Bundle_t>,
    /**
     * Set the entity Bundle in the storage.
     */
    readonly set: (entity: Entities.Bundle_t) => void,
    /**
     * Delete the entity Bundle from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Burn: {
    /**
     * Load the entity Burn from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Burn_t | undefined>,
    /**
     * Load the entity Burn from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Burn_t>,
    readonly getWhere: Entities.Burn_indexedFieldOperations,
    /**
     * Returns the entity Burn from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Burn_t) => Promise<Entities.Burn_t>,
    /**
     * Set the entity Burn in the storage.
     */
    readonly set: (entity: Entities.Burn_t) => void,
    /**
     * Delete the entity Burn from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Collect: {
    /**
     * Load the entity Collect from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Collect_t | undefined>,
    /**
     * Load the entity Collect from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Collect_t>,
    readonly getWhere: Entities.Collect_indexedFieldOperations,
    /**
     * Returns the entity Collect from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Collect_t) => Promise<Entities.Collect_t>,
    /**
     * Set the entity Collect in the storage.
     */
    readonly set: (entity: Entities.Collect_t) => void,
    /**
     * Delete the entity Collect from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Factory: {
    /**
     * Load the entity Factory from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Factory_t | undefined>,
    /**
     * Load the entity Factory from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Factory_t>,
    readonly getWhere: Entities.Factory_indexedFieldOperations,
    /**
     * Returns the entity Factory from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Factory_t) => Promise<Entities.Factory_t>,
    /**
     * Set the entity Factory in the storage.
     */
    readonly set: (entity: Entities.Factory_t) => void,
    /**
     * Delete the entity Factory from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Mint: {
    /**
     * Load the entity Mint from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Mint_t | undefined>,
    /**
     * Load the entity Mint from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Mint_t>,
    readonly getWhere: Entities.Mint_indexedFieldOperations,
    /**
     * Returns the entity Mint from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Mint_t) => Promise<Entities.Mint_t>,
    /**
     * Set the entity Mint in the storage.
     */
    readonly set: (entity: Entities.Mint_t) => void,
    /**
     * Delete the entity Mint from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Pool: {
    /**
     * Load the entity Pool from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Pool_t | undefined>,
    /**
     * Load the entity Pool from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Pool_t>,
    readonly getWhere: Entities.Pool_indexedFieldOperations,
    /**
     * Returns the entity Pool from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Pool_t) => Promise<Entities.Pool_t>,
    /**
     * Set the entity Pool in the storage.
     */
    readonly set: (entity: Entities.Pool_t) => void,
    /**
     * Delete the entity Pool from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly PoolDayData: {
    /**
     * Load the entity PoolDayData from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.PoolDayData_t | undefined>,
    /**
     * Load the entity PoolDayData from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.PoolDayData_t>,
    readonly getWhere: Entities.PoolDayData_indexedFieldOperations,
    /**
     * Returns the entity PoolDayData from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.PoolDayData_t) => Promise<Entities.PoolDayData_t>,
    /**
     * Set the entity PoolDayData in the storage.
     */
    readonly set: (entity: Entities.PoolDayData_t) => void,
    /**
     * Delete the entity PoolDayData from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly PoolHourData: {
    /**
     * Load the entity PoolHourData from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.PoolHourData_t | undefined>,
    /**
     * Load the entity PoolHourData from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.PoolHourData_t>,
    readonly getWhere: Entities.PoolHourData_indexedFieldOperations,
    /**
     * Returns the entity PoolHourData from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.PoolHourData_t) => Promise<Entities.PoolHourData_t>,
    /**
     * Set the entity PoolHourData in the storage.
     */
    readonly set: (entity: Entities.PoolHourData_t) => void,
    /**
     * Delete the entity PoolHourData from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Swap: {
    /**
     * Load the entity Swap from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Swap_t | undefined>,
    /**
     * Load the entity Swap from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Swap_t>,
    readonly getWhere: Entities.Swap_indexedFieldOperations,
    /**
     * Returns the entity Swap from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Swap_t) => Promise<Entities.Swap_t>,
    /**
     * Set the entity Swap in the storage.
     */
    readonly set: (entity: Entities.Swap_t) => void,
    /**
     * Delete the entity Swap from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Tick: {
    /**
     * Load the entity Tick from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Tick_t | undefined>,
    /**
     * Load the entity Tick from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Tick_t>,
    readonly getWhere: Entities.Tick_indexedFieldOperations,
    /**
     * Returns the entity Tick from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Tick_t) => Promise<Entities.Tick_t>,
    /**
     * Set the entity Tick in the storage.
     */
    readonly set: (entity: Entities.Tick_t) => void,
    /**
     * Delete the entity Tick from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Token: {
    /**
     * Load the entity Token from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Token_t | undefined>,
    /**
     * Load the entity Token from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Token_t>,
    readonly getWhere: Entities.Token_indexedFieldOperations,
    /**
     * Returns the entity Token from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Token_t) => Promise<Entities.Token_t>,
    /**
     * Set the entity Token in the storage.
     */
    readonly set: (entity: Entities.Token_t) => void,
    /**
     * Delete the entity Token from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly TokenDayData: {
    /**
     * Load the entity TokenDayData from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.TokenDayData_t | undefined>,
    /**
     * Load the entity TokenDayData from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.TokenDayData_t>,
    readonly getWhere: Entities.TokenDayData_indexedFieldOperations,
    /**
     * Returns the entity TokenDayData from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.TokenDayData_t) => Promise<Entities.TokenDayData_t>,
    /**
     * Set the entity TokenDayData in the storage.
     */
    readonly set: (entity: Entities.TokenDayData_t) => void,
    /**
     * Delete the entity TokenDayData from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly TokenHourData: {
    /**
     * Load the entity TokenHourData from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.TokenHourData_t | undefined>,
    /**
     * Load the entity TokenHourData from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.TokenHourData_t>,
    readonly getWhere: Entities.TokenHourData_indexedFieldOperations,
    /**
     * Returns the entity TokenHourData from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.TokenHourData_t) => Promise<Entities.TokenHourData_t>,
    /**
     * Set the entity TokenHourData in the storage.
     */
    readonly set: (entity: Entities.TokenHourData_t) => void,
    /**
     * Delete the entity TokenHourData from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly Transaction: {
    /**
     * Load the entity Transaction from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.Transaction_t | undefined>,
    /**
     * Load the entity Transaction from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.Transaction_t>,
    readonly getWhere: Entities.Transaction_indexedFieldOperations,
    /**
     * Returns the entity Transaction from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.Transaction_t) => Promise<Entities.Transaction_t>,
    /**
     * Set the entity Transaction in the storage.
     */
    readonly set: (entity: Entities.Transaction_t) => void,
    /**
     * Delete the entity Transaction from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
  readonly UniswapDayData: {
    /**
     * Load the entity UniswapDayData from the storage by ID.
     * If the entity is not found, returns undefined.
     */
    readonly get: (id: string) => Promise<Entities.UniswapDayData_t | undefined>,
    /**
     * Load the entity UniswapDayData from the storage by ID.
     * If the entity is not found, throws an error.
     */
    readonly getOrThrow: (id: string, message?: string) => Promise<Entities.UniswapDayData_t>,
    readonly getWhere: Entities.UniswapDayData_indexedFieldOperations,
    /**
     * Returns the entity UniswapDayData from the storage by ID.
     * If the entity is not found, creates it using provided parameters and returns it.
     */
    readonly getOrCreate: (entity: Entities.UniswapDayData_t) => Promise<Entities.UniswapDayData_t>,
    /**
     * Set the entity UniswapDayData in the storage.
     */
    readonly set: (entity: Entities.UniswapDayData_t) => void,
    /**
     * Delete the entity UniswapDayData from the storage.
     *
     * The 'deleteUnsafe' method is experimental and unsafe. You should manually handle all entity references after deletion to maintain database consistency.
     */
    readonly deleteUnsafe: (id: string) => void,
  }
};

