import { UniswapV3Pool } from "generated";
import { ensurePoolInitialized } from './utils/snapshot';

UniswapV3Pool.Burn.handler(async ({ event, context }) => {
    const poolId = `${event.chainId}-${event.srcAddress.toLowerCase()}`;

    await ensurePoolInitialized(poolId, context);

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
    upperTick.liquidityNet = upperTick.liquidityNet + amount;

    context.Tick.set(lowerTick);
    context.Tick.set(upperTick);
});
