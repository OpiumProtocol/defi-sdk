pragma solidity 0.6.4;
pragma experimental ABIEncoderV2;

import { Ownable } from "./Ownable.sol";
import { ProtocolInfo,  AdapterInfo } from "./Structs.sol";
import { Strings } from "./Strings.sol";


/**
 * @title Base contract for AdapterRegistry.
 */
abstract contract ProtocolManager is Ownable {

    using Strings for string;

    string internal constant INITIAL_PROTOCOL_NAME = "Initial protocol name";

    // protocol name => protocol struct with info and adapters
    mapping (string => ProtocolInfo) internal protocol;
    // protocol name => next protocol name
    mapping (string => string) internal nextProtocolName; // linked list

    /**
     * @notice Initializes contract storage.
     */
    constructor() internal {
        nextProtocolName[INITIAL_PROTOCOL_NAME] = INITIAL_PROTOCOL_NAME;
    }

    /**
     * @notice Adds new protocols.
     * The function is callable only by the owner.
     * @param protocolNames Names of the protocols to be added.
     * @param protocols New protocols and their adapters.
     */
    function addProtocols(
        string[] memory protocolNames,
        ProtocolInfo[] memory protocols
    )
        public
        onlyOwner
    {
        uint256 length = protocolNames.length;
        require(length == protocols.length, "PM: lengths differ!");
        require(length != 0, "PM: empty!");

        for (uint256 i = 0; i < length; i++) {
            addProtocol(protocolNames[i], protocols[i]);
        }
    }

    /**
     * @notice Removes protocols.
     * The function is callable only by the owner.
     * @param protocolNames Names of the protocols to be removed.
     */
    function removeProtocols(
        string[] memory protocolNames
    )
        public
        onlyOwner
    {
        require(protocolNames.length != 0, "PM: empty!");

        uint256 length = protocolNames.length;
        for (uint256 i = 0; i < length; i++) {
            removeProtocol(protocolNames[i]);
        }
    }

    /**
     * @notice Updates a protocol info.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be updated.
     * @param name Name of the protocol to be added instead.
     * @param description Description of the protocol to be added instead.
     * @param websiteURL URL of the protocol website to be added instead.
     * @param iconURL URL of the protocol icon to be added instead.
     */
    function updateProtocolInfo(
        string memory protocolName,
        string memory name,
        string memory description,
        string memory websiteURL,
        string memory iconURL
    )
        public
        onlyOwner
    {
        require(isValidProtocol(protocolName), "PM: bad name!");
        require(abi.encodePacked(name, description, websiteURL, iconURL).length != 0, "PM: empty!");

        ProtocolInfo storage protocolInfo = protocol[protocolName];

        if (!name.isEmpty()) {
            protocolInfo.name = name;
        }

        if (!description.isEmpty()) {
            protocolInfo.description = description;
        }

        if (!websiteURL.isEmpty()) {
            protocolInfo.websiteURL = websiteURL;
        }

        if (!iconURL.isEmpty()) {
            protocolInfo.iconURL = iconURL;
        }

        protocolInfo.version++;
    }

    /**
     * @notice Adds protocol adapters.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be updated.
     * @param protocolAdapters Array of new adapters to be added.
     */
    function addProtocolAdapters(
        string memory protocolName,
        AdapterInfo[] memory protocolAdapters
    )
        public
        onlyOwner
    {
        require(isValidProtocol(protocolName), "PM: bad name!");
        require(protocolAdapters.length != 0, "PM: empty!");

        for (uint256 i = 0; i < protocolAdapters.length; i++) {
            addProtocolAdapter(protocolName, protocolAdapters[i]);
        }

        protocol[protocolName].version++;
    }

    /**
     * @notice Removes protocol adapters.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be updated.
     * @param adapterIndices Array of adapter indexes to be removed.
     * @dev NOTE: indexes will change during execution of this function!!!
     */
    function removeProtocolAdapters(
        string memory protocolName,
        uint256[] memory adapterIndices
    )
        public
        onlyOwner
    {
        require(isValidProtocol(protocolName), "PM: bad name!");
        require(adapterIndices.length != 0, "PM: empty!");

        for (uint256 i = 0; i < adapterIndices.length; i++) {
            removeProtocolAdapter(protocolName, adapterIndices[i]);
        }

        protocol[protocolName].version++;
    }

    /**
     * @notice Updates a protocol adapter.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be updated.
     * @param adapterIndex Index of the adapter to be updated.
     * @param newAdapterAddress New adapter address to be added instead.
     * @param newSupportedTokens New supported tokens to be added instead.
     */
    function updateProtocolAdapterInfo(
        string memory protocolName,
        uint256 adapterIndex,
        address newAdapterAddress,
        address[] memory newSupportedTokens
    )
        public
        onlyOwner
    {
        require(isValidProtocol(protocolName), "PM: bad name!");
        require(adapterIndex < protocol[protocolName].adapters.length, "PM: bad index!");
        require(newAdapterAddress != address(0) || newSupportedTokens.length != 0, "PM: empty!");

        AdapterInfo storage adapter = protocol[protocolName].adapters[adapterIndex];

        if (newAdapterAddress != address(0)) {
            adapter.adapterAddress = newAdapterAddress;
        }

        if (newSupportedTokens.length != 0) {
            adapter.supportedTokens = newSupportedTokens;
        }

        protocol[protocolName].version++;
    }

    /**
     * @return Array of protocol names.
     */
    function getProtocolNames()
        public
        view
        returns (string[] memory)
    {
        uint256 counter = 0;
        string memory currentProtocolName = nextProtocolName[INITIAL_PROTOCOL_NAME];

        while (!currentProtocolName.isEqualTo(INITIAL_PROTOCOL_NAME)) {
            currentProtocolName = nextProtocolName[currentProtocolName];
            counter++;
        }

        string[] memory protocols = new string[](counter);
        counter = 0;
        currentProtocolName = nextProtocolName[INITIAL_PROTOCOL_NAME];

        while (!currentProtocolName.isEqualTo(INITIAL_PROTOCOL_NAME)) {
            protocols[counter] = currentProtocolName;
            currentProtocolName = nextProtocolName[currentProtocolName];
            counter++;
        }

        return protocols;
    }

    /**
     * @param protocolName Name of the protocol.
     * @return name Name of the protocol.
     * @return description Description of the protocol.
     * @return websiteURL Website of the protocol.
     * @return iconURL Icon of the protocol.
     */
    function getProtocolInfo(
        string memory protocolName
    )
        public
        view
        returns (
            string memory name,
            string memory description,
            string memory websiteURL,
            string memory iconURL,
            uint256 version
        )
    {
        return (
            protocol[protocolName].name,
            protocol[protocolName].description,
            protocol[protocolName].websiteURL,
            protocol[protocolName].iconURL,
            protocol[protocolName].version
        );
    }

    /**
     * @param protocolName Name of the protocol.
     * @return Protocol adapters.
     */
    function getProtocolAdapters(
        string memory protocolName
    )
        public
        view
        returns (AdapterInfo[] memory)
    {
        return protocol[protocolName].adapters;
    }

    /**
     * @param protocolName Name of the protocol.
     * @return Whether protocol name is valid.
     */
    function isValidProtocol(
        string memory protocolName
    )
        public
        view
        returns (bool)
    {
        return !nextProtocolName[protocolName].isEmpty() && !protocolName.isEqualTo(INITIAL_PROTOCOL_NAME);
    }

    /**
     * @notice Adds a new protocol.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be added.
     * @param protocolInfo Info about new protocol and its adapters.
     */
    function addProtocol(
        string memory protocolName,
        ProtocolInfo memory protocolInfo
    )
        internal
    {
        require(!protocolName.isEqualTo(INITIAL_PROTOCOL_NAME), "PM: initial name!");
        require(!protocolName.isEmpty(), "PM: empty name!");
        require(nextProtocolName[protocolName].isEmpty(), "PM: name exists!");

        nextProtocolName[protocolName] = nextProtocolName[INITIAL_PROTOCOL_NAME];
        nextProtocolName[INITIAL_PROTOCOL_NAME] = protocolName;

        protocol[protocolName].name = protocolInfo.name;
        protocol[protocolName].description = protocolInfo.description;
        protocol[protocolName].websiteURL = protocolInfo.websiteURL;
        protocol[protocolName].iconURL = protocolInfo.iconURL;
        protocol[protocolName].version = 1;

        for (uint256 i = 0; i < protocolInfo.adapters.length; i++) {
            addProtocolAdapter(protocolName, protocolInfo.adapters[i]);
        }
    }

    /**
     * @notice Removes one of the protocols.
     * @param protocolName Name of the protocol to be removed.
     */
    function removeProtocol(
        string memory protocolName
    )
        internal
    {
        require(isValidProtocol(protocolName), "PM: bad name!");

        string memory prevProtocolName;
        string memory currentProtocolName = nextProtocolName[protocolName];
        while (!currentProtocolName.isEqualTo(protocolName)) {
            prevProtocolName = currentProtocolName;
            currentProtocolName = nextProtocolName[currentProtocolName];
        }

        delete protocol[protocolName];

        nextProtocolName[prevProtocolName] = nextProtocolName[protocolName];
        delete nextProtocolName[protocolName];
    }

    /**
     * @notice Adds a protocol adapter.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be updated.
     * @param protocolAdapter New adapter to be added.
     */
    function addProtocolAdapter(
        string memory protocolName,
        AdapterInfo memory protocolAdapter
    )
        internal
    {
        require(protocolAdapter.adapterAddress != address(0), "PM: zero!");
        require(protocolAdapter.supportedTokens.length != 0, "PM: empty!");

        protocol[protocolName].adapters.push(protocolAdapter);
    }

    /**
     * @notice Removes a protocol adapter.
     * The function is callable only by the owner.
     * @param protocolName Name of the protocol to be updated.
     * @param adapterIndex Adapter index to be removed.
     */
    function removeProtocolAdapter(
        string memory protocolName,
        uint256 adapterIndex
    )
        internal
    {
        uint256 length = protocol[protocolName].adapters.length;
        require(adapterIndex < length, "PM: bad index!");

        if (adapterIndex != length - 1) {
            protocol[protocolName].adapters[adapterIndex] = protocol[protocolName].adapters[length - 1];
        }

        protocol[protocolName].adapters.pop();
    }
}
