// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "https://github.com/aloycwl/Util.sol/blob/main/Hashes/Hashes.sol";

contract Check is Hashes {

    function isSuspended(address adr) internal view {
        assembly {
            if or(gt(sload(address()), 0x00), gt(sload(adr), 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER3)
                revert(0x80, 0x64)
            }
        }
    }

    function isSuspended(address adr, address ad2) internal view {
        assembly {
            if or(or(gt(sload(address()), 0x00), gt(sload(adr), 0x00)), gt(sload(ad2), 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER3)
                revert(0x80, 0x64)
            }
        }
    }

    function isVRS(uint amt, uint8 v, bytes32 r, bytes32 s) internal {
        bytes32 hsh;

        assembly {
            mstore(0x00, caller())
            let ptr := add(keccak256(0x00, 0x20), 0x01)
            let ind := sload(ptr) 
            
            sstore(ptr, add(ind, 0x01))

            mstore(0x80, caller())
            mstore(0xa0, ind)
            mstore(0xc0, amt)
            hsh := keccak256(0x80, 0x60)
        }

        address val = ecrecover(hsh, v, r, s);
        isSuspended(msg.sender);

        assembly {
            if iszero(eq(val, sload(APP))) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER4)
                revert(0x80, 0x64)
            }
        }
    }

}