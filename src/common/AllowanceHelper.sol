// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {ERC20, SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

/// @title Periphery
/// @notice Enables calling multiple methods in a single call to the contract
abstract contract AllowanceHelper {
    using SafeTransferLib for ERC20;

    /// @notice Approves a spender to spend an ERC20 token if not already approved.
    /// @param token The ERC20 token to approve.
    /// @param spender The address to approve.
    function _allow(address token, address spender) internal {
        if (spender == address(0)) {
            return;
        }
        if (ERC20(token).allowance(address(this), spender) == 0) {
            ERC20(token).safeApprove(spender, type(uint256).max);
        }
    }
}
