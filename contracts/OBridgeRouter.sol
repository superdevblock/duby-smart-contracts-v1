// contracts/OBridgeRouter.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./interfaces/IOBridgeERC20.sol";
import "./interfaces/IWrappedNativeToken.sol";

contract OBridgeRouter is Ownable {
    using SafeERC20 for IERC20;

    address public immutable wNativeToken;

    event LogRouterSwapInEVM(address token, address from, address to, uint amount, uint fromChainID, uint toChainID, uint form);

    constructor(address _wNativeToken) {
        require(_wNativeToken != address(0), "OBridgeRouter: Wrapped native token address can't be zero.");
        wNativeToken = _wNativeToken;
    }

    receive() external payable {
        assert(msg.sender == wNativeToken); // only accept Native via fallback from the wNativeToken contract
    }

    function chainID() public view returns (uint) {
        return block.chainid;
    }

    function changeRouter(address[] memory tokenList, address newRouter) external onlyOwner returns (bool) {
        for(uint i; i < tokenList.length; i++)
            IOBridgeERC20(tokenList[i]).transferOwnership(newRouter);
        return true;
    }

    function addMinter(address token, address _minter) external onlyOwner returns (bool) {
        IOBridgeERC20(token).addMinter(_minter);
        return true;
    }

    function removeMinter(address token, address _minter) external onlyOwner returns (bool) {
        IOBridgeERC20(token).removeMinter(_minter);
        return true;
    }

    function mintOBToken(address token, address to, uint256 amount) external onlyOwner returns (bool) {
        IOBridgeERC20(token).mint(to, amount);
        return true;
    }

    function burnOBToken(address token, address from, uint256 amount) external onlyOwner returns (bool) {
        IOBridgeERC20(token).burn(from, amount);
        return true;
    }

    function swapInNativeToken(address token, address to, uint toChainID) external payable returns (bool) {
        require(IOBridgeERC20(token).getOrgToken() == wNativeToken, "OBridgeRouter: Original token is not native token.");
        
        IWrappedNativeToken(wNativeToken).deposit{value: msg.value}();
        assert(IWrappedNativeToken(wNativeToken).transfer(token, msg.value));
        
        emit LogRouterSwapInEVM(token, msg.sender, to, msg.value, block.chainid, toChainID, 0);
        return true;
    }

    function swapInERC20Token(address token, address to, uint amount, uint toChainID) external returns (bool) {
        require(IOBridgeERC20(token).getOrgToken() != address(0), "OBridgeRouter: Have to call swapInOBToken function.");
        
        IERC20(IOBridgeERC20(token).getOrgToken()).transferFrom(msg.sender, token, amount);

        emit LogRouterSwapInEVM(token, msg.sender, to, amount, block.chainid, toChainID, 1);
        return true;
    }

    function swapInOBToken(address token, address to, uint amount, uint toChainID) external returns (bool) {
        IOBridgeERC20(token).burn(msg.sender, amount);

        emit LogRouterSwapInEVM(token, msg.sender, to, amount, block.chainid, toChainID, 2);        
        return true;
    }

    function swapOut(uint uID, address token, address to, uint amount) external onlyOwner returns (bool) {
        if(IOBridgeERC20(token).getOrgToken() == wNativeToken) {
            IOBridgeERC20(token).swapOut(uID, to, amount, 0);
        } else {
            IOBridgeERC20(token).swapOut(uID, to, amount, 1);
        }

        return true;
    }
}
