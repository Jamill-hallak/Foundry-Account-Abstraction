# Foundry Account Abstraction: A Comprehensive Demo

## 🚀 Overview

This repository is a **state-of-the-art demonstration** of **Account Abstraction (AA)**, a transformative concept in blockchain technology. Built using **Foundry**, this project highlights how Account Abstraction enables unprecedented flexibility by turning externally owned accounts (EOAs) into programmable smart contracts. 

Key features of this project include deploying and interacting with minimal smart wallets on both **zkSync** and **Arbitrum** networks, demonstrating the cutting-edge potential of AA in real-world applications.

This project is based on the **Account Abstraction course by Cyfrin** and has been adapted to showcase its practical applications.

---

## 🌟 Highlights

### What This Repository Demonstrates:
- **Minimal EVM Smart Wallet**: Built on Arbitrum, leveraging Ethereum’s **EntryPoint** contract for transaction handling.
- **zkSync Native Account Abstraction**: Demonstrates zkSync-specific native AA features, distinct from ERC-4337.
- **End-to-End Deployment**: Deployments on local zkSync networks, zkSync Sepolia, and Arbitrum testnets.
- **User Operations Flow**: Includes examples of user operation creation and execution in both Ethereum and zkSync environments.
- **Secure Practices**: Showcases encrypted key management to prevent accidental key exposure.

---

## 🔧 Architecture

### Account Abstraction: Redefining EOAs
- **Traditional EOAs**: Transactions rely solely on private keys.
- **Abstracted EOAs**: Transactions leverage programmable logic for both **execution** and **authorization** using smart contracts, enabling flexible and secure workflows.

### zkSync Native AA Workflow:
1. **Contract Deployment**: Utilize the `CONTRACT_DEPLOYER` system contract to mark the smart wallet as an AA-enabled account.
2. **Factory Dependencies**: Register contract hashes in the `KnownCodesStorage` for efficient deployments.
3. **User Operations**: Integrate with zkSync’s alt-mempool for streamlined AA transaction handling.

### Arbitrum EntryPoint Workflow:
1. **Smart Wallet Deployment**: Deploy wallets compatible with ERC-4337 standards.
2. **Transaction Execution**: Route transactions through the `EntryPoint.sol` contract, ensuring compatibility with Ethereum’s AA model.

---

## 📚 Getting Started

### Prerequisites
Ensure the following tools are installed:

- **Git**: `git --version`
- **Foundry**: `forge --version`
- **Foundry zkSync**: `forge-zksync --help`
- **npx & npm**: `npm --version` and `npx --version`
- **Yarn**: `yarn --version`
- **Docker**: `docker --version` (daemon must be running)

### Installation
1. Clone the repository:
    ```bash
    git clone https://github.com/Jamill-hallak/Foundry-Account-Abstraction.git
    cd Foundry-Account-Abstraction
    ```

2. Install dependencies:
    ```bash
    make
    ```

---

## 🚦 Quickstart

### Vanilla Foundry
1. Set up Foundry:
    ```bash
    foundryup
    ```

2. Run tests:
    ```bash
    make test
    ```

### Arbitrum Deployment
1. Deploy:
    ```bash
    make deployEth
    ```

2. Send a user operation:
    ```bash
    make sendUserOp
    ```

### zkSync Deployment
1. Set up zkSync Foundry:
    ```bash
    foundryup-zksync
    ```

2. Build and test:
    ```bash
    make zkbuild
    make zktest
    ```

3. Deploy to zkSync:
    ```bash
    make zkdeploy
    ```

4. Send a zkSync AA transaction:
    ```bash
    make sendTx
    ```

---

## 🛠️ Technical Features

### Deployment Workflow

### Advanced Features
- Native zkSync Account Abstraction
- ERC-4337-compatible Arbitrum smart wallets
- Integration with zkSync alt-mempool

---

## 🤔 FAQ

### Why can’t Foundry or Cast handle factory dependencies?
Foundry and Cast currently lack support for:
- The `factoryDeps` transaction field
- Type 113 transactions required for zkSync AA deployments

### Why is `forge create --legacy` supported?
Foundry-zkSync transforms legacy deployments (e.g., transactions to the `0x0` address) into compatible zkSync calls, simplifying contract creation.

---

## 📊 Vision

This repository demonstrates the potential of **Account Abstraction** to drive innovation in blockchain infrastructure. By enabling smart wallet functionality across zkSync and Arbitrum, it bridges the gap between cutting-edge research and practical implementation. This is a pivotal step toward programmable accounts that redefine how we interact with Web3 ecosystems.
