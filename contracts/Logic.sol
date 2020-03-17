pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import { Action, Approval, ActionType, AmountType } from "./Structs.sol";
import { InteractiveAdapter } from "./interactiveAdapters/InteractiveAdapter.sol";
import { ERC20 } from "./ERC20.sol";
import { SignatureVerifier } from "./SignatureVerifier.sol";
import { AdapterRegistry } from "./AdapterRegistry.sol";
import { TokenSpender } from "./TokenSpender.sol";
import { SafeERC20 } from "./SafeERC20.sol";


/**
 * @title Main contract executing actions.
 */
contract Logic is SignatureVerifier {
    using SafeERC20 for ERC20;

    address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    uint256 internal constant RELATIVE_AMOUNT_BASE = 1000;

    TokenSpender public tokenSpender;
    AdapterRegistry public adapterRegistry;

    event ExecutedAction(uint256 index);

    constructor(
        address _adapterRegistry
    )
        public
    {
        tokenSpender = new TokenSpender();
        adapterRegistry = AdapterRegistry(_adapterRegistry);
    }

//    /**
//     * @notice Execute actions on signer's behalf.
//     * @param actions Array with actions.
//     * @param approvals Array with assets approvals for the actions.
//     * @param signature Signature for the approvals array.
//     */
    // function executeActions(
    //     Action[] memory actions,
    //     Approval[] memory approvals,
    //     bytes memory signature
    // )
    //     public
    //     payable
    // {
    //     executeActions(actions, approvals, getUserFromSignature(approvals, signature));
    // }

    /**
     * @notice Execute actions on msg.sender's behalf.
     * @param actions Array with actions.
     * @param approvals Array with assets approvals for the actions.
     */
    function executeActions(
        Action[] memory actions,
        Approval[] memory approvals
    )
        public
        payable
    {
        executeActions(actions, approvals, msg.sender);
    }

    function executeActions(
        Action[] memory actions,
        Approval[] memory approvals,
        address payable user
    )
        internal
    {
        uint256 length = actions.length;
        address[][] memory assetsToBeWithdrawn = new address[][](length + 1);

        assetsToBeWithdrawn[0] = tokenSpender.issueAssets(approvals, user);

        for (uint256 i = 0; i < length; i++) {
            assetsToBeWithdrawn[i + 1] = executeAction(actions[i]);
            emit ExecutedAction(i);
        }

        returnAssets(assetsToBeWithdrawn, user);
    }

    function executeAction(Action memory action) internal returns (address[] memory) {
//        require(adapterRegistry.isValidProtocolAdapter(action.adapter), "L: adapter is not valid!");
        require(action.actionType != ActionType.None, "L: wrong action type!");
        require(action.amounts.length == action.amountTypes.length, "L: inconsistent arrays![1]");
        require(action.amounts.length == action.assets.length, "L: inconsistent arrays![2]");

        uint256[] memory absoluteAmounts = getAbsoluteAmounts(action);

        address[] memory assetsToBeWithdrawn = callInteractiveAdapter(
            action.actionType,
            action.adapter,
            action.assets,
            absoluteAmounts,
            action.data
        );

        return assetsToBeWithdrawn;
    }

    function getAbsoluteAmounts(
        Action memory action
    )
        internal
        view
        returns (uint256[] memory)
    {
        uint256 length = action.amounts.length;
        uint256[] memory absoluteAmounts = new uint256[](length);

        for (uint i = 0; i < length; i++) {
            absoluteAmounts[i] = getAbsoluteAmount(
                action.actionType,
                action.adapter,
                action.assets[i],
                action.amounts[i],
                action.amountTypes[i]
            );
        }

        return absoluteAmounts;
    }

    function getAbsoluteAmount(
        ActionType actionType,
        address adapter,
        address asset,
        uint256 amount,
        AmountType amountType
    )
        internal
        view
        returns (uint256 absoluteAmount)
    {
        require(amountType != AmountType.None, "L: wrong amount type!");

        uint256 totalAmount;
        if (amountType == AmountType.Relative) {
            require(amount <= RELATIVE_AMOUNT_BASE, "L: wrong relative value!");
            if (actionType == ActionType.Deposit) {
               if (asset == ETH) {
                   totalAmount = address(this).balance;
               } else {
                   totalAmount = ERC20(asset).balanceOf(address(this));
               }
            } else {
                address[] memory assets = new address[](1);
                assets[0] = asset;
                int256 signedAmount;// =
//                    adapterRegistry.getBalances(address(this), adapter, assets)[0].amount;
                totalAmount = uint256(signedAmount > 0 ? signedAmount : -signedAmount);
            }
            absoluteAmount = totalAmount * amount / RELATIVE_AMOUNT_BASE;
        } else {
            absoluteAmount = amount;
        }
    }

    function callInteractiveAdapter(
        ActionType actionType,
        address adapter,
        address[] memory assets,
        uint256[] memory amounts,
        bytes memory data
    )
        internal
        returns (address[] memory)
    {
        bool success;
        bytes memory result;

        if (actionType == ActionType.Deposit) {
            (success, result) = adapter.delegatecall(
                abi.encodeWithSelector(
                    InteractiveAdapter(adapter).deposit.selector,
                    assets,
                    amounts,
                    data
                )
            );
        } else {
            (success, result) = adapter.delegatecall(
                abi.encodeWithSelector(
                    InteractiveAdapter(adapter).withdraw.selector,
                    assets,
                    amounts,
                    data
                )
            );
        }

        require(success, "L: revert in action's delegatecall!");

        return abi.decode(result, (address[]));
    }

    function returnAssets(
        address[][] memory assetsToBeWithdrawn,
        address payable user
    )
        internal
    {
        ERC20 asset;
        uint256 assetBalance;

        for (uint256 i = 0; i < assetsToBeWithdrawn.length; i++) {
            for(uint256 j = 0; j < assetsToBeWithdrawn[i].length; j++) {
                asset = ERC20(assetsToBeWithdrawn[i][j]);
                assetBalance = asset.balanceOf(address(this));
                if (assetBalance > 0) {
                    asset.safeTransfer(user, assetBalance);
                }
            }
        }

        uint256 ethBalance = address(this).balance;
        if (ethBalance > 0) {
            user.transfer(ethBalance);
        }
    }

}
