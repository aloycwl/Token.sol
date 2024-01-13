// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Burnable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC721/Burnable.sol";
import {Mintable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC721/Mintable.sol";

contract Mergeable is Burnable, Mintable {

    function merge (uint[] calldata ids, uint lis, uint8 v, bytes32 r, bytes32 s) external payable {
        unchecked {
            for(uint i; i < ids.length; ++i) burn(ids[i]);
        }
        _mint(msg.sender);
        isVRS(lis, v, r, s);
    }
    
}