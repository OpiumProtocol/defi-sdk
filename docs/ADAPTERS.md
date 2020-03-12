## Table of Contents

  - [AdapterRegistry](#adapterregistry-is-protocolmanager-tokenadaptermanager)
  - [ProtocolManager (abstract contract)](#protocolmanager-is-ownable-abstract-contract)
  - [TokenAdapterManager (abstract contract)](#tokenadaptermanager-is-ownable-abstract-contract)
  - [Ownable](#ownable)
  - [adapters/AaveAssetAdapter](#aaveassetadapter-is-protocoladapter)
  - [adapters/AaveDebtAdapter](#aavedebtadapter-is-protocoladapter)
  - [adapters/AaveTokenAdapter](#aavetokenadapter-is-tokenadapter)
  - [adapters/CompoundAssetAdapter](#compoundassetadapter-is-protocoladapter)
  - [adapters/CompoundDebtAdapter](#compounddebtadapter-is-protocoladapter)
  - [adapters/CompoundTokenAdapter](#compoundtokenadapter-is-tokenadapter)
  - [adapters/CurveAdapter](#curveadapter-is-protocoladapter)
  - [adapters/CurveTokenAdapter](#curvetokenadapter-is-tokenadapter)
  - [adapters/DSRAdapter](#dsradapter-is-protocoladapter)
  - [adapters/MCDAssetAdapter](#mcdassetadapter-is-protocoladapter-mkradapter-abstract-contract)
  - [adapters/MCDDebtAdapter](#mcddebtadapter-is-protocoladapter-mkradapter-abstract-contract)
  - [adapters/MKRAdapter (abstract contract)](#mkradapter-abstract-contract)
  - [adapters/PoolTogetherAdapter](#pooltogetheradapter-is-protocoladapter)
  - [adapters/PoolTogetherTokenAdapter](#pooltogethertokenadapter-is-tokenadapter)
  - [adapters/SynthetixAssetAdapter](#synthetixassetadapter-is-protocoladapter)
  - [adapters/SynthetixDebtAdapter](#synthetixdebtadapter-is-protocoladapter)
  - [adapters/ZrxAdapter](#zrxadapter-is-protocoladapter)
  - [adapters/ProtocolAdapter (interface)](#protocoladapter-interface)
  - [adapters/TokenAdapter (interface)](#tokenadapter-interface)

## AdapterRegistry is [ProtocolManager](#protocolmanager-is-ownable-abstract-contract), [TokenAdapterManager](#tokenadaptermanager-is-ownable-abstract-contract)

Registry holding array of protocol adapters and checking balances and rates via these adapters.

### `view` functions

#### `getBalances(address account) returns (ProtocolBalance[] memory)`

Iterates over all the supported protocols, their adapters and supported assets and appends balances.

#### `getProtocolBalances(address account, string[] memory protocolNames) returns (ProtocolBalance[] memory)`

Iterates over the `protocolNames`, their adapters and supported assets and appends balances.

#### `getAdapterBalances(address account, AdapterInfo[] memory protocolAdapters) returns (AdapterBalance[] memory)`

Iterates over `protocolAdapters` and their assets and appends balances.

#### `getFullTokenUnit(string calldata tokenType, address token) returns (FullTokenUnit memory)`

Returns the representation of the token's full share (1e18) in the underlying tokens.
This function will show the real underlying tokens (e.g. cDAI and cUSDC for Curve Compound pool).

#### `getFinalFullTokenUnit(string calldata tokenType, address token) returns (FullTokenUnit memory)`

Returns the representation of the token's full share (1e18) in the underlying tokens.
This function will try to recover the "deepest" underlying tokens (e.g. DAI and USDC for Curve Compound pool).

## ProtocolManager is [Ownable](#ownable) (abstract contract)

Base contract for `AdapterRegistry` contract.
Implements logic connected with `ProtocolName`s, `ProtocolAdapter`s, and their `supportedTokens` management.

### State variables

```
mapping (string => string) internal nextProtocolName;
mapping (string => ProtocolInfo) internal protocol;
```

### `onlyOwner` functions

#### `addProtocols()`

#### `removeProtocols()`

#### `updateProtocolInfo()`

Increases protocol version by 1.

#### `addProtocolAdapters()`

Increases protocol version by 1.

#### `removeProtocolAdapters()`

Increases protocol version by 1.

#### `updateProtocolAdapterInfo()`

Increases protocol version by 1.

### `view` functions

#### `getProtocolNames()`

Returns list of protocols' names.

#### `getProtocolInfo(string calldata protocolName)`

Returns name, description, websiteURL, iconURL and version of the protocol.

#### `getProtocolAdapters(string calldata protocolName)`

Returns adapters and their supported tokens addresses.

#### `isValidProtocol(string memory protocolName)`

Returns `true` if protocol name is listed in the registry and `false` otherwise.

## TokenAdapterManager is [Ownable](#ownable) (abstract contract)

Base contract for `AdapterRegistry` contract.
Implements logic connected with `ProtocolName`s, `ProtocolAdapter`s, and their `supportedTokens` management.

### State variables

```
mapping (string => string) internal nextTokenAdapterName;
mapping (string => address) internal tokenAdapter;
```

### `onlyOwner` functions

#### `addTokenAdapters()`

#### `removeTokenAdapters()`

#### `updateTokenAdapter()`

### `view` functions

#### `getTokenAdapterNames()`

Returns list of token adapters' names.

#### `getTokenAdapter(string calldata tokenAdapterName)`

Returns token adapter address.

#### `isValidTokenAdapter(string memory tokenAdapterName)`

Returns `true` if token adapter name is listed in the registry and `false` otherwise.

## Ownable 

Base contract for `AdapterAssetsManager` and `Logic` contracts.
Implements `Ownable` logic.
Includes `onlyOwner` modifier, `transferOwnership()` function, and public state variable `owner`. 

## AaveAssetAdapter is [ProtocolAdapter](#protocoladapter-interface)

Asset adapter for Aave protocol.

## AaveDebtAdapter is [ProtocolAdapter](#protocoladapter-interface)

Debt adapter for Aave protocol.

## AaveTokenAdapter is [TokenAdapter](#tokenadapter-interface)

Token adapter for ATokens.

## CompoundAssetAdapter is [ProtocolAdapter](#protocoladapter-interface)

Asset adapter for Compound protocol.

## CompoundDebtAdapter is [ProtocolAdapter](#protocoladapter-interface)

Debt adapter for Compound protocol.

## CompoundTokenAdapter is [TokenAdapter](#tokenadapter-interface)

Token adapter for CTokens.

## CurveAdapter is [ProtocolAdapter](#protocoladapter-interface)

Adapter for [curve.fi](https://compound.curve.fi/) protocol.

## CurveTokenAdapter is [TokenAdapter](#tokenadapter-interface)

Token adapter for Curve pool tokens.

## DyDxAssetAdapter is [ProtocolAdapter](#protocoladapter-interface)

Asset adapter for dYdX protocol.
`getBalance()` function checks balance only for dYdX account with 0 index.

## DyDxDebtAdapter is [ProtocolAdapter](#protocoladapter-interface)

Debt adapter for dYdX protocol.
`getBalance()` function checks debt only for dYdX account with 0 index.


## DSRAdapter is [ProtocolAdapter](#protocoladapter-interface), [MKRAdapter](#mkradapter-abstract-contract)

Adapter for DSR protocol.

## MCDAssetAdapter is [ProtocolAdapter](#protocoladapter-interface), [MKRAdapter](#mkradapter-abstract-contract)

Asset adapter for MCD vaults.

## MCDDebtAdapter is [ProtocolAdapter](#protocoladapter-interface), [MKRAdapter](#mkradapter-abstract-contract)

Debt adapter for MCD vaults.

## MKRAdapter (abstract contract)

Base contract for Maker adapters.
Includes all the required constants and `pure` functions with calculations.

## PoolTogetherAdapter is [ProtocolAdapter](#protocoladapter-interface)

Adapter for PoolTogether protocol.

## PoolTogetherTokenAdapter is [TokenAdapter](#tokenadapter-interface)

Token adapter for PoolTogether pools.

## SynthetixAssetAdapter is [ProtocolAdapter](#protocoladapter-interface)

Asset adapter for Synthetix protocol.
Returns amount of SNX tokens locked by minting sUSD tokens.

## SynthetixDebtAdapter is [ProtocolAdapter](#protocoladapter-interface)

Debt adapter for Synthetix protocol.
Returns amount of sUSD tokens that should be burned to unlock SNX tokens.

## UniswapAdapter is [ProtocolAdapter](#protocoladapter-interface)

Adapter for Uniswap protocol.

## UniswapTokenAdapter is [TokenAdapter](#tokenadapter-interface)

Token adapter for Uniswap pool tokens.

## ZrxAdapter is [ProtocolAdapter](#protocoladapter-interface)

Adapter for 0x Staking protocol.

## ProtocolAdapter (interface)

Interface for protocol adapters.
Includes all the functions required to be implemented.
Adapters inheriting this interface MUST be stateless.
Only `internal constant` state variables MUST be used.
Only `internal` functions SHOULD be used.

### Functions

#### `adapterType() returns (string memory)`
MUST return "Asset" or "Debt".

#### `tokenType() returns (string memory)`
MUST return token type (default is "ERC20").

#### `getBalance(address,address) returns (uint256)`
MUST return amount of the given token locked on the protocol by the given account.

## TokenAdapter (interface)

Interface for token adapters.
Includes all the functions required to be implemented.
Adapters inheriting this interface MUST be stateless.
Only `internal constant` state variables MUST be used.
Only `internal` functions SHOULD be used.

### Functions

#### `getInfo(address) returns (TokenInfo memory)`
MUST return TokenInfo struct with ERC20-style token info.

#### `getComponents(address) returns (Component[] memory)`;
MUST return array of Component structs with underlying tokens rates for the given token.
