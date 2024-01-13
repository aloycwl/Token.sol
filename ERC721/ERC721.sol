// SPDX-License-Identifier: None
pragma solidity 0.8.0;

import {Check} from "https://github.com/aloycwl/Util.sol/blob/main/Security/Check.sol";
import {Top5} from "https://github.com/aloycwl/DAO.sol/blob/main/Node/Top5.sol";
import {Mergeable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC721/Mergeable.sol";
import {Upgradeable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC721/Upgradeable.sol";

contract ERC721 is Check, Top5, Mergeable, Upgradeable {

    event Transfer(address indexed, address indexed, uint indexed);
    event Approval(address indexed, address indexed, uint indexed);
    event ApprovalForAll(address indexed, address indexed, bool);

    function supportsInterface(bytes4 a) external pure returns(bool bol) {
        assembly { bol := or(eq(a, INF), eq(a, IN2)) }
    }

    function name() external pure returns(string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x08)
            mstore(0xc0, "Game NFT")
            return(0x80, 0x60)
        }
    }

    function symbol() external pure returns(string memory) {
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x02)
            mstore(0xc0, "GN")
            return(0x80, 0x60)
        }
    }

    function count() external view returns(uint amt) {
        assembly { amt := sload(INF) }
    }

    function balanceOf(address adr) external view returns (uint amt) {
        assembly {
            mstore(0x00, adr)
            amt := sload(keccak256(0x00, 0x20))
        }
    }

    function ownerOf(uint tid) external view returns(address adr) {
        assembly {
            mstore(0x00, tid)
            adr := sload(keccak256(0x00, 0x20))
        }
    }

    function tokenURI(uint tid) external view returns (string memory) {
        assembly {
            mstore(0xc0, sload(ER4))
            mstore(0xe0, sload(add(ER4, 0x01)))
            let len := 0x00

            for { let i := tid } gt(i, 0x00) { } {
                len := add(len, 0x01)
                i := div(i, 0x0a)
            }

            for { let ptr := add(0xf6, len) } gt(tid, 0x00) { tid := div(tid, 0x0a) } {
                ptr := sub(ptr, 0x01)
                mstore8(ptr, add(0x30, mod(tid, 0xa)))
            }

            if eq(len, 0x00) { 
                len := 0x01 
                mstore8(0xf6, 0x30)
            }

            mstore(0x80, 0x20)
            mstore(0xa0, add(len, 0x36))
            return(0x80, 0x80)
        }
    }

    function getApproved(uint tid) external view returns(address adr) {
        assembly {
            mstore(0x00, tid)
            adr := sload(add(keccak256(0x00, 0x20), 0x03))
        }
    }

    function isApprovedForAll(address frm, address toa) external view returns(bool bol) {
        assembly {
            mstore(0x00, frm)
            mstore(0x20, toa)
            bol := sload(keccak256(0x00, 0x40))
        }
    }

    function approve(address toa, uint tid) external {
        assembly {
            mstore(0x00, tid)
            let tmp := keccak256(0x00, 0x20)
            let oid := sload(tmp) 

            mstore(0x00, oid)
            mstore(0x20, caller())
            mstore(0x00, sload(keccak256(0x00, 0x40)))

            if and(iszero(eq(caller(), oid)), iszero(mload(0x00))) {
                mstore(0x80, ERR)
                mstore(0xa0, STR)
                mstore(0xc0, ER1)
                revert(0x80, 0x64)
            }
            
            sstore(add(tmp, 0x03), toa)

            log4(0x00, 0x00, EAP, oid, toa, tid)
        }
    }

    function setApprovalForAll(address toa, bool bol) external {
        assembly {
            mstore(0x00, caller())
            mstore(0x20, toa)
            sstore(keccak256(0x00, 0x40), bol)
            
            mstore(0x00, bol)
            log3(0x00, 0x20, EAA, caller(), toa)
        }
    }

    function _transfer(address toa, uint tid) private {
        address frm;

        assembly {
            mstore(0x00, tid)
            let ptr := keccak256(0x00, 0x20)
            frm := sload(ptr)

            mstore(0x00, frm)
            mstore(0x20, caller())
            let tmp:= sload(keccak256(0x00, 0x40))

            mstore(0x00, sload(add(ptr, 0x03)))

            if and(and(iszero(eq(mload(0x00), toa)), iszero(eq(frm, caller()))), eq(tmp, 0x00)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
            
            sstore(ptr, toa)
            sstore(add(ptr, 0x03), 0x00)

            mstore(0x00, frm)
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, sub(sload(tmp), 0x01))

            mstore(0x00, toa)
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), 0x01))

            log4(0x00, 0x00, ETF, frm, toa, tid)
        }
        isSuspended(frm, toa);
        _setTop5(toa);
    }

    function transferFrom(address, address toa, uint tid) external {
        _transfer(toa, tid);
    }

    function safeTransferFrom(address, address toa, uint tid) external {
        _transfer(toa, tid);
    }

    function safeTransferFrom(address, address toa, uint tid, bytes memory) external {
        _transfer(toa, tid);
    }
}