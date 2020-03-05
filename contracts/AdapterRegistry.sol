pragma solidity 0.6.3;
pragma experimental ABIEncoderV2;

import { Ownable } from "./Ownable.sol";
import { ProtocolManager } from "./ProtocolManager.sol";
import { TokenAdapterManager } from "./TokenAdapterManager.sol";
import { ProtocolAdapter } from "./adapters/ProtocolAdapter.sol";
import { TokenAdapter } from "./adapters/TokenAdapter.sol";
import { Strings } from "./Strings.sol";
import {
    ProtocolBalance,
    ProtocolInfo,
    AdapterBalance,
    AdapterInfo,
    FullTokenUnit,
    TokenUnit,
    TokenInfo,
    Component
} from "./Structs.sol";


/**
* @title Registry for protocols, protocol adapters, and token adapters.
* @notice getBalances() function implements the main functionality.
*/
contract AdapterRegistry is Ownable, ProtocolManager, TokenAdapterManager {

    using Strings for string;

    /**
     * @param tokenType String with type of the token.
     * @param token Address of the token.
     * @return Final components by token type and token address.
     */
    function getFullTokenUnit(
        string calldata tokenType,
        address token
    )
        external
        view
        returns (FullTokenUnit memory)
    {
        Component[] memory components = getComponents(tokenType, token, 1e18);
        return getFullTokenUnit(tokenType, token, 1e18, components);
    }

    /**
     * @param tokenType String with type of the token.
     * @param token Address of the token.
     * @return Final components by token type and token address.
     */
    function getFinalFullTokenUnit(
        string calldata tokenType,
        address token
    )
        external
        view
        returns (FullTokenUnit memory)
    {
        Component[] memory finalComponents = getFinalComponents(tokenType, token, 1e18);
        return getFullTokenUnit(tokenType, token, 1e18, finalComponents);
    }
    /**
     * @param account Address of the account.
     * @return ProtocolBalance array by the given account.
     */
    function getBalances(
        address account
    )
        external
        view
        returns (ProtocolBalance[] memory)
    {
        string[] memory protocolNames = getProtocolNames();

        return getProtocolBalances(account, protocolNames);
    }

    /**
     * @param account Address of the account.
     * @param protocolNames Array of the protocols' names.
     * @return ProtocolBalance array by the given account and names of protocols.
     */
    function getProtocolBalances(
        address account,
        string[] memory protocolNames
    )
        public
        view
        returns (ProtocolBalance[] memory)
    {
        ProtocolBalance[] memory protocolBalances = new ProtocolBalance[](protocolNames.length);

        for (uint256 i = 0; i < protocolNames.length; i++) {
            protocolBalances[i] = ProtocolBalance({
                name: protocol[protocolNames[i]].name,
                description: protocol[protocolNames[i]].description,
                websiteURL: protocol[protocolNames[i]].websiteURL,
                iconURL: protocol[protocolNames[i]].iconURL,
                version: protocol[protocolNames[i]].version,
                adapterBalances: getAdapterBalances(account, protocol[protocolNames[i]].adapters)
            });
        }

        return protocolBalances;
    }

    /**
     * @param account Address of the account.
     * @param protocolAdapters Array of the protocol adapters' addresses.
     * @return AdapterBalance array by the given account and adapter structs.
     */
    function getAdapterBalances(
        address account,
        AdapterInfo[] memory protocolAdapters
    )
        public
        view
        returns (AdapterBalance[] memory)
    {
        AdapterBalance[] memory adapterBalances = new AdapterBalance[](protocolAdapters.length);

        for (uint256 i = 0; i < protocolAdapters.length; i++) {
            adapterBalances[i] = getAdapterBalance(
                account,
                protocolAdapters[i].adapterAddress,
                protocolAdapters[i].supportedTokens
            );
        }

        return adapterBalances;
    }

    /**
     * @param account Address of the account.
     * @param protocolAdapter Address of the protocol adapter.
     * @param tokens Array with tokens' addresses.
     * @return AdapterBalance array by the given account, address of adapter, and addresses of tokens.
     */
    function getAdapterBalance(
        address account,
        address protocolAdapter,
        address[] memory tokens
    )
        internal
        view
        returns (AdapterBalance memory)
    {
        FullTokenUnit[] memory finalFullTokenUnits = new FullTokenUnit[](tokens.length);
        ProtocolAdapter adapter = ProtocolAdapter(protocolAdapter);
        string memory tokenType = adapter.tokenType();
        uint256 value;

        for (uint256 i = 0; i < tokens.length; i++) {
            try adapter.getBalance(tokens[i], account) returns (uint256 result) {
                value = result;
            } catch {
                value = 0;
            }

            finalFullTokenUnits[i] = getFullTokenUnit(
                tokenType,
                tokens[i],
                value,
                getFinalComponents(tokenType, tokens[i], 1e18)
            );
        }

        return AdapterBalance({
            adapterType: adapter.adapterType(),
            balances: finalFullTokenUnits
        });
    }

    /**
     * @param tokenType Type of the base token.
     * @param token Address of the base token.
     * @param value Amount of the base token.
     * @return FullTokenUnit by the given components.
     */
    function getFullTokenUnit(
        string memory tokenType,
        address token,
        uint256 value,
        Component[] memory components
    )
        internal
        view
        returns (FullTokenUnit memory)
    {
        TokenUnit[] memory componentTokenUnits = new TokenUnit[](components.length);

        for (uint256 i = 0; i < components.length; i++) {
            componentTokenUnits[i] = getTokenUnit(
                components[i].tokenType,
                components[i].token,
                components[i].rate * value / 1e18
            );
        }

        return FullTokenUnit({
            base: getTokenUnit(tokenType, token, value),
            underlying: componentTokenUnits
        });
    }

    /**
     * @param tokenType String with type of the token.
     * @param token Address of the token.
     * @return Final components by token type and token address.
     */
    function getFinalComponents(
        string memory tokenType,
        address token,
        uint256 value
    )
        internal
        view
        returns (Component[] memory)
    {
        uint256 totalLength;

        totalLength = getFinalComponentsNumber(tokenType, token, true);

        Component[] memory finalTokens = new Component[](totalLength);
        uint256 length;
        uint256 init = 0;

        Component[] memory components = getComponents(tokenType, token, value);

        for (uint256 i = 0; i < components.length; i++) {
            Component[] memory finalComponents = getFinalComponents(
                components[i].tokenType,
                components[i].token,
                components[i].rate
            );

            length = finalComponents.length;

            if (length == 0) {
                finalTokens[init] = components[i];
                init = init + 1;
            } else {
                for (uint256 j = 0; j < length; j++) {
                    finalTokens[init + j] = finalComponents[j];
                }

                init = init + length;
            }
        }

        return finalTokens;
    }

    /**
     * @param tokenType String with type of the token.
     * @param token Address of the token.
     * @return Final tokens number by token type and token.
     */
    function getFinalComponentsNumber(
        string memory tokenType,
        address token,
        bool initial
    )
        internal
        view
        returns (uint256)
    {
        if (tokenType.isEqualTo("ERC20")) {
            return initial ? uint256(0) : uint256(1);
        }

        uint256 totalLength = 0;
        Component[] memory components = getComponents(tokenType, token, 1e18);

        for (uint256 i = 0; i < components.length; i++) {
            totalLength = totalLength + getFinalComponentsNumber(
                components[i].tokenType,
                components[i].token,
                false
            );
        }

        return totalLength;
    }

    /**
     * @param tokenType String with type of the token.
     * @param token Address of the token.
     * @return Array of Component structs.
     */
    function getComponents(
        string memory tokenType,
        address token,
        uint256 value
    )
        internal
        view
        returns (Component[] memory)
    {
        TokenAdapter adapter = TokenAdapter(tokenAdapter[tokenType]);
        Component[] memory components;

        try adapter.getComponents(token) returns (Component[] memory result) {
            components = result;
        } catch {
            components = new Component[](0);
        }

        for (uint256 i = 0; i < components.length; i++) {
            components[i].rate = components[i].rate * value / 1e18;
        }

        return components;
    }

    /**
     * @notice Fulfills TokenUnit struct using type, address, and balance of the token.
     * @param tokenType String with type of the token.
     * @param token Address of the token.
     * @param value Amount of tokens.
     * @return TokenUnit struct with token info and balance.
     */
    function getTokenUnit(
        string memory tokenType,
        address token,
        uint256 value
    )
        internal
        view
        returns (TokenUnit memory)
    {
        TokenAdapter adapter = TokenAdapter(tokenAdapter[tokenType]);

        try adapter.getInfo(token) returns (TokenInfo memory result) {
            return TokenUnit({
                info: result,
                value: value
            });
        } catch {
            return TokenUnit({
                info: TokenInfo({
                    token: token,
                    name: "Not available",
                    symbol: "N/A",
                    decimals: 18
                }),
                value: value
            });
        }
    }
}
