import { TransactionBlock } from "@mysten/sui.js/transactions";
import { signAndExecute } from "./utils";
import { SUI_CLOCK_OBJECT_ID, normalizeSuiAddress } from "@mysten/sui.js/utils";
import { SuiClient, getFullnodeUrl } from "@mysten/sui.js/client";
import { bcs } from "@mysten/sui.js/bcs";
import {
    ENV, Coins, Pool, DEEPBOOK_PACKAGE_ID, REGISTRY_ID, DEEP_TREASURY_ID, Constants, MY_ADDRESS,
    Pools, OrderType, SelfMatchingOptions,
    MANAGER_ADDRESSES
} from './coinConstants';
import { generateProof } from "./balanceManager";

const client = new SuiClient({ url: getFullnodeUrl(ENV) });

// =================================================================
// Transactions
// =================================================================

export const placeLimitOrder = (
    pool: Pool,
    managerKey: string,
    clientOrderId: number,
    price: number,
    quantity: number,
    isBid: boolean,
    orderType: number,
    selfMatchingOption: number,
    payWithDeep: boolean,
    txb: TransactionBlock
) => {
    txb.setGasBudget(Constants.GAS_BUDGET);
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;
    const inputPrice = price * Constants.FLOAT_SCALAR * quoteScalar / baseScalar;
    const inputQuantity = quantity * baseScalar;

    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::place_limit_order`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
            txb.pure.u64(clientOrderId),
            txb.pure.u8(orderType),
            txb.pure.u8(selfMatchingOption),
            txb.pure.u64(inputPrice),
            txb.pure.u64(inputQuantity),
            txb.pure.bool(isBid),
            txb.pure.bool(payWithDeep),
            txb.pure.u64(Constants.LARGE_TIMESTAMP),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const placeMarketOrder = (
    pool: Pool,
    managerKey: string,
    clientOrderId: number,
    quantity: number,
    isBid: boolean,
    selfMatchingOption: number,
    payWithDeep: boolean,
    txb: TransactionBlock
) => {
    txb.setGasBudget(Constants.GAS_BUDGET);
    const baseScalar = pool.baseCoin.scalar;

    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::place_market_order`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
            txb.pure.u64(clientOrderId),
            txb.pure.u8(selfMatchingOption),
            txb.pure.u64(quantity * baseScalar),
            txb.pure.bool(isBid),
            txb.pure.bool(payWithDeep),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const modifyOrder = (
    pool: Pool,
    managerKey: string,
    orderId: number,
    newQuantity: number,
    txb: TransactionBlock,
 ) => {
    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::modify_order`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
            txb.pure.u128(orderId),
            txb.pure.u64(newQuantity),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const cancelOrder = (
    pool: Pool,
    managerKey: string,
    orderId: number,
    txb: TransactionBlock
) => {
    txb.setGasBudget(Constants.GAS_BUDGET);
    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::cancel_order`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
            txb.pure.u128(orderId),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const cancelAllOrders = (
    pool: Pool,
    managerKey: string,
    txb: TransactionBlock
) => {
    txb.setGasBudget(Constants.GAS_BUDGET);
    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::cancel_all_orders`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const withdrawSettledAmounts = (
    pool: Pool,
    managerKey: string,
    txb: TransactionBlock
) => {
    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::withdraw_settled_amounts`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const addDeepPricePoint = (
    targetPool: Pool,
    referencePool: Pool,
    txb: TransactionBlock
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::add_deep_price_point`,
        arguments: [
            txb.object(targetPool.address),
            txb.object(referencePool.address),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [targetPool.baseCoin.type, targetPool.quoteCoin.type, referencePool.baseCoin.type, referencePool.quoteCoin.type]
    });
}

export const claimRebates = (
    pool: Pool,
    managerKey: string,
    txb: TransactionBlock
) => {
    const tradeProof = generateProof(managerKey, txb);

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::claim_rebates`,
        arguments: [
            txb.object(pool.address),
            txb.object(MANAGER_ADDRESSES[managerKey].address),
            tradeProof,
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const burnDeep = (
    pool: Pool,
    txb: TransactionBlock,
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::burn_deep`,
        arguments: [
            txb.object(pool.address),
            txb.object(DEEP_TREASURY_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
}

export const midPrice = async (
    pool: Pool,
    txb: TransactionBlock
) => {
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::mid_price`,
        arguments: [
            txb.object(pool.address),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const bytes = res.results![0].returnValues![0][0];
    const parsed_mid_price = Number(bcs.U64.parse(new Uint8Array(bytes)));
    const adjusted_mid_price = parsed_mid_price * baseScalar / quoteScalar / Constants.FLOAT_SCALAR;

    return adjusted_mid_price;
}

export const whiteListed = async (
    pool: Pool,
    txb: TransactionBlock
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::whitelisted`,
        arguments: [
            txb.object(pool.address),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const bytes = res.results![0].returnValues![0][0];
    const whitelisted = bcs.Bool.parse(new Uint8Array(bytes));

    return whitelisted;
}

export const getQuoteQuantityOut = async (
    pool: Pool,
    baseQuantity: number,
    txb: TransactionBlock
) => {
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_quote_quantity_out`,
        arguments: [
            txb.object(pool.address),
            txb.pure.u64(baseQuantity * baseScalar),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const baseOut = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![0][0])));
    const quoteOut = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![1][0])));
    const deepRequired = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![2][0])));

    console.log(`For ${baseQuantity} base in, you will get ${baseOut / baseScalar} base, ${quoteOut / quoteScalar} quote, and requires ${deepRequired / Coins.DEEP.scalar} deep`);
}

