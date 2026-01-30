module clay_cooler::profiles {
    use std::string::{String};
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::coin::{Self, Coin};
    use sui::sui::SUI;
    use sui::transfer;

    /// The Core Profile Object
    struct CreatorProfile has key, store {
        id: UID,
        owner: address,
        name: String,
        x_handle: String,
        niche: String,
        tier: u8,
        is_hatched: bool,
        sui_balance: u64,
    }

    /// Function: Create the initial 'Cold Mud' Profile
    public entry fun create_profile(
        name: String, 
        x_handle: String, 
        niche: String, 
        ctx: &mut TxContext
    ) {
        let profile = CreatorProfile {
            id: object::new(ctx),
            owner: tx_context::sender(ctx),
            name,
            x_handle,
            niche,
            tier: 1, 
            is_hatched: false,
            sui_balance: 0,
        };
        transfer::share_object(profile);
    }

    /// Function: Glacial Sync (Update social handle safely)
    public entry fun glacial_sync(
        profile: &mut CreatorProfile,
        new_handle: String,
        ctx: &mut TxContext
    ) {
        assert!(tx_context::sender(ctx) == profile.owner, 0);
        profile.x_handle = new_handle;
    }

    /// Function: Make it Snow (Tipping Logic)
    public entry fun make_it_snow(
        profile: &mut CreatorProfile,
        payment: Coin<SUI>,
        _ctx: &mut TxContext
    ) {
        let amount = coin::value(&payment);
        profile.sui_balance = profile.sui_balance + amount;
        transfer::public_transfer(payment, profile.owner);
    }
}