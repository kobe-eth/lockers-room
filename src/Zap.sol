// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {IMulticall} from "src/interfaces/IMulticall.sol";
import {Constants, PermissionHelper} from "src/common/PermissionHelper.sol";

/// @notice Enable anything.
/// @author @kobe-eth
contract Zap is IMulticall, PermissionHelper {
    /// @notice Checks if timestamp is not expired
    /// @param deadline Timestamp to not be expired.
    modifier checkDeadline(uint256 deadline) {
        if (block.timestamp > deadline) revert Constants.DEADLINE_EXCEEDED();
        _;
    }

    /// @notice Call multiple functions in the current contract and return the data from all of them if they all succeed
    /// @param deadline The time by which this function must be called before failing
    /// @param data The encoded function data for each of the calls to make to this contract
    /// @return results The results from each of the calls passed in via data
    function multicall(uint256 deadline, bytes[] calldata data)
        public
        payable
        override
        checkDeadline(deadline)
        returns (bytes[] memory results)
    {
        results = new bytes[](data.length);
        for (uint256 i = 0; i < data.length; i++) {
            address target = abi.decode(data[i][0:32], (address));
            if (!isAllowed[target]) revert Constants.NOT_ALLOWED();
            (bool success, bytes memory result) = target.delegatecall(data[i][96:]);

            if (!success) {
                if (result.length < 68) {
                    revert();
                }
                assembly {
                    result := add(result, 0x04)
                }
                revert(abi.decode(result, (string)));
            }

            results[i] = result;
        }
    }

    receive() external payable {}
}
