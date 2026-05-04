/***** TAKE NOTE ******
This is a hack to get genType to work!

In order for genType to produce recursive types, it needs to be at the 
root module of a file. If it's defined in a nested module it does not 
work. So all the MockDb types and internal functions are defined in TestHelpers_MockDb
and only public functions are recreated and exported from this module.

the following module:
```rescript
module MyModule = {
  @genType
  type rec a = {fieldB: b}
  @genType and b = {fieldA: a}
}
```

produces the following in ts:
```ts
// tslint:disable-next-line:interface-over-type-literal
export type MyModule_a = { readonly fieldB: b };

// tslint:disable-next-line:interface-over-type-literal
export type MyModule_b = { readonly fieldA: MyModule_a };
```

fieldB references type b which doesn't exist because it's defined
as MyModule_b
*/

module MockDb = {
  @genType
  let createMockDb = TestHelpers_MockDb.createMockDb
}

@genType
module Addresses = {
  include TestHelpers_MockAddresses
}

module EventFunctions = {
  //Note these are made into a record to make operate in the same way
  //for Res, JS and TS.

  /**
  The arguements that get passed to a "processEvent" helper function
  */
  @genType
  type eventProcessorArgs<'event> = {
    event: 'event,
    mockDb: TestHelpers_MockDb.t,
    @deprecated("Set the chainId for the event instead")
    chainId?: int,
  }

  @genType
  type eventProcessor<'event> = eventProcessorArgs<'event> => promise<TestHelpers_MockDb.t>

  /**
  A function composer to help create individual processEvent functions
  */
  let makeEventProcessor = (~register) => args => {
    let {event, mockDb, ?chainId} =
      args->(Utils.magic: eventProcessorArgs<'event> => eventProcessorArgs<Internal.event>)

    // Have the line here, just in case the function is called with
    // a manually created event. We don't want to break the existing tests here.
    let _ =
      TestHelpers_MockDb.mockEventRegisters->Utils.WeakMap.set(event, register)
    TestHelpers_MockDb.makeProcessEvents(mockDb, ~chainId=?chainId)([event->(Utils.magic: Internal.event => Types.eventLog<unknown>)])
  }

  module MockBlock = {
    @genType
    type t = {
      hash?: string,
      number?: int,
      timestamp?: int,
    }

    let toBlock = (_mock: t) => {
      hash: _mock.hash->Belt.Option.getWithDefault("foo"),
      number: _mock.number->Belt.Option.getWithDefault(0),
      timestamp: _mock.timestamp->Belt.Option.getWithDefault(0),
    }->(Utils.magic: Types.AggregatedBlock.t => Internal.eventBlock)
  }

  module MockTransaction = {
    @genType
    type t = {
      from?: option<Address.t>,
      gasPrice?: option<bigint>,
      hash?: string,
    }

    let toTransaction = (_mock: t) => {
      from: _mock.from->Belt.Option.getWithDefault(None),
      gasPrice: _mock.gasPrice->Belt.Option.getWithDefault(None),
      hash: _mock.hash->Belt.Option.getWithDefault("foo"),
    }->(Utils.magic: Types.AggregatedTransaction.t => Internal.eventTransaction)
  }

  @genType
  type mockEventData = {
    chainId?: int,
    srcAddress?: Address.t,
    logIndex?: int,
    block?: MockBlock.t,
    transaction?: MockTransaction.t,
  }

  /**
  Applies optional paramters with defaults for all common eventLog field
  */
  let makeEventMocker = (
    ~params: Internal.eventParams,
    ~mockEventData: option<mockEventData>,
    ~register: unit => Internal.eventConfig,
  ): Internal.event => {
    let {?block, ?transaction, ?srcAddress, ?chainId, ?logIndex} =
      mockEventData->Belt.Option.getWithDefault({})
    let block = block->Belt.Option.getWithDefault({})->MockBlock.toBlock
    let transaction = transaction->Belt.Option.getWithDefault({})->MockTransaction.toTransaction
    let config = RegisterHandlers.getConfig()
    let event: Internal.event = {
      params,
      transaction,
      chainId: switch chainId {
      | Some(chainId) => chainId
      | None =>
        switch config.defaultChain {
        | Some(chainConfig) => chainConfig.id
        | None =>
          Js.Exn.raiseError(
            "No default chain Id found, please add at least 1 chain to your config.yaml",
          )
        }
      },
      block,
      srcAddress: srcAddress->Belt.Option.getWithDefault(Addresses.defaultAddress),
      logIndex: logIndex->Belt.Option.getWithDefault(0),
    }
    // Since currently it's not possible to figure out the event config from the event
    // we store a reference to the register function by event in a weak map
    let _ = TestHelpers_MockDb.mockEventRegisters->Utils.WeakMap.set(event, register)
    event
  }
}


module UniswapV3Factory = {
  module PoolCreated = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.UniswapV3Factory.PoolCreated.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.UniswapV3Factory.PoolCreated.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("token0")
      token0?: Address.t,
      @as("token1")
      token1?: Address.t,
      @as("fee")
      fee?: bigint,
      @as("tickSpacing")
      tickSpacing?: bigint,
      @as("pool")
      pool?: Address.t,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?token0,
        ?token1,
        ?fee,
        ?tickSpacing,
        ?pool,
        ?mockEventData,
      } = args

      let params = 
      {
       token0: token0->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       token1: token1->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       fee: fee->Belt.Option.getWithDefault(0n),
       tickSpacing: tickSpacing->Belt.Option.getWithDefault(0n),
       pool: pool->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
      }
->(Utils.magic: Types.UniswapV3Factory.PoolCreated.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.UniswapV3Factory.PoolCreated.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.UniswapV3Factory.PoolCreated.event)
    }
  }

}


