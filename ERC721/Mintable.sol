// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Top5} from "https://github.com/aloycwl/DAO.sol/blob/main/Node/Top5.sol";
import {Check} from "https://github.com/aloycwl/Util.sol/blob/main/Security/Check.sol";
import {DynamicPrice} from "https://github.com/aloycwl/Util.sol/blob/main/Payment/DynamicPrice.sol";

contract Mintable is Check, DynamicPrice, Top5 {

    function _mint (address adr) internal {
        assembly {
            let tid := add(sload(INF), 0x01)
            sstore(INF, tid)

            mstore(0x00, adr) 
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), 0x01))
            
            mstore(0x00, tid)
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, adr) 
            
            log4(0x00, 0x00, ETF, 0x00, adr, tid)
        }
    }

    function mint (uint lis, uint len, uint8 v, bytes32 r, bytes32 s) external payable {
        bytes32 tmp;
        unchecked { for(uint i; i < len; ++i) _mint(msg.sender); }
        assembly { tmp := add(AFA, lis) }
        _pay(tmp, owner(), len);
        isVRS(lis, v, r, s);
        _setTop5(msg.sender);
    }

    function mint (address adr) external onlyOwner {
        _mint(adr);
        _setTop5(msg.sender);
    }
    
}