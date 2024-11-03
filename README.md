# Foundry Fund Me F24

A decentralized funding platform built with Solidity, utilizing the Foundry framework for development, testing, and deployment. This project allows users to securely contribute funds to a smart contract, enabling a transparent and decentralized way to support projects.

---

## 📋 Table of Contents

- [Foundry Fund Me F24](#foundry-fund-me-f24)
  - [📋 Table of Contents](#-table-of-contents)
  - [🔋 Features](#-features)
  - [⚙️ Tech Stack](#️-tech-stack)
  - [🚀 Installation](#-installation)
  - [🤸 Usage](#-usage)
  - [🛠️ Makefile Commands](#️-makefile-commands)
  - [🔧 Configuration Details](#-configuration-details)
  - [🤝 Contributing](#-contributing)
  - [📜 License](#-license)

---

## 🔋 Features

-   **Decentralized Funding**: Users can fund projects directly through the smart contract.
-   **Smart Contracts with Solidity**: Transactions are secure and transparent, leveraging the Ethereum blockchain.
-   **Network Compatibility**: Configurations for Sepolia, Mainnet, and Anvil test environments.
-   **Mock Price Feeds**: Uses `MockV3Aggregator` for simulating price feeds on local Anvil networks.

---

## ⚙️ Tech Stack

-   **Solidity** (version 0.8.18)
-   **Foundry** - development and testing framework
-   **Chainlink Price Feeds** - real and mock data for funding calculations

---

## 🚀 Installation

1. **Clone the repository**:
    ```sh
    git clone https://github.com/RomThpt/foundry-fund-me-f24.git
    ```
2. **Navigate to the project directory**:
    ```sh
    cd foundry-fund-me-f24
    ```
3. **Install dependencies**:
    ```sh
    forge install
    ```

---

## 🤸 Usage

1. **Compile the smart contracts**:
    ```sh
    forge build
    ```
2. **Run tests**:
    ```sh
    forge test
    ```

---

## 🛠️ Makefile Commands

For convenience, the project includes a Makefile with pre-defined commands:

-   **Build**: Compile the contracts
    ```sh
    make build
    ```
-   **Deploy to Sepolia**: Deploy the contract to the Sepolia test network
    ```sh
    make deploy-sepolia
    ```

## 🔧 Configuration Details

The project includes configurations for different networks, with automatic selection based on `block.chainid`:

-   **Sepolia Network**: Uses Chainlink's Sepolia price feed at `0x694AA1769357215DE4FAC081bf1f309aDC325306`.
-   **Mainnet**: Configured with the mainnet price feed at `0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419`.
-   **Anvil (Local)**: Creates a mock price feed with `MockV3Aggregator` if no other configuration is found.

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request to discuss any potential changes.

## 📜 License

This project is licensed under the MIT License.

---

Thanks @cyfrin for the course
