// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

interface IStrategy {
    function deposit(address _staker, uint256 _amount, bool _earn) external;
}
