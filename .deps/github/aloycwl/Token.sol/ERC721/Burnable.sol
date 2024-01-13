// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "https://github.com/aloycwl/Util.sol/blob/main/Hashes/Hashes.sol";

contract Burnable is Hashes {

    function burn (uint tid) public {
        assembly {
            mstore(0x00, tid)
            let ptr := keccak256(0x00, 0x20)
            let frm := sload(ptr)

            if iszero(eq(frm, caller())) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
            
            sstore(ptr, 0x00)
            sstore(add(ptr, 0x03), 0x00)

            mstore(0x00, frm)
            let tmp := keccak256(0x00, 0x20)
            sstore(tmp, sub(sload(tmp), 0x01))

            log4(0x00, 0x00, ETF, frm, 0x00, tid) 
        }
    }
    
}