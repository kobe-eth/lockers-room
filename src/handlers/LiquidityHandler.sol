// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import "src/libraries/Constants.sol";
import "src/common/ContextHelper.sol";
import "src/common/AllowanceHelper.sol";

/// @title Liquidity Handler
/// @notice Handle deposit into Liquid Lockers.
contract LiquidityHandler is AllowanceHelper, ContextHelper {
    using SafeTransferLib for ERC20;
}
