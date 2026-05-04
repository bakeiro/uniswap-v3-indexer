module ContractType = {
  @genType
  type t = 
    | @as("UniswapV3Factory") UniswapV3Factory
    | @as("UniswapV3Pool") UniswapV3Pool

  let name = "CONTRACT_TYPE"
  let variants = [
    UniswapV3Factory,
    UniswapV3Pool,
  ]
  let config = Internal.makeEnumConfig(~name, ~variants)
}

module EntityType = {
  @genType
  type t = 
    | @as("Bundle") Bundle
    | @as("Burn") Burn
    | @as("Collect") Collect
    | @as("Factory") Factory
    | @as("Mint") Mint
    | @as("Pool") Pool
    | @as("PoolDayData") PoolDayData
    | @as("PoolHourData") PoolHourData
    | @as("Swap") Swap
    | @as("Tick") Tick
    | @as("Token") Token
    | @as("TokenDayData") TokenDayData
    | @as("TokenHourData") TokenHourData
    | @as("Transaction") Transaction
    | @as("UniswapDayData") UniswapDayData
    | @as("dynamic_contract_registry") DynamicContractRegistry

  let name = "ENTITY_TYPE"
  let variants = [
    Bundle,
    Burn,
    Collect,
    Factory,
    Mint,
    Pool,
    PoolDayData,
    PoolHourData,
    Swap,
    Tick,
    Token,
    TokenDayData,
    TokenHourData,
    Transaction,
    UniswapDayData,
    DynamicContractRegistry,
  ]
  let config = Internal.makeEnumConfig(~name, ~variants)
}

let allEnums = ([
  ContractType.config->Internal.fromGenericEnumConfig,
  EntityType.config->Internal.fromGenericEnumConfig,
])
