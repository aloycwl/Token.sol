// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Ownable} from "https://github.com/aloycwl/Util.sol/blob/main/Access/Ownable.sol";
import {Check} from "https://github.com/aloycwl/Util.sol/blob/main/Security/Check.sol";

contract Burnable is Ownable, Check {

    function mint (address adr, uint amt) external onlyOwner {
        assembly {
            mstore(0x00, adr)
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), amt))
            sstore(INF, add(sload(INF), amt))
            mstore(0x00, amt)
            log3(0x00, 0x20, ETF, 0x00, adr) 
        }
        isSuspended(adr);
    }

}