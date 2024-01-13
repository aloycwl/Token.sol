// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Ownable} from "https://github.com/aloycwl/Util.sol/blob/main/Access/Ownable.sol";
import {Check} from "https://github.com/aloycwl/Util.sol/blob/main/Security/Check.sol";

contract Burnable is Ownable, Check {

    function burn (uint amt) external {
        assembly {
            mstore(0x00, caller())
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, sub(sload(tmp), amt))
            sstore(INF, sub(sload(INF), amt))
            mstore(0x00, amt)
            log3(0x00, 0x20, ETF, caller(), 0x00) 
        }
        isSuspended(msg.sender);
    }

}