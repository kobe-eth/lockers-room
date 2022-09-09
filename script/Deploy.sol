// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import "forge-std/Test.sol";

import "src/Zap.sol";

contract DeployScript is Script, Test {
    function run() public {
        vm.startBroadcast();
        console.log("Hello World");
        vm.stopBroadcast();
    }
}
