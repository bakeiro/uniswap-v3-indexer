@val external require: string => unit = "require"

let registerContractHandlers = (
  ~contractName,
  ~handlerPathRelativeToRoot,
  ~handlerPathRelativeToConfig,
) => {
  try {
    require(`../${Path.relativePathToRootFromGenerated}/${handlerPathRelativeToRoot}`)
  } catch {
  | exn =>
    let params = {
      "Contract Name": contractName,
      "Expected Handler Path": handlerPathRelativeToConfig,
      "Code": "EE500",
    }
    let logger = Logging.createChild(~params)

    let errHandler = exn->ErrorHandling.make(~msg="Failed to import handler file", ~logger)
    errHandler->ErrorHandling.log
    errHandler->ErrorHandling.raiseExn
  }
}

let makeGeneratedConfig = () => {
  let chains = [
    {
      let contracts = [
        {
          InternalConfig.name: "UniswapV3Factory",
          abi: Types.UniswapV3Factory.abi,
          addresses: [
            "0x1F98431c8aD98523631AE4a59f267346ea31F984"->Address.Evm.fromStringOrThrow
,
          ],
          events: [
            (Types.UniswapV3Factory.PoolCreated.register() :> Internal.eventConfig),
          ],
          startBlock: None,
        },
        {
          InternalConfig.name: "UniswapV3Pool",
          abi: Types.UniswapV3Pool.abi,
          addresses: [
            "0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8"->Address.Evm.fromStringOrThrow
,
            "0xe6ff8b9a37b0fab776134636d9981aa778c4e718"->Address.Evm.fromStringOrThrow
,
            "0x56534741cd8b152df6d48adf7ac51f75169a83b2"->Address.Evm.fromStringOrThrow
,
            "0x99ac8ca7087fa4a2a1fb6357269965a2014abc35"->Address.Evm.fromStringOrThrow
,
          ],
          events: [
            (Types.UniswapV3Pool.Initialize.register() :> Internal.eventConfig),
            (Types.UniswapV3Pool.Collect.register() :> Internal.eventConfig),
            (Types.UniswapV3Pool.Burn.register() :> Internal.eventConfig),
            (Types.UniswapV3Pool.Mint.register() :> Internal.eventConfig),
            (Types.UniswapV3Pool.Swap.register() :> Internal.eventConfig),
          ],
          startBlock: None,
        },
      ]
      let chain = ChainMap.Chain.makeUnsafe(~chainId=1)
      {
        InternalConfig.maxReorgDepth: 200,
        startBlock: 0,
        id: 1,
        contracts,
        sources: NetworkSources.evm(~chain, ~contracts=[{name: "UniswapV3Factory",events: [Types.UniswapV3Factory.PoolCreated.register()],abi: Types.UniswapV3Factory.abi}, {name: "UniswapV3Pool",events: [Types.UniswapV3Pool.Initialize.register(), Types.UniswapV3Pool.Collect.register(), Types.UniswapV3Pool.Burn.register(), Types.UniswapV3Pool.Mint.register(), Types.UniswapV3Pool.Swap.register()],abi: Types.UniswapV3Pool.abi}], ~hyperSync=Some("https://1.hypersync.xyz"), ~allEventSignatures=[Types.UniswapV3Factory.eventSignatures, Types.UniswapV3Pool.eventSignatures]->Belt.Array.concatMany, ~shouldUseHypersyncClientDecoder=true, ~rpcs=[], ~lowercaseAddresses=false)
      }
    },
  ]

  Config.make(
    ~shouldRollbackOnReorg=true,
    ~shouldSaveFullHistory=false,
    ~isUnorderedMultichainMode=true,
    ~chains,
    ~enableRawEvents=false,
    ~batchSize=?Env.batchSize,
    ~preloadHandlers=true,
    ~lowercaseAddresses=false,
    ~shouldUseHypersyncClientDecoder=true,
  )
}

%%private(
  let config: ref<option<Config.t>> = ref(None)
)

let registerAllHandlers = () => {
  let configWithoutRegistrations = makeGeneratedConfig()
  EventRegister.startRegistration(
    ~ecosystem=configWithoutRegistrations.ecosystem,
    ~multichain=configWithoutRegistrations.multichain,
    ~preloadHandlers=configWithoutRegistrations.preloadHandlers,
  )

  registerContractHandlers(
    ~contractName="UniswapV3Factory",
    ~handlerPathRelativeToRoot="src/EventHandlers.ts",
    ~handlerPathRelativeToConfig="src/EventHandlers.ts",
  )
  registerContractHandlers(
    ~contractName="UniswapV3Pool",
    ~handlerPathRelativeToRoot="src/EventHandlers.ts",
    ~handlerPathRelativeToConfig="src/EventHandlers.ts",
  )

  let generatedConfig = {
    // Need to recreate initial config one more time,
    // since configWithoutRegistrations called register for event
    // before they were ready
    ...makeGeneratedConfig(),
    registrations: Some(EventRegister.finishRegistration()),
  }
  config := Some(generatedConfig)
  generatedConfig
}

let getConfig = () => {
  switch config.contents {
  | Some(config) => config
  | None => registerAllHandlers()
  }
}

let getConfigWithoutRegistrations = makeGeneratedConfig
