# <h1 align="center"> 💦 Lockers Room</h1>
<p align="center">
    <img src="https://media.giphy.com/media/enVAELA3hZrP5blXVG/giphy.gif">
</p>
<p align="center"> Swap any assets and get access to the lockers room.</p>

![Github Actions](https://github.com/kobe-eth/lockers-room/workflows/CI/badge.svg)

# How it works ?

In order to enter the Locker rooms, Zap uses delegate call to `Handlers` contracts.
Using Zap, you can multiple combinations of actions such as :
- Deposit into Locker
- Deposit into Strategies
- Swap trough Paraswap and Deposit into Locker
- Swap trough Paraswap, add liquidity and deposit into Strategies.

and many more etc.

```mermaid
graph TD
	Zap --> delegateCall
	delegateCall --> LockerHandler
	LockerHandler --> Depositor
    delegateCall --> ParaswapHandler
    ParaswapHandler --> AugustusSwapper
    delegateCall --> StrategyHandler
    StrategyHandler --> Vault
    delegateCall --> LiquidityHandler
    LiquidityHandler --> Exchange
```

# WIP
`LiquidityHandler.sol`