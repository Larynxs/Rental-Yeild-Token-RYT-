// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RentalYieldToken is ERC20, Ownable {

    uint256 public constant MAX_SUPPLY = 1_000_000 * 10 ** 18;
    uint256 public constant LOCK_UP_PERIOD = 365 days;
    uint256 public deploymentTime;

    event IncomeDistributed(uint256 totalAmount, uint256 timestamp);
    event TokensRedeemed(address indexed holder, uint256 amount);
    event TokensBurned(address indexed holder, uint256 amount);

    constructor() ERC20("Rental Yield Token", "RYT") Ownable(msg.sender) {
        deploymentTime = block.timestamp;
        _mint(msg.sender, MAX_SUPPLY);
    }

    function distributeIncome(uint256 totalIncome) public onlyOwner {
        require(totalSupply() > 0, "No tokens in circulation");
        emit IncomeDistributed(totalIncome, block.timestamp);
    }

    function redeem(uint256 amount) public {
        require(
            block.timestamp >= deploymentTime + LOCK_UP_PERIOD,
            "Lock-up period has not ended yet"
        );
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");
        _burn(msg.sender, amount);
        emit TokensRedeemed(msg.sender, amount);
    }

    function burn(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount, "Insufficient token balance");
        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    function isLockUpEnded() public view returns (bool) {
        return block.timestamp >= deploymentTime + LOCK_UP_PERIOD;
    }

    function lockUpTimeRemaining() public view returns (uint256) {
        if (isLockUpEnded()) return 0;
        return (deploymentTime + LOCK_UP_PERIOD) - block.timestamp;
    }

    function getHolderBalance(address holder) public view returns (uint256) {
        return balanceOf(holder);
    }
}