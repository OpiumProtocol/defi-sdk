pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;


struct ProtocolBalance {
    string name;
    string description;
    string websiteURL;
    string iconURL;
    uint256 version;
    AdapterBalance[] adapterBalances;
}


struct ProtocolInfo {
    string name;
    string description;
    string websiteURL;
    string iconURL;
    uint256 version;
    AdapterInfo[] adapters;
}


struct AdapterInfo {
    address adapterAddress;
    address[] supportedTokens;
}


struct AdapterBalance {
    string adapterType; // "Asset", "Debt"
    FullTokenUnit[] balances;
}


struct FullTokenUnit {
    TokenUnit base;
    TokenUnit[] underlying;
}


struct TokenUnit {
    TokenInfo info;
    uint256 value;
}


struct TokenInfo {
    address token;
    string name;
    string symbol;
    uint8 decimals;
}


struct Protocol {
    ProtocolInfo info;
    AdapterInfo[] adapters;
}


struct Component {
    address token;
    string tokenType;  // "ERC20" by default
    uint256 rate;  // price per share (1e18)
}
