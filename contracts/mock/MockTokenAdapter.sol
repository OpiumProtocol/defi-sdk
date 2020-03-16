pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import { TokenInfo, Component } from "../Structs.sol";
import { TokenAdapter } from "../adapters/TokenAdapter.sol";


contract MockTokenAdapter is TokenAdapter {

    /**
      * @return TokenInfo struct with ERC20-style token info.
      * @dev Implementation of TokenAdapter interface function.
      */
    function getInfo(address token) external view override returns (TokenInfo memory) {
        return TokenInfo({
            token: token,
            name: "Mock",
            symbol: "MCK",
            decimals: 18
        });
    }

    /**
     * @return Empty Component array.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address) external view override returns (Component[] memory) {
        return new Component[](0);
    }
}
