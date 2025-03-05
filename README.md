# 💼 EthWallet

## 📝 Overview

EthWallet is a smart contract that allows users to deposit, withdraw, and transfer ETH between accounts while charging a 1% transaction fee. It also demonstrates how to connect two smart contracts by delegating fee calculation to an external contract.

## ✨ Features

- 🔹 **Deposit & Withdraw ETH**: Users can securely deposit and withdraw their ETH.
- 🔹 **Transfer with Fee**: ETH transfers between users are charged a 1% fee.
- 🔹 **Connected Smart Contracts**: Fee calculation is delegated to an external contract (`CalculateFees`).
- 🔹 **Fee Management**: The contract owner can withdraw accumulated transaction fees.
- 🔹 **Access Control**: Only the owner can check other users' balances or withdraw fees.

## 🛠 Technical Details

- **Solidity Version**: `^0.8.24`
- **External Contract**: `CalculateFees` for fee calculation.
- **Key Functions**:
  - `deposit()`: Deposits ETH into the contract.
  - `withdraw(uint256 amount)`: Withdraws ETH up to the user's balance.
  - `transfer(uint256 amount, address to)`: Transfers ETH with a 1% fee.
  - `getYourBalance()`: Returns the caller's balance.
  - `getAnyBalance(address wallet)`: Allows the owner to check any balance.
  - `withdrawFees()`: Allows the owner to withdraw collected fees.

## 🚀 Deploying the Smart Contract

1. Open **Remix IDE**.
2. Create two Solidity files: `EthWallet.sol` and `CalculateFees.sol`.
3. Compile both contracts using **Solidity 0.8.24**.
4. Deploy `CalculateFees` first and copy its address.
5. Deploy `EthWallet`, passing the `CalculateFees` contract address to its constructor.

## ✅ Interacting & Testing

### ✔️ Deposit ETH

1. Call `deposit()` and send ETH.
2. Check the contract balance to verify the deposit.

### ✔️ Transfer ETH with Fee

1. Call `transfer(amount, to)`.
2. Ensure 1% fee is deducted.
3. Verify balances of sender and receiver.

### ✔️ Withdraw ETH

1. Call `withdraw(amount)`.
2. Ensure the requested amount is transferred back.

### ✔️ Check Balances

1. Call `getYourBalance()` to check your balance.
2. The owner can call `getAnyBalance(wallet)` to check another address.

### ✔️ Withdraw Fees (Owner Only)

1. Call `withdrawFees()`.
2. Ensure the owner receives the collected fees.

## 📜 License

This project is licensed under **LGPL-3.0-only**.
