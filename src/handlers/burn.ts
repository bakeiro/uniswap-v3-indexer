import { UniswapV3Pool } from "generated";

UniswapV3Pool.Burn.handler(async ({ event, context }) => {
    const poolId = `${event.chainId}-${event.srcAddress.toLowerCase()}`;
    const lowerTickId = `${poolId}#${event.params.tickLower}`;
    const upperTickId = `${poolId}#${event.params.tickUpper}`;
    const amount = event.params.amount;

    const [lowerTickRO, upperTickRO] = await Promise.all([
        context.Tick.get(lowerTickId),
        context.Tick.get(upperTickId),
    ]);

    if (!lowerTickRO || !upperTickRO) return;

    const lowerTick = { ...lowerTickRO };
    const upperTick = { ...upperTickRO };

    lowerTick.liquidityGross = lowerTick.liquidityGross - amount;
    lowerTick.liquidityNet = lowerTick.liquidityNet - amount;
    upperTick.liquidityGross = upperTick.liquidityGross - amount;
    upperTick.liquidityNet = upperTick.liquidityNet + amount; // inverso del Mint (FIXME: originally was liqNet - Amount, but claude told me this was wrong, leaving this comment here for the future, I can compare the RPC ticks with this ticks to check which code is the correct one )

    context.Tick.set(lowerTick);
    context.Tick.set(upperTick);
});
