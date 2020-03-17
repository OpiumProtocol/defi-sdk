pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import { TokenAdapter } from "../TokenAdapter.sol";
import { MKRAdapter } from "./MKRAdapter.sol";
import { TokenInfo, Component } from "../../Structs.sol";
import { ERC20 } from "../../ERC20.sol";


/**
 * @dev Pot contract interface.
 * Only the functions required for ChaiTokenAdapter contract are added.
 * The Pot contract is available here
 * github.com/makerdao/dss/blob/master/src/pot.sol.
 */
interface Pot {
    function pie(address) external view returns (uint256);
    function dsr() external view returns (uint256);
    function rho() external view returns (uint256);
    function chi() external view returns (uint256);
}


/**
 * @title Adapter for Chai tokens.
 * @dev Implementation of TokenAdapter interface.
 */
contract ChaiTokenAdapter is TokenAdapter, MKRAdapter {

    /**
     * @return TokenInfo struct with ERC20-style token info.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getInfo(address token) external view override returns (TokenInfo memory) {
        return TokenInfo({
            token: token,
            name: ERC20(token).name(),
            symbol: ERC20(token).symbol(),
            decimals: ERC20(token).decimals()
        });
    }

    /**
     * @return Array of Component structs with underlying tokens rates for the given asset.
     * @dev Implementation of TokenAdapter interface function.
     */
    function getComponents(address) external view override returns (Component[] memory) {
        Pot pot = Pot(POT);
        Component[] memory underlyingTokens = new Component[](1);

        underlyingTokens[0] = Component({
            token: DAI,
            tokenType: "ERC20",
            // solhint-disable-next-line not-rely-on-time
            rate: mkrRmul(mkrRmul(mkrRpow(pot.dsr(), now - pot.rho(), ONE), pot.chi()), 1e18)
        });

        return underlyingTokens;
    }
}
