pragma solidity 0.6.2;
pragma experimental ABIEncoderV2;

import { Approval } from "./Structs.sol";


contract SignatureVerifier {
    function getUserFromSignature(
        Approval[] memory approvals,
        bytes memory signature
    )
        internal
        pure
        returns (address payable)
    {
        approvals;
        signature;
        return address(0);
    }
}