module UniswapV3Pool = {
  module Initialize = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.UniswapV3Pool.Initialize.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.UniswapV3Pool.Initialize.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("sqrtPriceX96")
      sqrtPriceX96?: bigint,
      @as("tick")
      tick?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?sqrtPriceX96,
        ?tick,
        ?mockEventData,
      } = args

      let params = 
      {
       sqrtPriceX96: sqrtPriceX96->Belt.Option.getWithDefault(0n),
       tick: tick->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.UniswapV3Pool.Initialize.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.UniswapV3Pool.Initialize.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.UniswapV3Pool.Initialize.event)
    }
  }

  module Collect = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.UniswapV3Pool.Collect.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.UniswapV3Pool.Collect.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("owner")
      owner?: Address.t,
      @as("recipient")
      recipient?: Address.t,
      @as("tickLower")
      tickLower?: bigint,
      @as("tickUpper")
      tickUpper?: bigint,
      @as("amount0")
      amount0?: bigint,
      @as("amount1")
      amount1?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?owner,
        ?recipient,
        ?tickLower,
        ?tickUpper,
        ?amount0,
        ?amount1,
        ?mockEventData,
      } = args

      let params = 
      {
       owner: owner->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       recipient: recipient->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       tickLower: tickLower->Belt.Option.getWithDefault(0n),
       tickUpper: tickUpper->Belt.Option.getWithDefault(0n),
       amount0: amount0->Belt.Option.getWithDefault(0n),
       amount1: amount1->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.UniswapV3Pool.Collect.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.UniswapV3Pool.Collect.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.UniswapV3Pool.Collect.event)
    }
  }

  module Burn = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.UniswapV3Pool.Burn.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.UniswapV3Pool.Burn.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("owner")
      owner?: Address.t,
      @as("tickLower")
      tickLower?: bigint,
      @as("tickUpper")
      tickUpper?: bigint,
      @as("amount")
      amount?: bigint,
      @as("amount0")
      amount0?: bigint,
      @as("amount1")
      amount1?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?owner,
        ?tickLower,
        ?tickUpper,
        ?amount,
        ?amount0,
        ?amount1,
        ?mockEventData,
      } = args

      let params = 
      {
       owner: owner->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       tickLower: tickLower->Belt.Option.getWithDefault(0n),
       tickUpper: tickUpper->Belt.Option.getWithDefault(0n),
       amount: amount->Belt.Option.getWithDefault(0n),
       amount0: amount0->Belt.Option.getWithDefault(0n),
       amount1: amount1->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.UniswapV3Pool.Burn.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.UniswapV3Pool.Burn.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.UniswapV3Pool.Burn.event)
    }
  }

  module Mint = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.UniswapV3Pool.Mint.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.UniswapV3Pool.Mint.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("sender")
      sender?: Address.t,
      @as("owner")
      owner?: Address.t,
      @as("tickLower")
      tickLower?: bigint,
      @as("tickUpper")
      tickUpper?: bigint,
      @as("amount")
      amount?: bigint,
      @as("amount0")
      amount0?: bigint,
      @as("amount1")
      amount1?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?sender,
        ?owner,
        ?tickLower,
        ?tickUpper,
        ?amount,
        ?amount0,
        ?amount1,
        ?mockEventData,
      } = args

      let params = 
      {
       sender: sender->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       owner: owner->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       tickLower: tickLower->Belt.Option.getWithDefault(0n),
       tickUpper: tickUpper->Belt.Option.getWithDefault(0n),
       amount: amount->Belt.Option.getWithDefault(0n),
       amount0: amount0->Belt.Option.getWithDefault(0n),
       amount1: amount1->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.UniswapV3Pool.Mint.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.UniswapV3Pool.Mint.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.UniswapV3Pool.Mint.event)
    }
  }

  module Swap = {
    @genType
    let processEvent: EventFunctions.eventProcessor<Types.UniswapV3Pool.Swap.event> = EventFunctions.makeEventProcessor(
      ~register=(Types.UniswapV3Pool.Swap.register :> unit => Internal.eventConfig),
    )

    @genType
    type createMockArgs = {
      @as("sender")
      sender?: Address.t,
      @as("recipient")
      recipient?: Address.t,
      @as("amount0")
      amount0?: bigint,
      @as("amount1")
      amount1?: bigint,
      @as("sqrtPriceX96")
      sqrtPriceX96?: bigint,
      @as("liquidity")
      liquidity?: bigint,
      @as("tick")
      tick?: bigint,
      mockEventData?: EventFunctions.mockEventData,
    }

    @genType
    let createMockEvent = args => {
      let {
        ?sender,
        ?recipient,
        ?amount0,
        ?amount1,
        ?sqrtPriceX96,
        ?liquidity,
        ?tick,
        ?mockEventData,
      } = args

      let params = 
      {
       sender: sender->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       recipient: recipient->Belt.Option.getWithDefault(TestHelpers_MockAddresses.defaultAddress),
       amount0: amount0->Belt.Option.getWithDefault(0n),
       amount1: amount1->Belt.Option.getWithDefault(0n),
       sqrtPriceX96: sqrtPriceX96->Belt.Option.getWithDefault(0n),
       liquidity: liquidity->Belt.Option.getWithDefault(0n),
       tick: tick->Belt.Option.getWithDefault(0n),
      }
->(Utils.magic: Types.UniswapV3Pool.Swap.eventArgs => Internal.eventParams)

      EventFunctions.makeEventMocker(
        ~params,
        ~mockEventData,
        ~register=(Types.UniswapV3Pool.Swap.register :> unit => Internal.eventConfig),
      )->(Utils.magic: Internal.event => Types.UniswapV3Pool.Swap.event)
    }
  }

}

