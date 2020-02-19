pragma solidity 0.6.2;
pragma experimental ABIEncoderV2;

import { Approval, AmountType } from "./Structs.sol";
import { Ownable } from "./Ownable.sol";
import { ERC20 } from "./ERC20.sol";
import { SafeERC20 } from "./SafeERC20.sol";


contract TokenSpender is Ownable {
    using SafeERC20 for ERC20;

    uint256 internal constant RELATIVE_AMOUNT_BASE = 1000;

    function issueAssets(
        Approval[] calldata approvals,
        address user
    )
        external
        onlyOwner
        returns (address[] memory)
    {
        uint256 length = approvals.length;
        address[] memory assetsToBeWithdrawn = new address[](length);

        for (uint256 i = 0; i < length; i++) {
            Approval memory approval = approvals[i];
            address asset = approval.asset;

            assetsToBeWithdrawn[i] = asset;
            uint256 absoluteAmount = getAbsoluteAmount(approval, user);
            ERC20(asset).safeTransferFrom(user, msg.sender, absoluteAmount);
        }

        return assetsToBeWithdrawn;
    }

    function getAbsoluteAmount(
        Approval memory approval,
        address user
    )
        internal
        view
        returns (uint256 absoluteAmount)
    {
        address asset = approval.asset;
        AmountType amountType = approval.amountType;
        uint256 amount = approval.amount;

        require(amountType != AmountType.None, "TS: wrong amount type!");

        if (amountType == AmountType.Relative) {
            require(amount <= RELATIVE_AMOUNT_BASE, "TS: wrong relative value!");

            absoluteAmount = ERC20(asset).balanceOf(user) * amount / RELATIVE_AMOUNT_BASE;
            // in case allowance is too low
            absoluteAmount = min(absoluteAmount, ERC20(asset).allowance(user, address(this)));
        } else {
            absoluteAmount = amount;
        }
    }

    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x < y ? x : y;
    }
}
