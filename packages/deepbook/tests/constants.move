#[test_only]
module deepbook::constants {
    const POOL_CREATION_FEE: u64 = 100 * 1_000_000_000; // 100 SUI, can be updated
    const FLOAT_SCALING: u64 = 1_000_000_000;
    const MAX_U64: u64 = (1u128 << 64 - 1) as u64;
    // Restrictions on limit orders.
    const NO_RESTRICTION: u8 = 0;
    // Mandates that whatever amount of an order that can be executed in the current transaction, be filled and then the rest of the order canceled.
    const IMMEDIATE_OR_CANCEL: u8 = 1;
    // Mandates that the entire order size be filled in the current transaction. Otherwise, the order is canceled.
    const FILL_OR_KILL: u8 = 2;
    // Mandates that the entire order be passive. Otherwise, cancel the order.
    const POST_ONLY: u8 = 3;
    // Maximum restriction value.
    const MAX_RESTRICTION: u8 = 3;

    const LIVE: u8 = 0;
    const PARTIALLY_FILLED: u8 = 1;
    const FILLED: u8 = 2;
    const CANCELED: u8 = 3;
    const EXPIRED: u8 = 4;

    const MAKER_FEE: u64 = 500000;
    const TAKER_FEE: u64 = 1000000;
    const TICK_SIZE: u64 = 1000;
    const LOT_SIZE: u64 = 1000;
    const MIN_SIZE: u64 = 10000;
    const DEEP_MULTIPLIER: u64 = 10 * FLOAT_SCALING;
    const TAKER_DISCOUNT: u64 = 500_000_000;
    const USDC_UNIT: u64 = 1_000_000;
    const SUI_UNIT: u64 = 1_000_000_000;

    const EOrderInfoMismatch: u64 = 0;
    const EBookOrderMismatch: u64 = 1;
    
    public fun pool_creation_fee(): u64 {
        POOL_CREATION_FEE
    }

    public fun float_scaling(): u64 {
        FLOAT_SCALING
    }

    public fun max_u64(): u64 {
        MAX_U64
    }

    public fun no_restriction(): u8 {
        NO_RESTRICTION
    }

    public fun immediate_or_cancel(): u8 {
        IMMEDIATE_OR_CANCEL
    }

    public fun fill_or_kill(): u8 {
        FILL_OR_KILL
    }

    public fun post_only(): u8 {
        POST_ONLY
    }

    public fun max_restriction(): u8 {
        MAX_RESTRICTION
    }

    public fun live(): u8 {
        LIVE
    }

    public fun partially_filled(): u8 {
        PARTIALLY_FILLED
    }

    public fun filled(): u8 {
        FILLED
    }

    public fun canceled(): u8 {
        CANCELED
    }

    public fun expired(): u8 {
        EXPIRED
    }

    public fun maker_fee(): u64 {
        MAKER_FEE
    }

    public fun taker_fee(): u64 {
        TAKER_FEE
    }

    public fun tick_size(): u64 {
        TICK_SIZE
    }

    public fun lot_size(): u64 {
        LOT_SIZE
    }

    public fun min_size(): u64 {
        MIN_SIZE
    }

    public fun deep_multiplier(): u64 {
        DEEP_MULTIPLIER
    }

    public fun taker_discount(): u64 {
        TAKER_DISCOUNT
    }

    public fun e_order_info_mismatch(): u64 {
        EOrderInfoMismatch
    }

    public fun e_book_order_mismatch(): u64 {
        EBookOrderMismatch
    }

    public fun usdc_unit(): u64 {
        USDC_UNIT
    }

    public fun sui_unit(): u64 {
        SUI_UNIT
    }
}