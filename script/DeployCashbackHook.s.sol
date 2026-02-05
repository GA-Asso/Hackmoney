// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import {CashbackHook} from "../src/CashbackHook.sol";
import {CashbackPreferences} from "../src/CashbackPreferences.sol";
import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";

contract DeployCashbackHook is Script {
    // Uniswap v4 PoolManager on Sepolia
    address constant POOL_MANAGER = 0xE03A1074c86CFeDd5C142C4F04F1a1536e203543;

    function run() external {
        vm.startBroadcast();
        
        // Deploy CashbackHook
        CashbackHook hook = new CashbackHook(IPoolManager(POOL_MANAGER));
        console.log("CashbackHook deployed at:", address(hook));
        
        // Deploy CashbackPreferences helper
        CashbackPreferences prefs = new CashbackPreferences();
        console.log("CashbackPreferences deployed at:", address(prefs));
        
        vm.stopBroadcast();
    }
}
