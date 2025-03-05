// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.24;

import "./interfaces/ICalculateFees.sol";

error NotEnoughFunds(address, uint256);

contract EthWallet {

    address public owner;
    address public txOrigin;
    address public calculateFees;
    mapping(address => uint256) private balances;
    uint256 public fees;

    constructor(address calculateFees_) {
        owner = msg.sender;
        calculateFees = calculateFees_;
    }

    modifier onlyOwner { // 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
        require(msg.sender == owner, "You are not the owner"); // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
        _;
    }

    // Allows the contract to receive ETH without calling a specific function
    receive() external payable {}

    // Allows users to deposit ETH into the smart contract
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // Allow users to withdraw up to their balance
    function withdraw(uint256 amount) public {
        if (balances[msg.sender] <= amount) revert NotEnoughFunds(msg.sender, amount);
 
        balances[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");
    }

    // Allow user transfer ETH between accounts with a 1% fee commission
    function transfer(uint256 amount, address payable to) public {
        require(amount <= balances[msg.sender], "Not enough funds");

        // uint256 fee_ = calculateFee(amount);
        uint256 fee_ = ICalculateFees(calculateFees).calculateFee(amount);
        uint256 amountFee_ = amount - fee_; 

        fees += fee_;
        balances[msg.sender] -= amount;
        balances[to] += amountFee_;
        (bool sent,) = to.call{value: amountFee_}(""); 
        require(sent, "Transfer failed");
    }

    // Allows users to check their balances
    function getYourBalance() external view returns(uint256) {
        return balances[msg.sender];
    }

    // Allows the owner to check the balance of any account
    function getAnyBalance(address wallet) external view onlyOwner returns(uint256) {
        return balances[wallet];
    }

    // Allows the owner to withdraw the accumulated fees
    function withdrawFees() external onlyOwner {
        balances[owner] += fees;
        fees = 0;
        (bool sent, ) = owner.call{value: fees}("");
        require(sent, "Transfer failed");
    }

}