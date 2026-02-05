# Cashback ID 🦄💰

**A Uniswap v4 Hook for Automated Cashback Yield Generation**

**Tech Stack:** Uniswap v4 (Hooks), Sui Network (High-Speed Execution), ENS (Identity)  
**Tagline:** "Tu nombre es tu cuenta. Tu compra es tu inversión."

---

## 🚀 Deployed Contracts

### Sepolia Testnet

| Contract | Address | Status |
|----------|---------|--------|
| **CashbackHook** | [`0x9d922BA7fdAB56D2bEa439CD6C42b5b6B497D6A7`](https://sepolia.etherscan.io/address/0x9d922BA7fdAB56D2bEa439CD6C42b5b6B497D6A7) | ✅ Deployed |
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
User Swaps → Uniswap v4 Pool → CashbackHook → Yield Pool (Auto LP)
```

1. **User swaps** tokens through a Uniswap v4 pool with CashbackHook
2. **Hook intercepts** the `afterSwap` callback
3. **Cashback calculated** based on swap volume
4. **Auto-deposit** into yield-generating liquidity pools
5. **User earns** passive yield on their cashback

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
