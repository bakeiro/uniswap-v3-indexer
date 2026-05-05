import { UniswapV3Pool, Token, Pool, Bundle } from "generated";
import { CHAIN_CONFIGS } from "./utils/chains";
import { isAddressInList } from "./utils/index";
import { ZERO_BD, ZERO_BI, ADDRESS_ZERO } from "./utils/constants";
import { findNativePerToken, getNativePriceInUSD } from "./utils/pricing";
import { updatePoolDayData, updatePoolHourData } from "./utils/intervalUpdates";
import { getPoolMetadataEffect, getTokenMetadataEffect } from "./utils/tokenMetadataEffect";

UniswapV3Pool.Initialize.handler(async ({event, context}) => {
    const poolId = `${event.chainId}-${event.srcAddress.toLowerCase()}`;
    let pool = await context.Pool.get(poolId);

    // Bootstrap Pool/Token/Factory/Bundle when factory is not in the networks config
    if (!pool) {
        const { factoryAddress, whitelistTokens } = CHAIN_CONFIGS[event.chainId];
        const factoryId = `${event.chainId}-${factoryAddress.toLowerCase()}`;

        const [poolMeta, existingFactory] = await Promise.all([
            context.effect(getPoolMetadataEffect, { address: event.srcAddress, chainId: event.chainId }),
            context.Factory.get(factoryId),
        ]);

        if (!existingFactory) {
            context.Factory.set({
                id: factoryId,
                poolCount: ZERO_BI,
                txCount: ZERO_BI,
                numberOfSwaps: ZERO_BI,
                totalVolumeETH: ZERO_BD,
                totalVolumeUSD: ZERO_BD,
                totalFeesETH: ZERO_BD,
                totalFeesUSD: ZERO_BD,
                untrackedVolumeUSD: ZERO_BD,
                totalValueLockedETH: ZERO_BD,
                totalValueLockedUSD: ZERO_BD,
                totalValueLockedUSDUntracked: ZERO_BD,
                totalValueLockedETHUntracked: ZERO_BD,
                owner: ADDRESS_ZERO,
            });
            context.Bundle.set({ id: event.chainId.toString(), ethPriceUSD: ZERO_BD });
        }

        const token0Id = `${event.chainId}-${poolMeta.token0}`;
        const token1Id = `${event.chainId}-${poolMeta.token1}`;

        const [existingToken0, existingToken1, token0Meta, token1Meta] = await Promise.all([
            context.Token.get(token0Id),
            context.Token.get(token1Id),
            context.effect(getTokenMetadataEffect, { address: poolMeta.token0, chainId: event.chainId }),
            context.effect(getTokenMetadataEffect, { address: poolMeta.token1, chainId: event.chainId }),
        ]);

        if (!existingToken0) {
            context.Token.set({
                id: token0Id,
                symbol: token0Meta.symbol,
                name: token0Meta.name,
                decimals: BigInt(token0Meta.decimals),
                isWhitelisted: isAddressInList(poolMeta.token0, whitelistTokens),
                volume: ZERO_BD, volumeUSD: ZERO_BD, untrackedVolumeUSD: ZERO_BD,
                feesUSD: ZERO_BD, txCount: ZERO_BI, poolCount: ZERO_BI,
                totalValueLocked: ZERO_BD, totalValueLockedUSD: ZERO_BD,
                totalValueLockedUSDUntracked: ZERO_BD, derivedETH: ZERO_BD,
                whitelistPools: [],
            });
        }

        if (!existingToken1) {
            context.Token.set({
                id: token1Id,
                symbol: token1Meta.symbol,
                name: token1Meta.name,
                decimals: BigInt(token1Meta.decimals),
                isWhitelisted: isAddressInList(poolMeta.token1, whitelistTokens),
                volume: ZERO_BD, volumeUSD: ZERO_BD, untrackedVolumeUSD: ZERO_BD,
                feesUSD: ZERO_BD, txCount: ZERO_BI, poolCount: ZERO_BI,
                totalValueLocked: ZERO_BD, totalValueLockedUSD: ZERO_BD,
                totalValueLockedUSDUntracked: ZERO_BD, derivedETH: ZERO_BD,
                whitelistPools: [],
            });
        }

        pool = {
            id: poolId,
            createdAtTimestamp: BigInt(event.block.timestamp),
            createdAtBlockNumber: BigInt(event.block.number),
            token0_id: token0Id,
            token1_id: token1Id,
            feeTier: BigInt(poolMeta.fee),
            liquidity: ZERO_BI,
            sqrtPrice: ZERO_BI,
            token0Price: ZERO_BD,
            token1Price: ZERO_BD,
            tick: undefined,
            observationIndex: ZERO_BI,
            volumeToken0: ZERO_BD, volumeToken1: ZERO_BD,
            volumeUSD: ZERO_BD, untrackedVolumeUSD: ZERO_BD,
            feesUSD: ZERO_BD, txCount: ZERO_BI,
            collectedFeesToken0: ZERO_BD, collectedFeesToken1: ZERO_BD,
            collectedFeesUSD: ZERO_BD,
            totalValueLockedToken0: ZERO_BD, totalValueLockedToken1: ZERO_BD,
            totalValueLockedETH: ZERO_BD, totalValueLockedUSD: ZERO_BD,
            totalValueLockedUSDUntracked: ZERO_BD,
            liquidityProviderCount: ZERO_BI,
        };
        context.Pool.set(pool);
    }

    let [bundle, token0, token1] = await Promise.all([
        context.Bundle.get(event.chainId.toString()),
        context.Token.get(pool.token0_id),
        context.Token.get(pool.token1_id)
    ]);

    if (!bundle || !token0 || !token1) return;

    const {
        stablecoinWrappedNativePoolId,
        stablecoinIsToken0,
        wrappedNativeAddress,
        stablecoinAddresses,
        minimumNativeLocked,
    } = CHAIN_CONFIGS[event.chainId];

    pool = { ...pool, sqrtPrice: event.params.sqrtPriceX96, tick: event.params.tick };
    context.Pool.set(pool);

    bundle = {
        ...bundle,
        ethPriceUSD: await getNativePriceInUSD(context, event.chainId, stablecoinWrappedNativePoolId, stablecoinIsToken0)
    };
    context.Bundle.set(bundle);

    await Promise.all([
        updatePoolDayData(event.block.timestamp, pool, context),
        updatePoolHourData(event.block.timestamp, pool, context),
    ]);

    const [derivedETH_t0, derivedETH_t1] = await Promise.all([
        findNativePerToken(context, token0, bundle, wrappedNativeAddress, stablecoinAddresses, minimumNativeLocked),
        findNativePerToken(context, token1, bundle, wrappedNativeAddress, stablecoinAddresses, minimumNativeLocked),
    ]);

    context.Token.set({ ...token0, derivedETH: derivedETH_t0 });
    context.Token.set({ ...token1, derivedETH: derivedETH_t1 });
});
