// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {Constants} from "src/libraries/Constants.sol";
import {IStrategy} from "src/interfaces/IStrategy.sol";
import {ContextHelper} from "src/common/ContextHelper.sol";
import {ERC20, SafeTransferLib, AllowanceHelper} from "src/common/AllowanceHelper.sol";

/// @title Locker Handler
/// @notice Handle deposit into Liquid Lockers.
contract StrategyHandler is AllowanceHelper, ContextHelper {
    using SafeTransferLib for ERC20;

    function deposit(address strategy, address token, uint256 underlyingAmount, bool earn, address recipient)
        external
    {
        underlyingAmount = _amountIn(underlyingAmount, token);
        _allow(token, strategy);
        IStrategy(strategy).deposit(recipient, underlyingAmount, earn);
    }
}
