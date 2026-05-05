module ContractType = {
  @genType
  type t = 
    | @as("UniswapV3Pool") UniswapV3Pool

  let name = "CONTRACT_TYPE"
  let variants = [
    UniswapV3Pool,
  ]
  let config = Internal.makeEnumConfig(~name, ~variants)
}

module EntityType = {
  @genType
  type t = 
    | @as("Pool") Pool
    | @as("Tick") Tick
    | @as("dynamic_contract_registry") DynamicContractRegistry

  let name = "ENTITY_TYPE"
  let variants = [
    Pool,
    Tick,
    DynamicContractRegistry,
  ]
  let config = Internal.makeEnumConfig(~name, ~variants)
}

let allEnums = ([
  ContractType.config->Internal.fromGenericEnumConfig,
  EntityType.config->Internal.fromGenericEnumConfig,
])
