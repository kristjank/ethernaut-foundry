# Ethernaut CTF - Foundry edition

Unofficial port of Ethernaut to Foundry. Some levels are missing, and some solutions are a bit tricky to test.

## What is Ethernaut by OpenZeppelin

[Ethernaut](https://github.com/OpenZeppelin/ethernaut) is a Web3/Solidity based war game inspired in [overthewire.org](https://overthewire.org/), to be played in the Ethereum Virtual Machine. Each level is a smart contract that needs to be 'hacked'.

The game acts both as a tool for those interested in learning Ethereum, and as a way to catalog historical hacks in levels. Levels can be infinite, and the game does not require to be played in any particular order.

Created by [OpenZeppelin](https://www.openzeppelin.com/)
Visit [https://ethernaut.openzeppelin.com/](https://ethernaut.openzeppelin.com/)

## Acknowledgements

- Ethernaut was created by by [OpenZeppelin](https://www.openzeppelin.com/)
- [Ethernaut Website](https://ethernaut.openzeppelin.com/)
- [Ethernaut GitHub](https://github.com/OpenZeppelin/ethernaut)
- [Foundry](https://github.com/gakonst/foundry)
- [Foundry Book](https://book.getfoundry.sh/)
- [Template for this repo](https://github.com/StErMi/foundry-ethernaut) (Has solutions included)

## How to play

### Install Foundry

```bash
curl -L https://foundry.paradigm.xyz | bash
```

### Update Foundry

```bash
foundryup
```

### Clone repo and install dependencies

```bash
git clone git@github.com:Vanclief/ethernaut-foundry.git
cd ethernaut-foundry
git submodule update --init --recursive
```

### Run a solution

```bash
# example forge test --match-contract TestCoinFlip
forge test --match-contract NAME_OF_THE_TEST
```

### Code your solutions

Open the level file from the `test/` folder. (e.g. for the Reentrance level open `test/Reentrace.rs`).

Write down your solution where the `/** CODE YOUR EXPLOIT HERE */` comment is.