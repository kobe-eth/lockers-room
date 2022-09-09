// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {Constants} from "src/libraries/Constants.sol";
import {ContextHelper} from "src/common/ContextHelper.sol";
import {ERC20, SafeTransferLib, AllowanceHelper} from "src/common/AllowanceHelper.sol";

/// @title Locker Handler
/// @notice Handle deposit into Liquid Lockers.
contract ParaswapHandler is AllowanceHelper, ContextHelper {
    using SafeTransferLib for ERC20;

    /// @notice Error when swap fails.
    error SWAP_FAILED();

    /// @notice Error when slippage is too high.
    error NOT_ENOUGHT_RECEIVED();

    /// @notice AugustusSwapper contract address.
    address public constant AUGUSTUS = 0xDEF171Fe48CF0115B1d80b88dc8eAB59176FEe57;

    /// @notice Paraswap Token pull contract address.
    address public constant TOKEN_TRANSFER_PROXY = 0x216B4B4Ba9F3e719726886d34a177484278Bfcae;

    function exchange(
        address srcToken,
        address destToken,
        uint256 underlyingAmount,
        bytes memory callData,
        address recipient
    ) external payable returns (uint256 received) {
        underlyingAmount = _amountIn(underlyingAmount, srcToken);

        bool success;
        if (srcToken == ETH_ADDRESS) {
            (success,) = AUGUSTUS.call{value: underlyingAmount}(callData);
        } else {
            _allow(srcToken, TOKEN_TRANSFER_PROXY);
            (success,) = AUGUSTUS.call(callData);
        }
        if (!success) revert SWAP_FAILED();

        if (recipient == Constants.MSG_SENDER) {
            recipient = msg.sender;

            if (destToken == ETH_ADDRESS) {
                received = address(this).balance;
                SafeTransferLib.safeTransferETH(recipient, received);
            } else {
                received = ERC20(destToken).balanceOf(address(this));
                ERC20(destToken).safeTransfer(recipient, received);
            }
        }
    }

    receive() external payable {}
}
