
type hyperSyncConfig = {endpointUrl: string}
type hyperFuelConfig = {endpointUrl: string}

@genType.opaque
type rpcConfig = {
  syncConfig: InternalConfig.sourceSync,
}

@genType
type syncSource = HyperSync(hyperSyncConfig) | HyperFuel(hyperFuelConfig) | Rpc(rpcConfig)

@genType.opaque
type aliasAbi = Ethers.abi

type eventName = string

type contract = {
  name: string,
  abi: aliasAbi,
  addresses: array<string>,
  events: array<eventName>,
}

type configYaml = {
  syncSource,
  startBlock: int,
  confirmedBlockThreshold: int,
  contracts: dict<contract>,
  lowercaseAddresses: bool,
}

let publicConfig = ChainMap.fromArrayUnsafe([
  {
    let contracts = Js.Dict.fromArray([
      (
        "UniswapV3Pool",
        {
          name: "UniswapV3Pool",
          abi: Types.UniswapV3Pool.abi,
          addresses: [
            "0x8ad599c3a0ff1de082011efddc58f1908eb6e6d8",
            "0xe6ff8b9a37b0fab776134636d9981aa778c4e718",
            "0x56534741cd8b152df6d48adf7ac51f75169a83b2",
            "0x99ac8ca7087fa4a2a1fb6357269965a2014abc35",
          ],
          events: [
            Types.UniswapV3Pool.Mint.name,
            Types.UniswapV3Pool.Burn.name,
          ],
        }
      ),
    ])
    let chain = ChainMap.Chain.makeUnsafe(~chainId=1)
    (
      chain,
      {
        confirmedBlockThreshold: 200,
        syncSource: HyperSync({endpointUrl: "https://1.hypersync.xyz"}),
        startBlock: 0,
        contracts,
        lowercaseAddresses: false
      }
    )
  },
])

@genType
let getGeneratedByChainId: int => configYaml = chainId => {
  let chain = ChainMap.Chain.makeUnsafe(~chainId)
  if !(publicConfig->ChainMap.has(chain)) {
    Js.Exn.raiseError(
      "No chain with id " ++ chain->ChainMap.Chain.toString ++ " found in config.yaml",
    )
  }
  publicConfig->ChainMap.get(chain)
}
