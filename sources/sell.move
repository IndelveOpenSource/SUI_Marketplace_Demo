module ttmarketplace::sell {
    use sui::object::{Self, ID, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use ttmarketplace::mint::{Nft};

    const EInvalidPublisher: u64 = 0;

    struct NftOwnership has key {
        id: UID,
        nft: ID,
        price: u64,
        publisher: address,
    }

    public entry fun sell_nft(
        nft: &mut Nft,
        price: u64,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nftOwnership = NftOwnership { 
            id: object::new(ctx),
            nft: object::id(nft),
            price,
            publisher: sender,
        };
        transfer::share_object(nftOwnership);
    }

    public entry fun delete(nftOwnership: &mut NftOwnership, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        assert!(sender == nftOwnership.publisher, EInvalidPublisher);
        delete_publication(nftOwnership);
    }

    public fun getPrice(self: &mut NftOwnership): u64 {
        return self.price
    }
    
    public fun getPublisher(self: &mut NftOwnership): address {
        return self.publisher
    }

    public fun delete_publication(nftOwnership: &mut NftOwnership) {
        nftOwnership.publisher = @0x0;
    }
}