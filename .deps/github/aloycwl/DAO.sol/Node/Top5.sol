// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Hashes} from "https://github.com/aloycwl/Util.sol/blob/main/Hashes/Hashes.sol";

contract Top5 is Hashes {

    function isTop5 (address adr) external view returns(bool bol, uint nod) {
        assembly {
            mstore(0x00, adr)
            nod := sload(add(keccak256(0x00, 0x20), 0x01))
            
            mstore(0x00, TP5)
            mstore(0x20, nod)
            let tmp := keccak256(0x00, 0x40)

            for { let i } lt(i, 0x05) { i := add(i, 0x01) } {
                if eq(adr, sload(add(tmp, i))) { bol := 0x01 }
            }
        }
    }

    function getTop5 (uint nod) external view returns(address[5] memory) {
        assembly {
            mstore(0x00, TP5)
            mstore(0x20, nod)
            let tmp := keccak256(0x00, 0x40)

            mstore(0x80, sload(tmp))
            mstore(0xa0, sload(add(tmp, 0x01)))
            mstore(0xc0, sload(add(tmp, 0x02)))
            mstore(0xe0, sload(add(tmp, 0x03)))
            mstore(0x0100, sload(add(tmp, 0x04)))
            return(0x80, 0xa0)
        }
    }

    function _setTop5 (address top) internal {
        uint nod = assignNode(top);

        assembly {
            mstore(0x00, TP5)
            mstore(0x20, nod)
            let tmp := keccak256(0x00, 0x40)
            let ind
            let lwt := ETF

            for { let i } lt(i, 0x05) { i := add(i, 0x01) } {
                let adr := sload(add(tmp, i))
                if eq(adr, top) { return(0x00, 0x00) }
                mstore(0x00, adr)
                let ptr := sload(keccak256(0x00, 0x20))
                if lt(ptr, lwt) {
                    ind := i
                    lwt := ptr
                }
            }

            mstore(0x00, top)
            if gt(sload(keccak256(0x00, 0x20)), lwt) {
                sstore(add(tmp, ind), top)
            }
        }
    }

    function assignNode (address adr) internal returns (uint num) {
        assembly {
            mstore(0x00, adr)
            let tmp := add(keccak256(0x00, 0x20), 0x01)
            num := sload(tmp)

            if iszero(num) {
                mstore(0x00, timestamp())
                mstore(0x20, caller())
                num := add(mod(keccak256(0x00, 0x40), sload(ER5)), 0x01)
                sstore(tmp, num)
            }
        }
    }
}