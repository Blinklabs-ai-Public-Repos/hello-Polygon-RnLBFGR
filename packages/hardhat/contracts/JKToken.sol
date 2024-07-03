// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract JKToken is ERC20, Ownable {
    uint256 private immutable INITIAL_SUPPLY;
    uint256 public constant BURN_RATE = 1; // 1% burn rate
    uint256 public constant BURN_DENOMINATOR = 100;

    constructor(string memory name_, string memory symbol_, uint256 initialSupply_) ERC20(name_, symbol_) {
        INITIAL_SUPPLY = initialSupply_ * 10**decimals();
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = (amount * BURN_RATE) / BURN_DENOMINATOR;
        uint256 transferAmount = amount - burnAmount;

        super._transfer(sender, recipient, transferAmount);
        _burn(sender, burnAmount);
    }
}