<script lang="ts">
	import { onMount } from 'svelte';
	import {
		defaultEvmStores as evm,
		connected,
		allChainsData,
		getChainDataByChainId,
		chainId,
		contracts,
		signerAddress
	} from 'ethers-svelte';

	import IERC20 from '@openzeppelin/contracts/build/contracts/IERC20.json';

	const LINKTOKEN_ADDRESS_ON_GOERLI = '0x326C977E6efc84E512bB9C30f76E30c160eD06FB';

	// @ts-ignore
	evm.attachContract('link', LINKTOKEN_ADDRESS_ON_GOERLI, IERC20.abi);

	const GOERLI_CHAINID = 5;

	async function doSomething() {
		let tx = await $contracts.link.transfer(
			'0x326C977E6efc84E512bB9C30f76E30c160eD06FB',
			BigInt(1)
		);
		console.log(tx);
		return tx;
	}
</script>

<div class="p-4">
	<h2 class="">Contract ABI Read/Write</h2>
	<div class="pt-4">
		{#if $connected}
			{#if BigInt($chainId) !== BigInt(GOERLI_CHAINID)}
				<p>
					You are connected to the wrong network: {getChainDataByChainId($chainId).name}.
				</p>

				<p>
					Please connect to the network {getChainDataByChainId(5).name} for the $contract store demo
				</p>
			{:else if $contracts.link}
				{#await $contracts.link.totalSupply()}
					<span>waiting for $contracts.link.totalSupply() Promise...</span>
				{:then supply}
					<p>We have the result of $contracts.link.totalSupply() :</p>
					<p>ERC20 LINK contract has a supply of {supply} tokens on Görli.</p>
					<button class="button" on:click={doSomething()}
						>Send 0.01 Gorli ETH to the zero address</button
					>
				{/await}
			{/if}
		{:else}
			<p>Please connect your wallet to interact with the contract demo.</p>
			<p>
				Add additional testnet connections to metamask via (Account Icon / Settings / Advanced / Show Test Networks)
			</p>
		{/if}
	</div>
</div>
