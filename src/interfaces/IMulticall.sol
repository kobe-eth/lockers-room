// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

/// @title Multicall interface
/// @notice Enables calling multiple methods in a single call to the contract
interface IMulticall {
    function multicall(uint256 deadline, bytes[] calldata data) external payable returns (bytes[] memory results);
}
