// Copyright (c) Mysten Labs, Inc.
// SPDX-License-Identifier: Apache-2.0

module deepbook::pool {
    use sui::{
        balance::{Self,Balance},
        vec_set::VecSet,
        coin::{Coin, TreasuryCap},
        clock::Clock,
        sui::SUI,
        event,
    };

    use std::{
        ascii::String,
        type_name,
    };

    use deepbook::{
        order::{Self, Order},
        deep_price::{Self, DeepPrice},
        big_vector::{Self, BigVector},
        account::{Account, TradeProof},
        state_manager::{Self, StateManager, TradeParams},
        utils,
        math,
    };

    // <<<<<<<<<<<<<<<<<<<<<<<< Error Codes <<<<<<<<<<<<<<<<<<<<<<<<
    const EInvalidFee: u64 = 1;
    const ESameBaseAndQuote: u64 = 2;
    const EInvalidTickSize: u64 = 3;
    const EInvalidLotSize: u64 = 4;
    const EInvalidMinSize: u64 = 5;

    // <<<<<<<<<<<<<<<<<<<<<<<< Constants <<<<<<<<<<<<<<<<<<<<<<<<
    const POOL_CREATION_FEE: u64 = 100 * 1_000_000_000; // 100 SUI, can be updated
    const TREASURY_ADDRESS: address = @0x0; // TODO: if different per pool, move to pool struct
    // Assuming 10k orders per second in a pool, would take over 50 million years to overflow
    const START_BID_ORDER_ID: u64 = (1u128 << 64 - 1) as u64;
    const START_ASK_ORDER_ID: u64 = 1;
    const MIN_ASK_ORDER_ID: u128 = 1 << 127;
    const MIN_PRICE: u64 = 1;
    const MAX_PRICE: u64 = (1u128 << 63 - 1) as u64;

    // <<<<<<<<<<<<<<<<<<<<<<<< Events <<<<<<<<<<<<<<<<<<<<<<<<
    /// Emitted when a new pool is created
    public struct PoolCreated<phantom BaseAsset, phantom QuoteAsset> has copy, store, drop {
        /// object ID of the newly created pool
        pool_id: ID,
        // 10^9 scaling
        taker_fee: u64,
        maker_fee: u64,
        tick_size: u64,
        lot_size: u64,
        min_size: u64,
    }

    // <<<<<<<<<<<<<<<<<<<<<<<< Structs <<<<<<<<<<<<<<<<<<<<<<<<

    /// Temporary to represent DEEP token, remove after we have the open-sourced the DEEP token contract
    public struct DEEP has store {}

    /// Pool holds everything related to the pool. next_bid_order_id increments for each bid order,
    /// next_ask_order_id decrements for each ask order. All funds for live orders and settled funds
    /// are held in base_balances, quote_balances, and deepbook_balance.
    public struct Pool<phantom BaseAsset, phantom QuoteAsset> has key {
        id: UID,
        tick_size: u64,
        lot_size: u64,
        min_size: u64,
        bids: BigVector<Order>,
        asks: BigVector<Order>,
        next_bid_order_id: u64,
        next_ask_order_id: u64,
        deep_config: Option<DeepPrice>,

        base_balances: Balance<BaseAsset>,
        quote_balances: Balance<QuoteAsset>,
        deepbook_balance: Balance<DEEP>,

        state_manager: StateManager,
    }

    // <<<<<<<<<<<<<<<<<<<<<<<< Package Functions <<<<<<<<<<<<<<<<<<<<<<<<

