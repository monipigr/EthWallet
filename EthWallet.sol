// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.24;

error NotEnoughFunds(address, uint256);

contract EthWallet {

    address public owner;
    mapping(address => uint256) private balances;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    receive() external payable {}

    // User can deposit ETH to the smart contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // User can withdraw maximum balance they have sent
    function withdraw(uint256 amount) public {
        if (balances[msg.sender] <= amount) revert NotEnoughFunds(msg.sender, amount);
 
        balances[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
    }

    // User can transfer ETH to other accounts if they have enough funds
    function transfer(uint256 amount, address payable to) public {
        require(amount <= balances[msg.sender], "Not enough funds");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        (bool sent,) = to.call{value: amount}(""); 
        require(sent, "Transfer failed");
    }

    // User can get their balance
    function getYourBalance() external view returns(uint256) {
        return balances[msg.sender];
    }

    // Owner can get the balance of any account
    function getAnyBalance(address wallet) public view onlyOwner returns(uint256) {
        return balances[wallet];
    }

}