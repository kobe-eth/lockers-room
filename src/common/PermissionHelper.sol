// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {Constants} from "src/libraries/Constants.sol";

/// @title Permission Helper
/// @notice Authorizes delegated calls to addresses.
abstract contract PermissionHelper {
    /// @notice Owner address.
    address public owner;

    /// @notice Next owner address. Default is zero address.
    address public nextOwner;

    /// @notice Allowed addresses.
    mapping(address => bool) public isAllowed;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert Constants.NOT_ALLOWED();
        _;
    }

    /// @notice Set allowed address.
    /// @param _allowed Address to set.
    /// @param _isAllowed Allowed status.
    function setAllowed(address _allowed, bool _isAllowed) external onlyOwner {
        isAllowed[_allowed] = _isAllowed;
    }

    /// @notice Set next owner.
    /// @param _nextOwner Next owner address.
    function commitOwnership(address _nextOwner) external onlyOwner {
        nextOwner = _nextOwner;
    }

    /// @notice Accept ownership.
    function acceptOwnership() external {
        if (msg.sender != nextOwner) revert Constants.NOT_ALLOWED();
        owner = nextOwner;
    }
}
