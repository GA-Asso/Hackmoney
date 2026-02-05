// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IPoolManager} from "@uniswap/v4-core/src/interfaces/IPoolManager.sol";
import {IHooks} from "@uniswap/v4-core/src/interfaces/IHooks.sol";
import {PoolKey} from "@uniswap/v4-core/src/types/PoolKey.sol";
import {BalanceDelta} from "@uniswap/v4-core/src/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "@uniswap/v4-core/src/types/BeforeSwapDelta.sol";

/// @notice Interface for ENS Registry
interface IENS {
    function resolver(bytes32 node) external view returns (address);
}

/// @notice Interface for ENS Resolver with text records
interface IENSResolver {
    function text(bytes32 node, string calldata key) external view returns (string memory);
    function name(bytes32 node) external view returns (string memory);
}

/// @notice Interface for ENS Reverse Registrar
interface IReverseRegistrar {
    function node(address addr) external pure returns (bytes32);
}

/**
 * @title CashbackHook
 * @author Cashback ID Team - HackMoney 2026
 * @notice Uniswap v4 hook that processes cashback based on ENS text record preferences
 * @dev Reads user preferences from ENS text records to personalize cashback behavior
 * 
 * ENS Text Records Used:
 * - cashback.mode: "yield" | "stablecoin" | "hold"
 * - cashback.percent: "1" to "10" (percentage)
 * - cashback.autocompound: "true" | "false"
 */
