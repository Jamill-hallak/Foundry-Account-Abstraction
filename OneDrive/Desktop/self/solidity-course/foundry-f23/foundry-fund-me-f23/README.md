# Foundry Fund Me

This project is part of the **Cyfrin Solidity Course**, demonstrating the development of a decentralized funding application using Foundry and Solidity.

**[⭐️ Course Link | Foundry Fund Me](https://updraft.cyfrin.io/courses/foundry/foundry-fund-me/fund-me-project-setup)**

## Table of Contents

- [Foundry Fund Me](#foundry-fund-me)
  - [Table of Contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Requirements](#requirements)
    - [Quickstart](#quickstart)
  - [Usage](#usage)
    - [Deploy](#deploy)
    - [Testing](#testing)
    - [Test Coverage](#test-coverage)
    - [Local zkSync](#local-zksync)
      - [Additional Requirements](#additional-requirements)
      - [Setup Local zkSync Node](#setup-local-zksync-node)
      - [Deploy to Local zkSync Node](#deploy-to-local-zksync-node)
  - [Deployment to a Testnet or Mainnet](#deployment-to-a-testnet-or-mainnet)
    - [Setup Environment Variables](#setup-environment-variables)
    - [Deploy Script](#deploy-script)
    - [Scripts](#scripts)
    - [Withdraw](#withdraw)
  - [Estimate Gas](#estimate-gas)
  - [Formatting](#formatting)
  - [Additional Info](#additional-info)
    - [Official Repository Clarification](#official-repository-clarification)
    - [Summary](#summary)

---

## Getting Started

### Requirements

- **Git**: Install from [git-scm.com](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git). Verify installation:
  ```bash
  git --version
  ```
- **Foundry**: Install from [getfoundry.sh](https://getfoundry.sh/). Verify installation:
  ```bash
  forge --version
  ```

---

### Quickstart

```bash
git clone https://github.com/Jamill-hallak/foundry-fund-me
cd foundry-fund-me
make
```

---

## Usage

### Deploy

```bash
forge script script/DeployFundMe.s.sol
```

---

### Testing

Run tests with:

```bash
forge test
```

To run specific tests:

```bash
forge test --match-test testFunctionName
```

To run tests with a forked network:

```bash
forge test --fork-url $SEPOLIA_RPC_URL
```

---

### Test Coverage

Generate test coverage reports:

```bash
forge coverage
```

---

### Local zkSync

#### Additional Requirements

- **zkSync Foundry Plugin**: [foundry-zksync](https://github.com/matter-labs/foundry-zksync)
- **npm and npx**: [Install npm](https://docs.npmjs.com/cli/v10/commands/npm-install)
- **Docker**: [Install Docker](https://docs.docker.com/engine/install/)

#### Setup Local zkSync Node

Configure and start the zkSync node:

```bash
npx zksync-cli dev config
npx zksync-cli dev start
```

#### Deploy to Local zkSync Node

```bash
make deploy-zk
```

---

## Deployment to a Testnet or Mainnet

### Setup Environment Variables

Create a `.env` file with the following variables:

- `PRIVATE_KEY`: Your wallet's private key (use test accounts only).
- `SEPOLIA_RPC_URL`: RPC URL of the Sepolia testnet.
- `ETHERSCAN_API_KEY`: (Optional) For contract verification on Etherscan.

### Deploy Script

```bash
forge script script/DeployFundMe.s.sol   --rpc-url $SEPOLIA_RPC_URL   --private-key $PRIVATE_KEY   --broadcast   --verify   --etherscan-api-key $ETHERSCAN_API_KEY
```

---

### Scripts

Interact with deployed contracts:

- **Fund Contract**:
  ```bash
  cast send <FUNDME_CONTRACT_ADDRESS> "fund()" --value 0.1ether --private-key <PRIVATE_KEY>
  ```
- **Withdraw Funds**:
  ```bash
  forge script script/Interactions.s.sol:WithdrawFundMe     --rpc-url sepolia     --private-key $PRIVATE_KEY     --broadcast
  ```

### Withdraw

```bash
cast send <FUNDME_CONTRACT_ADDRESS> "withdraw()" --private-key <PRIVATE_KEY>
```

---

## Estimate Gas

Estimate gas costs:

```bash
forge snapshot
```

---

## Formatting

Format the code:

```bash
forge fmt
```

---

## Additional Info

### Official Repository Clarification

The `chainlink-brownie-contracts` repository is an official Chainlink repository, maintained by the Chainlink team. It packages `chainlink/contracts` for seamless Foundry integration.

---

### Summary

- The `chainlink-brownie-contracts` repository is official and reliable.
- It provides a convenient way to integrate Chainlink contracts into Foundry projects.

---

