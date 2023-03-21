module ttmarketplace::mint {
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::url::{Self, Url};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    const EInvalidOwner: u64 = 0;

    struct Nft has key {
        id: UID,
        name: string::String,
        description: string::String,
        url: Url,
        owner: address,
    }

    public entry fun create_nft(
        name: vector<u8>, 
        description: vector<u8>, 
        url: vector<u8>, 
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = Nft {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url),
            owner: sender,
        };
        transfer::share_object(nft);
    }

    public fun update_ownership(nft: &mut Nft, newOwner: address) {
        nft.owner = newOwner;
    }

}