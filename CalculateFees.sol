// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.24;

contract CalculateFees { 

    uint256 public constant FEE = 1; //1% Fixed transaction fee

    function calculateFee(uint256 amount_) external pure returns(uint256) {
        return (amount_ * FEE) / 100;
    }

}