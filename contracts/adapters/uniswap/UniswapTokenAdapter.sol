pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import { TokenAdapter } from "../TokenAdapter.sol";
import { TokenInfo, Component } from "../../Structs.sol";
import { ERC20 } from "../../ERC20.sol";


/**
 * @dev Factory contract interface.
 * Only the functions required for UniswapAdapter contract are added.
 * The Factory contract is available here
 * github.com/Uniswap/contracts-vyper/blob/master/contracts/uniswap_exchange.vy.
 */
interface Exchange {
    function name() external view returns (bytes32);
    function symbol() external view returns (bytes32);
    function decimals() external view returns (uint256);
}


/**
 * @dev Factory contract interface.
 * Only the functions required for UniswapAdapter contract are added.
 * The Factory contract is available here
 * github.com/Uniswap/contracts-vyper/blob/master/contracts/uniswap_factory.vy.
 */
interface Factory {
    function getToken(address) external view returns (address);
}

/**
 * @dev CToken contract interface.
 * Only the functions required for CompoundDebtAdapter contract are added.
 * The CToken contract is available here
 * github.com/compound-finance/compound-protocol/blob/master/contracts/CToken.sol.
 */
interface CToken {
    function isCToken() external view returns (bool);
}


/**
 * @title TokenAdapter for Uniswap pool tokens.
 * @dev Implementation of TokenAdapter interface.
 */
contract UniswapTokenAdapter is TokenAdapter {

    address internal constant FACTORY = 0xc0a47dFe034B400B47bDaD5FecDa2621de6c4d95;
    address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address internal constant SAI_POOL = 0x09cabEC1eAd1c0Ba254B09efb3EE13841712bE14;

    /**
     * @return TokenInfo struct with ERC20-style token info.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getInfo(address token) external view override returns (TokenInfo memory) {
        return TokenInfo({
            token: token,
            name: getPoolName(token),
            symbol: "UNI",
            decimals: uint8(Exchange(token).decimals())
        });
    }

    /**
     * @return Array of Component structs with underlying tokens rates for the given asset.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address token) external view override returns (Component[] memory) {
        address underlying = Factory(FACTORY).getToken(token);
        uint256 totalSupply = ERC20(token).totalSupply();
        string memory underlyingTokenType;
        Component[] memory underlyingTokens = new Component[](2);

        underlyingTokens[0] = Component({
            token: ETH,
            tokenType: "ERC20",
            rate: token.balance * 1e18 / totalSupply
        });

        try CToken(underlying).isCToken() {
            underlyingTokenType = "CToken";
        } catch {
            underlyingTokenType = "ERC20";
        }

        underlyingTokens[1] = Component({
            token: underlying,
            tokenType: underlyingTokenType,
            rate: ERC20(underlying).balanceOf(token) * 1e18 / totalSupply
        });

        return underlyingTokens;
    }

    function getPoolName(address token) internal view returns (string memory) {
        if (token == SAI_POOL) {
            return "SAI pool";
        } else {
            return string(abi.encodePacked(getSymbol(Factory(FACTORY).getToken(token)), " pool"));
        }
    }

    function getSymbol(address token) internal view returns (string memory) {
        (bool success, bytes memory returndata) = token.staticcall(
            abi.encodeWithSelector(ERC20(token).symbol.selector)
        );
        require(success, "UTA: bad symbol()!");

        if (returndata.length == 32) {
            return convertToString(abi.decode(returndata, (bytes32)));
        } else {
            return abi.decode(returndata, (string));
        }
    }

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
