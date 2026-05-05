import { BigDecimal } from "generated";
import { ZERO_BD, ONE_BD, ZERO_BI, ONE_BI } from "./constants";

export function safeDiv(a: BigDecimal, b: BigDecimal): BigDecimal {
    return b.eq(ZERO_BD) ? ZERO_BD : a.div(b);
}

export function fastExponentiation(value: BigDecimal, power: bigint): BigDecimal {
    if (power < ZERO_BI) return safeDiv(ONE_BD, fastExponentiation(value, -power));
    if (power === ZERO_BI) return ONE_BD;
    if (power === ONE_BI) return value;
    const half = fastExponentiation(value, power / 2n);
    const result = half.times(half);
    return power % 2n === ONE_BI ? result.times(value) : result;
}
