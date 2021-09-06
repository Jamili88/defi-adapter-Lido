<img src="https://avatars.githubusercontent.com/u/71294241?s=400&u=0b62a061c11a7536c27b1d53760152b5e9bd40f5&v=4" alt="Header" style="width:200px;align=center;float: right;" />

## OpytFi-Lido Adapter

This repository contains a DeFi adapter 
that allows the OptyFi Yield Aggregator 
Protocol to plug into the Lido Protocol and
offer users exposure to the yield generated 
by becoming a validator on the ETH 2.0 Beacon Chain. 

### Prerequisites

- Install [Node JS](https://nodejs.org/en/download/) >= v12.0.0
- Learn [Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) and [Typescript](https://www.typescriptlang.org/)
- Learn [Solidity](https://docs.soliditylang.org/en/latest/) >=v0.6.12.
- Learn smart contract development environment like [Hardhat](https://hardhat.org/getting-started/)
- Learn testing framework like [mocha](https://mochajs.org/)
- Learn assertion library like [chai](https://www.chaijs.com/)

## Getting started

### Development Setup

- Create a `.env` file and set a BIP-39 compatible mnemonic as an environment variable. Follow the example in `.env.example`. If you don't already have a mnemonic, use this [website](https://iancoleman.io/bip39/) to generate one.
- You will require access to archive Node URL for forking the mainnet.

Proceed with installing dependencies:

```sh
yarn install
```

### What is a DeFiAdapter

- DeFi adapter is a vital building block for executing [opty.fi](https://opty.fi)'s network of strategies.
- Specifications for DeFi adapter help perform :
  - transactions like deposit, withdraw, staking, un-staking, adding liquidity, claim reward and harvesting of the reward.
  - read calls for liquidity pool token contract address, liquidity pool token balance, staked token balance, balance in underlying token of both staked and non-staked liquidity pool token, unclaimed reward tokens and reward token contract address
- A DeFi Adapter smart contract requires implementation of following interfaces :
  - [IAdapter.sol](./contracts/interfaces/opty/IAdapter.sol) **(Mandatory)**
  - [IAdapterHarvestReward.sol](./contracts/interfaces/opty/IAdapterHarvestReward.sol) **(Optional)**
  - [IAdapterStaking.sol](./contracts/interfaces/opty/IAdapterStaking.sol) **(Optional)**
  - [IAdapterBorrow.sol](./contracts/interfaces/opty/IAdapterBorrow.sol) **(Optional)**
  - [IAdapterInvestmentLimit.sol](./contracts/interfaces/opty/IAdapterInvestmentLimit.sol) **(Optional)**

#### Useful commands

| Usage                                                                           | Command            |
| ------------------------------------------------------------------------------- | ------------------ |
| Compile the smart contracts with Hardhat                                        | `$ yarn compile`   |
| Compile the smart contracts and generate TypeChain artifacts                    | `$ yarn typechain` |
| Lint the Solidity Code                                                          | `$ yarn lint:sol`  |
| Lint the TypeScript Code                                                        | `$ yarn lint:ts`   |
| Run the Mocha tests                                                             | `$ yarn test`      |
| Generate the code coverage report                                               | `$ yarn coverage`  |
| Delete the smart contract artifacts, the coverage reports and the Hardhat cache | `$ yarn clean`     |
| Deploy the adapter to Hardhat Network                                           | `$ yarn deploy`    |

### References

- [Hardhat](https://hardhat.org/getting-started/)
- [Ethereum Development Documentation](https://ethereum.org/en/developers/docs/)
- [Harvest Finance Docs](https://harvest-finance.gitbook.io/harvest-finance/)