contract CashbackHook is IHooks {
    IPoolManager public immutable POOL_MANAGER;
    IENS public immutable ENS_REGISTRY;
    IReverseRegistrar public immutable REVERSE_REGISTRAR;
    
    // Sepolia addresses
    address constant ENS_REGISTRY_SEPOLIA = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
    address constant REVERSE_REGISTRAR_SEPOLIA = 0xA0a1AbcDAe1a2a4A2EF8e9113Ff0e02DD81DC0C6;
    
    // Events for tracking cashback
    event CashbackCalculated(
        address indexed user,
        string ensName,
        string mode,
        uint256 percent,
        int256 swapAmount
    );
    
    event PreferencesRead(
        address indexed user,
        bytes32 node,
        string mode,
        string percent,
        string autocompound
    );

    struct UserPreferences {
        string mode;        // "yield", "stablecoin", "hold"
        uint256 percent;    // 1-10
        bool autocompound;
    }

    constructor(IPoolManager _poolManager) {
        POOL_MANAGER = _poolManager;
        ENS_REGISTRY = IENS(ENS_REGISTRY_SEPOLIA);
        REVERSE_REGISTRAR = IReverseRegistrar(REVERSE_REGISTRAR_SEPOLIA);
    }

    /// @notice Read user cashback preferences from ENS text records
    /// @param user The user address to lookup
    /// @return prefs The user preferences struct
    function getUserPreferences(address user) public view returns (UserPreferences memory prefs) {
        // Get the reverse node for this address
        bytes32 reverseNode = REVERSE_REGISTRAR.node(user);
        
        // Get the resolver for this node
        address resolverAddr = ENS_REGISTRY.resolver(reverseNode);
        
        if (resolverAddr == address(0)) {
            // No ENS name, return defaults
            return UserPreferences({
                mode: "hold",
                percent: 1,
                autocompound: false
            });
        }
        
        IENSResolver resolver = IENSResolver(resolverAddr);
        
        // Read text records
        string memory mode = resolver.text(reverseNode, "cashback.mode");
        string memory percentStr = resolver.text(reverseNode, "cashback.percent");
        string memory autocompoundStr = resolver.text(reverseNode, "cashback.autocompound");
        
        // Parse and validate
        prefs.mode = bytes(mode).length > 0 ? mode : "hold";
        prefs.percent = parsePercent(percentStr);
        prefs.autocompound = keccak256(bytes(autocompoundStr)) == keccak256(bytes("true"));
        
        return prefs;
    }
    
    /// @notice Parse percent string to uint, with validation
    function parsePercent(string memory s) internal pure returns (uint256) {
        bytes memory b = bytes(s);
        if (b.length == 0) return 1;
        
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] >= 0x30 && b[i] <= 0x39) {
                result = result * 10 + (uint8(b[i]) - 48);
            }
        }
        
        // Clamp between 1-10
        if (result < 1) return 1;
        if (result > 10) return 10;
        return result;
    }

    // ========== Hook Implementations ==========

    function beforeInitialize(address, PoolKey calldata, uint160) external pure returns (bytes4) {
        return IHooks.beforeInitialize.selector;
    }

    function afterInitialize(address, PoolKey calldata, uint160, int24) external pure returns (bytes4) {
        return IHooks.afterInitialize.selector;
    }

    function beforeAddLiquidity(
        address, PoolKey calldata, IPoolManager.ModifyLiquidityParams calldata, bytes calldata
    ) external pure returns (bytes4) {
        return IHooks.beforeAddLiquidity.selector;
    }

    function afterAddLiquidity(
        address, PoolKey calldata, IPoolManager.ModifyLiquidityParams calldata,
        BalanceDelta, BalanceDelta, bytes calldata
    ) external pure returns (bytes4, BalanceDelta) {
        return (IHooks.afterAddLiquidity.selector, BalanceDelta.wrap(0));
    }

    function beforeRemoveLiquidity(
        address, PoolKey calldata, IPoolManager.ModifyLiquidityParams calldata, bytes calldata
    ) external pure returns (bytes4) {
        return IHooks.beforeRemoveLiquidity.selector;
    }

    function afterRemoveLiquidity(
        address, PoolKey calldata, IPoolManager.ModifyLiquidityParams calldata,
        BalanceDelta, BalanceDelta, bytes calldata
    ) external pure returns (bytes4, BalanceDelta) {
        return (IHooks.afterRemoveLiquidity.selector, BalanceDelta.wrap(0));
    }

    function beforeSwap(
        address, PoolKey calldata, IPoolManager.SwapParams calldata, bytes calldata
    ) external pure returns (bytes4, BeforeSwapDelta, uint24) {
        return (IHooks.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    /// @notice Main hook logic - calculates and processes cashback based on ENS preferences
    function afterSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external returns (bytes4, int128) {
        // Read user preferences from ENS text records
        UserPreferences memory prefs = getUserPreferences(sender);
        
        // Calculate cashback amount based on swap delta and user percent
        int256 swapAmount = params.zeroForOne ? 
            int256(int128(delta.amount0())) : 
            int256(int128(delta.amount1()));
        
        // Get ENS name for logging (best effort)
        string memory ensName = "";
        try this.getENSName(sender) returns (string memory name) {
            ensName = name;
        } catch {}
        
        // Emit event for tracking
        emit CashbackCalculated(
            sender,
            ensName,
            prefs.mode,
            prefs.percent,
            swapAmount
        );
        
        // Apply cashback logic based on mode
        int128 hookDelta = 0;
        
        if (keccak256(bytes(prefs.mode)) == keccak256(bytes("yield"))) {
            // TODO: Deposit to yield pool
            // hookDelta = depositToYield(sender, cashbackAmount);
        } else if (keccak256(bytes(prefs.mode)) == keccak256(bytes("stablecoin"))) {
            // TODO: Convert to stablecoin and send
            // hookDelta = sendStablecoin(sender, cashbackAmount);
        }
        // "hold" mode: do nothing, tokens stay in pool
        
        return (IHooks.afterSwap.selector, hookDelta);
    }
    
    /// @notice Get ENS name for an address (external for try/catch)
    function getENSName(address user) external view returns (string memory) {
        bytes32 reverseNode = REVERSE_REGISTRAR.node(user);
        address resolverAddr = ENS_REGISTRY.resolver(reverseNode);
        if (resolverAddr == address(0)) return "";
        return IENSResolver(resolverAddr).name(reverseNode);
    }

    function beforeDonate(
        address, PoolKey calldata, uint256, uint256, bytes calldata
    ) external pure returns (bytes4) {
        return IHooks.beforeDonate.selector;
    }

    function afterDonate(
        address, PoolKey calldata, uint256, uint256, bytes calldata
    ) external pure returns (bytes4) {
        return IHooks.afterDonate.selector;
    }
}
