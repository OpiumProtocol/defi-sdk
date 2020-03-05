pragma solidity 0.6.3;
pragma experimental ABIEncoderV2;

import { TokenInfo, Component } from "../Structs.sol";


/**
 * @title Base contract for token adapters.
 * @dev getInfo() and getComponents() functions MUST be implemented.
 */
interface TokenAdapter {

    /**
     * @dev MUST return TokenInfo struct with ERC20-style token info.
     * struct TokenInfo {
     *     address token;
     *     string name;
     *     string symbol;
     *     uint8 decimals;
     * }
     */
    function getInfo(address token) external view returns (TokenInfo memory);

    /**
    * @dev MUST return array of Component structs with underlying tokens rates for the given token.
    * struct Component {
    *     address token; // Address of token contract
    *     string tokenType;     // Token type ("ERC20" by default)
    *     uint256 rate;        // Price per share (1e18)
    * }
    */
    function getComponents(address token) external view returns (Component[] memory);
}
