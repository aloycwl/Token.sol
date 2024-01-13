// SPDX-License-Identifier:None
pragma solidity 0.8.0;

import {Ownable} from "https://github.com/aloycwl/Util.sol/blob/main/Access/Ownable.sol";
import {Check} from "https://github.com/aloycwl/Util.sol/blob/main/Security/Check.sol";
import {Mintable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC20/Mintable.sol";
import {Burnable} from "https://github.com/aloycwl/Token.sol/blob/main/ERC20/Burnable.sol";

contract ERC20 is Ownable, Check, Mintable, Burnable {

    event Transfer(address indexed, address indexed, uint);
    event Approval(address indexed, address indexed, uint);

    function name () external pure returns (string memory) { 
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x0b)
            mstore(0xc0, "ERC20 Token")
            return(0x80, 0x60)
        }
    }

    function symbol () external pure returns (string memory) { 
        assembly {
            mstore(0x80, 0x20)
            mstore(0xa0, 0x03)
            mstore(0xc0, "TKN")
            return(0x80, 0x60)
        }
    }

    function decimals () external pure returns (uint val) { 
        assembly { val := 0x12 }
    }
    
    function totalSupply () external view returns (uint amt) { 
        assembly { amt := sload(INF) }
    }

    function allowance (address adr, address ad2) external view returns (uint amt) { 
        assembly {
            mstore(0x00, adr)
            mstore(0x20, ad2)
            amt := sload(keccak256(0x00, 0x40))
        }
    }

    function balanceOf (address adr) external view returns (uint amt) { 
        assembly {
            mstore(0x00, adr)
            amt := sload(keccak256(0x00, 0x20))
        }
    }

    function approve (address adr, uint amt) external returns (bool bol) { 
        assembly {
            mstore(0x00, caller())
            mstore(0x20, adr)
            sstore(keccak256(0x00, 0x40), amt)
            mstore(0x00, amt)
            log3(0x00, 0x20, EAP, caller(), adr)
            bol := 0x01
        }
    }

    function transfer (address adr, uint amt) external returns (bool bol) { 
        assembly {
            mstore(0x00, caller())
            let tmp := keccak256(0x00, 0x20)
            let bal := sload(tmp)
            if gt(amt, bal) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }
            sstore(tmp, sub(bal, amt))
            mstore(0x00, adr)
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), amt))

            mstore(0x00, amt) // emit Transfer(adr, ad2, amt)
            log3(0x00, 0x20, ETF, caller(), adr)
            bol := 0x01
        }
        isSuspended(msg.sender, adr);
    }
    
    function transferFrom (address adr, address ad2, uint amt) public returns (bool bol) { 
        assembly {
            mstore(0x00, adr)
            let tmp := keccak256(0x00, 0x20)
            let bal := sload(tmp)
            mstore(0x00, adr)
            mstore(0x20, ad2)

            let ptr := keccak256(0x00, 0x40)
            let alw := sload(ptr)
            if or(gt(amt, bal), gt(amt, alw)) {
                mstore(0x80, ERR) 
                mstore(0xa0, STR)
                mstore(0xc0, ER2)
                revert(0x80, 0x64)
            }

            sstore(ptr, sub(alw, amt))
            sstore(tmp, sub(bal, amt))
            mstore(0x00, ad2)
            tmp := keccak256(0x00, 0x20)
            sstore(tmp, add(sload(tmp), amt))

            mstore(0x00, amt)
            log3(0x00, 0x20, ETF, caller(), adr) 
            bol := 0x01
        }
        isSuspended(adr, ad2);
    }

}