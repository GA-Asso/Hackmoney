// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import core Uniswap v4 interfaces
import { IPoolManager } from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import { IHook } from "@uniswap/v4-core/src/interfaces/IHook.sol";
import { IHooks } from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import { Hooks } from "@uniswap/v4-core/src/libraries/Hooks.sol";

// Import required hook interfaces
import { IBeforeInitializeHook } from "@uniswap/v4-core/src/interfaces/hooks/IBeforeInitializeHook.sol";
import { IAfterInitializeHook } from "@uniswap/v4-core/src/interfaces/hooks/IAfterInitializeHook.sol";
import { IBeforeSwapHook } from "@uniswap/v4-core/src/interfaces/hooks/IBeforeSwapHook.sol";
import { IAfterSwapHook } from "@uniswap/v4-core/src/interfaces/hooks/IAfterSwapHook.sol";

/**
 * @title CashbackHook
 * @author Pumaclaw Assistant
 * @notice This hook receives cashback funds and deposits them into a liquidity pool
 * to generate yield for the user. It will be triggered after a swap.
 */
contract CashbackHook is 
    IBeforeInitializeHook,
    IAfterInitializeHook,
    IBeforeSwapHook,
    IAfterSwapHook
{
    // Define the flags for the hooks this contract implements
    uint256 public constant HOOK_FLAGS = 
        uint256(Hooks.BEFORE_INITIALIZE_FLAG) |
        uint256(Hooks.AFTER_INITIALIZE_FLAG) |
        uint256(Hooks.BEFORE_SWAP_FLAG) |
        uint256(Hooks.AFTER_SWAP_FLAG);

    /// @notice The address of the PoolManager which this hook is connected to.
    IPoolManager public poolManager;

    constructor(IPoolManager _poolManager) {
        poolManager = _poolManager;
    }

    // --- HOOK IMPLEMENTATIONS ---

    /// @notice Called before the pool is initialized.
    /// @param sender The address initializing the pool.
    /// @param key The PoolKey identifying the pool.
    /// @param sqrtPriceX96 The initial price of the pool.
    /// @return A selector for a callback function.
    function beforeInitialize(
        address sender,
        IPoolManager.PoolKey calldata key,
        uint160 sqrtPriceX96
    ) external override returns (bytes4) {
        // No action needed before initialization
        return IBeforeInitializeHook.beforeInitialize.selector;
    }

    /// @notice Called after the pool is initialized.
    /// @param sender The address that initialized the pool.
    /// @param key The PoolKey identifying the pool.
    /// @param sqrtPriceX96 The initial price of the pool.
    /// @param tick The initial tick of the pool.
    /// @return A selector for a callback function.
    function afterInitialize(
        address sender,
        IPoolManager.PoolKey calldata key,
        uint160 sqrtPriceX96,
        int24 tick
    ) external override returns (bytes4) {
        // No action needed after initialization
        return IAfterInitializeHook.afterInitialize.selector;
    }

    /// @notice Called before a swap occurs.
    /// @param sender The address initiating the swap.
    /// @param key The PoolKey identifying the pool.
    /// @param params The parameters for the swap.
    /// @return A selector for a callback function.
    function beforeSwap(
        address sender,
        IPoolManager.PoolKey calldata key,
        IPoolManager.SwapParams calldata params
    ) external override returns (bytes4) {
        // No action needed before the swap itself
        return IBeforeSwapHook.beforeSwap.selector;
    }
    
    /// @notice This is the core logic. It's called after a swap.
    /// We will use this to take the incoming cashback and provide liquidity.
    /// @param sender The address that initiated the swap.
    /// @param key The PoolKey identifying the pool.
    /// @param params The parameters used in the swap.
    /// @return A selector for a callback function.
    function afterSwap(
        address sender,
        IPoolManager.PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        bytes calldata
    ) external override returns (bytes4) {
        (int256 amount0, int256 amount1) = poolManager.getSwapFeeAmmounts(key, params);

        address token;
        uint256 amount;

        if(amount0 > 0) {
            token = key.currency0;
            amount = uint256(amount0);
        } else {
            token = key.currency1;
            amount = uint256(amount1);
        }

        // TODO: Implement logic to get user's preferred pool from ENS
        address targetPool = 0x...; 

        IERC20(token).approve(address(poolManager), amount);

        poolManager.addLiquidity(
            targetPool,
            -70600,
            70600,
            amount,
            bytes("")
        );

        return IAfterSwapHook.afterSwap.selector;
    }
}
