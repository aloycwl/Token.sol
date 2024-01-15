# ERC721

Contains:

ERC721.sol - The lightest version of ERC721 token contract with suspension.

Mintable.sol - Enable minting of NFT for contract owner, 
also minting of NFT with ECSDA signing and payment using coin or token.

Burnable.sol - Enable burning of NFT for NFT owner.

Mergeable.sol - Enable merging of NFT. This will burn the existing NFT(s) by NFT owner
and mint a new one with better ability.

Upgradeable.sol - Enable upgrading of NFT. This will burn the existing NFT and reissue
a new one with better ability.

Setting the base URI for ERC721, you must break up your uri into 32 bytes and the rest of it.
Must add a slash (/) at the end of your CID.
```
bytes32 b01;
bytes32 b02;
assembly {
  b01 := "ipfs://QmbpbGsoMJs7x87t7MXhQTuBo"
  b02 := "rebQCbP9NHACkbM1dhNqA/"
}
Proxy(payable(address(this))).mem(0x0000000773696720657272000000000000000000000000000000000000000000, b01);
Proxy(payable(address(this))).mem(0x0000000773696720657272000000000000000000000000000000000000000001, b02);
```
