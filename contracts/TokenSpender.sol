pragma solidity 0.6.1;
pragma experimental ABIEncoderV2;

import { Approval } from "./Structs.sol";
import { Ownable } from "./Ownable.sol";
import { IERC20 } from "./IERC20.sol";
import { SafeERC20 } from "./SafeERC20.sol";


contract TokenSpender is Ownable {
    using SafeERC20 for IERC20;

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

            IERC20(asset).safeTransferFrom(user, msg.sender, approval.amount);
        }

        return assetsToBeWithdrawn;
    }
}
