// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Burnable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC721/Burnable.sol";
import {Mintable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC721/Mintable.sol";

contract Upgradeable is Burnable, Mintable {

    function upgrade (uint lis, uint tid, uint8 v, bytes32 r, bytes32 s) external payable {
        burn(tid);
        _mint(msg.sender);
        bytes32 tmp;
        assembly {
            tmp := add(AFA, lis)
        }
        _pay(tmp, owner(), 1);
        isVRS(lis, v, r, s);
    }
    
}