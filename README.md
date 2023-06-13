<!-- Improved compatibility of back to top link -->

<a name="readme-top"></a>

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]

<br />
<div align="center">
  <a href="https://github.com/Elliott-Green/SveltekitXSkeletonXEthers">
    <img src="./static/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Sveltekit X Skeleton X Ethers</h3>

  <p align="center">
    A more opinionated, but barebones front end web3 template using some of my favorite technologies.
    <br />
    <br />
    <br />
    <a href="verceldeployementhere.com">View Demo</a>
    ·
    <a href="https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/issues">Report Bug</a>
    ·
    <a href="https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about">About</a>
    </li>
    <li>
      <a href="#setup">Setup</a>
      <ul>
        <li><a href="#dependencies--setup">Dependencies & Setup</a></li>
        <li><a href="#lint--format">Lint & Format</a></li>
        <li><a href="#docker-commands">Docker Commands</a></li>
      </ul>
    </li>
    <li><a href="#what-is-this-repository-showing-me">What is this repository showing me?</a></li>
    <li><a href="#how-do-i-use-this-as-a-template-then">How do I use this as a template then?</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>

## About

###### _This project is inspired from [SvelteKit-Ethers Template](https://github.com/0xjimmy/svelte-kit-ethers-template) by [0xJimmy](https://github.com/0xjimmy)._

The aim of this template is to provide a more opinionated `Hello World` setup with built-in contract reading and writing capabilities.

- [**SvelteKit**](https://kit.svelte.dev/docs/introduction) - Makes frontend development relatively enjoyable and offers impressive speed.
- [**TailwindCSS**](https://tailwindcss.com) - A class-based CSS framework that eliminates the need for messy CSS files.
- [**SkeletonUI**](https://www.skeleton.dev) - A UI library that builds on top of Skeleton and TailwindCSS, providing easy-to-use components for visually appealing designs.
- [**Ethers.JS**](https://docs.ethers.org/v5/) - A well-documented and actively maintained library that encapsulates Ethereum function calls.
- [**Ethers-Svelte**](https://github.com/clbrge/ethers-svelte) - A utility for managing Ethers state in Svelte stores.
- [**Etherscan Link Generator**](https://github.com/MetaMask/etherscan-link) - A tool for generating block explorer URLs for a given chain ID. Ethers doesn't provide this functionality by default, _but WAGMI does_.

> - Feel free to uninstall SkeletonUI and choose your own preferred styling solution.

> - ⚠️ Before using this repository, it is recommended to read the documentation for all the technologies involved. Please avoid raising issues that can be resolved by referring to the documentation of the respective dependencies.

  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="./static/screenshot.png" alt="Logo" >
  </a>

## Setup

### Dependencies & Setup

```bash
 npm i                   # Install dependencies
 npm run dev             # run local server
```

### Lint & Format

```bash
npm run lint             # Checks for linting issues
npm run format           # Runs linter over ./
```

## Docker Commands

This project includes a set of scripts to manage the application in a containerised environment if you so choose.

To build a Docker image for the application, run the following commands.

```bash
npm run docker:build    # will build a Docker image with the tag sk-skeleton-ethers-template-image
npm run docker:run      # will run a new Docker container named container from the image in detached mode (-d), mapping the container's port 5173 to the host's port 5173
npm run docker:stop     # will stop the running sk-skeleton-ethers-template-container
npm run docker:remove   # will remove the sk-skeleton-ethers-template-container. The container needs to be stopped before it can be removed.
npm run docker:clean    # will force remove the Docker image.
```

## What is this repository showing me?

This repository contains an opinionated hello world using the [Greeter / Hello World Contract](https://github.com/PaulRBerg/hardhat-template/blob/main/contracts/Greeter.sol). It serves as a guide to various functionalities in a blockchain web application. The highlighted features are:

1. User Metamask Connectivity: Establishing a link to the user's Metamask wallet.

2. Chain Identification: Detecting the blockchain network currently selected in Metamask.

3. ENS Resolving: Converting Ethereum Name Service (ENS) domains into corresponding Ethereum addresses.

4. Balance Formatting: Presenting Ethereum balances in a readable format.

5. Balance Query: Fetching the balance of Ethereum addresses.

6. Block Listener Webhook: Setting up webhooks to listen for new blocks on the blockchain.

7. Contract State Reading: Fetching the state of a smart contract.

8. Contract State Writing: Writing to the state of a smart contract.

9. Transaction Status Handling: Managing successful and failed transactions.

10. Jazzicons Usage: Implementing Jazzicons for unique, deterministic icons.

## How do I use this as a template then?

You will need the ABI of the contracts you want to interact with.

I recommend using [this template](https://github.com/PaulRBerg/hardhat-template) to setup a hardhat environment to test, deploy and interact with your contract.

You also might want to get funds from the [Sepolia PoW faucet](https://sepolia-faucet.pk910.de/) to use the application.

1. Once you have your ABI then you can replace/add it into `src/lib/abi`.

2. In `+layout.svelte` we call `attachContract(name, address, abi)` to bind the contract into the svelte-ethers stores.

You should now have access to `await $contracts.name.getFoo();` to fetch the `getFoo` state from the `name` contract we provided before.

You should also have access to `await $contracts.name.setFoo(foobar);` to set the state from the chain. Remember to await the success from the transaction.

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

## Contact

Elliott Green - [@cryptonines](https://twitter.com/cryptonines)

Project Link: [https://github.com/Elliott-Green/SveltekitXSkeletonXEthers](https://github.com/Elliott-Green/SveltekitXSkeletonXEthers)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

[contributors-shield]: https://img.shields.io/github/contributors/Elliott-Green/SveltekitXSkeletonXEthers.svg?style=for-the-badge
[contributors-url]: https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Elliott-Green/SveltekitXSkeletonXEthers.svg?style=for-the-badge
[forks-url]: https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/network/members
[stars-shield]: https://img.shields.io/github/stars/Elliott-Green/SveltekitXSkeletonXEthers.svg?style=for-the-badge
[stars-url]: https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/stargazers
[issues-shield]: https://img.shields.io/github/issues/Elliott-Green/SveltekitXSkeletonXEthers.svg?style=for-the-badge
[issues-url]: https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/issues
[license-shield]: https://img.shields.io/github/license/Elliott-Green/SveltekitXSkeletonXEthers.svg?style=for-the-badge
[license-url]: https://github.com/Elliott-Green/SveltekitXSkeletonXEthers/blob/master/LICENSE.txt
[product-screenshot]: ./static/screenshot.png
