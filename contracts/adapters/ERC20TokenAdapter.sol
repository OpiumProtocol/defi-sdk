pragma solidity 0.6.3;
pragma experimental ABIEncoderV2;

import { TokenAdapter } from "./TokenAdapter.sol";
import { ERC20 } from "../ERC20.sol";
import { TokenInfo, Component } from "../Structs.sol";


/**
 * @title Adapter for ERC20 tokens.
 * @dev Implementation of TokenAdapter interface function.
 */
contract ERC20TokenAdapter is TokenAdapter {

    address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address internal constant SAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;

    /**
     * @return TokenInfo struct with ERC20-style token info.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getInfo(address token) external view override returns (TokenInfo memory) {
        if (token == ETH) {
            return TokenInfo({
                token: ETH,
                name: "Ether",
                symbol: "ETH",
                decimals: uint8(18)
            });
        } else if (token == SAI) {
            return TokenInfo({
                token: SAI,
                name: "Sai Stablecoin v1.0",
                symbol: "SAI",
                decimals: uint8(18)
            });
        } else {
            return TokenInfo({
                token: token,
                name: getName(token),
                symbol: getSymbol(token),
                decimals: ERC20(token).decimals()
            });
        }
    }

    /**
     * @return Empty Component array.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address) external view override returns (Component[] memory) {
        return new Component[](0);
    }

    /**
     * @dev Internal function to get non-ERC20 tokens' names.
     */
    function getName(address token) internal view returns (string memory) {
        (bool success, bytes memory returnData) = token.staticcall(
            abi.encodeWithSelector(ERC20(token).name.selector)
        );
        require(success, "ERC20TA: bad name()!");
        if (returnData.length == 32) {
            return convertToString(abi.decode(returnData, (bytes32)));
        } else {
            return abi.decode(returnData, (string));
        }
    }

    /**
     * @dev Internal function to get non-ERC20 tokens' symbols.
     */
    function getSymbol(address token) internal view returns (string memory) {
        (bool success, bytes memory returnData) = token.staticcall(
            abi.encodeWithSelector(ERC20(token).symbol.selector)
        );
        require(success, "ERC20TA: bad symbol()!");
        if (returnData.length == 32) {
            return convertToString(abi.decode(returnData, (bytes32)));
        } else {
            return abi.decode(returnData, (string));
        }
    }

    /**
     * @dev Internal function to convert bytes32 to string.
     */
    function convertToString(bytes32 data) internal pure returns (string memory) {
        uint256 i = 0;
        uint256 length;
        bytes memory result;

        while (data[i] != byte(0)) {
            i++;
        }

        length = i;
        result = new bytes(length);

        for (i = 0; i < length; i++) {
            result[i] = data[i];
        }

        return string(result);
    }
}