export const getBaseQuantityOut = async (
    pool: Pool,
    quoteQuantity: number,
    txb: TransactionBlock
) => {
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_base_quantity_out`,
        arguments: [
            txb.object(pool.address),
            txb.pure.u64(quoteQuantity * quoteScalar),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const baseOut = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![0][0])));
    const quoteOut = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![1][0])));
    const deepRequired = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![2][0])));

    console.log(`For ${quoteQuantity} quote in, you will get ${baseOut / baseScalar} base, ${quoteOut / quoteScalar} quote, and requires ${deepRequired / Coins.DEEP.scalar} deep`);
}

export const getQuantityOut = async (
    pool: Pool,
    basequantity: number,
    quoteQuantity: number,
    txb: TransactionBlock
) => {
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_quantity_out`,
        arguments: [
            txb.object(pool.address),
            txb.pure.u64(basequantity * baseScalar),
            txb.pure.u64(quoteQuantity * quoteScalar),
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const baseOut = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![0][0])));
    const quoteOut = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![1][0])));
    const deepRequired = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![2][0])));

    console.log(`For ${basequantity} base and ${quoteQuantity} quote in, you will get ${baseOut / baseScalar} base, ${quoteOut / quoteScalar} quote, and requires ${deepRequired / Coins.DEEP.scalar} deep`);
}

export const accountOpenOrders = async (
    pool: Pool,
    managerKey: string,
    txb: TransactionBlock,
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::account_open_orders`,
        arguments: [
            txb.object(pool.address),
            txb.pure.id(MANAGER_ADDRESSES[managerKey].address),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });

    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const order_ids = res.results![0].returnValues![0][0];
    const VecSet = bcs.struct('VecSet', {
        constants: bcs.vector(bcs.U128),
    });

    let parsed_order_ids = VecSet.parse(new Uint8Array(order_ids)).constants;

    console.log(parsed_order_ids);
}

export const getLevel2Range = async (
    pool: Pool,
    priceLow: number,
    priceHigh: number,
    isBid: boolean,
    txb: TransactionBlock,
) => {
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_level2_range`,
        arguments: [
            txb.object(pool.address),
            txb.pure.u64(priceLow * Constants.FLOAT_SCALAR * quoteScalar / baseScalar),
            txb.pure.u64(priceHigh * Constants.FLOAT_SCALAR * quoteScalar / baseScalar),
            txb.pure.bool(isBid),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });

    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const prices = res.results![0].returnValues![0][0];
    const parsed_prices = bcs.vector(bcs.u64()).parse(new Uint8Array(prices));
    const quantities = res.results![0].returnValues![1][0];
    const parsed_quantities = bcs.vector(bcs.u64()).parse(new Uint8Array(quantities));
    console.log(res.results![0].returnValues![0]);
    console.log(parsed_prices);
    console.log(parsed_quantities);
    return [parsed_prices, parsed_quantities];
}

