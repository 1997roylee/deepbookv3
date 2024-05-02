
<a name="0x0_pool"></a>

# Module `0x0::pool`



-  [Struct `PoolCreated`](#0x0_pool_PoolCreated)
-  [Struct `DEEP`](#0x0_pool_DEEP)
-  [Resource `Pool`](#0x0_pool_Pool)
-  [Constants](#@Constants_0)
-  [Function `place_limit_order`](#0x0_pool_place_limit_order)
-  [Function `transfer_trade_balances`](#0x0_pool_transfer_trade_balances)
-  [Function `transfer_settled_amounts`](#0x0_pool_transfer_settled_amounts)
-  [Function `match_against_book`](#0x0_pool_match_against_book)
-  [Function `place_market_order`](#0x0_pool_place_market_order)
-  [Function `get_amount_out`](#0x0_pool_get_amount_out)
-  [Function `get_level2_bids`](#0x0_pool_get_level2_bids)
-  [Function `get_level2_asks`](#0x0_pool_get_level2_asks)
-  [Function `get_level2_ticks_from_mid`](#0x0_pool_get_level2_ticks_from_mid)
-  [Function `cancel_order`](#0x0_pool_cancel_order)
-  [Function `claim_rebates`](#0x0_pool_claim_rebates)
-  [Function `cancel_all`](#0x0_pool_cancel_all)
-  [Function `user_open_orders`](#0x0_pool_user_open_orders)
-  [Function `create_pool`](#0x0_pool_create_pool)
-  [Function `increase_user_stake`](#0x0_pool_increase_user_stake)
-  [Function `remove_user_stake`](#0x0_pool_remove_user_stake)
-  [Function `get_user_stake`](#0x0_pool_get_user_stake)
-  [Function `add_deep_price_point`](#0x0_pool_add_deep_price_point)
-  [Function `set_next_trade_params`](#0x0_pool_set_next_trade_params)
-  [Function `get_base_quote_types`](#0x0_pool_get_base_quote_types)
-  [Function `key`](#0x0_pool_key)
-  [Function `share`](#0x0_pool_share)
-  [Function `deposit_base`](#0x0_pool_deposit_base)
-  [Function `deposit_quote`](#0x0_pool_deposit_quote)
-  [Function `deposit_deep`](#0x0_pool_deposit_deep)
-  [Function `withdraw_base`](#0x0_pool_withdraw_base)
-  [Function `withdraw_quote`](#0x0_pool_withdraw_quote)
-  [Function `withdraw_deep`](#0x0_pool_withdraw_deep)
-  [Function `send_treasury`](#0x0_pool_send_treasury)
-  [Function `inject_limit_order`](#0x0_pool_inject_limit_order)
-  [Function `order_is_bid`](#0x0_pool_order_is_bid)
-  [Function `get_order_id`](#0x0_pool_get_order_id)
-  [Function `fee_is_deep`](#0x0_pool_fee_is_deep)
-  [Function `correct_supply`](#0x0_pool_correct_supply)


<pre><code><b>use</b> <a href="account.md#0x0_account">0x0::account</a>;
<b>use</b> <a href="big_vector.md#0x0_big_vector">0x0::big_vector</a>;
<b>use</b> <a href="deep_price.md#0x0_deep_price">0x0::deep_price</a>;
<b>use</b> <a href="math.md#0x0_math">0x0::math</a>;
<b>use</b> <a href="order.md#0x0_order">0x0::order</a>;
<b>use</b> <a href="state_manager.md#0x0_state_manager">0x0::state_manager</a>;
<b>use</b> <a href="utils.md#0x0_utils">0x0::utils</a>;
<b>use</b> <a href="dependencies/move-stdlib/ascii.md#0x1_ascii">0x1::ascii</a>;
<b>use</b> <a href="dependencies/move-stdlib/option.md#0x1_option">0x1::option</a>;
<b>use</b> <a href="dependencies/move-stdlib/type_name.md#0x1_type_name">0x1::type_name</a>;
<b>use</b> <a href="dependencies/sui-framework/balance.md#0x2_balance">0x2::balance</a>;
<b>use</b> <a href="dependencies/sui-framework/clock.md#0x2_clock">0x2::clock</a>;
<b>use</b> <a href="dependencies/sui-framework/coin.md#0x2_coin">0x2::coin</a>;
<b>use</b> <a href="dependencies/sui-framework/event.md#0x2_event">0x2::event</a>;
<b>use</b> <a href="dependencies/sui-framework/object.md#0x2_object">0x2::object</a>;
<b>use</b> <a href="dependencies/sui-framework/sui.md#0x2_sui">0x2::sui</a>;
<b>use</b> <a href="dependencies/sui-framework/transfer.md#0x2_transfer">0x2::transfer</a>;
<b>use</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context">0x2::tx_context</a>;
<b>use</b> <a href="dependencies/sui-framework/vec_set.md#0x2_vec_set">0x2::vec_set</a>;
</code></pre>



<a name="0x0_pool_PoolCreated"></a>

## Struct `PoolCreated`

Emitted when a new pool is created


<pre><code><b>struct</b> <a href="pool.md#0x0_pool_PoolCreated">PoolCreated</a>&lt;BaseAsset, QuoteAsset&gt; <b>has</b> <b>copy</b>, drop, store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>pool_id: <a href="dependencies/sui-framework/object.md#0x2_object_ID">object::ID</a></code>
</dt>
<dd>
 object ID of the newly created pool
</dd>
<dt>
<code>taker_fee: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>maker_fee: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>tick_size: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>lot_size: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>min_size: u64</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x0_pool_DEEP"></a>

## Struct `DEEP`

Temporary to represent DEEP token, remove after we have the open-sourced the DEEP token contract


<pre><code><b>struct</b> <a href="pool.md#0x0_pool_DEEP">DEEP</a> <b>has</b> store
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>dummy_field: bool</code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="0x0_pool_Pool"></a>

## Resource `Pool`

Pool holds everything related to the pool. next_bid_order_id increments for each bid order,
next_ask_order_id decrements for each ask order. All funds for live orders and settled funds
are held in base_balances, quote_balances, and deepbook_balance.


<pre><code><b>struct</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt; <b>has</b> key
</code></pre>



<details>
<summary>Fields</summary>


<dl>
<dt>
<code>id: <a href="dependencies/sui-framework/object.md#0x2_object_UID">object::UID</a></code>
</dt>
<dd>

</dd>
<dt>
<code>tick_size: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>lot_size: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>min_size: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>bids: <a href="big_vector.md#0x0_big_vector_BigVector">big_vector::BigVector</a>&lt;<a href="order.md#0x0_order_Order">order::Order</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>asks: <a href="big_vector.md#0x0_big_vector_BigVector">big_vector::BigVector</a>&lt;<a href="order.md#0x0_order_Order">order::Order</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>next_bid_order_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>next_ask_order_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>deep_config: <a href="dependencies/move-stdlib/option.md#0x1_option_Option">option::Option</a>&lt;<a href="deep_price.md#0x0_deep_price_DeepPrice">deep_price::DeepPrice</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>base_balances: <a href="dependencies/sui-framework/balance.md#0x2_balance_Balance">balance::Balance</a>&lt;BaseAsset&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>quote_balances: <a href="dependencies/sui-framework/balance.md#0x2_balance_Balance">balance::Balance</a>&lt;QuoteAsset&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>deepbook_balance: <a href="dependencies/sui-framework/balance.md#0x2_balance_Balance">balance::Balance</a>&lt;<a href="pool.md#0x0_pool_DEEP">pool::DEEP</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code><a href="state_manager.md#0x0_state_manager">state_manager</a>: <a href="state_manager.md#0x0_state_manager_StateManager">state_manager::StateManager</a></code>
</dt>
<dd>

</dd>
</dl>


</details>

<a name="@Constants_0"></a>

## Constants


<a name="0x0_pool_MAX_PRICE"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_MAX_PRICE">MAX_PRICE</a>: u64 = 4611686018427387904;
</code></pre>



<a name="0x0_pool_MIN_PRICE"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_MIN_PRICE">MIN_PRICE</a>: u64 = 1;
</code></pre>



<a name="0x0_pool_EInvalidFee"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_EInvalidFee">EInvalidFee</a>: u64 = 1;
</code></pre>



<a name="0x0_pool_EInvalidLotSize"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_EInvalidLotSize">EInvalidLotSize</a>: u64 = 4;
</code></pre>



<a name="0x0_pool_EInvalidMinSize"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_EInvalidMinSize">EInvalidMinSize</a>: u64 = 5;
</code></pre>



<a name="0x0_pool_EInvalidTickSize"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_EInvalidTickSize">EInvalidTickSize</a>: u64 = 3;
</code></pre>



<a name="0x0_pool_ESameBaseAndQuote"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_ESameBaseAndQuote">ESameBaseAndQuote</a>: u64 = 2;
</code></pre>



<a name="0x0_pool_MIN_ASK_ORDER_ID"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_MIN_ASK_ORDER_ID">MIN_ASK_ORDER_ID</a>: u128 = 170141183460469231731687303715884105728;
</code></pre>



<a name="0x0_pool_POOL_CREATION_FEE"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_POOL_CREATION_FEE">POOL_CREATION_FEE</a>: u64 = 100000000000;
</code></pre>



<a name="0x0_pool_START_ASK_ORDER_ID"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_START_ASK_ORDER_ID">START_ASK_ORDER_ID</a>: u64 = 1;
</code></pre>



<a name="0x0_pool_START_BID_ORDER_ID"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_START_BID_ORDER_ID">START_BID_ORDER_ID</a>: u64 = 9223372036854775808;
</code></pre>



<a name="0x0_pool_TREASURY_ADDRESS"></a>



<pre><code><b>const</b> <a href="pool.md#0x0_pool_TREASURY_ADDRESS">TREASURY_ADDRESS</a>: <b>address</b> = 0;
</code></pre>



<a name="0x0_pool_place_limit_order"></a>

## Function `place_limit_order`

Place a limit order to the order book.
1. Transfer any settled funds from the pool to the account.
2. Match the order against the order book if possible.
3. Transfer balances for the executed quantity as well as the remaining quantity.
4. Assert for any order restrictions.
5. If there is remaining quantity, inject the order into the order book.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_place_limit_order">place_limit_order</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, client_order_id: u64, order_type: u8, price: u64, quantity: u64, is_bid: bool, expire_timestamp: u64, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &<a href="dependencies/sui-framework/clock.md#0x2_clock_Clock">clock::Clock</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): <a href="order.md#0x0_order_Order">order::Order</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_place_limit_order">place_limit_order</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    client_order_id: u64,
    order_type: u8,
    price: u64,
    quantity: u64,
    is_bid: bool,
    expire_timestamp: u64,
    <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &Clock,
    ctx: &<b>mut</b> TxContext,
): Order {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.refresh(ctx.epoch());

    self.<a href="pool.md#0x0_pool_transfer_settled_amounts">transfer_settled_amounts</a>(<a href="account.md#0x0_account">account</a>, proof, ctx);

    <b>let</b> order_id = <a href="utils.md#0x0_utils_encode_order_id">utils::encode_order_id</a>(is_bid, price, self.<a href="pool.md#0x0_pool_get_order_id">get_order_id</a>(is_bid));
    <b>let</b> fee_is_deep = self.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>();
    <b>let</b> owner = <a href="account.md#0x0_account">account</a>.owner();
    <b>let</b> pool_id = self.id.to_inner();
    <b>let</b> <b>mut</b> <a href="order.md#0x0_order">order</a> =
        <a href="order.md#0x0_order_initial_order">order::initial_order</a>(pool_id, order_id, client_order_id, order_type, price, quantity, fee_is_deep, is_bid, owner, expire_timestamp);
    self.<a href="pool.md#0x0_pool_match_against_book">match_against_book</a>(&<b>mut</b> <a href="order.md#0x0_order">order</a>, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>);

    self.<a href="pool.md#0x0_pool_transfer_trade_balances">transfer_trade_balances</a>(<a href="account.md#0x0_account">account</a>, proof, &<b>mut</b> <a href="order.md#0x0_order">order</a>, ctx);

    <a href="order.md#0x0_order">order</a>.assert_post_only();
    <a href="order.md#0x0_order">order</a>.assert_fill_or_kill();
    <b>if</b> (<a href="order.md#0x0_order">order</a>.is_immediate_or_cancel() || <a href="order.md#0x0_order">order</a>.is_complete()) {
        <b>return</b> <a href="order.md#0x0_order">order</a>
    };

    <b>if</b> (<a href="order.md#0x0_order">order</a>.remaining_quantity() &gt; 0) {
        <b>let</b> order_copy = <a href="order.md#0x0_order">order</a>.copy_order();
        self.<a href="pool.md#0x0_pool_inject_limit_order">inject_limit_order</a>(order_copy);
    };

    <a href="order.md#0x0_order">order</a>
}
</code></pre>



</details>

<a name="0x0_pool_transfer_trade_balances"></a>

## Function `transfer_trade_balances`

Given an order, transfer the appropriate balances. Up until this point, any partial fills have been executed
and the remaining quantity is the only quantity left to be injected into the order book.
1. Transfer the taker balances while applying taker fees.
2. Transfer the maker balances while applying maker fees.
3. Update the total fees for the order.


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_transfer_trade_balances">transfer_trade_balances</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, <a href="order.md#0x0_order">order</a>: &<b>mut</b> <a href="order.md#0x0_order_Order">order::Order</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_transfer_trade_balances">transfer_trade_balances</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    <a href="order.md#0x0_order">order</a>: &<b>mut</b> Order,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> (<b>mut</b> base_in, <b>mut</b> base_out) = (0, 0);
    <b>let</b> (<b>mut</b> quote_in, <b>mut</b> quote_out) = (0, 0);
    <b>let</b> <b>mut</b> deep_in = 0;
    <b>let</b> (taker_fee, maker_fee) = (self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.taker_fee_for_user(<a href="account.md#0x0_account">account</a>.owner()), self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.maker_fee());
    <b>let</b> (executed_quantity, remaining_quantity, cumulative_quote_quantity) =
        (<a href="order.md#0x0_order">order</a>.executed_quantity(), <a href="order.md#0x0_order">order</a>.remaining_quantity(), <a href="order.md#0x0_order">order</a>.cumulative_quote_quantity());

    // Calculate the taker balances. These are derived from executed quantity.
    <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid()) {
        quote_in = quote_in + cumulative_quote_quantity;
        base_out = base_out + executed_quantity;
        <b>if</b> (self.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
            deep_in = deep_in + math::mul(taker_fee, math::mul(executed_quantity, self.deep_config.borrow().deep_per_quote()));
        } <b>else</b> {
            quote_in = quote_in + math::mul(taker_fee, executed_quantity);
        }
    } <b>else</b> {
        base_in = base_in + executed_quantity;
        quote_out = quote_out + cumulative_quote_quantity;
        <b>if</b> (self.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
            deep_in = deep_in + math::mul(taker_fee, math::mul(executed_quantity, self.deep_config.borrow().deep_per_base()));
        } <b>else</b> {
            base_in = base_in + math::mul(taker_fee, executed_quantity);
        }
    };

    // Calculate the maker balances. These are derived from the remaining quantity.
    <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid()) {
        quote_in = quote_in + remaining_quantity * <a href="order.md#0x0_order">order</a>.price();
        <b>if</b> (self.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
            deep_in = deep_in + math::mul(maker_fee, math::mul(remaining_quantity, self.deep_config.borrow().deep_per_quote()));
        } <b>else</b> {
            quote_in = quote_in + math::mul(maker_fee, quote_in);
        }
    } <b>else</b> {
        base_in = base_in + remaining_quantity;
        <b>if</b> (self.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
            deep_in = deep_in + math::mul(maker_fee, math::mul(remaining_quantity, self.deep_config.borrow().deep_per_base()));
        } <b>else</b> {
            base_in = base_in + math::mul(maker_fee, base_in);
        }
    };

    // Calculate the total fees for the <a href="order.md#0x0_order">order</a>.
    <b>let</b> total_fees = <b>if</b> (self.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
        deep_in
    } <b>else</b> {
        <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid()) {
            quote_in - <a href="order.md#0x0_order">order</a>.original_quantity() * <a href="order.md#0x0_order">order</a>.price()
        } <b>else</b> {
            base_in - <a href="order.md#0x0_order">order</a>.original_quantity()
        }
    };
    <a href="order.md#0x0_order">order</a>.set_total_fees(total_fees);

    <b>if</b> (base_in &gt; 0) self.<a href="pool.md#0x0_pool_deposit_base">deposit_base</a>(<a href="account.md#0x0_account">account</a>, proof, base_in, ctx);
    <b>if</b> (base_out &gt; 0) self.<a href="pool.md#0x0_pool_withdraw_base">withdraw_base</a>(<a href="account.md#0x0_account">account</a>, proof, base_out, ctx);
    <b>if</b> (quote_in &gt; 0) self.<a href="pool.md#0x0_pool_deposit_quote">deposit_quote</a>(<a href="account.md#0x0_account">account</a>, proof, quote_in, ctx);
    <b>if</b> (quote_out &gt; 0) self.<a href="pool.md#0x0_pool_withdraw_quote">withdraw_quote</a>(<a href="account.md#0x0_account">account</a>, proof, quote_out, ctx);
    <b>if</b> (deep_in &gt; 0) self.<a href="pool.md#0x0_pool_deposit_deep">deposit_deep</a>(<a href="account.md#0x0_account">account</a>, proof, deep_in, ctx);
}
</code></pre>



</details>

<a name="0x0_pool_transfer_settled_amounts"></a>

## Function `transfer_settled_amounts`

Transfer any settled amounts from the pool to the account.


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_transfer_settled_amounts">transfer_settled_amounts</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_transfer_settled_amounts">transfer_settled_amounts</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> (base_amount, quote_amount) = self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.reset_user_settled_amounts(<a href="account.md#0x0_account">account</a>.owner());
    self.<a href="pool.md#0x0_pool_withdraw_base">withdraw_base</a>(<a href="account.md#0x0_account">account</a>, proof, base_amount, ctx);
    self.<a href="pool.md#0x0_pool_withdraw_quote">withdraw_quote</a>(<a href="account.md#0x0_account">account</a>, proof, quote_amount, ctx);
}
</code></pre>



</details>

<a name="0x0_pool_match_against_book"></a>

## Function `match_against_book`

Matches the given order and quantity against the order book.
If is_bid, it will match against asks, otherwise against bids.
Mutates the order and the maker order as necessary.


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_match_against_book">match_against_book</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="order.md#0x0_order">order</a>: &<b>mut</b> <a href="order.md#0x0_order_Order">order::Order</a>, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &<a href="dependencies/sui-framework/clock.md#0x2_clock_Clock">clock::Clock</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_match_against_book">match_against_book</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="order.md#0x0_order">order</a>: &<b>mut</b> Order,
    <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &Clock,
) {
    <b>let</b> (<b>mut</b> ref, <b>mut</b> offset, book_side) = <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid()) {
        <b>let</b> (ref, offset) = self.asks.min_slice();
        (ref, offset, &<b>mut</b> self.asks)
    } <b>else</b> {
        <b>let</b> (ref, offset) = self.bids.max_slice();
        (ref, offset, &<b>mut</b> self.bids)
    };

    <b>if</b> (ref.is_null()) <b>return</b>;

    <b>let</b> <b>mut</b> executed_base_quantity = 0;
    <b>let</b> <b>mut</b> executed_quote_quantity = 0;
    <b>let</b> <b>mut</b> remove_order_ids = <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[];
    <b>let</b> <b>mut</b> remove_order_owners = <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[];

    <b>let</b> <b>mut</b> other_order = &<b>mut</b> book_side.borrow_slice_mut(ref)[offset];
    <b>while</b> (<a href="order.md#0x0_order">order</a>.remaining_quantity() &gt; 0 && <a href="order.md#0x0_order">order</a>.can_match(other_order) ) {
        <b>if</b> (other_order.is_expired(<a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>.timestamp_ms())) {
            other_order.set_expired();
            remove_order_ids.push_back(other_order.order_id());
            remove_order_owners.push_back(other_order.owner());
            <b>continue</b>
        };

        <b>let</b> (filled_quantity, quote_quantity) =
            <a href="order.md#0x0_order">order</a>.match_orders(other_order, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>.timestamp_ms());
        executed_base_quantity = executed_base_quantity + filled_quantity;
        executed_quote_quantity = executed_quote_quantity + quote_quantity;

        self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.add_user_settled_amount(other_order.owner(), filled_quantity, other_order.is_bid());
        self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.increase_maker_volume(other_order.owner(), filled_quantity);

        <b>if</b> (other_order.is_complete()) {
            remove_order_ids.push_back(other_order.order_id());
            remove_order_owners.push_back(other_order.owner());
        };

        // Traverse <b>to</b> valid next <a href="order.md#0x0_order">order</a> <b>if</b> exists, otherwise <b>break</b> from <b>loop</b>.
        <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid() && book_side.valid_next(ref, offset)) {
            (ref, offset, other_order) = book_side.borrow_mut_next(ref, offset)
        } <b>else</b> <b>if</b> (!<a href="order.md#0x0_order">order</a>.is_bid() && book_side.valid_prev(ref, offset)) {
            (ref, offset, other_order) = book_side.borrow_mut_prev(ref, offset)
        } <b>else</b> {
            <b>break</b>
        }
    };

    // Iterate over orders_to_remove and remove from the book.
    <b>let</b> <b>mut</b> i = 0;
    <b>while</b> (i &lt; remove_order_ids.length()) {
        self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.remove_user_open_order(remove_order_owners[i], remove_order_ids[i]);
        book_side.remove(remove_order_ids[i]);
        i = i + 1;
    };
}
</code></pre>



</details>

<a name="0x0_pool_place_market_order"></a>

## Function `place_market_order`

Place a market order. Quantity is in base asset terms. Calls place_limit_order with
a price of MAX_PRICE for bids and MIN_PRICE for asks. Fills or kills the order.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_place_market_order">place_market_order</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, client_order_id: u64, quantity: u64, is_bid: bool, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &<a href="dependencies/sui-framework/clock.md#0x2_clock_Clock">clock::Clock</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): <a href="order.md#0x0_order_Order">order::Order</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_place_market_order">place_market_order</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    client_order_id: u64,
    quantity: u64,
    is_bid: bool,
    <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &Clock,
    ctx: &<b>mut</b> TxContext,
): Order {
    self.<a href="pool.md#0x0_pool_place_limit_order">place_limit_order</a>(
        <a href="account.md#0x0_account">account</a>,
        proof,
        client_order_id,
        <a href="order.md#0x0_order_fill_or_kill">order::fill_or_kill</a>(),
        <b>if</b> (is_bid) <a href="pool.md#0x0_pool_MAX_PRICE">MAX_PRICE</a> <b>else</b> <a href="pool.md#0x0_pool_MIN_PRICE">MIN_PRICE</a>,
        quantity,
        is_bid,
        <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>.timestamp_ms(),
        <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>,
        ctx,
    )
}
</code></pre>



</details>

<a name="0x0_pool_get_amount_out"></a>

## Function `get_amount_out`

Given an amount in and direction, calculate amount out
Will return (amount_out, amount_in_used)


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_get_amount_out">get_amount_out</a>&lt;BaseAsset, QuoteAsset&gt;(_self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, _amount_in: u64, _is_bid: bool): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_get_amount_out">get_amount_out</a>&lt;BaseAsset, QuoteAsset&gt;(
    _self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    _amount_in: u64,
    _is_bid: bool,
): u64 {
    // TODO: implement
    0
}
</code></pre>



</details>

<a name="0x0_pool_get_level2_bids"></a>

## Function `get_level2_bids`

Get the level2 bids between price_low and price_high.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_get_level2_bids">get_level2_bids</a>&lt;BaseAsset, QuoteAsset&gt;(_self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, _price_low: u64, _price_high: u64): (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;, <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_get_level2_bids">get_level2_bids</a>&lt;BaseAsset, QuoteAsset&gt;(
    _self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    _price_low: u64,
    _price_high: u64,
): (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;, <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;) {
    // TODO: implement
    (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[], <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[])
}
</code></pre>



</details>

<a name="0x0_pool_get_level2_asks"></a>

## Function `get_level2_asks`

Get the level2 bids between price_low and price_high.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_get_level2_asks">get_level2_asks</a>&lt;BaseAsset, QuoteAsset&gt;(_self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, _price_low: u64, _price_high: u64): (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;, <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_get_level2_asks">get_level2_asks</a>&lt;BaseAsset, QuoteAsset&gt;(
    _self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    _price_low: u64,
    _price_high: u64,
): (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;, <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;) {
    // TODO: implement
    (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[], <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[])
}
</code></pre>



</details>

<a name="0x0_pool_get_level2_ticks_from_mid"></a>

## Function `get_level2_ticks_from_mid`

Get the n ticks from the mid price


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_get_level2_ticks_from_mid">get_level2_ticks_from_mid</a>&lt;BaseAsset, QuoteAsset&gt;(_self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, _ticks: u64): (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;, <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_get_level2_ticks_from_mid">get_level2_ticks_from_mid</a>&lt;BaseAsset, QuoteAsset&gt;(
    _self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    _ticks: u64,
): (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;, <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;u64&gt;) {
    // TODO: implement
    (<a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[], <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[])
}
</code></pre>



</details>

<a name="0x0_pool_cancel_order"></a>

## Function `cancel_order`

1. Remove the order from the order book and from the user's open orders.
2. Refund the user for the remaining quantity and fees.
2a. If the order is a bid, refund the quote asset + non deep fee.
2b. If the order is an ask, refund the base asset + non deep fee.
3. If the order was placed with deep fees, refund the deep fees.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_cancel_order">cancel_order</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, order_id: u128, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &<a href="dependencies/sui-framework/clock.md#0x2_clock_Clock">clock::Clock</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): <a href="order.md#0x0_order_Order">order::Order</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_cancel_order">cancel_order</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    order_id: u128,
    <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &Clock,
    ctx: &<b>mut</b> TxContext,
): Order {
    <b>let</b> <b>mut</b> <a href="order.md#0x0_order">order</a> = <b>if</b> (<a href="pool.md#0x0_pool_order_is_bid">order_is_bid</a>(order_id)) {
        self.bids.remove(order_id)
    } <b>else</b> {
        self.asks.remove(order_id)
    };
    <a href="order.md#0x0_order">order</a>.set_canceled();
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.remove_user_open_order(<a href="account.md#0x0_account">account</a>.owner(), order_id);

    <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid()) {
        <b>let</b> <b>mut</b> quote_quantity = math::mul(<a href="order.md#0x0_order">order</a>.remaining_quantity(), <a href="order.md#0x0_order">order</a>.price());
        <b>if</b> (!<a href="order.md#0x0_order">order</a>.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
            quote_quantity = quote_quantity + <a href="order.md#0x0_order">order</a>.fees_to_refund();
        };
        self.<a href="pool.md#0x0_pool_withdraw_quote">withdraw_quote</a>(<a href="account.md#0x0_account">account</a>, proof, quote_quantity, ctx)
    } <b>else</b> {
        <b>let</b> <b>mut</b> base_quantity = <a href="order.md#0x0_order">order</a>.remaining_quantity();
        <b>if</b> (!<a href="order.md#0x0_order">order</a>.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
            base_quantity = base_quantity + <a href="order.md#0x0_order">order</a>.fees_to_refund();
        };
        self.<a href="pool.md#0x0_pool_withdraw_base">withdraw_base</a>(<a href="account.md#0x0_account">account</a>, proof, base_quantity, ctx)
    };

    <b>if</b> (<a href="order.md#0x0_order">order</a>.<a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>()) {
        self.<a href="pool.md#0x0_pool_withdraw_deep">withdraw_deep</a>(<a href="account.md#0x0_account">account</a>, proof, <a href="order.md#0x0_order">order</a>.fees_to_refund(), ctx)
    };

    <a href="order.md#0x0_order">order</a>.emit_order_canceled&lt;BaseAsset, QuoteAsset&gt;(<a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>.timestamp_ms());

    <a href="order.md#0x0_order">order</a>
}
</code></pre>



</details>

<a name="0x0_pool_claim_rebates"></a>

## Function `claim_rebates`

Claim the rebates for the user


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_claim_rebates">claim_rebates</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_claim_rebates">claim_rebates</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    ctx: &<b>mut</b> TxContext
) {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.refresh(ctx.epoch());
    <b>let</b> amount = self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.reset_user_rebates(<a href="account.md#0x0_account">account</a>.owner());
    <b>let</b> <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a> = self.deepbook_balance.split(amount).into_coin(ctx);
    <a href="account.md#0x0_account">account</a>.deposit_with_proof&lt;<a href="pool.md#0x0_pool_DEEP">DEEP</a>&gt;(proof, <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a>);
}
</code></pre>



</details>

<a name="0x0_pool_cancel_all"></a>

## Function `cancel_all`

Cancel all orders for an account. Withdraw settled funds back into user account.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_cancel_all">cancel_all</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="account.md#0x0_account">account</a>: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &<a href="dependencies/sui-framework/clock.md#0x2_clock_Clock">clock::Clock</a>, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;<a href="order.md#0x0_order_Order">order::Order</a>&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_cancel_all">cancel_all</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="account.md#0x0_account">account</a>: &<b>mut</b> Account,
    proof: &TradeProof,
    <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>: &Clock,
    ctx: &<b>mut</b> TxContext,
): <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>&lt;Order&gt;{
    <b>let</b> <b>mut</b> cancelled_orders = <a href="dependencies/move-stdlib/vector.md#0x1_vector">vector</a>[];
    <b>let</b> user_open_orders = self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.<a href="pool.md#0x0_pool_user_open_orders">user_open_orders</a>(<a href="account.md#0x0_account">account</a>.owner());

    <b>let</b> orders_vector = user_open_orders.into_keys();
    <b>let</b> len = orders_vector.length();
    <b>let</b> <b>mut</b> i = 0;
    <b>while</b> (i &lt; len) {
        <b>let</b> key = orders_vector[i];
        <b>let</b> cancelled_order = <a href="pool.md#0x0_pool_cancel_order">cancel_order</a>(self, <a href="account.md#0x0_account">account</a>, proof, key, <a href="dependencies/sui-framework/clock.md#0x2_clock">clock</a>, ctx);
        cancelled_orders.push_back(cancelled_order);
        i = i + 1;
    };

    cancelled_orders
}
</code></pre>



</details>

<a name="0x0_pool_user_open_orders"></a>

## Function `user_open_orders`

Get all open orders for a user.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_user_open_orders">user_open_orders</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user: <b>address</b>): <a href="dependencies/sui-framework/vec_set.md#0x2_vec_set_VecSet">vec_set::VecSet</a>&lt;u128&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_user_open_orders">user_open_orders</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user: <b>address</b>,
): VecSet&lt;u128&gt; {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.<a href="pool.md#0x0_pool_user_open_orders">user_open_orders</a>(user)
}
</code></pre>



</details>

<a name="0x0_pool_create_pool"></a>

## Function `create_pool`

Creates a new pool for trading and returns pool_key, called by state module


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_create_pool">create_pool</a>&lt;BaseAsset, QuoteAsset&gt;(taker_fee: u64, maker_fee: u64, tick_size: u64, lot_size: u64, min_size: u64, creation_fee: <a href="dependencies/sui-framework/balance.md#0x2_balance_Balance">balance::Balance</a>&lt;<a href="dependencies/sui-framework/sui.md#0x2_sui_SUI">sui::SUI</a>&gt;, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_create_pool">create_pool</a>&lt;BaseAsset, QuoteAsset&gt;(
    taker_fee: u64,
    maker_fee: u64,
    tick_size: u64,
    lot_size: u64,
    min_size: u64,
    creation_fee: Balance&lt;SUI&gt;,
    ctx: &<b>mut</b> TxContext,
): <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt; {
    <b>assert</b>!(creation_fee.value() == <a href="pool.md#0x0_pool_POOL_CREATION_FEE">POOL_CREATION_FEE</a>, <a href="pool.md#0x0_pool_EInvalidFee">EInvalidFee</a>);
    <b>assert</b>!(tick_size &gt; 0, <a href="pool.md#0x0_pool_EInvalidTickSize">EInvalidTickSize</a>);
    <b>assert</b>!(lot_size &gt; 0, <a href="pool.md#0x0_pool_EInvalidLotSize">EInvalidLotSize</a>);
    <b>assert</b>!(min_size &gt; 0, <a href="pool.md#0x0_pool_EInvalidMinSize">EInvalidMinSize</a>);

    <b>assert</b>!(<a href="dependencies/move-stdlib/type_name.md#0x1_type_name_get">type_name::get</a>&lt;BaseAsset&gt;() != <a href="dependencies/move-stdlib/type_name.md#0x1_type_name_get">type_name::get</a>&lt;QuoteAsset&gt;(), <a href="pool.md#0x0_pool_ESameBaseAndQuote">ESameBaseAndQuote</a>);

    <b>let</b> pool_uid = <a href="dependencies/sui-framework/object.md#0x2_object_new">object::new</a>(ctx);

    <a href="dependencies/sui-framework/event.md#0x2_event_emit">event::emit</a>(<a href="pool.md#0x0_pool_PoolCreated">PoolCreated</a>&lt;BaseAsset, QuoteAsset&gt; {
        pool_id: pool_uid.to_inner(),
        taker_fee,
        maker_fee,
        tick_size,
        lot_size,
        min_size,
    });

    <b>let</b> <a href="pool.md#0x0_pool">pool</a> = (<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt; {
        id: pool_uid,
        bids: <a href="big_vector.md#0x0_big_vector_empty">big_vector::empty</a>(10000, 1000, ctx), // TODO: what are these numbers
        asks: <a href="big_vector.md#0x0_big_vector_empty">big_vector::empty</a>(10000, 1000, ctx), // TODO: ditto
        next_bid_order_id: <a href="pool.md#0x0_pool_START_BID_ORDER_ID">START_BID_ORDER_ID</a>,
        next_ask_order_id: <a href="pool.md#0x0_pool_START_ASK_ORDER_ID">START_ASK_ORDER_ID</a>,
        deep_config: <a href="dependencies/move-stdlib/option.md#0x1_option_none">option::none</a>(),
        tick_size,
        lot_size,
        min_size,
        base_balances: <a href="dependencies/sui-framework/balance.md#0x2_balance_zero">balance::zero</a>(),
        quote_balances: <a href="dependencies/sui-framework/balance.md#0x2_balance_zero">balance::zero</a>(),
        deepbook_balance: <a href="dependencies/sui-framework/balance.md#0x2_balance_zero">balance::zero</a>(),
        <a href="state_manager.md#0x0_state_manager">state_manager</a>: <a href="state_manager.md#0x0_state_manager_new">state_manager::new</a>(taker_fee, maker_fee, 0, ctx),
    });

    // TODO: reconsider sending the Coin here. User pays gas;
    // TODO: depending on the frequency of the <a href="dependencies/sui-framework/event.md#0x2_event">event</a>;
    <a href="dependencies/sui-framework/transfer.md#0x2_transfer_public_transfer">transfer::public_transfer</a>(creation_fee.into_coin(ctx), <a href="pool.md#0x0_pool_TREASURY_ADDRESS">TREASURY_ADDRESS</a>);

    <a href="pool.md#0x0_pool">pool</a>
}
</code></pre>



</details>

<a name="0x0_pool_increase_user_stake"></a>

## Function `increase_user_stake`

Increase a user's stake


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_increase_user_stake">increase_user_stake</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user: <b>address</b>, amount: u64, ctx: &<a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_increase_user_stake">increase_user_stake</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user: <b>address</b>,
    amount: u64,
    ctx: &TxContext,
): (u64, u64) {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.refresh(ctx.epoch());

    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.<a href="pool.md#0x0_pool_increase_user_stake">increase_user_stake</a>(user, amount)
}
</code></pre>



</details>

<a name="0x0_pool_remove_user_stake"></a>

## Function `remove_user_stake`

Removes a user's stake.
Returns the total amount staked before this epoch and the total amount staked during this epoch.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_remove_user_stake">remove_user_stake</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user: <b>address</b>, ctx: &<a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_remove_user_stake">remove_user_stake</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user: <b>address</b>,
    ctx: &TxContext
): (u64, u64) {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.refresh(ctx.epoch());

    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.<a href="pool.md#0x0_pool_remove_user_stake">remove_user_stake</a>(user)
}
</code></pre>



</details>

<a name="0x0_pool_get_user_stake"></a>

## Function `get_user_stake`

Get the user's (current, next) stake amounts


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_get_user_stake">get_user_stake</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user: <b>address</b>, ctx: &<a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>): (u64, u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_get_user_stake">get_user_stake</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user: <b>address</b>,
    ctx: &TxContext,
): (u64, u64) {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.user_stake(user, ctx.epoch())
}
</code></pre>



</details>

<a name="0x0_pool_add_deep_price_point"></a>

## Function `add_deep_price_point`

Add a new price point to the pool.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_add_deep_price_point">add_deep_price_point</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, base_conversion_rate: u64, quote_conversion_rate: u64, timestamp: u64)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_add_deep_price_point">add_deep_price_point</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    base_conversion_rate: u64,
    quote_conversion_rate: u64,
    timestamp: u64,
) {
    <b>if</b> (self.deep_config.is_none()) {
        self.deep_config.fill(<a href="deep_price.md#0x0_deep_price_empty">deep_price::empty</a>());
    };
    self.deep_config
        .borrow_mut()
        .add_price_point(base_conversion_rate, quote_conversion_rate, timestamp);
}
</code></pre>



</details>

<a name="0x0_pool_set_next_trade_params"></a>

## Function `set_next_trade_params`

Update the pool's next pool state.
During an epoch refresh, the current pool state is moved to historical pool state.
The next pool state is moved to current pool state.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_set_next_trade_params">set_next_trade_params</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, fees: <a href="dependencies/move-stdlib/option.md#0x1_option_Option">option::Option</a>&lt;<a href="state_manager.md#0x0_state_manager_TradeParams">state_manager::TradeParams</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_set_next_trade_params">set_next_trade_params</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    fees: Option&lt;TradeParams&gt;,
) {
    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.<a href="pool.md#0x0_pool_set_next_trade_params">set_next_trade_params</a>(fees);
}
</code></pre>



</details>

<a name="0x0_pool_get_base_quote_types"></a>

## Function `get_base_quote_types`

Get the base and quote asset of pool, return as ascii strings


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_get_base_quote_types">get_base_quote_types</a>&lt;BaseAsset, QuoteAsset&gt;(_self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;): (<a href="dependencies/move-stdlib/ascii.md#0x1_ascii_String">ascii::String</a>, <a href="dependencies/move-stdlib/ascii.md#0x1_ascii_String">ascii::String</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_get_base_quote_types">get_base_quote_types</a>&lt;BaseAsset, QuoteAsset&gt;(
    _self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;
): (String, String) {
    (
        <a href="dependencies/move-stdlib/type_name.md#0x1_type_name_get">type_name::get</a>&lt;BaseAsset&gt;().into_string(),
        <a href="dependencies/move-stdlib/type_name.md#0x1_type_name_get">type_name::get</a>&lt;QuoteAsset&gt;().into_string()
    )
}
</code></pre>



</details>

<a name="0x0_pool_key"></a>

## Function `key`

Get the pool key string base+quote (if base, quote in lexicographic order) otherwise return quote+base
TODO: Why is this needed as a key? Why don't we just use the ID of the pool as an ID?


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_key">key</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;): <a href="dependencies/move-stdlib/ascii.md#0x1_ascii_String">ascii::String</a>
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_key">key</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;
): String {
    <b>let</b> (base, quote) = <a href="pool.md#0x0_pool_get_base_quote_types">get_base_quote_types</a>(self);
    <b>if</b> (<a href="utils.md#0x0_utils_compare">utils::compare</a>(&base, &quote)) {
        <a href="utils.md#0x0_utils_concat_ascii">utils::concat_ascii</a>(base, quote)
    } <b>else</b> {
        <a href="utils.md#0x0_utils_concat_ascii">utils::concat_ascii</a>(quote, base)
    }
}
</code></pre>



</details>

<a name="0x0_pool_share"></a>

## Function `share`

Share the Pool.


<pre><code><b>public</b>(<b>friend</b>) <b>fun</b> <a href="pool.md#0x0_pool_share">share</a>&lt;BaseAsset, QuoteAsset&gt;(self: <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>public</b>(<a href="dependencies/sui-framework/package.md#0x2_package">package</a>) <b>fun</b> <a href="pool.md#0x0_pool_share">share</a>&lt;BaseAsset, QuoteAsset&gt;(self: <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;) {
    <a href="dependencies/sui-framework/transfer.md#0x2_transfer_share_object">transfer::share_object</a>(self)
}
</code></pre>



</details>

<a name="0x0_pool_deposit_base"></a>

## Function `deposit_base`

This will be automatically called if not enough assets in settled_funds for a trade
User cannot manually deposit. Funds are withdrawn from user account and merged into pool balances.


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_deposit_base">deposit_base</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user_account: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, amount: u64, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_deposit_base">deposit_base</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user_account: &<b>mut</b> Account,
    proof: &TradeProof,
    amount: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> base = user_account.withdraw_with_proof&lt;BaseAsset&gt;(proof, amount, ctx);
    self.base_balances.join(base.into_balance());
}
</code></pre>



</details>

<a name="0x0_pool_deposit_quote"></a>

## Function `deposit_quote`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_deposit_quote">deposit_quote</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user_account: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, amount: u64, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_deposit_quote">deposit_quote</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user_account: &<b>mut</b> Account,
    proof: &TradeProof,
    amount: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> quote = user_account.withdraw_with_proof&lt;QuoteAsset&gt;(proof, amount, ctx);
    self.quote_balances.join(quote.into_balance());
}
</code></pre>



</details>

<a name="0x0_pool_deposit_deep"></a>

## Function `deposit_deep`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_deposit_deep">deposit_deep</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user_account: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, amount: u64, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_deposit_deep">deposit_deep</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user_account: &<b>mut</b> Account,
    proof: &TradeProof,
    amount: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a> = user_account.withdraw_with_proof&lt;<a href="pool.md#0x0_pool_DEEP">DEEP</a>&gt;(proof, amount, ctx);
    self.deepbook_balance.join(<a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a>.into_balance());
}
</code></pre>



</details>

<a name="0x0_pool_withdraw_base"></a>

## Function `withdraw_base`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_withdraw_base">withdraw_base</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user_account: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, amount: u64, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_withdraw_base">withdraw_base</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user_account: &<b>mut</b> Account,
    proof: &TradeProof,
    amount: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a> = self.base_balances.split(amount).into_coin(ctx);
    user_account.deposit_with_proof&lt;BaseAsset&gt;(proof, <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a>);
}
</code></pre>



</details>

<a name="0x0_pool_withdraw_quote"></a>

## Function `withdraw_quote`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_withdraw_quote">withdraw_quote</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user_account: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, amount: u64, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_withdraw_quote">withdraw_quote</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user_account: &<b>mut</b> Account,
    proof: &TradeProof,
    amount: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a> = self.quote_balances.split(amount).into_coin(ctx);
    user_account.deposit_with_proof&lt;QuoteAsset&gt;(proof, <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a>);
}
</code></pre>



</details>

<a name="0x0_pool_withdraw_deep"></a>

## Function `withdraw_deep`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_withdraw_deep">withdraw_deep</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, user_account: &<b>mut</b> <a href="account.md#0x0_account_Account">account::Account</a>, proof: &<a href="account.md#0x0_account_TradeProof">account::TradeProof</a>, amount: u64, ctx: &<b>mut</b> <a href="dependencies/sui-framework/tx_context.md#0x2_tx_context_TxContext">tx_context::TxContext</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_withdraw_deep">withdraw_deep</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    user_account: &<b>mut</b> Account,
    proof: &TradeProof,
    amount: u64,
    ctx: &<b>mut</b> TxContext,
) {
    <b>let</b> <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a> = self.deepbook_balance.split(amount).into_coin(ctx);
    user_account.deposit_with_proof&lt;<a href="pool.md#0x0_pool_DEEP">DEEP</a>&gt;(proof, <a href="dependencies/sui-framework/coin.md#0x2_coin">coin</a>);
}
</code></pre>



</details>

<a name="0x0_pool_send_treasury"></a>

## Function `send_treasury`

Send fees collected in input tokens to treasury


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_send_treasury">send_treasury</a>&lt;T&gt;(fee: <a href="dependencies/sui-framework/coin.md#0x2_coin_Coin">coin::Coin</a>&lt;T&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_send_treasury">send_treasury</a>&lt;T&gt;(fee: Coin&lt;T&gt;) {
    <a href="dependencies/sui-framework/transfer.md#0x2_transfer_public_transfer">transfer::public_transfer</a>(fee, <a href="pool.md#0x0_pool_TREASURY_ADDRESS">TREASURY_ADDRESS</a>)
}
</code></pre>



</details>

<a name="0x0_pool_inject_limit_order"></a>

## Function `inject_limit_order`

Balance accounting happens before this function is called


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_inject_limit_order">inject_limit_order</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, <a href="order.md#0x0_order">order</a>: <a href="order.md#0x0_order_Order">order::Order</a>)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_inject_limit_order">inject_limit_order</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    <a href="order.md#0x0_order">order</a>: Order,
) {
    <a href="order.md#0x0_order">order</a>.emit_order_placed&lt;BaseAsset, QuoteAsset&gt;();
    <b>let</b> (order_id, owner) = (<a href="order.md#0x0_order">order</a>.order_id(), <a href="order.md#0x0_order">order</a>.owner());
    <b>if</b> (<a href="order.md#0x0_order">order</a>.is_bid()) {
        self.bids.insert(order_id, <a href="order.md#0x0_order">order</a>);
    } <b>else</b> {
        self.asks.insert(order_id, <a href="order.md#0x0_order">order</a>);
    };

    self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.add_user_open_order(owner, order_id);
}
</code></pre>



</details>

<a name="0x0_pool_order_is_bid"></a>

## Function `order_is_bid`

Returns 0 if the order is a bid order, 1 if the order is an ask order


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_order_is_bid">order_is_bid</a>(order_id: u128): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_order_is_bid">order_is_bid</a>(order_id: u128): bool {
    (order_id &lt; <a href="pool.md#0x0_pool_MIN_ASK_ORDER_ID">MIN_ASK_ORDER_ID</a>)
}
</code></pre>



</details>

<a name="0x0_pool_get_order_id"></a>

## Function `get_order_id`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_get_order_id">get_order_id</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;, is_bid: bool): u64
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_get_order_id">get_order_id</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;,
    is_bid: bool
): u64 {
    <b>if</b> (is_bid) {
        self.next_bid_order_id = self.next_bid_order_id - 1;
        self.next_bid_order_id
    } <b>else</b> {
        self.next_ask_order_id = self.next_ask_order_id + 1;
        self.next_ask_order_id
    }
}
</code></pre>



</details>

<a name="0x0_pool_fee_is_deep"></a>

## Function `fee_is_deep`

Returns if the order fee is paid in deep tokens


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>&lt;BaseAsset, QuoteAsset&gt;(self: &<a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;BaseAsset, QuoteAsset&gt;): bool
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_fee_is_deep">fee_is_deep</a>&lt;BaseAsset, QuoteAsset&gt;(
    self: &<a href="pool.md#0x0_pool_Pool">Pool</a>&lt;BaseAsset, QuoteAsset&gt;
): bool {
    self.deep_config.is_some()
}
</code></pre>



</details>

<a name="0x0_pool_correct_supply"></a>

## Function `correct_supply`



<pre><code><b>fun</b> <a href="pool.md#0x0_pool_correct_supply">correct_supply</a>&lt;B, Q&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">pool::Pool</a>&lt;B, Q&gt;, tcap: &<b>mut</b> <a href="dependencies/sui-framework/coin.md#0x2_coin_TreasuryCap">coin::TreasuryCap</a>&lt;<a href="pool.md#0x0_pool_DEEP">pool::DEEP</a>&gt;)
</code></pre>



<details>
<summary>Implementation</summary>


<pre><code><b>fun</b> <a href="pool.md#0x0_pool_correct_supply">correct_supply</a>&lt;B, Q&gt;(self: &<b>mut</b> <a href="pool.md#0x0_pool_Pool">Pool</a>&lt;B, Q&gt;, tcap: &<b>mut</b> TreasuryCap&lt;<a href="pool.md#0x0_pool_DEEP">DEEP</a>&gt;) {
    <b>let</b> amount = self.<a href="state_manager.md#0x0_state_manager">state_manager</a>.reset_burn_balance();
    <b>let</b> burnt = self.deepbook_balance.split(amount);
    tcap.supply_mut().decrease_supply(burnt);
}
</code></pre>



</details>