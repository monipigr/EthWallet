// SPDX-License-Identifier: LGPL-3.0-only

pragma solidity ^0.8.24;

interface ICalculateFees {

    function calculateFee(uint256 amount_) external pure returns(uint256);

}