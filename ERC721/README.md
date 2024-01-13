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