export const getLevel2TickFromMid = async (
    pool: Pool,
    tickFromMid: number,
    txb: TransactionBlock,
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_level2_tick_from_mid`,
        arguments: [
            txb.object(pool.address),
            txb.pure.u64(tickFromMid)
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });

    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const prices = res.results![0].returnValues![0][0];
    const parsed_prices = bcs.vector(bcs.u64()).parse(new Uint8Array(prices));
    const quantities = res.results![0].returnValues![1][0];
    const parsed_quantities = bcs.vector(bcs.u64()).parse(new Uint8Array(quantities));
    console.log(res.results![0].returnValues![0]);
    console.log(parsed_prices);
    console.log(parsed_quantities);
    return [parsed_prices, parsed_quantities];
}

export const getLevel2TicksFromMid = async (
    pool: Pool,
    tickFromMid: number,
    txb: TransactionBlock,
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_level2_tick_from_mid`,
        arguments: [
            txb.object(pool.address),
            txb.pure.u64(tickFromMid)
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });

    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const prices = res.results![0].returnValues![0][0];
    const parsed_prices = bcs.vector(bcs.u64()).parse(new Uint8Array(prices));
    const quantities = res.results![0].returnValues![1][0];
    const parsed_quantities = bcs.vector(bcs.u64()).parse(new Uint8Array(quantities));
    console.log(res.results![0].returnValues![0]);
    console.log(parsed_prices);
    console.log(parsed_quantities);
    return [parsed_prices, parsed_quantities];
}

export const vaultBalances = async (
    pool: Pool,
    txb: TransactionBlock,
) => {
    const baseScalar = pool.baseCoin.scalar;
    const quoteScalar = pool.quoteCoin.scalar;

    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::vault_balances`,
        arguments: [
            txb.object(pool.address),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });

    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const baseInVault = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![0][0])));
    const quoteInVault = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![1][0])));
    const deepInVault = Number(bcs.U64.parse(new Uint8Array(res.results![0].returnValues![2][0])));
    console.log(`Base in vault: ${baseInVault / baseScalar}, Quote in vault: ${quoteInVault / quoteScalar}, Deep in vault: ${deepInVault / Coins.DEEP.scalar}`);

    return [baseInVault / baseScalar, quoteInVault / quoteScalar, deepInVault / Coins.DEEP.scalar];
}

export const getPoolIdByAssets = async (
    baseType: string,
    quoteType: string,
    txb: TransactionBlock,
) => {
    txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::get_pool_id_by_asset`,
        arguments: [
            txb.object(REGISTRY_ID),
        ],
        typeArguments: [baseType, quoteType]
    });

    const res = await client.devInspectTransactionBlock({
        sender: normalizeSuiAddress(MY_ADDRESS),
        transactionBlock: txb,
    });

    const ID = bcs.struct('ID', {
        bytes: bcs.Address,
    });
    const address = ID.parse(new Uint8Array(res.results![0].returnValues![0][0]))['bytes'];
    console.log(`Pool ID base ${baseType} and quote ${quoteType} is ${address}`);

    return address;
}

