// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import "src/libraries/Constants.sol";
import "src/common/ContextHelper.sol";
import "src/common/AllowanceHelper.sol";

import {ILocker} from "src/interfaces/ILocker.sol";

/// @title Locker Handler
/// @notice Handle deposit into Liquid Lockers.
contract LockerHandler is AllowanceHelper, ContextHelper {
    using SafeTransferLib for ERC20;

    function deposit(address locker, address token, bool lock, bool stake, uint256 underlyingAmount, address recipient)
        external payable
    {
        if (recipient == Constants.MSG_SENDER) recipient = msg.sender;
        else if (recipient == Constants.ADDRESS_THIS) recipient = address(this);

        underlyingAmount = _amountIn(underlyingAmount, token);
        _allow(token, locker);
        ILocker(locker).deposit(underlyingAmount, lock, stake, recipient);
    }
}
