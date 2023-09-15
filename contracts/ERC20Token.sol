// contracts/OBridgeERC20.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20, Ownable {
    uint8 immutable private decimal;

    constructor(string memory _name, string memory _symbol, uint8 _decimal) ERC20(_name, _symbol) {
        decimal = _decimal;
        _mint(msg.sender, 1000 * 10 ** _decimal);
    }

    function decimals() public view override returns (uint8) {
        return decimal;
    }
}