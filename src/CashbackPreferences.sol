// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/// @notice Interface for ENS Text Resolver
interface ITextResolver {
    function setText(bytes32 node, string calldata key, string calldata value) external;
    function text(bytes32 node, string calldata key) external view returns (string memory);
}

/// @notice Interface for ENS Reverse Registrar
interface IReverseRegistrar {
    function node(address addr) external pure returns (bytes32);
}

/**
 * @title CashbackPreferences
 * @author Cashback ID Team - HackMoney 2026
 * @notice Helper contract for managing ENS-based cashback preferences
 * @dev Provides a simple interface to set/get cashback preferences stored in ENS text records
 * 
 * Text Record Keys:
 * - cashback.mode: "yield" | "stablecoin" | "hold"
 * - cashback.percent: "1" to "10"
 * - cashback.autocompound: "true" | "false"
 */
contract CashbackPreferences {
    ITextResolver public immutable ENS_RESOLVER;
    IReverseRegistrar public immutable REVERSE_REGISTRAR;
    
    // Sepolia addresses
    address constant ENS_RESOLVER_SEPOLIA = 0x8FADE66B79cC9f707aB26799354482EB93a5B7dD;
    address constant REVERSE_REGISTRAR_SEPOLIA = 0xA0a1AbcDAe1a2a4A2EF8e9113Ff0e02DD81DC0C6;
    
    event PreferencesUpdated(
        address indexed user,
        string mode,
        uint256 percent,
        bool autocompound
    );
    
    struct Preferences {
        string mode;
        uint256 percent;
        bool autocompound;
    }

    constructor() {
        ENS_RESOLVER = ITextResolver(ENS_RESOLVER_SEPOLIA);
        REVERSE_REGISTRAR = IReverseRegistrar(REVERSE_REGISTRAR_SEPOLIA);
    }
    
    /// @notice Set cashback preferences (writes to ENS text records)
    /// @param node The ENS node (namehash) for your ENS name
    /// @param mode Cashback mode: "yield", "stablecoin", or "hold"
    /// @param percent Cashback percentage: 1-10
    /// @param autocompound Whether to autocompound yields
    function setPreferences(
        bytes32 node,
        string calldata mode,
        uint256 percent,
        bool autocompound
    ) external {
        require(percent >= 1 && percent <= 10, "Percent must be 1-10");
        require(
            keccak256(bytes(mode)) == keccak256("yield") ||
            keccak256(bytes(mode)) == keccak256("stablecoin") ||
            keccak256(bytes(mode)) == keccak256("hold"),
            "Invalid mode"
        );
        
        // Write to ENS text records
        ENS_RESOLVER.setText(node, "cashback.mode", mode);
        ENS_RESOLVER.setText(node, "cashback.percent", uintToString(percent));
        ENS_RESOLVER.setText(node, "cashback.autocompound", autocompound ? "true" : "false");
        
        emit PreferencesUpdated(msg.sender, mode, percent, autocompound);
    }
    
    /// @notice Get cashback preferences from ENS text records
    /// @param node The ENS node (namehash) for the ENS name
    /// @return prefs The preferences struct
    function getPreferences(bytes32 node) external view returns (Preferences memory prefs) {
        string memory mode = ENS_RESOLVER.text(node, "cashback.mode");
        string memory percentStr = ENS_RESOLVER.text(node, "cashback.percent");
        string memory autocompoundStr = ENS_RESOLVER.text(node, "cashback.autocompound");
        
        prefs.mode = bytes(mode).length > 0 ? mode : "hold";
        prefs.percent = parseUint(percentStr);
        if (prefs.percent < 1) prefs.percent = 1;
        if (prefs.percent > 10) prefs.percent = 10;
        prefs.autocompound = keccak256(bytes(autocompoundStr)) == keccak256("true");
        
        return prefs;
    }
    
    /// @notice Convert uint to string
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        
        return string(buffer);
    }
    
    /// @notice Parse string to uint
    function parseUint(string memory s) internal pure returns (uint256) {
        bytes memory b = bytes(s);
        if (b.length == 0) return 0;
        
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            if (b[i] >= 0x30 && b[i] <= 0x39) {
                result = result * 10 + (uint8(b[i]) - 48);
            }
        }
        return result;
    }
}
