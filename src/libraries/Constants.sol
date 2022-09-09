// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

/// @title Constant state
/// @notice Constant state used by the swap router
library Constants {
    /// @dev Used for identifying cases when this contract's balance of a token is to be used
    uint256 internal constant CONTRACT_BALANCE = 0;

    /// @dev Used as a flag for identifying msg.sender, saves gas by sending more 0 bytes
    address internal constant MSG_SENDER = address(1);

    /// @dev Used as a flag for identifying address(this), saves gas by sending more 0 bytes
    address internal constant ADDRESS_THIS = address(2);

    /// @dev Error message for when the amount of received tokens is less than the minimum amount
    error NOT_ENOUGH_RECEIVED();

    /// @dev Error message when the caller is not allowed to call the function.
    error NOT_ALLOWED();

    /// @dev Error message when the deadline has passed.
    error DEADLINE_EXCEEDED();
}
