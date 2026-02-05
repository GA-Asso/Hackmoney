# HackMoney 2026 - Track Strategy

## Target Tracks

### 1. Uniswap v4 Track ($5,000+)

**Prize:** Agent-driven financial systems with Hooks

**Qualification:**
- ✅ TxID transactions (testnet) - `0xcee92b4283bd...`
- ✅ GitHub repository
- ✅ README.md
- ⏳ Demo video (max 3 min)

**Our Implementation:**
- `CashbackHook.sol` - hooks into `afterSwap` to calculate and deposit cashback
- Deployed: `0x9d922BA7fdAB56D2bEa439CD6C42b5b6B497D6A7`

**TODO:**
1. [ ] Register hook with a Uniswap v4 pool
2. [ ] Implement actual cashback logic in `afterSwap`
3. [ ] Add yield pool deposit functionality

---

### 2. ENS Track ($5,000)

**Prizes:**
- 🎉 Integrate ENS ($3,500 split) - Any creative integration
- 🥇 Most Creative DeFi Use ($1,500) - Beyond simple name resolution

**Qualification:**
- Must write ENS-specific code (not just RainbowKit)
- No hard-coded values
- Demo video + live demo
- Open source on GitHub

---

## ENS Integration Strategy

### Option A: Cashback Preferences in Text Records (RECOMMENDED)

**Concept:** Users store their cashback preferences in ENS text records:

```
user.cashbackid.eth
├── text.cashback.mode = "yield" | "stablecoin" | "nft"
├── text.cashback.percent = "5"
├── text.cashback.pool = "ETH-USDC"
└── text.cashback.autocompound = "true"
```

**Implementation:**

```solidity
// In CashbackHook.sol
import "@ensdomains/ens-contracts/contracts/resolvers/PublicResolver.sol";

function afterSwap(...) external returns (bytes4, int128) {
    // 1. Get user ENS name from reverse resolution
    string memory ensName = reverseResolver.name(sender);
    
    // 2. Read cashback preferences from text records
    string memory mode = resolver.text(ensNode, "cashback.mode");
    string memory percent = resolver.text(ensNode, "cashback.percent");
    
    // 3. Apply user-specific cashback logic
    if (keccak256(bytes(mode)) == keccak256("yield")) {
        depositToYieldPool(cashbackAmount);
    } else if (keccak256(bytes(mode)) == keccak256("stablecoin")) {
        sendStablecoin(sender, cashbackAmount);
    }
}
```

**Why This Wins "Most Creative":**
- ENS as a DeFi preferences layer, not just naming
- Portable across DeFi apps
- User controls preferences without gas for each change
- On-chain verifiable

---

### Option B: ENS Subdomains for Merchants

**Concept:** Each merchant gets a subdomain with their cashback settings:

```
starbucks.merchants.cashbackid.eth
├── text.cashback.rate = "3"
├── text.cashback.token = "USDC"
└── text.logo = "ipfs://..."
```

---

### Option C: ENS as Cashback Receipt

**Concept:** Mint ENS subdomains as cashback receipts:

```
receipt-12345.cashbackid.eth → Points to NFT with cashback history
```

---

## Implementation Roadmap

### Phase 1: Hook + ENS Integration (THIS WEEK)
1. [ ] Add ENS resolver to CashbackHook
2. [ ] Read user preferences from text records
3. [ ] Implement preference-based cashback routing

### Phase 2: Frontend
1. [ ] ENS login (wagmi hooks)
2. [ ] Preference editor (writes to text records)
3. [ ] Cashback dashboard

### Phase 3: Demo
1. [ ] Record 3-min video showing full flow
2. [ ] Deploy live demo

---

## Resources

### Uniswap v4
- [Docs](https://docs.uniswap.org/contracts/v4/overview)
- [v4-template](https://github.com/uniswapfoundation/v4-template)
- [Builder Toolkit](https://uniswaplabs.notion.site/hackmoney)

### ENS
- [Text Records](https://docs.ens.domains/web/records)
- [Decentralized Websites](https://docs.ens.domains/dweb/intro)
- [ENS Contracts](https://github.com/ensdomains/ens-contracts)

---

## Contract Addresses (Sepolia)

| Contract | Address |
|----------|---------|
| CashbackHook | `0x9d922BA7fdAB56D2bEa439CD6C42b5b6B497D6A7` |
| PoolManager (Uniswap v4) | `0xE03A1074c86CFeDd5C142C4F04F1a1536e203543` |
| ENS Registry | `0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e` |
| ENS PublicResolver | `0x8FADE66B79cC9f707aB26799354482EB93a5B7dD` |
