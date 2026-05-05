import { UniswapV3Pool, BigDecimal } from "generated";
import { ZERO_BI, ONE_BD } from './utils/constants';
import { fastExponentiation, safeDiv } from './utils/index';

UniswapV3Pool.Mint.handler(async ({ event, context }) => {
    const poolId = `${event.chainId}-${event.srcAddress.toLowerCase()}`;

    if (!await context.Pool.get(poolId)) {
        context.Pool.set({ id: poolId });
    }

    const lowerTickId = `${poolId}#${event.params.tickLower}`;
    const upperTickId = `${poolId}#${event.params.tickUpper}`;
    const amount = event.params.amount;

    const [lowerTickRO, upperTickRO] = await Promise.all([
        context.Tick.get(lowerTickId),
        context.Tick.get(upperTickId),
    ]);

    const lowerTick = lowerTickRO
        ? { ...lowerTickRO }
        : createTick(lowerTickId, event.params.tickLower, poolId, event.block.timestamp, event.block.number);
    const upperTick = upperTickRO
        ? { ...upperTickRO }
        : createTick(upperTickId, event.params.tickUpper, poolId, event.block.timestamp, event.block.number);

    lowerTick.liquidityGross = lowerTick.liquidityGross + amount;
    lowerTick.liquidityNet = lowerTick.liquidityNet + amount;
    upperTick.liquidityGross = upperTick.liquidityGross + amount;
    upperTick.liquidityNet = upperTick.liquidityNet - amount;

    context.Tick.set(lowerTick);
    context.Tick.set(upperTick);
});

function createTick(id: string, tickIdx: bigint, poolId: string, timestamp: number, blockNumber: number) {
    const price0 = fastExponentiation(new BigDecimal('1.0001'), tickIdx);
    return {
        id,
        tickIdx,
        pool_id: poolId,
        poolAddress: poolId,
        liquidityGross: ZERO_BI,
        liquidityNet: ZERO_BI,
        price0,
        price1: safeDiv(ONE_BD, price0),
        createdAtTimestamp: BigInt(timestamp),
        createdAtBlockNumber: BigInt(blockNumber),
    };
}
