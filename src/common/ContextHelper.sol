// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {Constants} from "src/libraries/Constants.sol";
import {ERC20, SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";

/// @title ContextHelper
abstract contract ContextHelper {
    using SafeTransferLib for ERC20;

    address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    function _amountIn(uint256 amountIn, address token) internal returns (uint256) {
        if (amountIn == Constants.CONTRACT_BALANCE) {
            return ERC20(token).balanceOf(address(this));
        } else if (token == ETH_ADDRESS) {
            return msg.value;
        } else {
            ERC20(token).safeTransferFrom(msg.sender, address(this), amountIn);
        }
        return amountIn;
    }
}
