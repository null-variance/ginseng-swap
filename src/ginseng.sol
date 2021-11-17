// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "@openzeppelin/contracts/security/Pausable.sol";

/* === Implementation of the Ginseng optimistic stableswap protocol === */

contract Ginseng is ERC20, Pausable, Ownable {
  /* === State variables === */
  uint256 fee;
  mapping(address => uint256) public tokenAmounts;
  /* === Events === */
  event Swap(address token1, address token2, uint256 amount, address swapper);
  event AddLiquidity(uint256 amountAdded, address tokenAdded);
  event RemoveLiquidity(uint256 amountRemoved, address tokenRemoved);
  event FeeSet(uint256 newFee);

  constructor() ERC20("Test", "TEST") { //we need to add fee deduction as well!!
    fee = 1;
  }

  modifier tokenValid(address _token1, address _token2, uint256 _amount) {
    require(_amount < allowedSwapAmount(_token1, _token2), "Token is not valid");
    _;
  }

  /* === Functions === */

  function swap(address _token1, address _token2, uint256 _amount) tokenValid(_token1, _token2, _amount) public {
    //Token in
    IERC20(_token1).transferFrom(msg.sender, address(this), _amount);
    //Token out
    IERC20(_token2).transfer(msg.sender, _amount);

    tokenAmounts[_token1] -= _amount;
    tokenAmounts[_token2] += _amount;

    emit Swap(_token1, _token2, _amount, msg.sender);  
  }
  
  // TODO restrict which tokens can be added

  function addLiquidity(address _token, uint256 _amount) public {
    // Determine if liquidity is allowed 
    // TODO: just assume it is
    // Add liquidity
    tokenAmounts[_token] += _amount;

    // Add to sender balance
    _mint(msg.sender, _amount);

    emit AddLiquidity(_amount, _token);
  }

  // Ok let's do this one
  // What needs to happen here:
  function removeLiquidity(address _token, uint256 _amount) public {
    // Decrease sender balance, this will check it's valid
    _burn(msg.sender, _amount);

    tokenAmounts[_token] -= _amount;
    // Give back tokens they're requesting
    IERC20(_token).transfer(msg.sender, _amount);

    // transfer tokens
    emit RemoveLiquidity(_amount, _token);
  }
  
  /* === Settings === */
  function setFee(uint256 _fee) onlyOwner public {
    fee = _fee;
    emit FeeSet(fee);
  }

  function allowedSwapAmount(address _token1, address _token2) public view returns (uint256) {
    // Determine if there's liquidity and how much we can swap
    uint256 maxAmount1 = tokenAmounts[_token1];
    uint256 maxAmount2 = tokenAmounts[_token2];
    
    // This doesn't have ranges or limits or anything
    if (maxAmount1 >= maxAmount2) {
      return maxAmount2;
    }
    return maxAmount1;
  }

  function returnFee() public view returns (uint256) {
    return fee;
  }
}

// TODO: Which tokens can be added?
// TODO: Are there limits? Ranges?
// TODO: Fees?
