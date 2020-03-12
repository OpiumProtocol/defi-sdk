# Zerion DeFi SDK

This is a project with Zerion smart contracts interacting with different DeFi protocols.

![](https://github.com/zeriontech/protocol-wrappers/workflows/lint/badge.svg)
![](https://github.com/zeriontech/protocol-wrappers/workflows/build/badge.svg)
![](https://github.com/zeriontech/protocol-wrappers/workflows/test/badge.svg)
![](https://github.com/zeriontech/protocol-wrappers/workflows/coverage/badge.svg)

## Summary
This is a system of smart contracts created for interacting with the different DeFi protocols.
In the current implementation, one can check balances of tokens locked on the [supported](#list-of-supported-protocols) protocols.
There is a special **ProtocolAdapter** contract for every protocol.
Also, there are **TokenAdapter** contracts for some protocols.
**TokenAdapter** contract is required when the token used in the protocol is not just ERC20 token but the derivative token (like CToken or YToken).
All the adapters are kept and managed in **AdapterRegistry** contact.
All the interactions are done via **AdapterRegistry** contract as well.

## Table of Contents

  - [Addresses of deployed contracts](#addresses-of-deployed-contracts)
  - [Interacting with AdapterRegistry](#interacting-with-adapterregistry-contract)
  - [List of supported protocols](#list-of-supported-protocols)
  - [Creating and adding new adapters](#creating-and-adding-new-adapters)
  - [What's next](#whats-next)

## Addresses of deployed contracts

[AdapterRegistry](https://etherscan.io/address/0xaf51e57d3c78ce8495219ceb6d559b85e62f680e#code) is currently the only contract with verified source code.

## Interacting with **AdapterRegistry** contract

### Functions description

AdapterManager is the contract managing the list of supported adapters and their assets.

`getProtocolNames()` function returns the list of protocols supported by the **AdapterManager** contract.

`getProtocolInfo()` function returns the protocol metadata, i.e. name, one line description, icon and website URL's and version.
This info may be upgraded by the `owner`.
In this case, the version will be increased by 1.

`getProtocolAdapters()` function returns the list of protocol adapters for the given protocol name.
Also, the list of the supported tokens for every adapter is shown.

This contract is also used for checking balances and exchange rates. 
`getBalances()` function iterates over supported protocols, all their adapters and supported tokens and return balances of the assets locked on the supported protocols.
The function returns an array of the `ProtocolBalance` structs.
Its definition may be found in [Structs.sol](./contracts/Structs.sol).
All these structs have protocol metadata as the first fields.
After that, adapter balances are added.
The following object is an example of `ProtocolBalance` struct.

```javascript
{
  name: "Curve",
  description: "Exchange liquidity pool for stablecoin trading",
  iconURL: "protocol-icons.s3.amazonaws.com/curve.fi.png",
  websiteURL: "curve.fi",
  version: 1,
  adapterBalances: [
    {
      adapterType: "Asset",
      balances: [
        {
          base: {
            info: {
              token: "0x3740fb63ab7a09891d7c0d4299442A551D06F5fD",
              name: "cDAI+cUSDC pool",
              symbol: "cDAI+cUSDC",
              decimals: 18
            },
            value: 398803979082926895
          },
          underlying: [
            {
              info: {
                token: "0x6B175474E89094C44Da98b954EedeAC495271d0F",
                name: "Dai Stablecoin",
                symbol: "DAI",
                decimals: 18
              },
              value: 31350436734836604220961509427578200
            },
            {
              info: {
                token: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
                name: "USD//C",
                symbol: "USDC",
                decimals: 6
              },
              value: 370922396493302226989865
            }
          ]
        },
        ...
      ]
    }
  ]
}
```

`getFullTokenUnit()` and `getFinalFullTokenUnit()` functions returns the representation of the token's full share (1e18) in the underlying tokens.
The first one will show the real underlying tokens (e.g. cDAI and cUSDC for Curve Compound pool).
The second will try to recover the "deepest" underlying tokens (e.g. DAI and USDC for Curve Compound pool).

In case adapter or asset is not supported by **AdapterManager** contract, functions with adapters (and assets) being function's arguments may be used (e.g. `getAdapterBalances()` function).
In this case, one should be sure that token type used in the adapter is supported by the registry (or use "ERC20" token type instead).

More detailed information about adapters may be found in [adapters documentation](./docs/ADAPTERS.md).

## List of supported protocols

The following protocols are currently supported:

- [Aave](./contracts/adapters/aave)
- [Compound](./contracts/adapters/compound)
- [Curve](./contracts/adapters/curve)
- [dYdX](./contracts/adapters/dydx)
- [iearn](./contracts/adapters/iearn)
- [DSR](./contracts/adapters/maker)
- [MCD](./contracts/adapters/maker)
- [PoolTogether](./contracts/adapters/poolTogether)
- [Synthetix](./contracts/adapters/synthetix)
- [Uniswap](./contracts/adapters/uniswap)
- [0x Staking](./contracts/adapters/zrx)

## Creating and adding new adapters

To create new protocol adapter, one have to implement `ProtocolAdapter` interface.
`adapterType()`, `tokenType()`, and `getBalance()` functions MUST be implemented.

> **NOTE**: only `internal constant` state variables MUST be used, i.e. adapter MUST be stateless.
Only `internal` functions SHOULD be used, as all the other functions will not be accessible by **AdapterRegistry** contract.

`adapterType()` function has no arguments and MUST return type of the adapter:

- "Asset" in case the adapter returns the amount of account's tokens held on the protocol;
- "Debt" in case the adapter returns the amount of account's debt to the protocol.

`tokenType()` function has no arguments and MUST return type of the token used by the adapter:

- "ERC20" is the default type;
- "AToken", "CToken", "YToken", "Uniswap pool token", "Curve pool token", "PoolTogether pool" are the currently supported ones.

`getBalance(address,address)` function has two arguments of `address` type:
the first one is asset address and the second one is account address.
The function MUST return balance of given asset held on the protocol for the given account for "Asset" adapter type. The function MUST return the amount of tokens owed to the protocol by the given user for "Debt" adapter type.

To create new token adapter, one have to implement `TokenAdapter` interface.

`getTokenInfo(address)` function has the only argument – token address.
The function MUST return the ERC20-style token info, namely:

- `token`: `address` of the token contract;
- `name`: `string` with token name;
- `symbol`: `string` with token symbol;
- `decimals`: `uint8` number with token decimals.

`getComponents(address)` function has the only argument – token address.
The function MUST return all the underlying assets info:

- `token` : `address` of the underlying token contract;
- `tokenType` : `string` with underlying token type;
- `rate` : `uint256` with price per base token share (1e18).

After the adapters are deployed and tested, one can contact Zerion team in order to add the adapters to **AdapterRegistry** contract – balances will automatically appear in Zerion interface.

## What's next

We are currently developing interactive part of our system.
All the interactions will be separated into parts – actions.
Actions will be of two kinds – deposit and withdraw.
The actions will be sent to the interactive adapters – adapters that can not only check protocol balances but interact with the supported protocols.

The system will consist of the following parts:
  - **Logic** contract. 
The main contract that receives an array of actions, conducts all the calculations, redirects actions to the corresponding interactive adapters.
  - **TokenSpender** contract.
The contract that holds all the approvals from accounts.
It transfers all the required assets under the request of Logic contract.

### Use-cases for Logic contract

#### Swap cDAI to DSR (Chai)

The following actions array will be sent to `Logic` contract:

```
[
    {
        actionType: ActionType.Withdraw,
        InteractiveAdapter: <address of cDAI interactive adapter>,
        asset: 0x5d3a536e4d6dbd6114cc1ead35777bab948e3643,
        amount: Amount({
            amountType: AmountType.Relative,
            value: RELATIVE_AMOUNT_BASE
        }),
        data: ""
    },
    {
        actionType: ActionType.Deposit,
        InteractiveAdapter: <address of chai interactive adapter>,
        asset: 0x5d3a536e4d6dbd6114cc1ead35777bab948e3643,
        amount: Amount({
            amountType: AmountType.Relative,
            value: RELATIVE_AMOUNT_BASE
        }),
        data: ""
    }
]
```

Logic layer should do the following:

1. Call `redeem()` function with `getAssetAmount(address(this))` argument.
2. Approve all the DAI to `Chai` contract.
3. Call `join()` function with `address(this)` and `getAssetAmount(address(this))` arguments.
4. Withdraw Chai tokens to the account.

More detailed information about interactive adapters may be found in [interactive adapters documentation](./docs/INTERACTIVE_ADAPTERS.md).

## Dev notes

This project uses Truffle and web3js for all Ethereum interactions and testing.

### Available Functionality

#### Compile contracts

`npm run compile`

#### Run tests

`npm run test`

#### Run Solidity code coverage

`npm run coverage`

Currently, unsupported files are ignored.

#### Run Solidity and JS linters

`npm run lint`

Currently, unsupported files are ignored.

#### Run all the migrations scripts

`npm run deploy:network`, `network` is either `development` or `mainnet`

#### Verify contract's code on Etherscan

`truffle run verify ContractName@0xcontractAddress --network mainnet`
