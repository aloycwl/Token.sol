# ERC20

Contains:

ERC20.sol - The lightest version of ERC20 token contract with suspension.

Mintable.sol - Enable minting of tokens for contract owner

Burnable.sol - Enable burning of tokens for token owner

This contract is to be used with my proxy contract with the mem() function, you can get from here https://github.com/aloycwl/Proxy.sol/tree/main/ERC897.  To suspend the contract or an user, you need to edit the storage slot.

To suspend the contract or a single address from all withdrawal
```
bytes32 b32;
assembly {
  b32 := 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 // Replace this with the contract or user's address
}
Proxy(payable(address(this))).mem(b32, bytes32(uint(0x01)));
```

To unsuspend the contract or a single address
```
bytes32 b32;
assembly {
  b32 := 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 // Replace this with the contract or user's address
}
Proxy(payable(address(this))).mem(b32, bytes32(uint(0x00)));
```
