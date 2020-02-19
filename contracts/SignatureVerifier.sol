pragma solidity 0.6.2;
pragma experimental ABIEncoderV2;

import { Approval } from "./Structs.sol";


contract SignatureVerifier {
    mapping (address => uint256) public nonces;

    bytes32 public domainSeparator = keccak256(abi.encode(
            DOMAIN_SEPARATOR_TYPEHASH,
            address(this)
        ));

    // 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f
    bytes32 internal constant DOMAIN_SEPARATOR_TYPEHASH = keccak256(abi.encodePacked(
            "EIP712Domain(",
            "address verifyingContract",
            ")"
        ));

    bytes32 public constant APPROVAL_TYPEHASH = keccak256(abi.encodePacked(
            "Approval(",
            "address asset,",
            "uint256 amount,",
            "uint8 amountType,",
            "uint256 nonce",
            ")"
        ));

//    function getUserFromSignatures(
//        Approval[] memory approvals,
//        bytes[] memory signatures
//    )
//        internal
//        returns (address payable)
//    {
//        address initialSigner = getUserFromSignature(approvals[0], signatures[0]);
//        require(nonces[initialSigner] == approvals[0].nonce, "SV: wrong nonce!");
//        nonces[initialSigner]++;
//
//        address signer;
//        for (uint256 i = 1; i < approvals.length; i++) {
//            signer = getUserFromSignature(approvals[i], signatures[i]);
//            require(initialSigner == signer, "SV: wrong sig!");
//            require(nonces[signer] == approvals[i].nonce, "SV: wrong nonce!");
//            nonces[signer]++;
//        }
//        return payable(initialSigner);
//    }

    function getUserFromSignature(
        Approval memory approval,
        bytes32 r, bytes32 s, uint8 v
    )
        public
        view
        returns (address)
    {
        bytes32 hashedApproval = hashApproval(approval);
//        require(signature.length == 65, "SV: wrong sig!");
//        (bytes32 r, bytes32 s, uint8 v) = abi.decode(signature, (bytes32, bytes32, uint8));

        return ecrecover(hashedApproval, v, r, s);
    }

    /// @return Hash to be signed by assets supplier.
    function hashApproval(
        Approval memory approval
    )
        public
        view
        returns (bytes32)
    {
        bytes32 approvalHash = keccak256(abi.encode(
                APPROVAL_TYPEHASH,
                approval.asset,
                approval.amount,
                approval.amountType,
                approval.nonce
            ));
        return keccak256(abi.encodePacked(byte(0x19), byte(0x01), domainSeparator, approvalHash));
    }
}