    /// Place a limit order to the order book.
    /// 1. Transfer any settled funds from the pool to the account.
    /// 2. Match the order against the order book if possible.
    /// 3. Transfer balances for the executed quantity as well as the remaining quantity.
    /// 4. Assert for any order restrictions.
    /// 5. If there is remaining quantity, inject the order into the order book.
    public(package) fun place_limit_order<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        client_order_id: u64,
        order_type: u8,
        price: u64,
        quantity: u64,
        is_bid: bool,
        expire_timestamp: u64,
        clock: &Clock,
        ctx: &mut TxContext,
    ): Order {
        self.state_manager.refresh(ctx.epoch());

        self.transfer_settled_amounts(account, proof, ctx);

        let order_id = utils::encode_order_id(is_bid, price, self.get_order_id(is_bid));
        let fee_is_deep = self.fee_is_deep();
        let owner = account.owner();
        let pool_id = self.id.to_inner();
        let mut order =
            order::initial_order(pool_id, order_id, client_order_id, order_type, price, quantity, fee_is_deep, is_bid, owner, expire_timestamp);
        self.match_against_book(&mut order, clock);

        self.transfer_trade_balances(account, proof, &mut order, ctx);

        order.assert_post_only();
        order.assert_fill_or_kill();
        if (order.is_immediate_or_cancel() || order.is_complete()) {
            return order
        };

        if (order.remaining_quantity() > 0) {
            let order_copy = order.copy_order();
            self.inject_limit_order(order_copy);
        };

        order
    }

    /// Given an order, transfer the appropriate balances. Up until this point, any partial fills have been executed
    /// and the remaining quantity is the only quantity left to be injected into the order book.
    /// 1. Transfer the taker balances while applying taker fees.
    /// 2. Transfer the maker balances while applying maker fees.
    /// 3. Update the total fees for the order.
    fun transfer_trade_balances<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        order: &mut Order,
        ctx: &mut TxContext,
    ) {
        let (mut base_in, mut base_out) = (0, 0);
        let (mut quote_in, mut quote_out) = (0, 0);
        let mut deep_in = 0;
        let (taker_fee, maker_fee) = (self.state_manager.taker_fee_for_user(account.owner()), self.state_manager.maker_fee());
        let (executed_quantity, remaining_quantity, cumulative_quote_quantity) =
            (order.executed_quantity(), order.remaining_quantity(), order.cumulative_quote_quantity());

        // Calculate the taker balances. These are derived from executed quantity.
        if (order.is_bid()) {
            quote_in = quote_in + cumulative_quote_quantity;
            base_out = base_out + executed_quantity;
            if (self.fee_is_deep()) {
                deep_in = deep_in + math::mul(taker_fee, math::mul(executed_quantity, self.deep_config.borrow().deep_per_quote()));
            } else {
                quote_in = quote_in + math::mul(taker_fee, executed_quantity);
            }
        } else {
            base_in = base_in + executed_quantity;
            quote_out = quote_out + cumulative_quote_quantity;
            if (self.fee_is_deep()) {
                deep_in = deep_in + math::mul(taker_fee, math::mul(executed_quantity, self.deep_config.borrow().deep_per_base()));
            } else {
                base_in = base_in + math::mul(taker_fee, executed_quantity);
            }
        };

        // Calculate the maker balances. These are derived from the remaining quantity.
        if (order.is_bid()) {
            quote_in = quote_in + remaining_quantity * order.price();
            if (self.fee_is_deep()) {
                deep_in = deep_in + math::mul(maker_fee, math::mul(remaining_quantity, self.deep_config.borrow().deep_per_quote()));
            } else {
                quote_in = quote_in + math::mul(maker_fee, quote_in);
            }
        } else {
            base_in = base_in + remaining_quantity;
            if (self.fee_is_deep()) {
                deep_in = deep_in + math::mul(maker_fee, math::mul(remaining_quantity, self.deep_config.borrow().deep_per_base()));
            } else {
                base_in = base_in + math::mul(maker_fee, base_in);
            }
        };

        // Calculate the total fees for the order.
        let total_fees = if (self.fee_is_deep()) {
            deep_in
        } else {
            if (order.is_bid()) {
                quote_in - order.original_quantity() * order.price()
            } else {
                base_in - order.original_quantity()
            }
        };
        order.set_total_fees(total_fees);

        if (base_in > 0) self.deposit_base(account, proof, base_in, ctx);
        if (base_out > 0) self.withdraw_base(account, proof, base_out, ctx);
        if (quote_in > 0) self.deposit_quote(account, proof, quote_in, ctx);
        if (quote_out > 0) self.withdraw_quote(account, proof, quote_out, ctx);
        if (deep_in > 0) self.deposit_deep(account, proof, deep_in, ctx);
    }

    /// Transfer any settled amounts from the pool to the account.
    fun transfer_settled_amounts<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        ctx: &mut TxContext,
    ) {
        let (base_amount, quote_amount) = self.state_manager.reset_user_settled_amounts(account.owner());
        self.withdraw_base(account, proof, base_amount, ctx);
        self.withdraw_quote(account, proof, quote_amount, ctx);
    }

    /// Matches the given order and quantity against the order book.
    /// If is_bid, it will match against asks, otherwise against bids.
    /// Mutates the order and the maker order as necessary.
    fun match_against_book<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        order: &mut Order,
        clock: &Clock,
    ) {
        let (mut ref, mut offset, book_side) = if (order.is_bid()) {
            let (ref, offset) = self.asks.min_slice();
            (ref, offset, &mut self.asks)
        } else {
            let (ref, offset) = self.bids.max_slice();
            (ref, offset, &mut self.bids)
        };

        if (ref.is_null()) return;

        let mut executed_base_quantity = 0;
        let mut executed_quote_quantity = 0;
        let mut remove_order_ids = vector[];
        let mut remove_order_owners = vector[];

        let mut other_order = &mut book_side.borrow_slice_mut(ref)[offset];
        while (order.remaining_quantity() > 0 && order.can_match(other_order) ) {
            if (other_order.is_expired(clock.timestamp_ms())) {
                other_order.set_expired();
                remove_order_ids.push_back(other_order.order_id());
                remove_order_owners.push_back(other_order.owner());
                continue
            };

            let (filled_quantity, quote_quantity) =
                order.match_orders(other_order, clock.timestamp_ms());
            executed_base_quantity = executed_base_quantity + filled_quantity;
            executed_quote_quantity = executed_quote_quantity + quote_quantity;

            self.state_manager.add_user_settled_amount(other_order.owner(), filled_quantity, other_order.is_bid());
            self.state_manager.increase_maker_volume(other_order.owner(), filled_quantity);

            if (other_order.is_complete()) {
                remove_order_ids.push_back(other_order.order_id());
                remove_order_owners.push_back(other_order.owner());
            };

            // Traverse to valid next order if exists, otherwise break from loop.
            if (order.is_bid() && book_side.valid_next(ref, offset)) {
                (ref, offset, other_order) = book_side.borrow_mut_next(ref, offset)
            } else if (!order.is_bid() && book_side.valid_prev(ref, offset)) {
                (ref, offset, other_order) = book_side.borrow_mut_prev(ref, offset)
            } else {
                break
            }
        };

        // Iterate over orders_to_remove and remove from the book.
        let mut i = 0;
        while (i < remove_order_ids.length()) {
            self.state_manager.remove_user_open_order(remove_order_owners[i], remove_order_ids[i]);
            book_side.remove(remove_order_ids[i]);
            i = i + 1;
        };
    }

    /// Place a market order. Quantity is in base asset terms. Calls place_limit_order with
    /// a price of MAX_PRICE for bids and MIN_PRICE for asks. Fills or kills the order.
    public(package) fun place_market_order<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        client_order_id: u64,
        quantity: u64,
        is_bid: bool,
        clock: &Clock,
        ctx: &mut TxContext,
    ): Order {
        self.place_limit_order(
            account,
            proof,
            client_order_id,
            order::fill_or_kill(),
            if (is_bid) MAX_PRICE else MIN_PRICE,
            quantity,
            is_bid,
            clock.timestamp_ms(),
            clock,
            ctx,
        )
    }

    /// Given an amount in and direction, calculate amount out
    /// Will return (amount_out, amount_in_used)
    public(package) fun get_amount_out<BaseAsset, QuoteAsset>(
        _self: &Pool<BaseAsset, QuoteAsset>,
        _amount_in: u64,
        _is_bid: bool,
    ): u64 {
        // TODO: implement
        0
    }

    /// Get the level2 bids between price_low and price_high.
    public(package) fun get_level2_bids<BaseAsset, QuoteAsset>(
        _self: &Pool<BaseAsset, QuoteAsset>,
        _price_low: u64,
        _price_high: u64,
    ): (vector<u64>, vector<u64>) {
        // TODO: implement
        (vector[], vector[])
    }

    /// Get the level2 bids between price_low and price_high.
    public(package) fun get_level2_asks<BaseAsset, QuoteAsset>(
        _self: &Pool<BaseAsset, QuoteAsset>,
        _price_low: u64,
        _price_high: u64,
    ): (vector<u64>, vector<u64>) {
        // TODO: implement
        (vector[], vector[])
    }

    /// Get the n ticks from the mid price
    public(package) fun get_level2_ticks_from_mid<BaseAsset, QuoteAsset>(
        _self: &Pool<BaseAsset, QuoteAsset>,
        _ticks: u64,
    ): (vector<u64>, vector<u64>) {
        // TODO: implement
        (vector[], vector[])
    }

    /// 1. Remove the order from the order book and from the user's open orders.
    /// 2. Refund the user for the remaining quantity and fees.
    /// 2a. If the order is a bid, refund the quote asset + non deep fee.
    /// 2b. If the order is an ask, refund the base asset + non deep fee.
    /// 3. If the order was placed with deep fees, refund the deep fees.
    public(package) fun cancel_order<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        order_id: u128,
        clock: &Clock,
        ctx: &mut TxContext,
    ): Order {
        let mut order = if (order_is_bid(order_id)) {
            self.bids.remove(order_id)
        } else {
            self.asks.remove(order_id)
        };
        order.set_canceled();
        self.state_manager.remove_user_open_order(account.owner(), order_id);

        if (order.is_bid()) {
            let mut quote_quantity = math::mul(order.remaining_quantity(), order.price());
            if (!order.fee_is_deep()) {
                quote_quantity = quote_quantity + order.fees_to_refund();
            };
            self.withdraw_quote(account, proof, quote_quantity, ctx)
        } else {
            let mut base_quantity = order.remaining_quantity();
            if (!order.fee_is_deep()) {
                base_quantity = base_quantity + order.fees_to_refund();
            };
            self.withdraw_base(account, proof, base_quantity, ctx)
        };

        if (order.fee_is_deep()) {
            self.withdraw_deep(account, proof, order.fees_to_refund(), ctx)
        };

        order.emit_order_canceled<BaseAsset, QuoteAsset>(clock.timestamp_ms());

        order
    }

    /// Claim the rebates for the user
    public(package) fun claim_rebates<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        ctx: &mut TxContext
    ) {
        self.state_manager.refresh(ctx.epoch());
        let amount = self.state_manager.reset_user_rebates(account.owner());
        let coin = self.deepbook_balance.split(amount).into_coin(ctx);
        account.deposit_with_proof<DEEP>(proof, coin);
    }

    /// Cancel all orders for an account. Withdraw settled funds back into user account.
    public(package) fun cancel_all<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        account: &mut Account,
        proof: &TradeProof,
        clock: &Clock,
        ctx: &mut TxContext,
    ): vector<Order>{
        let mut cancelled_orders = vector[];
        let user_open_orders = self.state_manager.user_open_orders(account.owner());

        let orders_vector = user_open_orders.into_keys();
        let len = orders_vector.length();
        let mut i = 0;
        while (i < len) {
            let key = orders_vector[i];
            let cancelled_order = cancel_order(self, account, proof, key, clock, ctx);
            cancelled_orders.push_back(cancelled_order);
            i = i + 1;
        };

        cancelled_orders
    }

    /// Get all open orders for a user.
    public(package) fun user_open_orders<BaseAsset, QuoteAsset>(
        self: &Pool<BaseAsset, QuoteAsset>,
        user: address,
    ): VecSet<u128> {
        self.state_manager.user_open_orders(user)
    }

    /// Creates a new pool for trading and returns pool_key, called by state module
    public(package) fun create_pool<BaseAsset, QuoteAsset>(
        taker_fee: u64,
        maker_fee: u64,
        tick_size: u64,
        lot_size: u64,
        min_size: u64,
        creation_fee: Balance<SUI>,
        ctx: &mut TxContext,
    ): Pool<BaseAsset, QuoteAsset> {
        assert!(creation_fee.value() == POOL_CREATION_FEE, EInvalidFee);
        assert!(tick_size > 0, EInvalidTickSize);
        assert!(lot_size > 0, EInvalidLotSize);
        assert!(min_size > 0, EInvalidMinSize);

        assert!(type_name::get<BaseAsset>() != type_name::get<QuoteAsset>(), ESameBaseAndQuote);

        let pool_uid = object::new(ctx);

        event::emit(PoolCreated<BaseAsset, QuoteAsset> {
            pool_id: pool_uid.to_inner(),
            taker_fee,
            maker_fee,
            tick_size,
            lot_size,
            min_size,
        });

        let pool = (Pool<BaseAsset, QuoteAsset> {
            id: pool_uid,
            bids: big_vector::empty(10000, 1000, ctx), // TODO: what are these numbers
            asks: big_vector::empty(10000, 1000, ctx), // TODO: ditto
            next_bid_order_id: START_BID_ORDER_ID,
            next_ask_order_id: START_ASK_ORDER_ID,
            deep_config: option::none(),
            tick_size,
            lot_size,
            min_size,
            base_balances: balance::zero(),
            quote_balances: balance::zero(),
            deepbook_balance: balance::zero(),
            state_manager: state_manager::new(taker_fee, maker_fee, 0, ctx),
        });

        // TODO: reconsider sending the Coin here. User pays gas;
        // TODO: depending on the frequency of the event;
        transfer::public_transfer(creation_fee.into_coin(ctx), TREASURY_ADDRESS);

        pool
    }

    /// Increase a user's stake
    public(package) fun increase_user_stake<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user: address,
        amount: u64,
        ctx: &TxContext,
    ): (u64, u64) {
        self.state_manager.refresh(ctx.epoch());

        self.state_manager.increase_user_stake(user, amount)
    }

    /// Removes a user's stake.
    /// Returns the total amount staked before this epoch and the total amount staked during this epoch.
    public(package) fun remove_user_stake<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user: address,
        ctx: &TxContext
    ): (u64, u64) {
        self.state_manager.refresh(ctx.epoch());

        self.state_manager.remove_user_stake(user)
    }

    /// Get the user's (current, next) stake amounts
    public(package) fun get_user_stake<BaseAsset, QuoteAsset>(
        self: &Pool<BaseAsset, QuoteAsset>,
        user: address,
        ctx: &TxContext,
    ): (u64, u64) {
        self.state_manager.user_stake(user, ctx.epoch())
    }

    /// Add a new price point to the pool.
    public(package) fun add_deep_price_point<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        base_conversion_rate: u64,
        quote_conversion_rate: u64,
        timestamp: u64,
    ) {
        if (self.deep_config.is_none()) {
            self.deep_config.fill(deep_price::empty());
        };
        self.deep_config
            .borrow_mut()
            .add_price_point(base_conversion_rate, quote_conversion_rate, timestamp);
    }

    /// Update the pool's next pool state.
    /// During an epoch refresh, the current pool state is moved to historical pool state.
    /// The next pool state is moved to current pool state.
    public(package) fun set_next_trade_params<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        fees: Option<TradeParams>,
    ) {
        self.state_manager.set_next_trade_params(fees);
    }

    /// Get the base and quote asset of pool, return as ascii strings
    public(package) fun get_base_quote_types<BaseAsset, QuoteAsset>(
        _self: &Pool<BaseAsset, QuoteAsset>
    ): (String, String) {
        (
            type_name::get<BaseAsset>().into_string(),
            type_name::get<QuoteAsset>().into_string()
        )
    }

    /// Get the pool key string base+quote (if base, quote in lexicographic order) otherwise return quote+base
    /// TODO: Why is this needed as a key? Why don't we just use the ID of the pool as an ID?
    public(package) fun key<BaseAsset, QuoteAsset>(
        self: &Pool<BaseAsset, QuoteAsset>
    ): String {
        let (base, quote) = get_base_quote_types(self);
        if (utils::compare(&base, &quote)) {
            utils::concat_ascii(base, quote)
        } else {
            utils::concat_ascii(quote, base)
        }
    }

    #[allow(lint(share_owned))]
    /// Share the Pool.
    public(package) fun share<BaseAsset, QuoteAsset>(self: Pool<BaseAsset, QuoteAsset>) {
        transfer::share_object(self)
    }

    // <<<<<<<<<<<<<<<<<<<<<<<< Internal Functions <<<<<<<<<<<<<<<<<<<<<<<<

    /// This will be automatically called if not enough assets in settled_funds for a trade
    /// User cannot manually deposit. Funds are withdrawn from user account and merged into pool balances.
    fun deposit_base<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user_account: &mut Account,
        proof: &TradeProof,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        let base = user_account.withdraw_with_proof<BaseAsset>(proof, amount, ctx);
        self.base_balances.join(base.into_balance());
    }

    fun deposit_quote<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user_account: &mut Account,
        proof: &TradeProof,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        let quote = user_account.withdraw_with_proof<QuoteAsset>(proof, amount, ctx);
        self.quote_balances.join(quote.into_balance());
    }

    fun deposit_deep<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user_account: &mut Account,
        proof: &TradeProof,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        let coin = user_account.withdraw_with_proof<DEEP>(proof, amount, ctx);
        self.deepbook_balance.join(coin.into_balance());
    }

    fun withdraw_base<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user_account: &mut Account,
        proof: &TradeProof,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        let coin = self.base_balances.split(amount).into_coin(ctx);
        user_account.deposit_with_proof<BaseAsset>(proof, coin);
    }

    fun withdraw_quote<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user_account: &mut Account,
        proof: &TradeProof,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        let coin = self.quote_balances.split(amount).into_coin(ctx);
        user_account.deposit_with_proof<QuoteAsset>(proof, coin);
    }

    fun withdraw_deep<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        user_account: &mut Account,
        proof: &TradeProof,
        amount: u64,
        ctx: &mut TxContext,
    ) {
        let coin = self.deepbook_balance.split(amount).into_coin(ctx);
        user_account.deposit_with_proof<DEEP>(proof, coin);
    }

    #[allow(unused_function)]
    /// Send fees collected in input tokens to treasury
    fun send_treasury<T>(fee: Coin<T>) {
        transfer::public_transfer(fee, TREASURY_ADDRESS)
    }

    /// Balance accounting happens before this function is called
    fun inject_limit_order<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        order: Order,
    ) {
        order.emit_order_placed<BaseAsset, QuoteAsset>();
        let (order_id, owner) = (order.order_id(), order.owner());
        if (order.is_bid()) {
            self.bids.insert(order_id, order);
        } else {
            self.asks.insert(order_id, order);
        };

        self.state_manager.add_user_open_order(owner, order_id);
    }

    /// Returns 0 if the order is a bid order, 1 if the order is an ask order
    fun order_is_bid(order_id: u128): bool {
        (order_id < MIN_ASK_ORDER_ID)
    }

    fun get_order_id<BaseAsset, QuoteAsset>(
        self: &mut Pool<BaseAsset, QuoteAsset>,
        is_bid: bool
    ): u64 {
        if (is_bid) {
            self.next_bid_order_id = self.next_bid_order_id - 1;
            self.next_bid_order_id
        } else {
            self.next_ask_order_id = self.next_ask_order_id + 1;
            self.next_ask_order_id
        }
    }

    /// Returns if the order fee is paid in deep tokens
    fun fee_is_deep<BaseAsset, QuoteAsset>(
        self: &Pool<BaseAsset, QuoteAsset>
    ): bool {
        self.deep_config.is_some()
    }

    #[allow(unused_function)]
    fun correct_supply<B, Q>(self: &mut Pool<B, Q>, tcap: &mut TreasuryCap<DEEP>) {
        let amount = self.state_manager.reset_burn_balance();
        let burnt = self.deepbook_balance.split(amount);
        tcap.supply_mut().decrease_supply(burnt);
    }
    // Will be replaced by actual deep token package dependency

    // // Other helpful functions
    // TODO: taker order, send fees directly to treasury
    // public(package) fun get_order()
    // public(package) fun get_all_orders()
    // public(package) fun get_book()
}