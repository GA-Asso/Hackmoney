// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {CashbackHook} from "../src/CashbackHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract CashbackHookTest is Test {
    CashbackHook public hook;

    function setUp() public {
        // Mock PoolManager address for testing
        address mockPoolManager = address(0x1234);
        hook = new CashbackHook(IPoolManager(mockPoolManager));
    }

    function test_PoolManagerIsSet() public view {
        assertEq(address(hook.poolManager()), address(0x1234));
    }
}
