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
    address: string;
    ticks: TickSnapshot[];
}

// Load once at module level
const SNAPSHOT_PATH = path.resolve(__dirname, "../../../../snapshot.json");
let snapshotByAddress: Record<string, PoolSnapshot> | null = null;

function loadSnapshot(): Record<string, PoolSnapshot> {
    if (snapshotByAddress) return snapshotByAddress;
    if (!fs.existsSync(SNAPSHOT_PATH)) {
        snapshotByAddress = {};
        return snapshotByAddress;
    }
    const pools: PoolSnapshot[] = JSON.parse(fs.readFileSync(SNAPSHOT_PATH, "utf-8"));
    snapshotByAddress = Object.fromEntries(
        pools.map(p => [p.address.toLowerCase(), p])
    );
    return snapshotByAddress;
}

export async function ensurePoolInitialized(
    poolId: string,
    poolAddress: string,
    context: handlerContext
): Promise<void> {
    if (await context.Pool.get(poolId)) return;

    context.Pool.set({ id: poolId });

    const snapshot = loadSnapshot();
    const poolData = snapshot[poolAddress.toLowerCase()];
    if (!poolData) return;

    for (const tick of poolData.ticks) {
        const tickIdx = BigInt(tick.tickIdx);
        context.Tick.set({
            id: `${poolId}#${tick.tickIdx}`,
            pool_id: poolId,
            poolAddress: poolId,
            tickIdx,
            liquidityGross: BigInt(tick.liquidityGross),
            liquidityNet: BigInt(tick.liquidityNet),
            price0: new BigDecimal(tick.price0),
            price1: new BigDecimal(tick.price1),
            createdAtTimestamp: ZERO_BI,
            createdAtBlockNumber: ZERO_BI,
        });
    }
}
