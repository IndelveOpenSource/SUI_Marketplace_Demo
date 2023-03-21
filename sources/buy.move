module ttmarketplace::buy {
    use sui::transfer;
    use sui::sui::SUI;
    use sui::coin::{Self, Coin};
    use sui::tx_context::{Self, TxContext};
    use ttmarketplace::mint::{Nft};
    use ttmarketplace::sell::{Self, NftOwnership};

    const EInvalidBuyer: u64 = 1;

    public entry fun buy_nft(
        nftOwnership: &mut NftOwnership,
        nft: &mut Nft,
        coin: &mut Coin<SUI>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nftPrice = ttmarketplace::sell::getPrice(nftOwnership);
        let publisher = ttmarketplace::sell::getPublisher(nftOwnership);

        assert!(sender != publisher, EInvalidBuyer);

        ttmarketplace::mint::update_ownership(nft, sender);
        
        let coinBalance = sui::coin::balance_mut(coin);
        transfer::transfer(
            sui::coin::take(coinBalance, nftPrice, ctx),
            publisher
        );

        ttmarketplace::sell::delete_publication(nftOwnership);
    }



}