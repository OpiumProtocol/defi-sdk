pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import { InteractiveAdapter } from "./InteractiveAdapter.sol";
import { CompoundAdapter, CToken } from "../adapters/CompoundAdapter.sol";
import { IERC20 } from "../IERC20.sol";

/**
 * @dev CEther contract interface.
 * Only the functions required for CompoundLendInteractiveAdapter contract are added.
 * The CEther contract is available here
 * https://github.com/compound-finance/compound-protocol/blob/master/contracts/CEther.sol.
 */
interface CEther {
    function mint() external payable;
}


// TODO NatSpec for parameters
// TODO move all constants in another contract and implement Ctokentotoken and tokentoCtoken internal functions
contract CompoundLendInteractiveAdapter is InteractiveAdapter, CompoundAdapter {

    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant BAT = 0x0D8775F648430679A709E98d2b0Cb6250d2887EF;
    address internal constant REP = 0x1985365e9f78359a9B6AD760e32412f4a445E862;
    address internal constant SAI = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
    address internal constant ZRX = 0xE41d2489571d322189246DaFA5ebDe1F4699F498;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;

    /**
     * @notice Deposits asset to the Compound protocol.
     * Returns the asset sent back to the msg.sender.
     * @dev Implementation of ProtocolInteractiveAdapter virtual function.
     */
    function deposit(
        address[] calldata assets,
        uint256[] calldata amounts,
        bytes calldata
    )
        external
        payable
        override
        returns (address[] memory)
    {
        require(assets.length == 1, "CLIA: should be 1 asset!");
        require(amounts.length == 1,  "CLIA: should be 1 amount!");
        CToken cToken;

        if (assets[0] == ETH) {
            CEther(address(CETH)).mint.value(msg.value)();

            address[] memory tokensToBeWithdrawn = new address[](1);
            tokensToBeWithdrawn[0] = address(CETH);
            return tokensToBeWithdrawn;
        } else {
            if (assets[0] == DAI) {
                cToken = CDAI;
            } else if (assets[0] == BAT) {
                cToken = CBAT;
            } else if (assets[0] == REP) {
                cToken = CREP;
            } else if (assets[0] == SAI) {
                cToken = CSAI;
            } else if (assets[0] == ZRX) {
                cToken = CZRX;
            } else if (assets[0] == USDC) {
                cToken = CUSDC;
            } else if (assets[0] == WBTC) {
                cToken = CWBTC;
            } else {
                revert("CLIA: unknown asset!");
            }

            IERC20(assets[0]).approve(address(cToken), amounts[0]);
            require(cToken.mint(amounts[0]) == 0, "CLIA: deposit failed!");

            address[] memory tokensToBeWithdrawn = new address[](1);
            tokensToBeWithdrawn[0] = address(cToken);

            return tokensToBeWithdrawn;
        }
    }

    /**
     * @notice Withdraws asset from the Compound protocol.
     * Returns the asset sent back to the msg.sender.
     * @dev Implementation of ProtocolInteractiveAdapter virtual function.
     */
    function withdraw(
        address[] calldata assets,
        uint256[] calldata amounts,
        bytes calldata
    )
        external
        payable
        override
        returns (address[] memory)
    {
        require(assets.length == 1, "CLIA: should be 1 asset!");
        require(amounts.length == 1, "CLIA: should be 1 amount!");
        require(CToken(assets[0]).isCToken(), "CLIA: asset should be CToken");

        require(CToken(assets[0]).redeem(amounts[0]) == 0, "CLIA: withdraw failed!");

        address[] memory tokensToBeWithdrawn;

        if (assets[0] == ETH) {
            tokensToBeWithdrawn = new address[](0);
        } else {
            tokensToBeWithdrawn = new address[](1);
            tokensToBeWithdrawn[0] = CToken(assets[0]).underlying();
        }

        return tokensToBeWithdrawn;
    }
}
