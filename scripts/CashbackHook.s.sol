// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/CashbackHook.sol";

contract CashbackHookScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // TODO: Replace with the actual PoolManager address
        IPoolManager poolManager = IPoolManager(0x...); 

        new CashbackHook(poolManager);

        vm.stopBroadcast();
    }
}