export const swapExactBaseForQuote = (
    pool: Pool,
    baseAmount: number,
    deepAmount: number,
    txb: TransactionBlock
) => {
    const baseScalar = pool.baseCoin.scalar;
    const baseCoinId = pool.baseCoin.coinId;

    let baseCoin;
    if (pool.baseCoin.type === Coins.SUI.type) {
        [baseCoin] = txb.splitCoins(
            txb.gas,
            [txb.pure.u64(baseAmount * baseScalar)]
        );
    } else {
        [baseCoin] = txb.splitCoins(
            txb.object(baseCoinId),
            [txb.pure.u64(baseAmount * baseScalar)]
        );
    }
    const [deepCoin] = txb.splitCoins(
        txb.object(Coins.DEEP.coinId),
        [txb.pure.u64(deepAmount * Coins.DEEP.scalar)]
    );
    let [baseOut, quoteOut, deepOut] = txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::swap_exact_base_for_quote`,
        arguments: [
            txb.object(pool.address),
            baseCoin,
            deepCoin,
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    txb.transferObjects([baseOut], MY_ADDRESS);
    txb.transferObjects([quoteOut], MY_ADDRESS);
    txb.transferObjects([deepOut], MY_ADDRESS);
}

export const swapExactQuoteForBase = (
    pool: Pool,
    quoteAmount: number,
    deepAmount: number,
    txb: TransactionBlock
) => {
    const quoteScalar = pool.quoteCoin.scalar;
    const quoteCoinId = pool.quoteCoin.coinId;

    let quoteCoin;
    if (pool.quoteCoin.type === Coins.SUI.type) {
        [quoteCoin] = txb.splitCoins(
            txb.gas,
            [txb.pure.u64(quoteAmount * quoteScalar)]
        );
    } else {
        [quoteCoin] = txb.splitCoins(
            txb.object(quoteCoinId),
            [txb.pure.u64(quoteAmount * quoteScalar)]
        );
    }
    const [deepCoin] = txb.splitCoins(
        txb.object(Coins.DEEP.coinId),
        [txb.pure.u64(deepAmount * Coins.DEEP.scalar)]
    );
    let [baseOut, quoteOut, deepOut] = txb.moveCall({
        target: `${DEEPBOOK_PACKAGE_ID}::pool::swap_exact_quote_for_base`,
        arguments: [
            txb.object(pool.address),
            quoteCoin,
            deepCoin,
            txb.object(SUI_CLOCK_OBJECT_ID),
        ],
        typeArguments: [pool.baseCoin.type, pool.quoteCoin.type]
    });
    txb.transferObjects([baseOut], MY_ADDRESS);
    txb.transferObjects([quoteOut], MY_ADDRESS);
    txb.transferObjects([deepOut], MY_ADDRESS);
}

// Main entry points, comment out as needed...
const executeTransaction = async () => {
    // const txb = new TransactionBlock();

    // addDeepPricePoint(Pools.TONY_SUI_POOL, Pools.DEEP_SUI_POOL, txb);
    // // Limit order for whitelist pools
    // placeLimitOrder(
    //     Pools.DEEP_SUI_POOL,
    //     'MANAGER_1',
    //     1234, // Client Order ID
    //     2.5, // Price
    //     1, // Quantity
    //     true, // isBid
    //     OrderType.NO_RESTRICTION, // orderType
    //     SelfMatchingOptions.SELF_MATCHING_ALLOWED, // selfMatchingOption
    //     false, // payWithDeep
    //     txb
    // );
    // cancelOrder(Pools.DEEP_SUI_POOL, 'MANAGER_1', 46116860184283102412036854775805, txb);
    // cancelAllOrders(Pools.TONY_SUI_POOL, 'MANAGER_1', txb);
    // accountOpenOrders(Pools.DEEP_SUI_POOL, 'MANAGER_1', txb);
    // midPrice(Pools.DEEP_SUI_POOL, txb);
    // whiteListed(Pools.TONY_SUI_POOL, txb);
    // getQuoteQuantityOut(Pools.TONY_SUI_POOL, 1, txb);
    // getBaseQuantityOut(Pools.TONY_SUI_POOL, 1, txb);
    // getLevel2Range(Pools.DEEP_SUI_POOL, 2.5, 7.5, true, txb);
    // getLevel2TickFromMid(Pools.DEEP_SUI_POOL, 1, txb);
    // vaultBalances(Pools.DEEP_SUI_POOL, txb);
    // getPoolIdByAssets(Pools.DEEP_SUI_POOL.baseCoin.type, Pools.DEEP_SUI_POOL.quoteCoin.type, txb);
    // swapExactBaseForQuote(Pools.TONY_SUI_POOL, 1, 0.0004, txb);
    // swapExactQuoteForBase(Pools.TONY_SUI_POOL, 1, 0.0002, txb);

    // Run transaction against ENV
    // const res = await signAndExecute(txb, ENV);

    // console.dir(res, { depth: null });
}

executeTransaction();
