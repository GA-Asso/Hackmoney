module cashback_id::profile {
    use std::string::String;
    use sui::event;
    use sui::object::{Self, UID, new as new_object, uid_to_address};
    use sui::tx_context::{Self, TxContext, sender};
    use sui::transfer;

    public struct ProfileCreated has copy, drop {
        profile_id: address,
        owner: address,
    }

    public struct PreferencesUpdated has copy, drop {
        profile_id: address,
        mode: String,
        percent: u8,
        autocompound: bool,
    }

    public struct CashbackReceived has copy, drop {
        profile_id: address,
        amount: u64,
        new_total: u64,
        new_tier: u8,
    }

    public struct CashbackProfile has key, store {
        id: UID,
        mode: String,
        percent: u8,
        autocompound: bool,
        total_cashback: u64,
        total_spent: u64,
        tier: u8,
    }

    public fun create_profile(ctx: &mut TxContext): CashbackProfile {
        let profile = CashbackProfile {
            id: new_object(ctx),
            mode: std::string::utf8(b"hold"),
            percent: 1,
            autocompound: false,
            total_cashback: 0,
            total_spent: 0,
            tier: 1,
        };

        event::emit(ProfileCreated {
            profile_id: uid_to_address(&profile.id),
            owner: sender(ctx),
        });

        profile
    }

    public entry fun create_and_transfer_to_sender(ctx: &mut TxContext) {
        let profile = create_profile(ctx);
        transfer::transfer(profile, sender(ctx));
    }

    public entry fun update_preferences(
        profile: &mut CashbackProfile,
        mode: String,
        percent: u8,
        autocompound: bool,
    ) {
        assert!(percent >= 1 && percent <= 10, 0);
        profile.mode = mode;
        profile.percent = percent;
        profile.autocompound = autocompound;

        event::emit(PreferencesUpdated {
            profile_id: uid_to_address(&profile.id),
            mode: profile.mode,
            percent,
            autocompound,
        });
    }

    public fun add_cashback(profile: &mut CashbackProfile, amount: u64, spent: u64) {
        profile.total_cashback = profile.total_cashback + amount;
        profile.total_spent = profile.total_spent + spent;
        profile.tier = calculate_tier(profile.total_spent);

        event::emit(CashbackReceived {
            profile_id: uid_to_address(&profile.id),
            amount,
            new_total: profile.total_cashback,
            new_tier: profile.tier,
        });
    }

    public fun mode(p: &CashbackProfile): &String { &p.mode }
    public fun percent(p: &CashbackProfile): u8 { p.percent }
    public fun tier(p: &CashbackProfile): u8 { p.tier }
    public fun total_cashback(p: &CashbackProfile): u64 { p.total_cashback }

    fun calculate_tier(total_spent: u64): u8 {
        if (total_spent >= 10000_000000) { 3 }
        else if (total_spent >= 1000_000000) { 2 }
        else { 1 }
    }

    public fun get_tier_bonus(tier: u8): u8 {
        if (tier == 3) { 3 }
        else if (tier == 2) { 2 }
        else { 0 }
    }
}
