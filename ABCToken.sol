// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ----------------------------------------------------------------------------
// ABCToken Contract
// Name        : ABC
// Symbol      : ABC
// Decimals    : 18
// InitialSupply : 10,000,000,000 DTE
// ----------------------------------------------------------------------------
contract ABCToken is ERC20, Ownable {
    uint constant _initial_supply = 10000000000 * (10**18);

    bool private _tokenLock;
    mapping (address => bool) private _personalTokenLock;

    constructor() ERC20("ABCToken", "ABC") {
        super._mint(msg.sender, _initial_supply);
        _tokenLock = false;
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual override returns (bool) {
        address owner = _msgSender();
        require(isTokenLock(owner, to) == false, "TokenLock: invalid token transfer");

        super.transfer(to, value);
        return true;
    }


    function isTokenLock(address from, address to) public view returns (bool lock) {
        lock = false;
        if(_tokenLock == true){
            lock = true;
        }
        if(_personalTokenLock[from] == true || _personalTokenLock[to] == true) {
            lock = true;
        }
    }

    function removeTokenLock() onlyOwner public {
        require(_tokenLock == true, "_tokenLock is already false");
        _tokenLock = false;
    }

    function removePersonalTokenLock(address _who) onlyOwner public {
        require(_personalTokenLock[_who] == true, "alredy lock false");
        _personalTokenLock[_who] = false;
    }

    function addTokenLock() onlyOwner public {
        require(_tokenLock == false, "_tokenLock is already true");
        _tokenLock = true;
    }

    function addPersonalTokenLock(address _who) onlyOwner public {
        require(_personalTokenLock[_who] == false, "alredy lock true");
        _personalTokenLock[_who] = true;
    }

    function isPersonalTokenLock(address _who) view public returns(bool) {
        return _personalTokenLock[_who];
    }

}