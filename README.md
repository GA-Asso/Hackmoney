# 💳 Cashback ID 🦄💰

**A Cross-Chain Rewards Protocol powered by Sui, ENS, and LI.FI**

**Tech Stack:** Sui Network (High-Speed Execution), ENS (Identity), LI.FI (Cross-Chain)
**Tagline:** "Tu nombre es tu cuenta. Tu compra es tu inversión."

---

## 🚀 Deployed Contracts

### Sepolia Testnet

| Contract | Address | Status |
|----------|---------|--------|
| **CashbackHook** | [`0xE85F5b463fB5b15Cb9222Edc8c2e07e121352762`](https://sepolia.etherscan.io/address/0xE85F5b463fB5b15Cb9222Edc8c2e07e121352762) | ✅ Deployed |
| **PoolManager (Uniswap v4)** | [`0xE03A1074c86CFeDd5C142C4F04F1a1536e203543`](https://sepolia.etherscan.io/address/0xE03A1074c86CFeDd5C142C4F04F1a1536e203543) | ✅ Official |

---

## 🛠️ Quick Start

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js >= 18

### Installation

```bash
git clone https://github.com/GA-Asso/Hackmoney.git
cd Hackmoney
forge install
cp .env.example .env
```

### Build & Test

```bash
forge build
forge test -vv
```

### Deploy

```bash
source .env
forge script script/DeployCashbackHook.s.sol:DeployCashbackHook \
  --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast
```

---

## 🎯 How It Works

```
User Swaps → LI.FI Bridge → CashbackHook → Yield Pool (Auto LP)
```

1.  **User earns cashback** from purchases.
2.  **Funds are bridged cross-chain** through LI.FI.
3.  **Cashback is automatically deposited** into yield-generating liquidity pools, like the LI.FI pools.
4.  **User earns** passive yield on their cashback.

---

## 📁 Project Structure

```
├── src/CashbackHook.sol       # Main Uniswap v4 Hook
├── script/DeployCashbackHook.s.sol
├── test/CashbackHook.t.sol
├── lib/v4-core/               # Uniswap v4 core
├── app/                       # Next.js frontend (WIP)
└── sui/                       # Sui contracts (WIP)
```

---

## 📜 License

MIT

---

## 🤖 ETH Global - HackMoney 2026: Uniswap v4 Track

### 🤖 Uniswap v4 Agentic Finance

*   **Descripción:** Build on Uniswap v4 to explore agent-driven financial systems. Projects may involve agents that programmatically interact with Uniswap v4 pools for liquidity management, trade execution, routing, coordination, or other behaviors enabled by onchain state. Submissions should emphasize reliability, transparency, and composability over speculative intelligence. The use of Hooks is optional and encouraged where it meaningfully supports the design.
*   **Requisitos de Calificación:**
    *   TxID transactions (testnet and/or mainnet)
    *   GitHub repository
    *   README.md
    *   Demo link or setup instructions
    *   Demo video (max 3 min)


### 🕶️ Uniswap v4 Privacy DeFi

*   **Descripción:** Build on Uniswap v4 to explore privacy-enhancing financial systems in decentralized markets. Projects may introduce mechanisms that improve how information is handled during onchain trading and liquidity provision, such as reducing unnecessary information exposure, improving execution quality, or designing market behavior that is more resilient to adverse selection and extractive dynamics. Submissions should emphasize responsible, transparent system design that preserves onchain verifiability and protocol integrity. The use of Hooks is optional and encouraged where it meaningfully supports the design.
*   **Requisitos de Calificación:**
    *   TxID transactions (testnet and/or mainnet)
    *   GitHub repository
    *   README.md
    *   Demo link or setup instructions
    *   Demo video (max 3 min)
