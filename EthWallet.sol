// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.24;

error NotEnoughFunds(address, uint256);

contract EthWallet {

    uint256 public constant FEE = 1; //1% Fixed transaction fee

    address public owner;
    mapping(address => uint256) private balances;
    uint256 public fees;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "You are not the owner");
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

        uint256 fee_ = calculateFee(amount);
        uint256 amountFee_ = amount - fee_; 

        fees += fee_;
        balances[msg.sender] -= amount;
        balances[to] += amount;
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

    function calculateFee(uint256 amount) private pure returns(uint256) {
        return (amount * FEE) / 100;
    }

}