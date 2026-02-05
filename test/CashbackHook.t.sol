// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import {CashbackHook} from "../src/CashbackHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract CashbackHookTest is Test {
    CashbackHook public hook;

    function setUp() public {
        address mockPoolManager = address(0x1234);
        hook = new CashbackHook(IPoolManager(mockPoolManager));
    }

    function test_PoolManagerIsSet() public view {
        assertEq(address(hook.POOL_MANAGER()), address(0x1234));
    }

    function test_ENSRegistryIsSet() public view {
        // Check ENS Registry is set to Sepolia address
        assertEq(address(hook.ENS_REGISTRY()), 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
    }
    
    function test_ReverseRegistrarIsSet() public view {
        assertEq(address(hook.REVERSE_REGISTRAR()), 0xA0a1AbcDAe1a2a4A2EF8e9113Ff0e02DD81DC0C6);
    }
}
