  @genType
module UniswapV3Factory = {
  module PoolCreated = Types.MakeRegister(Types.UniswapV3Factory.PoolCreated)
}

  @genType
module UniswapV3Pool = {
  module Initialize = Types.MakeRegister(Types.UniswapV3Pool.Initialize)
  module Collect = Types.MakeRegister(Types.UniswapV3Pool.Collect)
  module Burn = Types.MakeRegister(Types.UniswapV3Pool.Burn)
  module Mint = Types.MakeRegister(Types.UniswapV3Pool.Mint)
  module Swap = Types.MakeRegister(Types.UniswapV3Pool.Swap)
}

@genType /** Register a Block Handler. It'll be called for every block by default. */
let onBlock: (
  Envio.onBlockOptions<Types.chain>,
  Envio.onBlockArgs<Types.handlerContext> => promise<unit>,
) => unit = (
  EventRegister.onBlock: (unknown, Internal.onBlockArgs => promise<unit>) => unit
)->Utils.magic
