import { BigDecimal, handlerContext } from "generated";
import { ZERO_BI } from "./constants";
import * as fs from "fs";
import * as path from "path";

interface TickSnapshot {
    tickIdx: string;
    price0: string;
    price1: string;
    liquidityNet: string;
    liquidityGross: string;
}

interface PoolSnapshot {
    chainId: number;
    address: string;
    ticks: TickSnapshot[];
}

const SNAPSHOT_PATH = path.resolve(__dirname, "../../../snapshot.json");
let snapshotByPoolId: Record<string, PoolSnapshot> | null = null;

function loadSnapshot(): Record<string, PoolSnapshot> {
    if (snapshotByPoolId) return snapshotByPoolId;
    if (!fs.existsSync(SNAPSHOT_PATH)) {
        snapshotByPoolId = {};
        return snapshotByPoolId;
    }
    const pools: PoolSnapshot[] = JSON.parse(fs.readFileSync(SNAPSHOT_PATH, "utf-8"));
    snapshotByPoolId = Object.fromEntries(
        pools.map(p => [`${p.chainId}-${p.address.toLowerCase()}`, p])
    );
    return snapshotByPoolId;
}

export async function ensurePoolInitialized(
    poolId: string,
    context: handlerContext
): Promise<void> {
    if (await context.Pool.get(poolId)) return;

    context.Pool.set({ id: poolId });

    const poolData = loadSnapshot()[poolId];
    if (!poolData) return;

    for (const tick of poolData.ticks) {
        context.Tick.set({
            id: `${poolId}#${tick.tickIdx}`,
            pool_id: poolId,
            poolAddress: poolId,
            tickIdx: BigInt(tick.tickIdx),
            liquidityGross: BigInt(tick.liquidityGross),
            liquidityNet: BigInt(tick.liquidityNet),
            price0: new BigDecimal(tick.price0),
            price1: new BigDecimal(tick.price1),
            createdAtTimestamp: ZERO_BI,
            createdAtBlockNumber: ZERO_BI,
        });
    }
}
