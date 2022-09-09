// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.16;

import {Zap} from "src/Zap.sol";
import {LockerHandler} from "src/handlers/LockerHandler.sol";
import {ERC20, ParaswapHandler} from "src/handlers/ParaswapHandler.sol";

import "forge-std/Test.sol";
import "forge-std/console.sol";

interface Depositor {
    function incentiveToken() external view returns (uint256);
}

contract ZapTest is Test {
    Zap internal zap;
    ParaswapHandler internal paraswapHandler;
    LockerHandler internal lockerHandler;

    address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant CRV_DEPOSITOR = 0xc1e3Ca8A3921719bE0aE3690A0e036feB4f69191;

    ERC20 public constant CRV = ERC20(0xD533a949740bb3306d119CC777fa900bA034cd52);
    ERC20 public constant SD_CRV = ERC20(0xD1b5651E55D4CeeD36251c61c50C889B36F6abB5);

    function setUp() public {
        zap = new Zap();
        paraswapHandler = new ParaswapHandler();
        lockerHandler = new LockerHandler();

        deal(address(zap), 0);
        assertEq(address(zap).balance, 0);

        zap.setAllowed(address(paraswapHandler), true);
        zap.setAllowed(address(lockerHandler), true);
    }

    function testGetQuoteHelper() public {
        (uint256 quote, bytes memory data) = getQuote(ETH_ADDRESS, address(CRV), 1e18, address(zap));
        assertGt(quote, 0);
        assertGt(data.length, 0);
    }

    function testSwapETHWithParaswap() public {
        uint256 amount = 1 ether;
        (uint256 quote, bytes memory txData) = getQuote(ETH_ADDRESS, address(CRV), amount, address(zap));

        bytes[] memory data = new bytes[](1);
        data[0] = abi.encode(
            address(paraswapHandler),
            abi.encodeWithSignature(
                "exchange(address,address,uint256,bytes,address)", ETH_ADDRESS, address(CRV), amount, txData, address(1)
            )
        );

        assertEq(CRV.balanceOf(address(this)), 0);
        zap.multicall{value: amount}(block.timestamp + 60, data);
        assertEq(CRV.balanceOf(address(this)), quote);
    }

    function testSwapToETHWithParaswap() public {
        uint256 amount = 1000 ether;
        deal(address(CRV), address(this), amount);
        assertEq(CRV.balanceOf(address(this)), amount);

        (uint256 quote, bytes memory txData) = getQuote(address(CRV), ETH_ADDRESS, amount, address(zap));

        bytes[] memory data = new bytes[](1);
        data[0] = abi.encode(
            address(paraswapHandler),
            abi.encodeWithSignature(
                "exchange(address,address,uint256,bytes,address)", address(CRV), ETH_ADDRESS, amount, txData, address(1)
            )
        );

        uint256 balance = address(this).balance;

        CRV.approve(address(zap), amount);

        assertEq(address(zap).balance, 0);
        bytes[] memory result = zap.multicall(block.timestamp + 60, data);

        uint256 received = abi.decode(result[0], (uint256));

        assertEq(quote, received);
        assertEq(address(zap).balance, 0);
        assertEq(address(this).balance, balance + received);
    }

    function testDepositToLocker() public {
        uint256 amount = 1000 ether;
        deal(address(CRV), address(this), amount);
        assertEq(CRV.balanceOf(address(this)), amount);

        bytes[] memory data = new bytes[](1);
        data[0] = abi.encode(
            address(lockerHandler),
            abi.encodeWithSignature(
                "deposit(address,address,bool,bool,uint256,address)",
                CRV_DEPOSITOR,
                address(CRV),
                false,
                false,
                amount,
                address(1)
            )
        );

        CRV.approve(address(zap), amount);
        zap.multicall(block.timestamp + 60, data);
        assertApproxEqAbs(SD_CRV.balanceOf(address(this)), amount, 1e18); // 0.1%
    }

    function testSwapAndDepositIntoLocker() public {
        uint256 amount = 1 ether;
        (uint256 quote, bytes memory txData) = getQuote(ETH_ADDRESS, address(CRV), amount, address(zap));

        bytes[] memory data = new bytes[](2);
        data[0] = abi.encode(
            address(paraswapHandler),
            abi.encodeWithSignature(
                "exchange(address,address,uint256,bytes,address)", ETH_ADDRESS, address(CRV), amount, txData, address(2)
            )
        );

        data[1] = abi.encode(
            address(lockerHandler),
            abi.encodeWithSignature(
                "deposit(address,address,bool,bool,uint256,address)",
                CRV_DEPOSITOR,
                address(CRV),
                false,
                false,
                0,
                address(1)
            )
        );

        zap.multicall{value: amount}(block.timestamp + 60, data);
        assertApproxEqRel(SD_CRV.balanceOf(address(this)), quote, 1e15); // 0.1%
    }

    function getQuote(address srcToken, address dstToken, uint256 amount, address receiver)
        public
        returns (uint256 quoteAmount, bytes memory data)
    {
        string[] memory inputs = new string[](10);
        inputs[0] = "python3";
        inputs[1] = "test/python/get_quote.py";
        inputs[2] = vm.toString(srcToken);
        inputs[3] = vm.toString(dstToken);
        inputs[4] = vm.toString(uint256(18));
        inputs[5] = vm.toString(uint256(18));
        inputs[6] = vm.toString(amount);
        inputs[7] = "SELL";
        inputs[8] = vm.toString(uint256(1));
        inputs[9] = vm.toString(receiver);

        return abi.decode(vm.ffi(inputs), (uint256, bytes));
    }

    receive() external payable {}
}
