# Uniswap v4 Cashback Hook

## Overview

This project implements a Uniswap v4 hook that provides a cashback mechanism. After a swap, a portion of the fees is captured and deposited into a liquidity pool of the user's choice, generating yield.

## Architecture

The core of the project is the `CashbackHook.sol` contract. This contract implements the `IAfterSwapHook` interface from Uniswap v4.

The hook is triggered after every swap in a pool where it's enabled. It calculates the cashback amount based on the swap fees and then adds liquidity to a predefined pool.

### Future improvements

In the future, the user's preferred liquidity pool will be fetched from their ENS profile, allowing for a more dynamic and user-centric experience.

## How it Works

1.  **Swap:** A user performs a swap on a Uniswap v4 pool with the CashbackHook enabled.
2.  **Hook Trigger:** The `afterSwap` function in `CashbackHook.sol` is called.
3.  **Cashback Calculation:** The hook determines the cashback amount from the swap fees.
4.  **Add Liquidity:** The hook adds the cashback amount as liquidity to a target pool.

## Deployment

To deploy the contracts, you will need to have Foundry installed.

1.  **Compile:**
    ```bash
    forge build
    ```
2.  **Test:**
    ```bash
    forge test
    ```
3.  **Deploy:**
    ```bash
    forge script script/CashbackHook.s.sol:CashbackHookScript --rpc-url <your_rpc_url> --private-key <your_private_key> --broadcast
    ```

## Scripts

The `scripts` directory will contain the necessary Foundry scripts for deployment and testing.
