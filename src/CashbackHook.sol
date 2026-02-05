// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Import core Uniswap v4 interfaces using remappings
import { IPoolManager } from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import { IHook } from "@uniswap/v4-core/src/interfaces/IHook.sol";
import { IHooks } from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import { Hooks } from "v4-core/src/libraries/Hooks.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Import required hook interfaces using remappings
import { IBeforeInitializeHook } from "@uniswap/v4-core/src/interfaces/hooks/IBeforeInitializeHook.sol";
import { IAfterInitializeHook } from "@uniswap/v4-core/src/interfaces/hooks/IAfterInitializeHook.sol";
import { IBeforeSwapHook } from "@uniswap/v4-core/src/interfaces/hooks/IBeforeSwapHook.sol";
import { IAfterSwapHook } from "@uniswap/v4-core/src/interfaces/hooks/IAfterSwapHook.sol";

/**
 * @title CashbackHook
 * @author Pumaclaw Assistant
 * @notice This hook receives cashback funds and deposits them into a liquidity pool
 * to generate yield for the user.
 */
contract CashbackHook is 
    IBeforeInitializeHook,
    IAfterInitializeHook,
    IBeforeSwapHook,
    IAfterSwapHook
{
    // Define the flags for the hooks this contract implements
    uint256 private constant HOOK_FLAGS = uint256(Hooks.AFTER_SWAP_FLAG);

    /// @notice The address of the PoolManager which this hook is connected to.
    IPoolManager public poolManager;

    ERC20 public immutable usdc;
    address public immutable targetPool = 0x0000000000000000000000000000000000000000;  // Para el ejemplo, un pool fijo (testnet)

    // Store the total funds of the yield pool.
    mapping(address => uint256) public yieldPool;

    // Store the credit amount
    mapping(address => uint256) public credit;  

    constructor(IPoolManager _poolManager, ERC20 _usdc) {
        poolManager = _poolManager;
        usdc = _usdc;
    }

    function getHookPermissions() public pure returns (IHooks.Permissions memory) {
        return IHooks.Permissions({
            flags: HOOK_FLAGS,
            fee: 0,
            extraData: ""
        });
    }

    function beforeInitialize(address, IPoolManager.PoolKey calldata, uint160, bytes calldata) external override returns (bytes4) {
        return this.beforeInitialize.selector;
    }

    function afterInitialize(address, IPoolManager.PoolKey calldata, uint160, int24, bytes calldata) external override returns (bytes4) {
        return this.afterInitialize.selector;
    }

    function beforeSwap(address, IPoolManager.PoolKey calldata, IPoolManager.SwapParams calldata, bytes calldata) external override returns (bytes4) {
        return this.beforeSwap.selector;
    }
    
    function afterSwap(
        address sender,
        IPoolManager.PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        bytes calldata extraData
    ) external returns (bytes4, int128) {
        // 1.  Recibir los fondos del cashback.
        address tokenIn = params.tokenIn;
        uint256 amountIn = params.amountIn;
        require(tokenIn == address(usdc), "Cashback must be in USDC");

        // 2.  Seleccionar un pool de liquidez.
        // Para la demo, usaremos un pool fijo.
        // address targetPool = 0x...;  // Reemplaza con la dirección del pool deseado.

        // 3.  Depositar los fondos en el pool.
        yieldPool[sender] += amountIn;

        // poolManager.modifyLiquidity(params);
        // Calculate credit - 75% of the funds
        credit[sender] = (yieldPool[sender] * 75) / 100;

        return (IHooks.afterSwap.selector, 0);
    }
}
