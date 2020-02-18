pragma solidity 0.6.2;
pragma experimental ABIEncoderV2;

import { InteractiveAdapter } from "./InteractiveAdapter.sol";
import { CompoundAdapter, CToken } from "../adapters/CompoundAdapter.sol";
import { ERC20 } from "../ERC20.sol";


/**
 * @dev CEther contract interface.
 * Only the functions required for CompoundInteractiveAdapter contract are added.
 * The CEther contract is available here
 * https://github.com/compound-finance/compound-protocol/blob/master/contracts/CEther.sol.
 */
interface CEther {
    function mint() external payable;
}


/**
 * @title Interactive adapter for Compound protocol lending.
 * @dev Implementation of InteractiveAdapter interface.
 */
contract CompoundInteractiveAdapter is InteractiveAdapter, CompoundAdapter {

    /**
     * @notice Deposits asset to the Compound protocol.
     * @param assets Array with one element - cToken address.
     * @param amounts Array with one element - underlying asset amount to be deposited.
     * @return Asset sent back to the msg.sender.
     * @dev Implementation of InteractiveAdapter function.
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

        address[] memory tokensToBeWithdrawn = new address[](1);

        if (assets[0] == CETH) {
            CEther(CETH).mint.value(amounts[0])();

            tokensToBeWithdrawn[0] = CETH;
            return tokensToBeWithdrawn;
        } else {
            CToken cToken = CToken(assets[0]);
            ERC20 underlying = ERC20(cToken.underlying());

            underlying.approve(assets[0], amounts[0]);
            require(cToken.mint(amounts[0]) == 0, "CLIA: deposit failed!");

            tokensToBeWithdrawn[0] = assets[0];
            return tokensToBeWithdrawn;
        }
    }

    /**
     * @notice Withdraws asset from the Compound protocol.
     * @param assets Array with one element - cToken address.
     * @param amounts Array with one element - cToken amount to be withdrawn.
     * @return Asset sent back to the msg.sender.
     * @dev Implementation of InteractiveAdapter function.
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

        CToken cToken = CToken(assets[0]);

        require(cToken.redeem(amounts[0]) == 0, "CLIA: withdraw failed!");

        address[] memory tokensToBeWithdrawn;

        if (assets[0] == CETH) {
            tokensToBeWithdrawn = new address[](0);
        } else {
            tokensToBeWithdrawn = new address[](1);
            tokensToBeWithdrawn[0] = cToken.underlying();
        }

        return tokensToBeWithdrawn;
    }
}
