// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import {CashbackHook} from "../src/CashbackHook.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract DeployCashbackHook is Script {
    function run() external {
        // Replace with actual PoolManager address on your target chain
        address poolManagerAddress = vm.envAddress("POOL_MANAGER_ADDRESS");
        
        vm.startBroadcast();
        CashbackHook hook = new CashbackHook(IPoolManager(poolManagerAddress));
        vm.stopBroadcast();
        
        console.log("CashbackHook deployed at:", address(hook));
    }
}
