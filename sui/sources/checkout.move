module cashback_id::checkout {
    use sui::coin::{Self, Coin, value};
    use sui::sui::SUI;
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext, sender};
    use std::vector;
    use cashback_id::profile::{Self, CashbackProfile};

    public struct PaymentProcessed has copy, drop {
        payer: address,
        merchant: address,
        amount: u64,
        cashback: u64,
    }

    public entry fun process_payment(
        profile: &mut CashbackProfile,
        payment: Coin<SUI>,
        merchant: address,
        ctx: &mut TxContext,
    ) {
        let amount = value(&payment);
        let base_percent = profile::percent(profile);
        let tier_bonus = profile::get_tier_bonus(profile::tier(profile));
        let total_percent = base_percent + tier_bonus;
        let cashback_amount = (amount * (total_percent as u64)) / 100;

        profile::add_cashback(profile, cashback_amount, amount);
        transfer::public_transfer(payment, merchant);

        event::emit(PaymentProcessed {
            payer: sender(ctx),
            merchant,
            amount,
            cashback: cashback_amount,
        });
    }

    public fun batch_payment_start(): vector<u64> { vector::empty() }

    public fun batch_payment_add(batch: &mut vector<u64>, amount: u64) {
        vector::push_back(batch, amount);
    }

    public fun batch_payment_total(batch: &vector<u64>): u64 {
        let mut total: u64 = 0;
        let len = vector::length(batch);
        let mut i: u64 = 0;
        while (i < len) {
            total = total + *vector::borrow(batch, i);
            i = i + 1;
        };
        total
    }
}
